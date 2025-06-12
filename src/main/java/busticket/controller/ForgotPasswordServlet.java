/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.UsersDAO;
import busticket.model.Users;
import busticket.util.EmailUtils;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class ForgotPasswordServlet extends HttpServlet {

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
        request.getRequestDispatcher("/WEB-INF/pages/auth/forgot-password.jsp").forward(request, response);
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
        String email = request.getParameter("email");

        // Kiểm tra xem email có tồn tại không
        UsersDAO uDAO = new UsersDAO();
        Users user = uDAO.getUserByEmail(email);  // Lấy đối tượng User từ email

        if (user != null) {
            // Tạo token reset mật khẩu
            String token = UUID.randomUUID().toString();  // Tạo token duy nhất
            uDAO.storeResetToken(user.getUser_id(), token);  // Lưu token vào cơ sở dữ liệu

            // Tạo link reset mật khẩu
            String resetLink = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + 
                               request.getContextPath() + "/reset-password?token=" + token;

            // Gửi email chứa link reset mật khẩu
            try {
                // Truyền tên người dùng, email và link reset mật khẩu
                EmailUtils.sendResetPasswordEmail(email, user.getName(), resetLink);
                request.setAttribute("message", "Password reset link has been sent to your email.");
            } catch (Exception e) {
                request.setAttribute("error", "Error occurred while sending the email.");
            }
        } else {
            request.setAttribute("error", "No account found with this email.");
        }

        // Forward tới trang quên mật khẩu
        request.getRequestDispatcher("/WEB-INF/pages/auth/forgot-password.jsp").forward(request, response);
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
