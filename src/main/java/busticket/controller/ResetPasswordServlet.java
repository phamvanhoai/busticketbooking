/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.UsersDAO;
import busticket.model.Users;
import busticket.util.PasswordUtils;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class ResetPasswordServlet extends HttpServlet {

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
        String token = request.getParameter("token");

        UsersDAO usersDAO = new UsersDAO();
        Users user = usersDAO.getUserByResetToken(token);  // Lấy người dùng dựa trên token

        if (user != null) {
            // Token hợp lệ, hiển thị form nhập mật khẩu mới
            request.setAttribute("token", token);
            request.getRequestDispatcher("/WEB-INF/pages/auth/reset-password.jsp").forward(request, response);
        } else {
            // Token không hợp lệ hoặc đã hết hạn
            request.setAttribute("error", "Invalid or expired token.");
            request.getRequestDispatcher("/WEB-INF/pages/auth/forgot-password.jsp").forward(request, response);
        }
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
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra nếu mật khẩu mới và xác nhận mật khẩu khớp nhau
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/pages/auth/reset-password.jsp").forward(request, response);
            return;  // Dừng lại nếu mật khẩu không khớp
        }

        // Kiểm tra token và cập nhật mật khẩu mới
        UsersDAO usersDAO = new UsersDAO();
        Users user = usersDAO.getUserByResetToken(token);  // Lấy user từ token

        if (user != null) {
            // Mã hóa mật khẩu mới và lưu vào DB
            String hashedPassword = PasswordUtils.hashPassword(newPassword); // Mã hóa mật khẩu mới
            usersDAO.updatePassword(user.getUser_id(), hashedPassword);  // Cập nhật mật khẩu vào DB

            // Đánh dấu token là đã sử dụng
            usersDAO.markTokenAsUsed(token);  // Đánh dấu token là đã sử dụng

            // Thông báo thay đổi mật khẩu thành công
            request.setAttribute("message", "Password has been reset successfully.");
            request.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp").forward(request, response);
        } else {
            // Nếu token không hợp lệ
            request.setAttribute("error", "Invalid or expired token.");
            request.getRequestDispatcher("/WEB-INF/pages/auth/forgot-password.jsp").forward(request, response);
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
