/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.DriverTripDAO;
import busticket.DAO.StaffAssignDriverDAO;
import busticket.model.Driver;
import busticket.model.StaffTrip;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
        /* Retrieve filter values and paging info */
        String search = request.getParameter("search");
        String date = request.getParameter("date");
        String routeId = request.getParameter("routeId");
        String status = request.getParameter("status");

        int page = 1;            // current page (default)
        int pageSize = 10;           // records per page
        String pageRaw = request.getParameter("page");
        if (pageRaw != null && pageRaw.matches("\\d+")) {
            page = Integer.parseInt(pageRaw);
        }
        int offset = (page - 1) * pageSize;

        StaffAssignDriverDAO dao = new StaffAssignDriverDAO();

        /* Count total rows and fetch paged trips */
        int totalRows = dao.countAvailableTrips(search, date, routeId, status);
        int totalPages = (int) Math.ceil(totalRows * 1.0 / pageSize);

        List<StaffTrip> trips
                = dao.getAvailableTripsWithPaging(search, date, routeId, status, offset, pageSize);

        /* Data for filter dropdowns */
        request.setAttribute("distinctRoutes", dao.getDistinctRoutes()); // route list
        request.setAttribute("drivers", dao.getAvailableDrivers());      // driver list

        /* Push data and paging variables to JSP */
        request.setAttribute("trips", trips);
        request.setAttribute("currentPage", page);
        request.setAttribute("numOfPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("date", date);
        request.setAttribute("routeId", routeId);
        request.setAttribute("status", status);

        /* Build base URL (without page param) so pagination tag can append ?page=n */
        StringBuilder base = new StringBuilder(request.getContextPath())
                .append("/staff/assign-driver-trip");

        List<String> q = new ArrayList<>();
        if (search != null && !search.isEmpty()) {
            q.add("search=" + search);
        }
        if (date != null && !date.isEmpty()) {
            q.add("date=" + date);
        }
        if (routeId != null && !routeId.isEmpty()) {
            q.add("routeId=" + routeId);
        }
        if (status != null && !status.isEmpty()) {
            q.add("status=" + status);
        }

        if (!q.isEmpty()) {
            base.append("?").append(String.join("&", q));
        }
        request.setAttribute("baseUrlWithSearch", base.toString());

        /* Forward to view */
        request.getRequestDispatcher(
                "/WEB-INF/staff/driver-trip/assign-driver-to-trip.jsp")
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
        // Retrieve form parameters
        String tripId = request.getParameter("tripId");
        String driverId = request.getParameter("driverId");

// Validate required fields
        if (tripId == null || driverId == null || tripId.isEmpty() || driverId.isEmpty()) {
            // Flash an error message and redirect back to the list
            request.getSession().setAttribute(
                    "error", "Please select both Trip and Driver.");
            response.sendRedirect(request.getContextPath() + "/staff/assign-driver-trip");
            return;
        }

// Convert parameter strings to integers
        int tripIdInt = Integer.parseInt(tripId);
        int driverIdInt = Integer.parseInt(driverId);

        StaffAssignDriverDAO dao = new StaffAssignDriverDAO();

// If the trip already has a driver, update; otherwise insert a new assignment
        if (dao.isDriverAssigned(tripIdInt)) {
            boolean updated = dao.updateDriverAssignment(driverIdInt, tripIdInt);
            if (updated) {
                request.getSession().setAttribute(
                        "success", "Driver assignment updated successfully.");
            } else {
                request.getSession().setAttribute(
                        "error", "Failed to update driver assignment.");
            }
        } else {
            boolean assigned = dao.assignDriverToTrip(driverIdInt, tripIdInt);
            if (assigned) {
                request.getSession().setAttribute(
                        "success", "Driver assigned to trip successfully.");
            } else {
                request.getSession().setAttribute(
                        "error", "Failed to assign driver.");
            }
        }

// PRG pattern: redirect back to the assignment list (GET)
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
