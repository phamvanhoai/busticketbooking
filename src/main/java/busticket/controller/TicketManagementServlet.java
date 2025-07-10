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
            request.setAttribute("errorMessage", "Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user from session
        Users users = (Users) session.getAttribute("currentUser");
        TicketManagementDAO ticketManagementDAO = new TicketManagementDAO();

        // Lấy thông báo từ session (nếu có)
        Object success = session.getAttribute("successMessage");
        Object error = session.getAttribute("errorMessage");
        if (success != null) {
            request.setAttribute("successMessage", success);
            session.removeAttribute("successMessage");
        }
        if (error != null) {
            request.setAttribute("errorMessage", error);
            session.removeAttribute("errorMessage");
        }

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
                    session.setAttribute("errorMessage", "Không tìm thấy hóa đơn!");
                    response.sendRedirect(request.getContextPath() + "/ticket-management");
                    return;
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Định dạng ID hóa đơn không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
                return;
            }
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
                        session.setAttribute("errorMessage", "Chuyến đi chưa hoàn thành. Không thể đánh giá!");
                        response.sendRedirect(request.getContextPath() + "/ticket-management");
                        return;
                    }

                } else {
                    session.setAttribute("errorMessage", "Không tìm thấy hóa đơn!");
                    response.sendRedirect(request.getContextPath() + "/ticket-management");
                    return;
                }

            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Định dạng ID hóa đơn không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
                return;
            }
        }

        // Default logic: list bookings with filters & pagination
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
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("currentUser");
        if (user == null) {
            session.setAttribute("errorMessage", "Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/ticket-management");
            return;
        }

        String action = request.getParameter("action");
        TicketManagementDAO ticketManagementDAO = new TicketManagementDAO();

        if (action == null) {
            session.setAttribute("errorMessage", "Hành động không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/ticket-management");
            return;
        }

        // ========================
        // CANCEL FORM LOGIC
        // ========================
        if (action.equalsIgnoreCase("cancel_form")) {
            String invoiceIdStr = request.getParameter("invoiceId");
            if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
                session.setAttribute("errorMessage", "Thiếu ID hóa đơn.");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
                return;
            }
            try {
                int invoiceId = Integer.parseInt(invoiceIdStr);
                Invoices invoice = ticketManagementDAO.getInvoiceById(invoiceId);
                if (invoice != null) {
                    request.setAttribute("invoice", invoice);
                    request.getRequestDispatcher("/WEB-INF/pages/ticket-management/cancel-ticket.jsp").forward(request, response);
                } else {
                    session.setAttribute("errorMessage", "Không tìm thấy hóa đơn!");
                    response.sendRedirect(request.getContextPath() + "/ticket-management");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Định dạng ID hóa đơn không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
            }
        } // ========================
        // REVIEW FORM LOGIC
        // ========================
        else if (action.equalsIgnoreCase("review_form")) {
            String invoiceIdStr = request.getParameter("invoiceId");
            if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
                session.setAttribute("errorMessage", "Thiếu ID hóa đơn.");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
                return;
            }
            try {
                int invoiceId = Integer.parseInt(invoiceIdStr);
                Invoices invoice = ticketManagementDAO.getInvoiceById(invoiceId);
                if (invoice != null) {
                    Date now = new Date();
                    if ("Paid".equalsIgnoreCase(invoice.getInvoiceStatus())
                            && invoice.getDepartureTime() != null
                            && !invoice.getDepartureTime().after(now)) {
                        Review reviewObj = ticketManagementDAO.getReviewByInvoiceId(invoiceId);
                        if (reviewObj != null) {
                            invoice.setReviewRating(reviewObj.getRating());
                            invoice.setReviewText(reviewObj.getText());
                        }
                        request.setAttribute("invoice", invoice);
                        request.getRequestDispatcher("/WEB-INF/pages/ticket-management/review-booking.jsp").forward(request, response);
                    } else {
                        session.setAttribute("errorMessage", "Chuyến đi chưa hoàn thành. Không thể đánh giá!");
                        response.sendRedirect(request.getContextPath() + "/ticket-management");
                    }
                } else {
                    session.setAttribute("errorMessage", "Không tìm thấy hóa đơn!");
                    response.sendRedirect(request.getContextPath() + "/ticket-management");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Định dạng ID hóa đơn không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
            }
        } // ========================
        // CANCEL LOGIC
        // ========================
        else if (action.equalsIgnoreCase("cancel")) {
            String invoiceIdStr = request.getParameter("invoiceId");
            String cancellationReason = request.getParameter("reason");

            if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
                System.out.println("Cancel Error: invoiceId missing");
                session.setAttribute("errorMessage", "Thiếu ID hóa đơn.");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
                return;
            }

            try {
                int invoiceId = Integer.parseInt(invoiceIdStr);
                boolean success = ticketManagementDAO.cancelInvoice(invoiceIdStr, cancellationReason, user.getUser_id());

                if (success) {
                    session.setAttribute("successMessage", "Hủy vé thành công, trạng thái: Pending Cancellation.");
                } else {
                    session.setAttribute("errorMessage", "Lỗi khi hủy vé.");
                }
                response.sendRedirect(request.getContextPath() + "/ticket-management");
            } catch (NumberFormatException e) {
                System.out.println("Cancel Error: invalid invoiceId format");
                session.setAttribute("errorMessage", "ID hóa đơn không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
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
                session.setAttribute("errorMessage", "Thiếu ID hóa đơn.");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
                return;
            }

            if (ratingStr == null || ratingStr.isEmpty()) {
                System.out.println("Review Error: rating is missing");
                session.setAttribute("errorMessage", "Thiếu điểm đánh giá.");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
                return;
            }

            try {
                int invoiceId = Integer.parseInt(invoiceIdStr);
                int rating = Integer.parseInt(ratingStr);

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
                    session.setAttribute("successMessage", "Đánh giá đã được gửi thành công.");
                } else {
                    session.setAttribute("errorMessage", "Lỗi khi gửi đánh giá.");
                }
                response.sendRedirect(request.getContextPath() + "/ticket-management");
            } catch (NumberFormatException e) {
                System.out.println("Review Error: Invalid number format");
                e.printStackTrace();
                session.setAttribute("errorMessage", "Định dạng số không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
            }
        } else {
            session.setAttribute("errorMessage", "Hành động không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/ticket-management");
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
