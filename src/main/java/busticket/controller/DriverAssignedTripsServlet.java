/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.DriverAssignedTripsDAO;
import busticket.model.DriverAssignedTrip;
import busticket.model.DriverPassenger;
import busticket.model.Users;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
        // Lấy thông tin người dùng từ session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Kiểm tra thông báo trong session
        if (session != null) {
            Object success = session.getAttribute("success");
            Object error = session.getAttribute("error");

            // Nếu có thông báo thành công
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }

            // Nếu có thông báo lỗi
            if (error != null) {
                request.setAttribute("error", error);
                session.removeAttribute("error");
            }
        }

        Users currentUser = (Users) session.getAttribute("currentUser");
        int driverId = currentUser.getUser_id();

        // Handle roll-call action
        if (request.getParameter("roll-call") != null) {
            try {
                int tripId = Integer.parseInt(request.getParameter("roll-call"));
                DriverAssignedTripsDAO driverAssignedTripsDAO = new DriverAssignedTripsDAO();
                List<DriverPassenger> passengers = driverAssignedTripsDAO.getPassengers(tripId);

                // Lấy trip_status từ cơ sở dữ liệu
                String tripStatus = driverAssignedTripsDAO.getTripStatus(tripId);

                request.setAttribute("passengers", passengers);
                request.setAttribute("tripId", tripId);
                request.setAttribute("tripStatus", tripStatus);
                request.getRequestDispatcher("/WEB-INF/driver/assigned-trips/passenger-roll-call.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/driver/assigned-trips");
                return;
            }
        }

        // Process "Start" action
        String start = request.getParameter("start");
        if (start != null) {
            try {
                int tripId = Integer.parseInt(request.getParameter("start"));
                DriverAssignedTripsDAO driverAssignedTripsDAO = new DriverAssignedTripsDAO();

                // Update the status of the trip to "Ongoing"
                driverAssignedTripsDAO.updateTripStatus(tripId, "Ongoing");

                // Set success message and redirect
                session.setAttribute("success", "Trip status updated to 'Ongoing'.");
                response.sendRedirect(request.getContextPath() + "/driver/assigned-trips");
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
                session.setAttribute("error", "Invalid Trip ID.");
                response.sendRedirect(request.getContextPath() + "/driver/assigned-trips");
            }
        }

        // Process "End" action
        String end = request.getParameter("end");
        if (end != null) {
            try {
                int tripId = Integer.parseInt(request.getParameter("end"));
                DriverAssignedTripsDAO driverAssignedTripsDAO = new DriverAssignedTripsDAO();

                // Update the status of the trip to "Completed"
                driverAssignedTripsDAO.updateTripStatus(tripId, "Completed");

                session.setAttribute("success", "Trip status updated to 'Completed'.");
                response.sendRedirect(request.getContextPath() + "/driver/assigned-trips");
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
                session.setAttribute("error", "Invalid Trip ID.");
                response.sendRedirect(request.getContextPath() + "/driver/assigned-trips");
            }
        }

// Lấy thông tin bộ lọc từ request
        String route = request.getParameter("route");
        String status = request.getParameter("status");
        String date = request.getParameter("date");

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

// Lấy danh sách chuyến theo bộ lọc và phân trang
        DriverAssignedTripsDAO driverAssignedTripsDAO = new DriverAssignedTripsDAO();
        List<DriverAssignedTrip> assignedTrips = driverAssignedTripsDAO.getAssignedTrips(driverId, route, status, date, offset, tripsPerPage);
        int totalTrips = driverAssignedTripsDAO.getTotalAssignedTripsCount(driverId, route, status, date);
        int totalPages = (int) Math.ceil((double) totalTrips / tripsPerPage);

// Lấy các địa điểm cho bộ lọc
        List<String> locations = driverAssignedTripsDAO.getAllLocations();

// Thiết lập các tham số vào request để JSP có thể sử dụng
        request.setAttribute("assignedTrips", assignedTrips);
        request.setAttribute("locations", locations);
        request.setAttribute("route", route);
        request.setAttribute("status", status);
        request.setAttribute("date", date);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

// Chuyển tiếp tới JSP
        request.getRequestDispatcher("/WEB-INF/driver/assigned-trips/assigned-trips.jsp").forward(request, response);
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
// Lấy thông tin từ session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        DriverAssignedTripsDAO driverAssignedTripsDAO = new DriverAssignedTripsDAO();
        Set<String> failedSeats = new HashSet<>();
        Map<Integer, String> ticketToSeatMap = new HashMap<>();

        // Lấy tripId từ request để truy vấn danh sách hành khách
        int tripId = 0;
        try {
            tripId = Integer.parseInt(request.getParameter("tripId"));
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "ID chuyến đi không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/driver/assigned-trips");
            return;
        }

        // Lấy danh sách hành khách để ánh xạ ticketId với seat_number
        List<DriverPassenger> passengers = driverAssignedTripsDAO.getPassengers(tripId);
        for (DriverPassenger passenger : passengers) {
            ticketToSeatMap.put(passenger.getTicketId(), passenger.getSeat());
        }

        // Thu thập tất cả ticketId từ request
        Set<Integer> ticketIds = new HashSet<>();
        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            if (paramName.startsWith("checkInStatus-") || paramName.startsWith("checkOutStatus-")) {
                try {
                    int ticketId = Integer.parseInt(paramName.split("-")[1]);
                    ticketIds.add(ticketId);
                } catch (NumberFormatException e) {
                    failedSeats.add("Unknown");
                }
            }
        }

        // Xử lý từng ticketId
        for (int ticketId : ticketIds) {
            try {
                String[] checkInValues = request.getParameterValues("checkInStatus-" + ticketId);
                String[] checkOutValues = request.getParameterValues("checkOutStatus-" + ticketId);
                boolean isCheckInChecked = checkInValues != null && Arrays.asList(checkInValues).contains("on");
                boolean isCheckOutChecked = checkOutValues != null && Arrays.asList(checkOutValues).contains("on");

                // Kiểm tra logic: không cho phép check-out nếu chưa check-in
                if (isCheckOutChecked && !isCheckInChecked) {
                    String seat = ticketToSeatMap.getOrDefault(ticketId, "Unknown");
                    failedSeats.add(seat);
                    continue; // Bỏ qua cập nhật nếu kiểm tra thất bại
                }

                // Cập nhật check-in
                if (isCheckInChecked) {
                    driverAssignedTripsDAO.updateCheckInStatus(ticketId, new Timestamp(System.currentTimeMillis()));
                } else {
                    driverAssignedTripsDAO.updateCheckInStatus(ticketId, null);
                }

                // Cập nhật check-out
                if (isCheckOutChecked) {
                    if (!driverAssignedTripsDAO.updateCheckOutStatusWithCheckInValidation(ticketId, new Timestamp(System.currentTimeMillis()))) {
                        String seat = ticketToSeatMap.getOrDefault(ticketId, "Unknown");
                        failedSeats.add(seat);
                    }
                } else {
                    driverAssignedTripsDAO.updateCheckOutStatusWithCheckInValidation(ticketId, null);
                }
            } catch (Exception e) {
                String seat = ticketToSeatMap.getOrDefault(ticketId, "Unknown");
                failedSeats.add(seat);
            }
        }

        // Thiết lập thông báo
        if (!failedSeats.isEmpty()) {
            session.setAttribute("error", "Không thể cập nhật trạng thái cho ghế: " + failedSeats + " (yêu cầu check-in trước khi check-out)");
        } else {
            session.setAttribute("success", "Đã lưu điểm danh thành công!");
        }

        response.sendRedirect(request.getContextPath() + "/driver/assigned-trips");
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
