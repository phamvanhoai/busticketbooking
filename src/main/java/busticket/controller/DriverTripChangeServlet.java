/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

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
        request.getRequestDispatcher("/WEB-INF/driver/trip-change/driver-trip-change.jsp")
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
