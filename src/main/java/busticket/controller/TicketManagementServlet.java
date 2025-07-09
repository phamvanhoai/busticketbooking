/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.TicketManagementDAO;
import busticket.model.Invoices;
import busticket.model.Review;
import busticket.model.Users;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class TicketManagementServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the logged-in user's ID from session
        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user from session
        Users users = (Users) session.getAttribute("currentUser");
        TicketManagementDAO ticketManagementDAO = new TicketManagementDAO();

        String cancel = request.getParameter("cancel");
        if (cancel != null) {
            try {
                int invoiceId = Integer.parseInt(cancel);
                Invoices invoice = ticketManagementDAO.getInvoiceById(invoiceId);

                if (invoice != null) {
                    request.setAttribute("invoice", invoice);
                    request.getRequestDispatcher("/WEB-INF/pages/ticket-management/cancel-ticket.jsp")
                            .forward(request, response);
                    return;
                } else {
                    request.setAttribute("errorMessage", "Invoice not found!");
                    request.getRequestDispatcher("/WEB-INF/pages/ticket-management/view-bookings.jsp")
                            .forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid invoice ID format!");
                request.getRequestDispatcher("/WEB-INF/pages/ticket-management/view-bookings.jsp")
                        .forward(request, response);
                return;
            }
        }

        // View details (optional)
        String detail = request.getParameter("detail");
        if (detail != null) {
            // Handle view details logic if needed
        }

        String review = request.getParameter("review");
        if (review != null) {
            try {
                int invoiceId = Integer.parseInt(review);
                Invoices invoice = ticketManagementDAO.getInvoiceById(invoiceId);

                if (invoice != null) {
                    Date now = new Date();

                    if ("Paid".equalsIgnoreCase(invoice.getInvoiceStatus())
                            && invoice.getDepartureTime() != null
                            && !invoice.getDepartureTime().after(now)) {

                        // Lấy review cũ nếu có
                        Review reviewObj = ticketManagementDAO.getReviewByInvoiceId(invoiceId);
                        if (reviewObj != null) {
                            invoice.setReviewRating(reviewObj.getRating());
                            invoice.setReviewText(reviewObj.getText());
                        }
                        request.setAttribute("invoice", invoice);
                        request.getRequestDispatcher("/WEB-INF/pages/ticket-management/review-booking.jsp")
                                .forward(request, response);
                        return;

                    } else {
                        response.sendRedirect(request.getContextPath() + "/ticket-management?status=trip_not_completed");
                        return;
                    }

                } else {
                    request.setAttribute("errorMessage", "Invoice not found!");
                    request.getRequestDispatcher("/WEB-INF/pages/ticket-management/view-bookings.jsp")
                            .forward(request, response);
                    return;
                }

            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid invoice ID format!");

                String statusParam = request.getParameter("status");
                if ("trip_not_completed".equals(statusParam)) {
                    request.setAttribute("errorMessage", "Trip chưa hoàn thành. Không thể đánh giá!");
                }
                if ("review_error".equals(statusParam)) {
                    request.setAttribute("errorMessage", "Đã xảy ra lỗi khi thực hiện review!");
                }
                if ("review_success".equals(statusParam)) {
                    request.setAttribute("successMessage", "Review thành công!");
                }
                request.getRequestDispatcher("/WEB-INF/pages/ticket-management/view-bookings.jsp")
                        .forward(request, response);
                return;
            }
        }

        // Default logic: list bookings with filters & pagination
        int userId = users.getUser_id();
        String ticketCode = request.getParameter("ticketCode");
        String route = request.getParameter("route");
        String status = request.getParameter("status");

        int currentPage = 1;
        int recordsPerPage = 10;

        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int offset = (currentPage - 1) * recordsPerPage;

        List<String> locations = ticketManagementDAO.getAllLocations();
        List<Invoices> invoicesList = ticketManagementDAO.getAllInvoices(ticketCode, route, status, offset, recordsPerPage);
        int totalRecords = ticketManagementDAO.getTotalInvoicesCount(ticketCode, route, status);
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        request.setAttribute("invoicesList", invoicesList);
        request.setAttribute("locations", locations);
        request.setAttribute("ticketCode", ticketCode);
        request.setAttribute("route", route);
        request.setAttribute("status", status);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/WEB-INF/pages/ticket-management/view-bookings.jsp")
                .forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông tin từ session (người dùng đang đăng nhập)
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        // Lấy thông tin từ form
        String action = request.getParameter("action");
        TicketManagementDAO ticketManagementDAO = new TicketManagementDAO();

        if (action == null) {
            // Nếu không có action thì coi như lỗi
            request.setAttribute("errorMessage", "Invalid action.");
            request.getRequestDispatcher("/ticket-management").forward(request, response);
            return;
        }

        // ======================== 
        // CANCEL LOGIC 
        // ========================
        if (action.equalsIgnoreCase("cancel")) {
            String invoiceIdStr = request.getParameter("invoiceId");
            String cancellationReason = request.getParameter("reason");

            if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
                System.out.println("Cancel Error: invoiceId missing");
                request.setAttribute("errorMessage", "Invoice ID is missing.");
                request.getRequestDispatcher("/ticket-management").forward(request, response);
                return;
            }

            try {
                int invoiceId = Integer.parseInt(invoiceIdStr);
                boolean success = ticketManagementDAO.cancelInvoice(invoiceIdStr, cancellationReason, user.getUser_id());

                if (success) {
                    request.setAttribute("successMessage", "Cancellation request is pending.");
                    request.getRequestDispatcher("/ticket-management").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Error in cancelling the invoice.");
                    request.getRequestDispatcher("/ticket-management").forward(request, response);
                }
            } catch (NumberFormatException e) {
                System.out.println("Cancel Error: invalid invoiceId format");
                request.setAttribute("errorMessage", "Invalid invoice ID format.");
                request.getRequestDispatcher("/ticket-management").forward(request, response);
            }
        } // ======================== 
        // REVIEW LOGIC 
        // ========================
        else if (action.equalsIgnoreCase("review")) {
            String invoiceIdStr = request.getParameter("invoiceId");
            String ratingStr = request.getParameter("rating");
            String reviewText = request.getParameter("reviewText");

            if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
                System.out.println("Review Error: invoiceId is missing");
                request.setAttribute("errorMessage", "Invoice ID is missing.");
                request.getRequestDispatcher("/ticket-management").forward(request, response);
                return;
            }

            if (ratingStr == null || ratingStr.isEmpty()) {
                System.out.println("Review Error: rating is missing");
                request.setAttribute("errorMessage", "Rating is missing.");
                request.getRequestDispatcher("/ticket-management").forward(request, response);
                return;
            }

            try {
                int invoiceId = Integer.parseInt(invoiceIdStr);
                int rating = Integer.parseInt(ratingStr);

                // Kiểm tra đã review chưa
                boolean hasReviewed = ticketManagementDAO.hasReviewed(invoiceId);
                boolean success;

                if (hasReviewed) {
                    success = ticketManagementDAO.updateInvoiceReview(invoiceId, rating, reviewText);
                    System.out.println("Review UPDATE for invoiceId = " + invoiceId);
                } else {
                    success = ticketManagementDAO.addInvoiceReview(invoiceId, rating, reviewText);
                    System.out.println("Review INSERT for invoiceId = " + invoiceId);
                }

                if (success) {
                    request.setAttribute("successMessage", "Your review has been submitted successfully.");
                    request.getRequestDispatcher("/ticket-management").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Error submitting your review.");
                    request.getRequestDispatcher("/ticket-management").forward(request, response);
                }

            } catch (NumberFormatException e) {
                System.out.println("Review Error: Invalid number format");
                e.printStackTrace();
                request.setAttribute("errorMessage", "Invalid number format.");
                request.getRequestDispatcher("/ticket-management").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Invalid action.");
            request.getRequestDispatcher("/ticket-management").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
