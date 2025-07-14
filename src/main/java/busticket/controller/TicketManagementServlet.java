/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.TicketManagementDAO;
import busticket.model.Invoices;
import busticket.model.Review;
import busticket.model.Tickets;
import busticket.model.Users;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import sun.security.krb5.internal.Ticket;

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
        try {
            // Get the logged-in user's ID from session
            HttpSession session = request.getSession();
            if (session == null || session.getAttribute("currentUser") == null) {
                request.setAttribute("errorMessage", "Please log in.");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Users users = (Users) session.getAttribute("currentUser");
            int userId = users.getUser_id();
            TicketManagementDAO ticketManagementDAO = new TicketManagementDAO();

            // Get messages from session (if any)
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
                        // Get departure time of the trip
                        Date departureTime = invoice.getDepartureTime();

                        if (departureTime != null) {
                            // Check if departure time is within 24 hours
                            long currentTime = System.currentTimeMillis();
                            long departureTimeMillis = departureTime.getTime();
                            long differenceInMillis = departureTimeMillis - currentTime;

                            // Check if the departure time is within 24 hours (24 * 60 * 60 * 1000 = 86400000 ms)
                            if (differenceInMillis <= 86400000) {
                                session.setAttribute("errorMessage", "Tickets can only be canceled 24 hours before departure.");
                                response.sendRedirect(request.getContextPath() + "/ticket-management");
                                return;
                            }
                        }

                        // If not within 24 hours, proceed to cancel the ticket
                        request.setAttribute("invoice", invoice);
                        request.getRequestDispatcher("/WEB-INF/pages/ticket-management/cancel-ticket.jsp")
                                .forward(request, response);
                        return;

                    } else {
                        session.setAttribute("errorMessage", "Invoice not found!");
                        response.sendRedirect(request.getContextPath() + "/ticket-management");
                        return;
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "Invalid invoice ID format!");
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
                            session.setAttribute("errorMessage", "The trip is not completed. Cannot review!");
                            response.sendRedirect(request.getContextPath() + "/ticket-management");
                            return;
                        }

                    } else {
                        session.setAttribute("errorMessage", "Invoice not found!");
                        response.sendRedirect(request.getContextPath() + "/ticket-management");
                        return;
                    }

                } catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "Invalid invoice ID format!");
                    response.sendRedirect(request.getContextPath() + "/ticket-management");
                    return;
                }
            }

            String detail = request.getParameter("detail");
            if (detail != null) {
                try {
                    int invoiceId = Integer.parseInt(detail);
                    Invoices invoice = ticketManagementDAO.getInvoiceById(invoiceId);

                    if (invoice != null) {
                        // Fetch tickets related to the invoice
                        List<Tickets> tickets = ticketManagementDAO.getTicketsByInvoice(invoiceId);
                        request.setAttribute("invoice", invoice);
                        request.setAttribute("tickets", tickets);
                        request.getRequestDispatcher("/WEB-INF/pages/ticket-management/view-booking-details.jsp")
                                .forward(request, response);
                        return;
                    } else {
                        session.setAttribute("errorMessage", "Invoice not found!");
                        response.sendRedirect(request.getContextPath() + "/ticket-management");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "Invalid invoice ID format!");
                    response.sendRedirect(request.getContextPath() + "/ticket-management");
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
            List<Invoices> invoicesList = ticketManagementDAO.getAllInvoices(userId, ticketCode, route, status, offset, recordsPerPage);
            int totalRecords = ticketManagementDAO.getTotalInvoicesCount(userId, ticketCode, route, status);
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            Date now = new Date();
            request.setAttribute("now", now);

            request.setAttribute("invoicesList", invoicesList);
            request.setAttribute("locations", locations);
            request.setAttribute("ticketCode", ticketCode);
            request.setAttribute("route", route);
            request.setAttribute("status", status);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/WEB-INF/pages/ticket-management/view-bookings.jsp")
                    .forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(TicketManagementServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
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
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("currentUser");
        if (user == null) {
            session.setAttribute("errorMessage", "Please log in.");
            response.sendRedirect(request.getContextPath() + "/ticket-management");
            return;
        }

        String action = request.getParameter("action");
        TicketManagementDAO ticketManagementDAO = new TicketManagementDAO();

        if (action == null) {
            session.setAttribute("errorMessage", "Invalid action.");
            response.sendRedirect(request.getContextPath() + "/ticket-management");
            return;
        }

        // ========================
        // CANCEL FORM LOGIC
        // ========================
        if (action.equalsIgnoreCase("cancel_form")) {
            String invoiceIdStr = request.getParameter("invoiceId");
            if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
                session.setAttribute("errorMessage", "Missing invoice ID.");
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
                    session.setAttribute("errorMessage", "Invoice not found!");
                    response.sendRedirect(request.getContextPath() + "/ticket-management");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid invoice ID format.");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
            }
        } // ========================
        // REVIEW FORM LOGIC
        // ========================
        else if (action.equalsIgnoreCase("review_form")) {
            String invoiceIdStr = request.getParameter("invoiceId");
            if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
                session.setAttribute("errorMessage", "Missing invoice ID.");
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
                        session.setAttribute("errorMessage", "The trip is not completed. Cannot review!");
                        response.sendRedirect(request.getContextPath() + "/ticket-management");
                    }
                } else {
                    session.setAttribute("errorMessage", "Invoice not found!");
                    response.sendRedirect(request.getContextPath() + "/ticket-management");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid invoice ID format.");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
            }
        } // ========================
        // CANCEL LOGIC
        // ========================
        else if (action.equalsIgnoreCase("cancel")) {
            String invoiceIdStr = request.getParameter("invoiceId");
            String cancellationReason = request.getParameter("reason");

            if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
                session.setAttribute("errorMessage", "Missing invoice ID.");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
                return;
            }

            try {
                int invoiceId = Integer.parseInt(invoiceIdStr);
                boolean success = ticketManagementDAO.cancelInvoice(invoiceIdStr, cancellationReason, user.getUser_id());

                if (success) {
                    session.setAttribute("successMessage", "Ticket successfully canceled, status: Pending Cancellation.");
                } else {
                    session.setAttribute("errorMessage", "Error canceling the ticket.");
                }
                response.sendRedirect(request.getContextPath() + "/ticket-management");
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid invoice ID format.");
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
                session.setAttribute("errorMessage", "Missing invoice ID.");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
                return;
            }

            if (ratingStr == null || ratingStr.isEmpty()) {
                session.setAttribute("errorMessage", "Missing rating.");
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
                } else {
                    success = ticketManagementDAO.addInvoiceReview(invoiceId, rating, reviewText);
                }

                if (success) {
                    session.setAttribute("successMessage", "Your review has been submitted successfully.");
                } else {
                    session.setAttribute("errorMessage", "Error submitting review.");
                }
                response.sendRedirect(request.getContextPath() + "/ticket-management");
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid number format.");
                response.sendRedirect(request.getContextPath() + "/ticket-management");
            }
        } else {
            session.setAttribute("errorMessage", "Invalid action.");
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
