/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffManageBookingDAO;
import busticket.model.StaffTicket;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffManageBookingsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final StaffManageBookingDAO dao = new StaffManageBookingDAO();


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


        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // View booking details
        if (path.equals("/staff/view-booking")) {
            String ticketId = request.getParameter("id");
            if (ticketId == null || ticketId.trim().isEmpty()) {
                response.sendRedirect(contextPath + "/staff/manage-bookings");
                return;
            }

            StaffTicket booking = dao.getBookingById(ticketId);
            if (booking == null) {
                response.sendRedirect(contextPath + "/pages/404.jsp");
                return;
            }

            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/WEB-INF/staff/manage-bookings/view-booking.jsp").forward(request, response);
            return;
        }

        // List bookings with filter + pagination
        List<StaffTicket> all = dao.getAllBookings();

        String q = request.getParameter("q");
        String status = request.getParameter("status");
        String pageParam = request.getParameter("page");

        // Parse page
        int page = 1;
        try {
            page = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
            if (page < 1) {
                page = 1;
            }
        } catch (NumberFormatException ignored) {
        }

        // Filter
        List<StaffTicket> filtered = new ArrayList<>();
        for (StaffTicket b : all) {
            boolean matchesSearch = (q == null || q.isEmpty())
                    || b.getTicketId().toLowerCase().contains(q.toLowerCase())
                    || b.getUserName().toLowerCase().contains(q.toLowerCase());
            boolean matchesStatus = (status == null || status.isEmpty())
                    || b.getPaymentStatus().equalsIgnoreCase(status);

            if (matchesSearch && matchesStatus) {
                filtered.add(b);
            }
        }

        // Pagination logic
        int limit = 10;
        int totalItems = filtered.size();
        int totalPages = (int) Math.ceil((double) totalItems / limit);
        int offset = (page - 1) * limit;

        List<StaffTicket> paged = filtered.subList(
                Math.min(offset, totalItems),
                Math.min(offset + limit, totalItems)
        );

        // Set data for JSP
        request.setAttribute("bookings", paged);
        request.setAttribute("q", q);
        request.setAttribute("status", status);
        request.setAttribute("currentPage", page);
        request.setAttribute("numOfPages", totalPages);
        request.setAttribute("baseUrlWithSearch", contextPath + "/staff/manage-bookings");

        request.getRequestDispatcher("/WEB-INF/staff/manage-bookings/manage-bookings.jsp")
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

        // Read form inputs
        String q = request.getParameter("q");
        String status = request.getParameter("status");

        // Build redirect URL with query parameters
        String redirectUrl = request.getContextPath() + "/staff/manage-bookings";
        boolean hasQuery = false;


        if (q != null && !q.isEmpty()) {
            redirectUrl += "?q=" + q;
            hasQuery = true;
        }

        if (status != null && !status.isEmpty()) {
            redirectUrl += hasQuery ? "&" : "?";
            redirectUrl += "status=" + status;
        }

        // Redirect to GET handler
        response.sendRedirect(redirectUrl);
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
