/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminTripsDAO;
import busticket.DAO.StaffTripStatusDAO;
import busticket.model.AdminDrivers;
import busticket.model.AdminRouteStop;
import busticket.model.AdminTrips;
import busticket.model.AdminUsers;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class StaffTripStatusServlet extends HttpServlet {

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
        StaffTripStatusDAO staffTripStatusDAO = new StaffTripStatusDAO();

        AdminTripsDAO adminTripsDAO = new AdminTripsDAO();

        String detail = request.getParameter("detail");
        if (detail != null) {
            try {
                int tripId = Integer.parseInt(detail);

                // Lấy chi tiết chuyến đi
                AdminTrips trip = adminTripsDAO.getTripDetailById(tripId);

                // Lấy danh sách điểm dừng của tuyến đường
                int routeId = trip.getRouteId();
                List<AdminRouteStop> stops = adminTripsDAO.getRouteStops(routeId);

                // Tính giờ đến từng stop (giờ xuất phát + travelMinutes cộng dồn)
                List<String> stopTimes = new ArrayList<>();
                LocalTime curTime = LocalTime.parse(trip.getTripTime()); // tripTime kiểu HH:mm

                for (int i = 0; i < stops.size(); i++) {
                    AdminRouteStop stop = stops.get(i);
                    // Stop đầu lấy giờ xuất phát
                    if (i > 0) {
                        // Cộng travelMinutes và dwellMinutes (nếu cần)
                        curTime = curTime.plusMinutes(stop.getTravelMinutes() + stop.getDwellMinutes());
                    }
                    stopTimes.add(curTime.toString());  // Lưu giờ dừng tại điểm
                }

                // Lấy danh sách hành khách
                List<AdminUsers> passengers = adminTripsDAO.getPassengersByTripId(tripId);

                // Đẩy dữ liệu vào request
                request.setAttribute("trip", trip);           // Chuyến đi
                request.setAttribute("passengers", passengers); // Danh sách hành khách
                request.setAttribute("stops", stops);         // Danh sách điểm dừng
                request.setAttribute("stopTimes", stopTimes); // Danh sách giờ đến các điểm dừng

                // Chuyển hướng đến trang view-trip-status-details.jsp
                request.getRequestDispatcher("/WEB-INF/staff/trip-status/view-trip-status-details.jsp")
                        .forward(request, response);
            } catch (Exception ex) {
                ex.printStackTrace();  // Xem lỗi chi tiết trong log console
                response.sendRedirect(request.getContextPath() + "/staff/trip-status");
                return;
            }
        }

        // Filters
        String route = request.getParameter("route");
        String status = request.getParameter("status");
        String driver = request.getParameter("driver");

        // Pagination
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

        // Fetch trips based on filters and pagination
        List<AdminTrips> trips = staffTripStatusDAO.getAllTrips(route, status, driver, offset, tripsPerPage);
        int totalTrips = staffTripStatusDAO.getTotalTripsCount(route, status, driver);
        int totalPages = (int) Math.ceil((double) totalTrips / tripsPerPage);

        // Get locations, drivers for filters
        List<String> locations = staffTripStatusDAO.getAllLocations();
        List<AdminDrivers> drivers = staffTripStatusDAO.getAllDrivers();

        // Set attributes for the JSP
        request.setAttribute("trips", trips);
        request.setAttribute("locations", locations);
        request.setAttribute("drivers", drivers);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/WEB-INF/staff/trip-status/view-trip-status.jsp").forward(request, response);
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
