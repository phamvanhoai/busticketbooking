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

        // Lấy danh sách chuyến đi của tài xế
        List<DriverAssignedTrip> assignedTrips = driverRequestTripChangeDAO.getAssignedTripsForDriver(userId);

        List<DriverRequestTripChange> cancelledTrips = driverRequestTripChangeDAO.getCancelledTripsForDriver(userId);
        request.setAttribute("cancelledTrips", cancelledTrips);

        // Truyền danh sách chuyến vào JSP
        request.setAttribute("assignedTrips", assignedTrips);
        request.getRequestDispatcher("/WEB-INF/driver/request-trip-change.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    public String getServletInfo() {
        return "Xử lý gửi yêu cầu đổi chuyến mà không cần thay đổi JSP";
    }

}
