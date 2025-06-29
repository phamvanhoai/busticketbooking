/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.HomeViewTripsDAO;
import busticket.model.HomeTrip;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class HomeViewTripsServlet extends HttpServlet {

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
        // 1. Lấy danh sách tên location
        HomeViewTripsDAO homeViewTripsDAO = new HomeViewTripsDAO();

        // 1) Read filter params
        String origin   = request.getParameter("origin");
        String dest     = request.getParameter("destination");
        String depDate  = request.getParameter("departureDate");
        Date date       = null;
        if (depDate != null && !depDate.isEmpty()) {
            date = Date.valueOf(depDate);
        }

        List<String> locations = homeViewTripsDAO.getAllLocations();
        request.setAttribute("locations", locations);

        boolean hasOrig = origin != null && !origin.isEmpty();
        boolean hasDest = dest   != null && !dest.isEmpty();
        if (hasOrig ^ hasDest) {
            request.setAttribute("error", "Please select both origin and destination.");
            request.getRequestDispatcher("/WEB-INF/pages/view-trips.jsp")
                   .forward(request, response);
            return;
        }

        List<HomeTrip> trips = homeViewTripsDAO.getTrips(
            hasOrig ? origin : null,
            hasDest ? dest   : null,
            date
        );
        request.setAttribute("trips", trips);
        request.getRequestDispatcher("/WEB-INF/pages/view-trips.jsp")
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

        HomeViewTripsDAO homeViewTripsDAO = new HomeViewTripsDAO();
        // Read filters from the form
        String origin   = emptyToNull(request.getParameter("origin"));
        String dest     = emptyToNull(request.getParameter("destination"));
        String depDate  = emptyToNull(request.getParameter("departureDate"));
        Date date       = null;
        if (depDate != null) {
            try { date = Date.valueOf(LocalDate.parse(depDate)); }
            catch (Exception e) { }
        }

        List<HomeTrip> trips = homeViewTripsDAO.getTrips(origin, dest, date);
        List<String>    locations = homeViewTripsDAO.getAllLocations();

        request.setAttribute("locations", locations);
        request.setAttribute("trips", trips);
        request.setAttribute("selectedOrigin", origin);
        request.setAttribute("selectedDestination", dest);
        request.setAttribute("selectedDate", depDate);

        request.getRequestDispatcher("/WEB-INF/pages/view-trips.jsp")
               .forward(request, response);
    }

    /**
     * Utility: convert empty or blank string to null for cleaner DAO calls.
     */
    private String emptyToNull(String s) {
        if (s == null) {
            return null;
        }
        s = s.trim();
        return s.isEmpty() ? null : s;
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
