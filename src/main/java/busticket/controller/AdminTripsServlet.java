/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminTripsDAO;
import busticket.model.AdminBuses;
import busticket.model.AdminDrivers;
import busticket.model.AdminRouteStop;
import busticket.model.AdminRoutes;
import busticket.model.AdminTrips;
import busticket.model.AdminUsers;
import busticket.util.SessionUtil;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminTripsServlet extends HttpServlet {

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
        // Check if the user is an admin; redirect to home if not
        if (!SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath());
            return;
        }

        AdminTripsDAO adminTripsDAO = new AdminTripsDAO();

        if (request.getParameter("add") != null) {
            request.setAttribute("routes", adminTripsDAO.getAllRoutes());
            request.setAttribute("buses", adminTripsDAO.getAllBuses());
            request.setAttribute("drivers", adminTripsDAO.getAllDrivers());
            request.getRequestDispatcher("/WEB-INF/admin/trips/add-trip.jsp")
                    .forward(request, response);
            return;
        }

        String detail = request.getParameter("detail");
        if (detail != null) {
            try {
                int tripId = Integer.parseInt(detail);
                AdminTrips trip = adminTripsDAO.getTripDetailById(tripId);
                int routeId = trip.getRouteId();
                List<AdminRouteStop> stops = adminTripsDAO.getRouteStops(routeId);
                List<String> stopTimes = new ArrayList<>();
                LocalTime curTime = LocalTime.parse(trip.getTripTime());

                for (int i = 0; i < stops.size(); i++) {
                    AdminRouteStop stop = stops.get(i);
                    if (i > 0) {
                        curTime = curTime.plusMinutes(stop.getTravelMinutes() + stop.getDwellMinutes());
                    }
                    stopTimes.add(curTime.toString());
                }

                List<AdminUsers> passengers = adminTripsDAO.getPassengersByTripId(tripId);
                request.setAttribute("trip", trip);
                request.setAttribute("passengers", passengers);
                request.setAttribute("stops", stops);
                request.setAttribute("stopTimes", stopTimes);
                request.getRequestDispatcher("/WEB-INF/admin/trips/view-trip-details.jsp")
                        .forward(request, response);
            } catch (Exception ex) {
                ex.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/admin/trips");
            }
            return;
        }

        String editId = request.getParameter("editId");
        if (editId != null) {
            try {
                int tripId = Integer.parseInt(editId);
                AdminTrips trip = adminTripsDAO.getTripById(tripId);
                List<AdminRoutes> routes = adminTripsDAO.getAllRoutes();
                List<AdminBuses> buses = adminTripsDAO.getAllBuses();
                List<AdminDrivers> drivers = adminTripsDAO.getAllDrivers();

                request.setAttribute("trip", trip);
                request.setAttribute("routes", routes);
                request.setAttribute("buses", buses);
                request.setAttribute("drivers", drivers);

                request.getRequestDispatcher("/WEB-INF/admin/trips/edit-trip.jsp")
                        .forward(request, response);
                return;
            } catch (NumberFormatException nfe) {
                request.getSession().setAttribute("error", "Invalid trip ID.");
            } catch (SQLException sqle) {
                request.getSession().setAttribute("error", "Database error: " + sqle.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/admin/trips");
            return;
        }

        String delete = request.getParameter("delete");
        if (delete != null) {
            try {
                int tripId = Integer.parseInt(delete);
                AdminTrips trip = adminTripsDAO.getTripById(tripId);
                List<AdminRoutes> routes = adminTripsDAO.getAllRoutes();
                List<AdminBuses> buses = adminTripsDAO.getAllBuses();
                List<AdminDrivers> drivers = adminTripsDAO.getAllDrivers();

                request.setAttribute("trip", trip);
                request.setAttribute("routes", routes);
                request.setAttribute("buses", buses);
                request.setAttribute("drivers", drivers);

                request.getRequestDispatcher("/WEB-INF/admin/trips/delete-trip.jsp")
                        .forward(request, response);
                return;
            } catch (NumberFormatException | SQLException ex) {
                request.getSession().setAttribute("error", "Cannot load trip for deletion.");
                response.sendRedirect(request.getContextPath() + "/admin/trips");
                return;
            }
        }

        List<String> locations = adminTripsDAO.getAllLocations();
        List<AdminDrivers> drivers = adminTripsDAO.getAllDrivers();
        List<String> busTypes = adminTripsDAO.getAllBusTypes();

        String route = request.getParameter("route");
        String busType = request.getParameter("busType");
        String driver = request.getParameter("driver");

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
        List<AdminTrips> trips = adminTripsDAO.getAllTrips(route, busType, driver, offset, tripsPerPage);
        int totalTrips = adminTripsDAO.getTotalTripsCount(route, busType, driver);
        int totalPages = (int) Math.ceil((double) totalTrips / tripsPerPage);

        request.setAttribute("trips", trips);
        request.setAttribute("locations", locations);
        request.setAttribute("drivers", drivers);
        request.setAttribute("busTypes", busTypes);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTrips", totalTrips);

        request.getRequestDispatcher("/WEB-INF/admin/trips/trips.jsp").forward(request, response);
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
        String action = request.getParameter("action");
        AdminTripsDAO adminTripsDAO = new AdminTripsDAO();

        try {
            if ("add".equals(action)) {
                int routeId = Integer.parseInt(request.getParameter("route"));
                int busId = Integer.parseInt(request.getParameter("bus"));
                int driverId = Integer.parseInt(request.getParameter("driver"));
                LocalDate ld = LocalDate.parse(request.getParameter("departureDate"));
                LocalTime lt = LocalTime.parse(request.getParameter("departureTime"));
                Timestamp ts = Timestamp.valueOf(LocalDateTime.of(ld, lt));
                String status = request.getParameter("status");

                try {
                    adminTripsDAO.addTrip(routeId, busId, driverId, ts, status);
                    request.getSession().setAttribute("success", "Trip added successfully.");
                    response.sendRedirect(request.getContextPath() + "/admin/trips");
                } catch (SQLException e) {
                    request.getSession().setAttribute("error", e.getMessage());
                    request.setAttribute("routes", adminTripsDAO.getAllRoutes());
                    request.setAttribute("buses", adminTripsDAO.getAllBuses());
                    request.setAttribute("drivers", adminTripsDAO.getAllDrivers());
                    request.setAttribute("route", routeId);
                    request.setAttribute("bus", busId);
                    request.setAttribute("driver", driverId);
                    request.setAttribute("departureDate", ld.toString());
                    request.setAttribute("departureTime", lt.toString());
                    request.setAttribute("status", status);
                    request.getRequestDispatcher("/WEB-INF/admin/trips/add-trip.jsp").forward(request, response);
                }
                return;

            } else if ("edit".equals(action)) {
                int tripId = Integer.parseInt(request.getParameter("tripId"));
                int routeId = Integer.parseInt(request.getParameter("route"));
                int busId = Integer.parseInt(request.getParameter("bus"));
                int driverId = Integer.parseInt(request.getParameter("driver"));
                LocalDate ld = LocalDate.parse(request.getParameter("departureDate"));
                LocalTime lt = LocalTime.parse(request.getParameter("departureTime"));
                Timestamp ts = Timestamp.valueOf(LocalDateTime.of(ld, lt));
                String status = request.getParameter("status");

                try {
                    adminTripsDAO.updateTrip(tripId, routeId, busId, driverId, ts, status);
                    request.getSession().setAttribute("success", "Trip updated successfully.");
                    response.sendRedirect(request.getContextPath() + "/admin/trips");
                } catch (SQLException e) {
                    AdminTrips trip = adminTripsDAO.getTripById(tripId);
                    request.getSession().setAttribute("error", e.getMessage());
                    request.setAttribute("trip", trip);
                    request.setAttribute("routes", adminTripsDAO.getAllRoutes());
                    request.setAttribute("buses", adminTripsDAO.getAllBuses());
                    request.setAttribute("drivers", adminTripsDAO.getAllDrivers());
                    request.setAttribute("route", routeId);
                    request.setAttribute("bus", busId);
                    request.setAttribute("driver", driverId);
                    request.setAttribute("departureDate", ld.toString());
                    request.setAttribute("departureTime", lt.toString());
                    request.setAttribute("status", status);
                    request.getRequestDispatcher("/WEB-INF/admin/trips/edit-trip.jsp").forward(request, response);
                }
                return;

            } else if ("delete".equals(action)) {
                int tripId = Integer.parseInt(request.getParameter("tripId"));
                adminTripsDAO.deleteTrip(tripId);
                request.getSession().setAttribute("success", "Trip deleted successfully.");
                response.sendRedirect(request.getContextPath() + "/admin/trips");
                return;
            }

        } catch (Exception ex) {
            request.getSession().setAttribute("error", "An error occurred: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/trips");
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
