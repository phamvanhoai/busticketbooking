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
        String origin = emptyToNull(request.getParameter("origin"));
        String destination = emptyToNull(request.getParameter("destination"));
        String depDate = emptyToNull(request.getParameter("departureDate"));
        String ticketCountParam = emptyToNull(request.getParameter("ticket"));
        Integer ticketCount = ticketCountParam != null ? Integer.parseInt(ticketCountParam) : null;
        Date date = depDate != null ? Date.valueOf(depDate) : null;

        // Xử lý phân trang
        int requestsPerPage = 10;
        int currentPage = 1;
        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        int offset = (currentPage - 1) * requestsPerPage;

        // Lấy danh sách locations
        List<String> locations = homeViewTripsDAO.getAllLocations();
        request.setAttribute("locations", locations);

        // Kiểm tra sự hợp lệ của origin và destination
        boolean hasOrigin = origin != null;
        boolean hasDestination = destination != null;
        if (hasOrigin ^ hasDestination || (origin != null && origin.equals(destination))) {
            request.setAttribute("error", "Vui lòng chọn cả điểm đi và điểm đến, và chúng không thể giống nhau.");
            request.getRequestDispatcher("/WEB-INF/pages/view-trips.jsp").forward(request, response);
            return;
        }

        // Lấy danh sách chuyến đi
        List<HomeTrip> trips = homeViewTripsDAO.getTrips(
                origin, destination, date, ticketCount, offset, requestsPerPage
        );

        // Lấy các điểm dừng và tính stopTimes cho từng chuyến đi
        for (HomeTrip trip : trips) {
            int tripId = trip.getTripId();
            List<AdminRouteStop> stops = homeViewTripsDAO.getRouteStopsForTrip(tripId);
            List<String> stopTimes = new ArrayList<>();
            LocalTime curTime = LocalTime.parse(trip.getTripTime());
            for (int i = 0; i < stops.size(); i++) {
                AdminRouteStop stop = stops.get(i);
                if (i > 0) {
                    curTime = curTime.plusMinutes(stop.getTravelMinutes() + stop.getDwellMinutes());
                }
                stopTimes.add(curTime.toString().substring(0, 5)); // Lấy HH:mm
            }
            trip.setRouteStops(stops);
            trip.setStopTimes(stopTimes);
        }

        // Tính tổng số trang
        int totalTrips = homeViewTripsDAO.countTrips(origin, destination, date, ticketCount);
        int totalPages = (int) Math.ceil((double) totalTrips / requestsPerPage);

        // Set attributes
        request.setAttribute("trips", trips);
        request.setAttribute("totalTrips", totalTrips);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

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
