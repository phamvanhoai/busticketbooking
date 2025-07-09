/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.DriverRequestTripChangeDAO;
import busticket.model.DriverRequestTripChange;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class DriverTripChangeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Gọi trang request-trip-change.jsp không kèm dữ liệu (vì JSP đã viết cứng option + bảng mẫu)
        request.getRequestDispatcher("/WEB-INF/driver/request-trip-change.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form
        String tripIdRaw = request.getParameter("tripId");
        String reason = request.getParameter("reason");

        // Lấy driverId từ session (đã lưu khi đăng nhập)
        HttpSession session = request.getSession();
        Integer driverId = (Integer) session.getAttribute("driverId");

        if (tripIdRaw != null && reason != null && driverId != null && !reason.trim().isEmpty()) {
            try {
                int tripId = Integer.parseInt(tripIdRaw);

                // Tạo model
                DriverRequestTripChange req = new DriverRequestTripChange();
                req.setDriverId(driverId);
                req.setTripId(tripId);
                req.setChangeReason(reason);

                // Lưu DB
                DriverRequestTripChangeDAO dao = new DriverRequestTripChangeDAO();
                dao.addRequest(req);

            } catch (NumberFormatException e) {
                // Không làm gì nếu dữ liệu sai — vì bạn không muốn thay đổi JSP để hiện lỗi
            }
        }

        // Sau khi xử lý xong, redirect về chính servlet để reload form
        response.sendRedirect("driver-trip-change");
    }

    @Override
    public String getServletInfo() {
        return "Xử lý gửi yêu cầu đổi chuyến mà không cần thay đổi JSP";
    }

}
