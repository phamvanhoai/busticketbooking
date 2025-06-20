/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminRoutesDAO;
import busticket.model.AdminBusTypes;
import busticket.model.AdminLocations;
import busticket.model.AdminRoutePrice;
import busticket.model.AdminRouteStop;
import busticket.model.AdminRoutes;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.view.Location;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminRoutesServlet extends HttpServlet {

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
        AdminRoutesDAO adminRoutesDAO = new AdminRoutesDAO();

        // Hiển thị form thêm
        if (request.getParameter("add") != null) {
            List<AdminBusTypes> busTypes = adminRoutesDAO.getAllBusTypes();
            request.setAttribute("busTypes", busTypes);

            List<AdminLocations> locations = adminRoutesDAO.getAllLocations();  // Lấy danh sách locations
            request.setAttribute("locations", locations);  // Truyền locations vào JSP
            request.getRequestDispatcher("/WEB-INF/admin/routes/add-route.jsp")
                    .forward(request, response);
            return;
        }

        // Edit Route
        String editId = request.getParameter("editId");
        if (editId != null) {
            try {
                int routeId = Integer.parseInt(editId);
                // 1) Route core
                AdminRoutes route = adminRoutesDAO.getRouteById(routeId);
                // 2) Bus types for price dropdown
                List<AdminBusTypes> busTypes = adminRoutesDAO.getAllBusTypes();
                // 3) Current prices
                List<AdminRoutePrice> prices = adminRoutesDAO.getPricesByRouteId(routeId);
                // 4) Current stops
                List<AdminRouteStop> stops = adminRoutesDAO.getRouteStops(routeId);
                // 5) Locations for all selects
                List<AdminLocations> locations = adminRoutesDAO.getAllLocations();

                request.setAttribute("route", route);
                request.setAttribute("busTypes", busTypes);
                request.setAttribute("prices", prices);
                request.setAttribute("stops", stops);
                request.setAttribute("locations", locations);

                // Lấy estimatedTime (phút) từ model
                int totalMinutes = route.getEstimatedTime();
                int hours = totalMinutes / 60;        // chia lấy phần nguyên
                int minutes = totalMinutes % 60;        // phần dư

                request.setAttribute("routeHours", hours);
                request.setAttribute("routeMinutes", minutes);

                request.getRequestDispatcher("/WEB-INF/admin/routes/edit-route.jsp")
                        .forward(request, response);
                return;
            } catch (SQLException ex) {
                Logger.getLogger(AdminRoutesServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        // Hiển thị form xóa
        String deleteId = request.getParameter("delete");
        if (deleteId != null) {
            int id = Integer.parseInt(deleteId);
            AdminRoutes route = adminRoutesDAO.getRouteById(id);
            if (route != null) {
                request.setAttribute("route", route);
                request.getRequestDispatcher("/WEB-INF/admin/routes/delete-route.jsp")
                        .forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Route not found.");
            }
            return;
        }

        // Danh sách với phân trang
        int routesPerPage = 10;
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        int offset = (currentPage - 1) * routesPerPage;

        List<AdminLocations> locations = adminRoutesDAO.getAllLocations();  // Lấy danh sách locations
        List<AdminRoutes> routesList = adminRoutesDAO.getAllRoutes(offset, routesPerPage);
        int totalRoutes = adminRoutesDAO.countRoutes();
        int totalPages = (int) Math.ceil((double) totalRoutes / routesPerPage);

        request.setAttribute("routes", routesList);
        request.setAttribute("locations", locations);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/WEB-INF/admin/routes/routes.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AdminRoutesDAO adminRoutesDAO = new AdminRoutesDAO();
        String action = request.getParameter("action");
        String baseUrl = request.getContextPath() + "/admin/routes";

        try {
            if ("create".equalsIgnoreCase(action)) {
                // --- 1) Tạo route và lấy routeId ---
                int startId = Integer.parseInt(request.getParameter("startLocationId"));
                int endId = Integer.parseInt(request.getParameter("endLocationId"));
                double dist = Double.parseDouble(request.getParameter("distance"));
                int hours = Integer.parseInt(request.getParameter("hours"));
                int mins = Integer.parseInt(request.getParameter("minutes"));
                int totalMin = hours * 60 + mins;

                int routeId;
                try ( PreparedStatement ps = adminRoutesDAO.getConnection()
                        .prepareStatement(
                                "INSERT INTO Routes(start_location_id,end_location_id,distance_km,estimated_time) VALUES(?,?,?,?)",
                                Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, startId);
                    ps.setInt(2, endId);
                    ps.setDouble(3, dist);
                    ps.setInt(4, totalMin);
                    ps.executeUpdate();
                    try ( ResultSet keys = ps.getGeneratedKeys()) {
                        keys.next();
                        routeId = keys.getInt(1);
                    }
                }

                // --- 2) Xử lý Route Prices ---
                String[] busTypeIds = request.getParameterValues("prices[].busTypeId");
                String[] priceVals = request.getParameterValues("prices[].price");
                if (busTypeIds != null && priceVals != null) {
                    for (int i = 0; i < busTypeIds.length; i++) {
                        int busTypeId = Integer.parseInt(busTypeIds[i]);
                        BigDecimal price = new BigDecimal(priceVals[i]);
                        // expire old, add new
                        adminRoutesDAO.expireOldRoutePrices(routeId, busTypeId);
                        adminRoutesDAO.addRoutePrice(routeId, busTypeId, price);
                    }
                }

                // --- 3) Xử lý Route Stops ---
                String[] stopLocs = request.getParameterValues("stops[].locationId");
                String[] stopDwells = request.getParameterValues("stops[].dwellMinutes");
                if (stopLocs != null && stopDwells != null) {
                    List<AdminRouteStop> stops = new ArrayList<>();
                    for (int i = 0; i < stopLocs.length; i++) {
                        int locId = Integer.parseInt(stopLocs[i]);
                        int dwell = Integer.parseInt(stopDwells[i]);
                        stops.add(new AdminRouteStop(routeId, i + 1, locId, dwell));
                    }
                    adminRoutesDAO.addRouteStops(routeId, stops);
                }

                response.sendRedirect(baseUrl);
                return;
            } else if ("update".equalsIgnoreCase(action)) {
                // --- 1) Update route ---
                int routeId = Integer.parseInt(request.getParameter("routeId"));
                int startId = Integer.parseInt(request.getParameter("startLocationId"));
                int endId = Integer.parseInt(request.getParameter("endLocationId"));
                double dist = Double.parseDouble(request.getParameter("distance"));
                int hours = Integer.parseInt(request.getParameter("hours"));
                int mins = Integer.parseInt(request.getParameter("minutes"));
                int totalMin = hours * 60 + mins;

                AdminRoutes r = new AdminRoutes();
                r.setRouteId(routeId);
                r.setStartLocationId(startId);
                r.setEndLocationId(endId);
                r.setDistanceKm(dist);
                r.setEstimatedTime(totalMin);
                adminRoutesDAO.updateRoute(r);

                // --- 2) Update prices ---
                String[] busTypeIds = request.getParameterValues("prices[].busTypeId");
                String[] priceVals = request.getParameterValues("prices[].price");
                if (busTypeIds != null && priceVals != null) {
                    for (int i = 0; i < busTypeIds.length; i++) {
                        int busTypeId = Integer.parseInt(busTypeIds[i]);
                        BigDecimal price = new BigDecimal(priceVals[i]);
                        adminRoutesDAO.expireOldRoutePrices(routeId, busTypeId);
                        adminRoutesDAO.addRoutePrice(routeId, busTypeId, price);
                    }
                }

                // --- 3) Update stops: xóa rồi thêm lại ---
                adminRoutesDAO.deleteRouteStops(routeId);
                String[] stopLocs = request.getParameterValues("stops[].locationId");
                String[] stopDwells = request.getParameterValues("stops[].dwellMinutes");
                if (stopLocs != null && stopDwells != null) {
                    List<AdminRouteStop> stops = new ArrayList<>();
                    for (int i = 0; i < stopLocs.length; i++) {
                        int locId = Integer.parseInt(stopLocs[i]);
                        int dwell = Integer.parseInt(stopDwells[i]);
                        stops.add(new AdminRouteStop(routeId, i + 1, locId, dwell));
                    }
                    adminRoutesDAO.addRouteStops(routeId, stops);
                }

                response.sendRedirect(baseUrl);
                return;
            } else if ("delete".equalsIgnoreCase(action)) {
                int routeId = Integer.parseInt(request.getParameter("routeId"));
                adminRoutesDAO.deleteRouteStops(routeId);
                // nếu cần, xóa hoặc expire giá ở đây
                adminRoutesDAO.deleteRoute(routeId);
                response.sendRedirect(baseUrl);
                return;
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
            }
        } catch (SQLException ex) {
            throw new ServletException("Error processing routes", ex);
        }
    }
}
