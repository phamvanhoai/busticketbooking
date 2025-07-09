/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.DriverManageAssignedTripsDAO;
import busticket.model.DriverManageAssignedTrips;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class DriverAssignedTripsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra nếu đang truy cập Roll Call
        if (request.getParameter("roll-call") != null) {
            request.getRequestDispatcher("/WEB-INF/driver/assigned-trips/passenger-roll-call.jsp")
                    .forward(request, response);
            return;
        }

        // Lấy driverId từ session (đã lưu khi tài xế đăng nhập)
        HttpSession session = request.getSession();
        Integer driverId = (Integer) session.getAttribute("driverId");

        if (driverId != null) {
            // Lấy danh sách chuyến được phân công
            DriverManageAssignedTripsDAO dao = new DriverManageAssignedTripsDAO();
            List<DriverManageAssignedTrips> trips = dao.getAssignedTripsByDriver(driverId);

            // Truyền danh sách sang JSP
            request.setAttribute("assignedTrips", trips);
        }

        // Hiển thị giao diện JSP
        request.getRequestDispatcher("/WEB-INF/driver/assigned-trips.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiện tại chưa xử lý POST, để trống
    }

    @Override
    public String getServletInfo() {
        return "Hiển thị danh sách chuyến đi được gán cho tài xế";
    }
}
