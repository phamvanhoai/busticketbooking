/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffAssignDriverDAO;
import busticket.model.Driver;
import busticket.model.StaffTrip;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffAssignDriverTripServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final StaffAssignDriverDAO dao = new StaffAssignDriverDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get filters
            String search = request.getParameter("search");
            String date = request.getParameter("date");
            String routeId = request.getParameter("routeId");
            String status = request.getParameter("status");
            String action = request.getParameter("action");
            String tripIdParam = request.getParameter("tripId");

            // Handle 'Remove Driver' action
            if ("remove".equals(action) && tripIdParam != null) {
                try {
                    int tripId = Integer.parseInt(tripIdParam);
                    dao.removeDriver(tripId);
                    request.getSession().setAttribute("success", "Driver removed from trip successfully.");
                } catch (Exception e) {
                    request.getSession().setAttribute("error", "Unable to remove driver from trip.");
                }
                response.sendRedirect(request.getContextPath() + "/staff/assign-driver-trip");
                return;
            }

            // Pagination
            int page = 1;
            int pageSize = 10;
            String pageRaw = request.getParameter("page");
            if (pageRaw != null && pageRaw.matches("\\d+")) {
                page = Integer.parseInt(pageRaw);
            }
            int offset = (page - 1) * pageSize;

            // Total results
            int totalRows = dao.countAvailableTrips(search, date, routeId, status);
            int totalPages = (int) Math.ceil(totalRows * 1.0 / pageSize);

            // Fetch trip list
            List<StaffTrip> trips = dao.getAvailableTripsWithPaging(search, date, routeId, status, offset, pageSize);

            // Dropdown filters
            request.setAttribute("distinctRoutes", dao.getDistinctRoutes());
            request.setAttribute("driverList", dao.getAvailableDrivers());

            // Pass data to JSP
            request.setAttribute("tripList", trips);
            request.setAttribute("currentPage", page);
            request.setAttribute("numOfPages", totalPages);
            request.setAttribute("search", search);
            request.setAttribute("date", date);
            request.setAttribute("dateFilter", date);
            request.setAttribute("routeId", routeId);
            request.setAttribute("status", status);

            // Build pagination URL while keeping filters
            StringBuilder base = new StringBuilder(request.getContextPath()).append("/staff/assign-driver-trip");
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
            request.getRequestDispatcher("/WEB-INF/staff/driver-trip/assign-driver-to-trip.jsp").forward(request, response);

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(500, "Internal Server Error: " + ex.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String tripId = request.getParameter("tripId");
            String driverId = request.getParameter("driverId");

            // Assign driver to trip
            if (tripId != null && !tripId.isEmpty()) {
                if (driverId == null || driverId.isEmpty()) {
                    request.getSession().setAttribute("error", "Please select a driver to assign!");
                    response.sendRedirect(request.getContextPath() + "/staff/assign-driver-trip");
                    return;
                }

                int tripIdInt = Integer.parseInt(tripId);
                int driverIdInt = Integer.parseInt(driverId);

                boolean success;
                if (dao.isDriverAssigned(tripIdInt)) {
                    success = dao.updateDriverAssignment(driverIdInt, tripIdInt);
                    request.getSession().setAttribute(success ? "success" : "error",
                            success ? "Driver updated successfully." : "Driver update failed.");
                } else {
                    success = dao.assignDriverToTrip(driverIdInt, tripIdInt);
                    request.getSession().setAttribute(success ? "success" : "error",
                            success ? "Driver assigned successfully." : "Driver assignment failed.");
                }

                response.sendRedirect(request.getContextPath() + "/staff/assign-driver-trip");
                return;
            }

            // Filter trips
            String search = request.getParameter("search");
            String date = request.getParameter("date");
            String routeId = request.getParameter("routeId");
            String status = request.getParameter("status");

            // Pagination
            int page = 1;
            String pageRaw = request.getParameter("page");
            if (pageRaw != null && pageRaw.matches("\\d+")) {
                page = Integer.parseInt(pageRaw);
            }
            int pageSize = 10;
            int offset = (page - 1) * pageSize;

            int totalRows = dao.countAvailableTrips(search, date, routeId, status);
            int totalPages = (int) Math.ceil(totalRows * 1.0 / pageSize);
            List<StaffTrip> trips = dao.getAvailableTripsWithPaging(search, date, routeId, status, offset, pageSize);

            // Set attributes
            request.setAttribute("tripList", trips);
            request.setAttribute("currentPage", page);
            request.setAttribute("numOfPages", totalPages);
            request.setAttribute("search", search);
            request.setAttribute("date", date);
            request.setAttribute("dateFilter", date);
            request.setAttribute("routeId", routeId);
            request.setAttribute("status", status);
            request.setAttribute("baseUrlWithSearch", request.getContextPath() + "/staff/assign-driver-trip");
            request.setAttribute("distinctRoutes", dao.getDistinctRoutes());
            request.setAttribute("driverList", dao.getAvailableDrivers());

            request.getRequestDispatcher("/WEB-INF/staff/driver-trip/assign-driver-to-trip.jsp")
                    .forward(request, response);

        } catch (Exception ex) {
            ex.printStackTrace();
            request.getSession().setAttribute("error", "Unexpected error occurred: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/assign-driver-trip");
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
