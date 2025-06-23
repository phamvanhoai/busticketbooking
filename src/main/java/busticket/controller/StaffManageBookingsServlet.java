/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffManageBookingDAO;
import busticket.model.StaffTicket;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
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
        // Parse the path from the URI
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // Handle booking detail view
        if (path.equals("/staff/view-booking")) {
            String ticketId = request.getParameter("id");
            if (ticketId == null || ticketId.trim().isEmpty()) {
                response.sendRedirect(contextPath + "/staff/manage-bookings");
                return;
            }

            // Retrieve ticket by ID
            StaffTicket booking = dao.getBookingById(ticketId);
            if (booking == null) {
                response.sendRedirect(contextPath + "/pages/404.jsp");
                return;
            }

            // Pass data to view
            request.setAttribute("booking", booking);
            request.setAttribute("distinctRoutes", dao.getDistinctRoutes());
            request.getRequestDispatcher("/WEB-INF/staff/manage-bookings/view-booking.jsp")
                    .forward(request, response);
            return;
        }

        // Handle filtering and pagination of bookings list
        String q = request.getParameter("q");             // search keyword
        String date = request.getParameter("date");       // filter by date
        String routeId = request.getParameter("routeId"); // filter by route
        String status = request.getParameter("status");   // filter by payment status
        String pageParam = request.getParameter("page");  // current page

        int page = 1;
        try {
            page = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
            if (page < 1) {
                page = 1;
            }
        } catch (NumberFormatException ignored) {
        }

        // Get filtered bookings
      List<StaffTicket> filtered = dao.getFilteredBookings(q, date, routeId, status);

        // Further filter by payment status if specified
        if (status != null && !status.isEmpty() && !status.equalsIgnoreCase("All Status")) {
            filtered.removeIf(t -> !t.getPaymentStatus().equalsIgnoreCase(status));
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

        // Send data to JSP for rendering
        request.setAttribute("bookings", paged);
        request.setAttribute("q", q);
        request.setAttribute("status", status);
        request.setAttribute("date", date);
        request.setAttribute("routeId", routeId);
        request.setAttribute("currentPage", page);
        request.setAttribute("numOfPages", totalPages);
        request.setAttribute("baseUrlWithSearch", contextPath + "/staff/manage-bookings");
        request.setAttribute("distinctRoutes", dao.getDistinctRoutes());

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
        doGet(request, response); // Delegate POST to GET handler
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
