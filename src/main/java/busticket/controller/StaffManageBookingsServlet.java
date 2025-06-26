/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffManageBookingDAO;
import busticket.DAO.StaffRouteDAO;
import busticket.model.StaffRoute;
import busticket.model.StaffTicket;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffManageBookingsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final StaffManageBookingDAO bookingDAO = new StaffManageBookingDAO();

    private static final int RECORDS_PER_PAGE = 10; // số bản ghi mỗi trang
    private final StaffRouteDAO routeDAO = new StaffRouteDAO();

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
        // Retrieve filter parameters from the request
        String q = request.getParameter("q");                 // Search keyword (invoice code or customer name)
        String routeId = request.getParameter("routeId");     // Route filter
        String date = request.getParameter("date");           // Departure date filter
        String status = request.getParameter("status");       // Invoice payment status filter
        String pageParam = request.getParameter("page");

        // Set default page number if not provided or invalid
        int page = 1;
        try {
            page = Integer.parseInt(pageParam);
        } catch (Exception e) {
            page = 1;
        }

        int recordsPerPage = 10; // Number of records per page

        try {
            // Get filtered tickets with pagination
            List<StaffTicket> tickets = bookingDAO.getFilteredTicketsByPage(q, routeId, date, status, page, recordsPerPage);

            // Count total records matching the filter to calculate total pages
            int totalRecords = bookingDAO.countFilteredTickets(q, routeId, date, status);
            int numOfPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

            // Get list of distinct routes for the route filter dropdown
            List<StaffRoute> distinctRoutes = routeDAO.getAllRoutes();

            // Set attributes for JSP rendering
            request.setAttribute("tickets", tickets);
            request.setAttribute("numOfPages", numOfPages);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", numOfPages);
            request.setAttribute("distinctRoutes", distinctRoutes);

            // Preserve filter parameters in the form
            request.setAttribute("q", q);
            request.setAttribute("routeId", routeId);
            request.setAttribute("date", date);
            request.setAttribute("status", status);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading bookings: " + e.getMessage());
        }

        // Forward to the booking management JSP page
        request.getRequestDispatcher("/WEB-INF/staff/manage-bookings/manage-bookings.jsp").forward(request, response);
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
