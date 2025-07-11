/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.DriverAssignedTripsDAO;
import busticket.model.DriverAssignedTrip;
import busticket.model.Users;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class DriverAssignedTripsServlet extends HttpServlet {

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
        // Get driver_id from session or request
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("currentUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Users currentUser = (Users) session.getAttribute("currentUser");
    int driverId = currentUser.getUser_id();  // Assuming driver_id is stored in 'currentUser'

    // Fetch the assigned trips for the driver
    DriverAssignedTripsDAO driverAssignedTripsDAO = new DriverAssignedTripsDAO();
    List<DriverAssignedTrip> assignedTrips = driverAssignedTripsDAO.getAssignedTrips(driverId);

    // Set the trips list as a request attribute
    request.setAttribute("assignedTrips", assignedTrips);

    // Forward the request to the JSP page for displaying the trips
    request.getRequestDispatcher("/WEB-INF/driver/assigned-trips.jsp").forward(request, response);
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
