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

        AdminTripsDAO adminTripsDAO = new AdminTripsDAO();

        // Lấy tham số hành động (action)
        String action = request.getParameter("action");

        if (request.getParameter("add") != null) {
            AdminTripsDAO dao = new AdminTripsDAO();
            request.setAttribute("routes", dao.getAllRoutes());
            request.setAttribute("buses", dao.getAllBuses());
            request.setAttribute("drivers", dao.getAllDrivers());
            request.getRequestDispatcher("/WEB-INF/admin/trips/add-trip.jsp")
                    .forward(request, response);
            return;
        }

        // View details flow
        String detail = request.getParameter("detail");
        if (detail != null) {
            try {
                int tripId = Integer.parseInt(detail);
                AdminTrips trip = adminTripsDAO.getTripDetailById(tripId);

                // Mới: Lấy danh sách điểm dừng của route
                int routeId = trip.getRouteId();
                List<AdminRouteStop> stops = adminTripsDAO.getRouteStops(routeId);

                // Tính giờ đến từng stop (giờ xuất phát + travelMinutes cộng dồn)
                List<String> stopTimes = new ArrayList<>();
                LocalTime curTime = LocalTime.parse(trip.getTripTime()); // tripTime kiểu HH:mm

                for (int i = 0; i < stops.size(); i++) {
                    AdminRouteStop stop = stops.get(i);
                    // Stop đầu lấy giờ xuất phát
                    if (i > 0) {
                        // Cộng travelMinutes, dwell chỉ cộng nếu muốn tính giờ rời
                        curTime = curTime.plusMinutes(stop.getTravelMinutes() + stop.getDwellMinutes());
                    }
                    stopTimes.add(curTime.toString());
                }

                // Load danh sách hành khách
                List<AdminUsers> passengers = adminTripsDAO.getPassengersByTripId(tripId);

                // Đẩy vào request
                request.setAttribute("trip", trip);
                request.setAttribute("passengers", passengers);

                // Đẩy thêm
                request.setAttribute("stops", stops);
                request.setAttribute("stopTimes", stopTimes);
                for (AdminRouteStop s : stops) {
                }

                request.getRequestDispatcher("/WEB-INF/admin/trips/view-trip-details.jsp")
                        .forward(request, response);
            } catch (Exception ex) {
                ex.printStackTrace();  // Xem lỗi chi tiết trong log console
                response.sendRedirect(request.getContextPath() + "/admin/trips");
                
                return;
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
                // ID không hợp lệ
                request.setAttribute("error", "Invalid trip ID.");
            } catch (SQLException sqle) {
                // Lỗi DB
                request.setAttribute("error", "Database error: " + sqle.getMessage());
            }
            // Nếu có lỗi, chuyển về trang list hoặc hiển thị thông báo
            response.sendRedirect(request.getContextPath() + "/admin/trips");
            return;
        }

        // 1) Nếu là Delete flow
        String delete = request.getParameter("delete");
        if (delete != null) {
            try {
                int tripId = Integer.parseInt(delete);
                // load dữ liệu chuyến
                AdminTrips trip = adminTripsDAO.getTripById(tripId);
                // đổ dropdown nếu muốn hiển thị tham số route/bus/driver
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
                // không tìm được hay lỗi DB — chuyển về list với thông báo
                request.getSession().setAttribute("error", "Cannot load trip for deletion.");
                response.sendRedirect(request.getContextPath() + "/admin/trips");
                return;
            }
        }

        // Lấy các danh sách dữ liệu từ DAO
        List<String> locations = adminTripsDAO.getAllLocations();  // Lấy danh sách locations
        List<AdminDrivers> drivers = adminTripsDAO.getAllDrivers();  // Lấy danh sách drivers
        List<String> busTypes = adminTripsDAO.getAllBusTypes();  // Lấy danh sách bus types

        // Các tham số lọc
        String route = request.getParameter("route");
        String busType = request.getParameter("busType");
        String driver = request.getParameter("driver");

        // Phân trang
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

        // Lấy danh sách chuyến đi với filter và phân trang
        List<AdminTrips> trips = adminTripsDAO.getAllTrips(route, busType, driver, offset, tripsPerPage);
        int totalTrips = adminTripsDAO.getTotalTripsCount(route, busType, driver);  // Lấy tổng số chuyến đi
        int totalPages = (int) Math.ceil((double) totalTrips / tripsPerPage);

        // Truyền dữ liệu vào request để hiển thị trên JSP
        request.setAttribute("trips", trips);
        request.setAttribute("locations", locations);  // Truyền locations vào JSP
        request.setAttribute("drivers", drivers);  // Truyền drivers vào JSP
        request.setAttribute("busTypes", busTypes);  // Truyền bus types vào JSP
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTrips", totalTrips);

        // Forward đến JSP
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
                // --- ADD NEW TRIP ---
                int routeId = Integer.parseInt(request.getParameter("route"));
                int busId = Integer.parseInt(request.getParameter("bus"));
                int driverId = Integer.parseInt(request.getParameter("driver"));
                // đọc ngày/giờ và ghép thành Timestamp
                LocalDate ld = LocalDate.parse(request.getParameter("departureDate"));
                LocalTime lt = LocalTime.parse(request.getParameter("departureTime"));
                Timestamp ts = Timestamp.valueOf(LocalDateTime.of(ld, lt));
                String status = request.getParameter("status");  // mới thêm
                adminTripsDAO.addTrip(routeId, busId, driverId, ts, status);
                // sau khi thêm, redirect về list
                response.sendRedirect(request.getContextPath() + "/admin/trips");
                return;

            } else if ("edit".equals(action)) {
                // --- UPDATE EXISTING TRIP ---
                int tripId = Integer.parseInt(request.getParameter("tripId"));
                int routeId = Integer.parseInt(request.getParameter("route"));
                int busId = Integer.parseInt(request.getParameter("bus"));
                int driverId = Integer.parseInt(request.getParameter("driver"));
                LocalDate ld = LocalDate.parse(request.getParameter("departureDate"));
                LocalTime lt = LocalTime.parse(request.getParameter("departureTime"));
                Timestamp ts = Timestamp.valueOf(LocalDateTime.of(ld, lt));
                String status = request.getParameter("status");
                adminTripsDAO.updateTrip(tripId, routeId, busId, driverId, ts, status);
                response.sendRedirect(request.getContextPath() + "/admin/trips");
                return;

            } else if ("delete".equals(action)) {
                // --- DELETE TRIP ---
                int tripId = Integer.parseInt(request.getParameter("tripId"));
                adminTripsDAO.deleteTrip(tripId);
                response.sendRedirect(request.getContextPath() + "/admin/trips");
                return;
            }

        } catch (Exception ex) {
            // Nếu có lỗi, đưa thông báo vào request và forward về trang error hoặc list
            response.sendRedirect(request.getContextPath() + "/admin/trips");
            return;
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
