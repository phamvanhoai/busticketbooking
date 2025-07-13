/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.DriverRequestTripChangeDAO;
import busticket.model.DriverAssignedTrip;
import busticket.model.DriverRequestTripChange;
import busticket.model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class DriverTripChangeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông tin tài xế từ session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        DriverRequestTripChangeDAO driverRequestTripChangeDAO = new DriverRequestTripChangeDAO();

        Users currentUser = (Users) session.getAttribute("currentUser");
        int userId = currentUser.getUser_id(); // Lấy user_id từ session

        // Pagination setup
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

        // DAO
        // Lấy danh sách chuyến đi của tài xế
        List<DriverAssignedTrip> assignedTrips = driverRequestTripChangeDAO.getAssignedTripsForDriver(userId);
        List<DriverRequestTripChange> cancelledTrips = driverRequestTripChangeDAO.getCancelledTripsForDriver(userId, offset, requestsPerPage);
        int totalRequests = driverRequestTripChangeDAO.countDriverCancelTripRequests(userId);
        int totalPages = (int) Math.ceil((double) totalRequests / requestsPerPage);

        // Set attributes
        request.setAttribute("assignedTrips", assignedTrips);
        request.setAttribute("cancelledTrips", cancelledTrips);
        request.setAttribute("totalRequests", totalRequests);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/driver/request-trip-change.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
// Lấy thông tin tài xế từ session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy thông tin từ form
        String tripId = request.getParameter("tripId");
        String reason = request.getParameter("reason");

        // Kiểm tra dữ liệu đầu vào
        if (tripId == null || tripId.isEmpty() || reason == null || reason.isEmpty()) {
            session.setAttribute("error", "Trip ID or reason cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/driver/request-trip-change");
            return;
        }

        DriverRequestTripChangeDAO driverRequestTripChangeDAO = new DriverRequestTripChangeDAO();

        // Lấy thông tin từ session
        Users currentUser = (Users) session.getAttribute("currentUser");
        int userId = currentUser.getUser_id(); // Lấy user_id từ session
        int driverId = driverRequestTripChangeDAO.getDriverIdFromUser(userId);

        // Tạo đối tượng yêu cầu thay đổi chuyến
        DriverRequestTripChange requestChange = new DriverRequestTripChange();
        requestChange.setRequestId(driverId);

        requestChange.setTripId(Integer.parseInt(tripId));
        requestChange.setRequestReason(reason);
        requestChange.setStatus("Pending"); // Trạng thái mặc định là Pending

        // Gọi DAO để lưu yêu cầu
        boolean isTripUpdated = driverRequestTripChangeDAO.updateTripStatusToPending(Integer.parseInt(tripId));

        if (!isTripUpdated) {
            session.setAttribute("error", "An error occurred while updating the trip status.");
            response.sendRedirect(request.getContextPath() + "/driver/request-trip-change");
            return;
        }

        boolean isRequestCreated = driverRequestTripChangeDAO.createTripChangeRequest(requestChange);

        // Kiểm tra kết quả và gửi thông báo
        if (isRequestCreated) {
            session.setAttribute("success", "Your request has been submitted successfully.");
        } else {
            session.setAttribute("error", "An error occurred while submitting your request.");
        }

        // Redirect lại trang yêu cầu thay đổi chuyến
        response.sendRedirect(request.getContextPath() + "/driver/trip-change");
    }

    @Override
    public String getServletInfo() {
        return "";
    }

}
