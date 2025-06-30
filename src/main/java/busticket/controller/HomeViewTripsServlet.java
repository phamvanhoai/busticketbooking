/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.HomeViewTripsDAO;
import busticket.model.AdminRouteStop;
import busticket.model.AdminSeatPosition;
import busticket.model.HomeTrip;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

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

        // Kiểm tra AJAX request lấy sơ đồ ghế
        String ajax = request.getParameter("ajax");
        if ("seats".equals(ajax)) {
            try {
                // parse busTypeId, tripId
                int busTypeId = Integer.parseInt(request.getParameter("busTypeId"));
                int tripId = Integer.parseInt(request.getParameter("tripId"));
                List<AdminSeatPosition> down = homeViewTripsDAO.getSeatPositions(busTypeId, "down");
                List<AdminSeatPosition> up = homeViewTripsDAO.getSeatPositions(busTypeId, "up");
                List<String> booked = homeViewTripsDAO.getBookedSeatNumbers(tripId);
                List<Map<String, Object>> downJson = new ArrayList<>(), upJson = new ArrayList<>();
                for (AdminSeatPosition s : down) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("row", s.getRow());
                    m.put("col", s.getCol());
                    m.put("code", s.getCode());
                    m.put("booked", booked.contains(s.getCode()));
                    downJson.add(m);
                }
                for (AdminSeatPosition s : up) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("row", s.getRow());
                    m.put("col", s.getCol());
                    m.put("code", s.getCode());
                    m.put("booked", booked.contains(s.getCode()));
                    upJson.add(m);
                }
                Map<String, Object> result = new HashMap<>();
                result.put("down", downJson);
                result.put("up", upJson);
                response.setContentType("application/json;charset=UTF-8");
                new ObjectMapper().writeValue(response.getWriter(), result);
                return;
            } catch (SQLException ex) {
                Logger.getLogger(HomeViewTripsServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        // Lấy filter params cho view thông thường
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String depDate = request.getParameter("departureDate");
        String ticketCountParam = request.getParameter("ticket");
        Integer ticketCount = ticketCountParam != null && !ticketCountParam.isEmpty() ? Integer.parseInt(ticketCountParam) : null;
        Date date = null;
        if (depDate != null && !depDate.trim().isEmpty()) {
            date = Date.valueOf(depDate);
        }

        // Xử lý phân trang
        int requestsPerPage = 10; // Số lượng chuyến đi hiển thị trên mỗi trang
        int currentPage = 1; // Mặc định trang đầu tiên

        // Kiểm tra tham số page trong URL
        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;  // Nếu không phải số, mặc định trang là 1
            }
        }

        // Tính toán offset cho truy vấn SQL
        int offset = (currentPage - 1) * requestsPerPage;

        // Gọi DAO để lấy danh sách chuyến đi và phân trang
        List<String> locations = homeViewTripsDAO.getAllLocations();
        request.setAttribute("locations", locations);

        // Kiểm tra sự hợp lệ của origin và destination
        boolean hasOrigin = origin != null && !origin.trim().isEmpty();
        boolean hasDestination = destination != null && !destination.trim().isEmpty();
        if (hasOrigin ^ hasDestination || (origin != null && origin.equals(destination))) {
            request.setAttribute("error", "Vui lòng chọn cả điểm đi và điểm đến, và chúng không thể giống nhau.");
            request.getRequestDispatcher("/WEB-INF/pages/view-trips.jsp").forward(request, response);
            return;
        }

        // Lấy danh sách chuyến đi với phân trang
        List<HomeTrip> trips = homeViewTripsDAO.getTrips(
                hasOrigin ? origin : null,
                hasDestination ? destination : null,
                date,
                ticketCount,
                offset,
                requestsPerPage
        );

        // Lấy các điểm dừng cho từng chuyến đi
        for (HomeTrip trip : trips) {
            int tripId = trip.getTripId();
            List<AdminRouteStop> stops = homeViewTripsDAO.getRouteStopsForTrip(tripId);

            // Tính toán giờ đến cho từng điểm dừng
            List<String> stopTimes = new ArrayList<>();
            LocalTime curTime = LocalTime.parse(trip.getTripTime()); // tripTime kiểu HH:mm

            for (int i = 0; i < stops.size(); i++) {
                AdminRouteStop stop = stops.get(i);
                // Stop đầu lấy giờ xuất phát
                if (i > 0) {
                    // Cộng travelMinutes, dwell chỉ cộng nếu muốn tính giờ rời
                    curTime = curTime.plusMinutes(stop.getTravelMinutes());
                }
                stopTimes.add(curTime.toString()); // Tính toán giờ đến và lưu vào stopTimes
            }

            // Set các thông tin của stops và stopTimes vào trip
            trip.setRouteStops(stops);
            trip.setStopTimes(stopTimes);  // Gán stopTimes vào trip
        }

        // Tổng số chuyến đi và tổng số trang
        int totalTrips = homeViewTripsDAO.countTrips(origin, destination, date, ticketCount);
        int totalPages = (int) Math.ceil((double) totalTrips / requestsPerPage);

        // Set các thuộc tính vào request
        request.setAttribute("trips", trips);
        request.setAttribute("totalTrips", totalTrips);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // Chuyển tiếp yêu cầu đến JSP mà không thay đổi URL
        request.getRequestDispatcher("/WEB-INF/pages/view-trips.jsp").forward(request, response);
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
