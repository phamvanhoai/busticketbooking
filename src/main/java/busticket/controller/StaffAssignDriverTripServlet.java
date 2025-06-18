/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.DriverTripDAO;
import busticket.DAO.StaffDriverDAO;
import busticket.DAO.TripDAO;
import busticket.model.Driver;
import busticket.model.Trip;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffAssignDriverTripServlet extends HttpServlet {

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
        TripDAO tripDAO = new TripDAO();
        StaffDriverDAO driverDAO = new StaffDriverDAO();

        List<Trip> tripList = tripDAO.getAllAvailableTrips();
        List<Driver> driverList = driverDAO.getAllDrivers();

        request.setAttribute("trips", tripList);
        request.setAttribute("drivers", driverList);

        request.getRequestDispatcher("/WEB-INF/staff/driver-trip/assign-driver-to-trip.jsp")
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
        String tripId = request.getParameter("tripId");
        String driverId = request.getParameter("driverId");

        if (tripId == null || driverId == null || tripId.isEmpty() || driverId.isEmpty()) {
            request.getSession().setAttribute("error", "Please select both Trip and Driver.");
            response.sendRedirect(request.getContextPath() + "/staff/assign-driver-trip");
            return;
        }

        DriverTripDAO dao = new DriverTripDAO();

        int tripIdInt = Integer.parseInt(tripId);
        int driverIdInt = Integer.parseInt(driverId);

        if (dao.isDriverAssigned(tripIdInt)) {
            request.getSession().setAttribute("error", "This trip already has a driver assigned.");
        } else {
            boolean success = dao.assignDriverToTrip(driverIdInt, tripIdInt);
            if (success) {
                request.getSession().setAttribute("success", "Driver assigned to trip successfully.");
            } else {
                request.getSession().setAttribute("error", "Failed to assign driver. Please try again.");
            }
        }

        // Redirect to avoid duplicate form error when F5
        response.sendRedirect(request.getContextPath() + "/staff/assign-driver-trip");
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
