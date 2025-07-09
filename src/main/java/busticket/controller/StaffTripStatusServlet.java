/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffTripStatusDAO;
import busticket.model.AdminDrivers;
import busticket.model.AdminTrips;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class StaffTripStatusServlet extends HttpServlet {

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
        StaffTripStatusDAO staffTripStatusDAO = new StaffTripStatusDAO();

        // Filters
        String route = request.getParameter("route");
        String status = request.getParameter("status");
        String driver = request.getParameter("driver");

        // Pagination
        int currentPage = 1;
        int tripsPerPage = 10;
        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        int offset = (currentPage - 1) * tripsPerPage;

        // Fetch trips based on filters and pagination
        List<AdminTrips> trips = staffTripStatusDAO.getAllTrips(route, status, driver, offset, tripsPerPage);
        int totalTrips = staffTripStatusDAO.getTotalTripsCount(route, status, driver);
        int totalPages = (int) Math.ceil((double) totalTrips / tripsPerPage);

        // Get locations, drivers for filters
        List<String> locations = staffTripStatusDAO.getAllLocations();
        List<AdminDrivers> drivers = staffTripStatusDAO.getAllDrivers();

        // Set attributes for the JSP
        request.setAttribute("trips", trips);
        request.setAttribute("locations", locations);
        request.setAttribute("drivers", drivers);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/WEB-INF/staff/trip-status/view-trip-status.jsp").forward(request, response);
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
