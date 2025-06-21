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
import jakarta.servlet.http.HttpSession;
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
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object success = session.getAttribute("success");
            Object error = session.getAttribute("error");
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }
            if (error != null) {
                request.setAttribute("error", error);
                session.removeAttribute("error");
            }
        }

        try {
            // --- Show add form ---
            if (request.getParameter("add") != null) {
                loadFormData(request, 0);
                request.getRequestDispatcher("/WEB-INF/admin/routes/add-route.jsp")
                        .forward(request, response);
                return;
            }

            // --- Show edit form ---
            String editId = request.getParameter("editId");
            if (editId != null) {
                int routeId = Integer.parseInt(editId);
                loadFormData(request, routeId);
                // Lấy estimatedTime (phút) từ model
                AdminRoutes route = adminRoutesDAO.getRouteById(routeId);
                int totalMinutes = route.getEstimatedTime();
                int hours = totalMinutes / 60;        // chia lấy phần nguyên
                int minutes = totalMinutes % 60;        // phần dư

                request.setAttribute("routeHours", hours);
                request.setAttribute("routeMinutes", minutes);
                request.getRequestDispatcher("/WEB-INF/admin/routes/edit-route.jsp")
                        .forward(request, response);
                return;
            }

            // --- Show delete confirmation ---
            String deleteId = request.getParameter("delete");
            if (deleteId != null) {
                int routeId = Integer.parseInt(deleteId);
                request.setAttribute("route", adminRoutesDAO.getRouteById(routeId));
                request.getRequestDispatcher("/WEB-INF/admin/routes/delete-route.jsp")
                        .forward(request, response);
                return;
            }

            // --- List with pagination ---
            int perPage = 10;
            int page = 1;
            if (request.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException ignored) {
                }
            }
            int offset = (page - 1) * perPage;
            List<AdminRoutes> routes = adminRoutesDAO.getAllRoutes(offset, perPage);
            int total = adminRoutesDAO.countRoutes();
            int totalPages = (int) Math.ceil((double) total / perPage);

            request.setAttribute("routes", routes);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("locations", adminRoutesDAO.getAllLocations());
            request.getRequestDispatcher("/WEB-INF/admin/routes/routes.jsp")
                    .forward(request, response);

        } catch (SQLException ex) {
            throw new ServletException("Error loading routes", ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AdminRoutesDAO adminRoutesDAO = new AdminRoutesDAO();
        String action = request.getParameter("action");
        String baseUrl = request.getContextPath() + "/admin/routes";
        HttpSession session = request.getSession();

        try {
            if ("create".equalsIgnoreCase(action)) {
                try {
                    // --- 1) Tạo route chính ---
                    AdminRoutes r = new AdminRoutes();
                    r.setStartLocationId(Integer.parseInt(request.getParameter("startLocationId")));
                    r.setEndLocationId(Integer.parseInt(request.getParameter("endLocationId")));
                    r.setDistanceKm(Double.parseDouble(request.getParameter("distance")));
                    int h = Integer.parseInt(request.getParameter("hours"));
                    int m = Integer.parseInt(request.getParameter("minutes"));
                    r.setEstimatedTime(h * 60 + m);
                    r.setRouteStatus(request.getParameter("routeStatus"));
                    int routeId = adminRoutesDAO.createRoute(r);

                    // --- 2) Prices: đọc mảng ---
                    String[] busTypes = request.getParameterValues("pricesBusTypeId[]");
                    String[] prices = request.getParameterValues("pricesPrice[]");
                    if (busTypes != null && prices != null) {
                        int n = Math.min(busTypes.length, prices.length);
                        for (int i = 0; i < n; i++) {
                            String bt = busTypes[i].trim();
                            String pr = prices[i].trim();
                            if (!bt.isEmpty() && !pr.isEmpty()) {
                                adminRoutesDAO.addRoutePrice(
                                        routeId,
                                        Integer.parseInt(bt),
                                        new BigDecimal(pr)
                                );
                            }
                        }
                    }

                    // --- 3) Stops: đọc mảng ---
                    String[] locs = request.getParameterValues("stopsLocationId[]");
                    String[] dwells = request.getParameterValues("stopsDwellMinutes[]");
                    if (locs != null && dwells != null) {
                        List<AdminRouteStop> stops = new ArrayList<>();
                        int mStops = Math.min(locs.length, dwells.length);
                        for (int i = 0; i < mStops; i++) {
                            String sl = locs[i].trim();
                            String dw = dwells[i].trim();
                            if (!sl.isEmpty() && !dw.isEmpty()) {
                                stops.add(new AdminRouteStop(
                                        routeId,
                                        stops.size() + 1,
                                        Integer.parseInt(sl),
                                        Integer.parseInt(dw)
                                ));
                            }
                        }
                        if (!stops.isEmpty()) {
                            adminRoutesDAO.addRouteStops(routeId, stops);
                        }
                    }

                    session.setAttribute("success", "Route created successfully!");
                    response.sendRedirect(baseUrl);
                    return;

                } catch (Exception ex) {
                    log("Error creating route", ex);
                    request.setAttribute("error", "Create failed: " + ex.getMessage());
                    loadFormData(request, 0);
                    request.getRequestDispatcher("/WEB-INF/admin/routes/add-route.jsp")
                            .forward(request, response);
                    return;
                }

            } else if ("update".equalsIgnoreCase(action)) {
                try {
                    // --- 1) Cập nhật route chính ---
                    int routeId = Integer.parseInt(request.getParameter("routeId"));
                    AdminRoutes route = new AdminRoutes();
                    route.setRouteId(routeId);
                    route.setStartLocationId(Integer.parseInt(request.getParameter("startLocationId")));
                    route.setEndLocationId(Integer.parseInt(request.getParameter("endLocationId")));
                    route.setDistanceKm(Double.parseDouble(request.getParameter("distance")));
                    int hours = Integer.parseInt(request.getParameter("hours"));
                    int minutes = Integer.parseInt(request.getParameter("minutes"));
                    route.setEstimatedTime(hours * 60 + minutes);
                    route.setRouteStatus(request.getParameter("routeStatus"));
                    adminRoutesDAO.updateRoute(route);

                    // --- 2) Prices: xóa cũ + thêm mới (mảng) ---
                    adminRoutesDAO.deleteRoutePrices(routeId);
                    String[] busTypes = request.getParameterValues("pricesBusTypeId[]");
                    String[] prices = request.getParameterValues("pricesPrice[]");
                    if (busTypes != null && prices != null) {
                        int n = Math.min(busTypes.length, prices.length);
                        for (int i = 0; i < n; i++) {
                            String bt = busTypes[i].trim();
                            String pr = prices[i].trim();
                            if (!bt.isEmpty() && !pr.isEmpty()) {
                                adminRoutesDAO.addRoutePrice(
                                        routeId,
                                        Integer.parseInt(bt),
                                        new BigDecimal(pr)
                                );
                            }
                        }
                    }

                    // --- 3) Stops: xóa cũ + thêm mới (mảng) ---
                    adminRoutesDAO.deleteRouteStops(routeId);
                    String[] locs = request.getParameterValues("stopsLocationId[]");
                    String[] dwells = request.getParameterValues("stopsDwellMinutes[]");
                    if (locs != null && dwells != null) {
                        List<AdminRouteStop> newStops = new ArrayList<>();
                        int mStops = Math.min(locs.length, dwells.length);
                        for (int i = 0; i < mStops; i++) {
                            String sl = locs[i].trim();
                            String dw = dwells[i].trim();
                            if (!sl.isEmpty() && !dw.isEmpty()) {
                                newStops.add(new AdminRouteStop(
                                        routeId,
                                        newStops.size() + 1,
                                        Integer.parseInt(sl),
                                        Integer.parseInt(dw)
                                ));
                            }
                        }
                        if (!newStops.isEmpty()) {
                            adminRoutesDAO.addRouteStops(routeId, newStops);
                        }
                    }

                    session.setAttribute("success", "Route updated successfully!");
                    response.sendRedirect(baseUrl);
                    return;

                } catch (Exception ex) {
                    log("Error updating route", ex);
                    request.setAttribute("error", "Update failed: " + ex.getMessage());
                    loadFormData(request, Integer.parseInt(request.getParameter("routeId")));
                    request.getRequestDispatcher("/WEB-INF/admin/routes/edit-route.jsp")
                            .forward(request, response);
                    return;
                }

            } else if ("delete".equalsIgnoreCase(action)) {
                int routeId = Integer.parseInt(request.getParameter("routeId"));
                adminRoutesDAO.deleteRoute(routeId);
                session.setAttribute("success", "Route deleted successfully!");
                response.sendRedirect(baseUrl);
                return;
            }

            // Unknown action
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");

        } catch (SQLException ex) {
            throw new ServletException("Error processing routes", ex);
        }
    }

    private void loadFormData(HttpServletRequest request, int routeId) throws SQLException {
        AdminRoutesDAO adminRoutesDAO = new AdminRoutesDAO();

        AdminRoutes route = adminRoutesDAO.getRouteById(routeId);
        List<AdminRouteStop> stops = adminRoutesDAO.getRouteStops(routeId);
        List<AdminRoutePrice> prices = adminRoutesDAO.getPricesByRouteId(routeId);
        List<AdminLocations> locations = adminRoutesDAO.getAllLocations();
        List<AdminBusTypes> busTypes = adminRoutesDAO.getAllBusTypes();

        request.setAttribute("route", route);
        request.setAttribute("stops", stops);
        request.setAttribute("prices", prices);
        request.setAttribute("locations", locations);
        request.setAttribute("busTypes", busTypes);
    }

}
