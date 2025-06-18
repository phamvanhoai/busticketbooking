/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.ProfileManagementDAO;

import busticket.model.Users;
import busticket.util.PasswordUtils;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ProfileManagementServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra session người dùng
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get the path from the URL (excluding base path like "/ticket-management")
        String path = request.getPathInfo();
        ProfileManagementDAO profileManagementDAO = new ProfileManagementDAO();

        if (path == null) {
            response.sendRedirect(request.getContextPath() + "/profile/view");
            return;
        }

        Users currentUser = (Users) session.getAttribute("currentUser");

        int userId = currentUser.getUser_id();

        // Get the most recent user information from DB
        Users profile = profileManagementDAO.getUserById(userId);

        switch (path) {
            case "/view":
                // Pass the user profile to the JSP
                request.setAttribute("userProfile", profile != null ? profile : currentUser);
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/view-profile.jsp")
                        .forward(request, response);
                break;
            case "/update":

                // Pass the user profile to the JSP
                request.setAttribute("userProfile", profile != null ? profile : currentUser);
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/update-profile.jsp").forward(request, response);
                break;
            case "/change-password":
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/change-password.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/profile/view");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra session người dùng
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("currentUser");

        // Lấy action từ form (profile update or password change)
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String birthdate = request.getParameter("birthdate");

            Timestamp birthdateTimestamp = null;

            if (birthdate != null && !birthdate.isEmpty()) {
                try {
                    birthdateTimestamp = Timestamp.valueOf(birthdate + " 00:00:00");
                } catch (IllegalArgumentException e) {
                    request.setAttribute("error", "Invalid birthdate format.");
                    request.getRequestDispatcher("/WEB-INF/pages/profile-management/update-profile.jsp").forward(request, response);
                    return;
                }
            }

            // Validate data
            List<String> errorMessages = new ArrayList<>();
            if (name == null || name.isEmpty()) {
                errorMessages.add("Full Name is required.");
            }
            if (email == null || email.isEmpty()) {
                errorMessages.add("Email is required.");
            }
            // Add more validation checks here

            if (!errorMessages.isEmpty()) {
                request.setAttribute("errors", errorMessages);
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/update-profile.jsp").forward(request, response);
                return;
            }

            // Proceed with updating the user profile
            ProfileManagementDAO profileDAO = new ProfileManagementDAO();
            boolean isUpdated = profileDAO.updateUser(new Users(currentUser.getUser_id(), name, email, phone, birthdateTimestamp, gender, address));

            if (isUpdated) {
                currentUser.setName(name);
                currentUser.setEmail(email);
                session.setAttribute("currentUser", currentUser);
                response.sendRedirect(request.getContextPath() + "/profile/view");
            } else {
                request.setAttribute("error", "Error updating profile.");
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/update-profile.jsp").forward(request, response);
            }
        } else if ("change-password".equals(action)) {
            // Đoạn xử lý thay đổi mật khẩu trong doPost
            // Lấy dữ liệu từ form
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Kiểm tra nếu mật khẩu mới và xác nhận mật khẩu trùng khớp
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "New password and confirmation do not match.");
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/change-password.jsp").forward(request, response);
                return;
            }

            // Kiểm tra mật khẩu cũ
            ProfileManagementDAO profileDAO = new ProfileManagementDAO();
            String hashedOldPassword = profileDAO.getHashedPassword(currentUser.getUser_id()); // Lấy mật khẩu đã mã hóa từ DB

            // Kiểm tra nếu mật khẩu cũ đúng
            boolean isOldPasswordValid = PasswordUtils.checkPassword(oldPassword, hashedOldPassword);

            if (!isOldPasswordValid) {
                request.setAttribute("error", "Old password is incorrect.");
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/change-password.jsp").forward(request, response);
                return;
            }

            // Hash mật khẩu mới trước khi lưu
            String hashedNewPassword = PasswordUtils.hashPassword(newPassword);

            // Cập nhật mật khẩu vào cơ sở dữ liệu
            boolean isPasswordUpdated = profileDAO.updatePassword(currentUser.getUser_id(), hashedNewPassword);

            if (isPasswordUpdated) {
                currentUser.setPassword(hashedNewPassword);
                session.setAttribute("currentUser", currentUser);
                request.setAttribute("message", "Password changed successfully.");
                response.sendRedirect(request.getContextPath() + "/profile/view");
            } else {
                request.setAttribute("error", "Failed to update password.");
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/change-password.jsp").forward(request, response);
            }
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Profile Management Servlet";
    }
}
