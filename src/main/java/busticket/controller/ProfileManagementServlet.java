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

        switch (path) {
            case "/view":

                // Retrieve the logged-in user from session
                if (session == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                Users currentUser = (Users) session.getAttribute("currentUser");
                if (currentUser == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                int userId = currentUser.getUser_id();

                // Get the most recent user information from DB
                Users profile = profileManagementDAO.getUserById(userId);
                // Pass the user profile to the JSP
                request.setAttribute("userProfile", profile != null ? profile : currentUser);
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/view-profile.jsp")
                        .forward(request, response);
                break;
            case "/update":

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
            // Cập nhật thông tin người dùng
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            String status = request.getParameter("status");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String birthdate = request.getParameter("birthdate");

            // Kiểm tra thông tin người dùng nhập vào
            List<String> errorMessages = new ArrayList<>();
            if (name == null || name.isEmpty()) {
                errorMessages.add("Full Name is required.");
            }
            if (email == null || email.isEmpty()) {
                errorMessages.add("Email is required.");
            }
            if (phone == null || phone.isEmpty()) {
                errorMessages.add("Phone number is required.");
            }
            if (role == null || role.isEmpty()) {
                errorMessages.add("Role is required.");
            }
            if (status == null || status.isEmpty()) {
                errorMessages.add("Status is required.");
            }
            if (gender == null || gender.isEmpty()) {
                errorMessages.add("Gender is required.");
            }
            if (address == null || address.isEmpty()) {
                errorMessages.add("Address is required.");
            }

            // Validate ngày sinh nếu có
            java.sql.Timestamp birthdateTimestamp = null;
            if (birthdate != null && !birthdate.isEmpty()) {
                try {
                    birthdateTimestamp = java.sql.Timestamp.valueOf(birthdate + " 00:00:00");
                } catch (IllegalArgumentException e) {
                    errorMessages.add("Invalid birthdate format.");
                }
            }

            // Nếu có lỗi, hiển thị lỗi và quay lại trang update profile
            if (!errorMessages.isEmpty()) {
                request.setAttribute("errors", errorMessages);
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/update-profile.jsp").forward(request, response);
                return;
            }

            // Nếu mật khẩu được nhập, tiến hành hash mật khẩu trước khi lưu
            String hashedPassword = currentUser.getPassword();  // Nếu không thay đổi mật khẩu thì giữ nguyên
            String newPassword = request.getParameter("password");
            if (newPassword != null && !newPassword.isEmpty()) {
                hashedPassword = PasswordUtils.hashPassword(newPassword);  // Hash mật khẩu mới
            }

            // Tạo đối tượng Users mới với thông tin cập nhật
            Users updatedUser = new Users(currentUser.getUser_id(), name, email, hashedPassword, phone, role, birthdateTimestamp, gender, address, currentUser.getCreated_at());

            // Sử dụng DAO để cập nhật thông tin người dùng vào cơ sở dữ liệu
            ProfileManagementDAO profileDAO = new ProfileManagementDAO();
            boolean isUpdated = profileDAO.updateUser(updatedUser);

            if (isUpdated) {
                // Cập nhật session với thông tin người dùng mới
                session.setAttribute("currentUser", updatedUser);
                response.sendRedirect(request.getContextPath() + "/profile/view");  // Redirect đến trang profile
            } else {
                // Nếu cập nhật không thành công, hiển thị lỗi và quay lại trang cập nhật
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
