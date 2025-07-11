/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.ProfileManagementDAO;

import busticket.model.Users;
import busticket.util.InputValidator;
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
                session.removeAttribute("error");
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
                    // Lấy lại dữ liệu từ database nếu có lỗi validation
                    ProfileManagementDAO profileManagementDAO = new ProfileManagementDAO();
                    Users profile = profileManagementDAO.getUserById(currentUser.getUser_id());

                    // Chuyển dữ liệu từ database vào request attributes để hiển thị lại form
                    request.setAttribute("name", profile.getName());
                    request.setAttribute("email", profile.getEmail());
                    request.setAttribute("phone", profile.getPhone());
                    request.setAttribute("gender", profile.getGender());
                    request.setAttribute("address", profile.getAddress());
                    request.setAttribute("birthdate", profile.getBirthdate() != null ? profile.getBirthdate().toString() : "");

                    request.setAttribute("error", "Invalid birthdate format.");
                    request.getRequestDispatcher("/WEB-INF/pages/profile-management/update-profile.jsp").forward(request, response);
                    return;
                }
            }

            // Validate dữ liệu
            List<String> errorMessages = new ArrayList<>();
            if (name == null || name.isEmpty() || !InputValidator.isUsernameValid(name)) {
                errorMessages.add("Full Name must be between 3 and 20 characters and contain only letters or underscores.");
            }
            if (phone != null && !phone.isEmpty()) {
                if (!InputValidator.isVietnamesePhoneValid(phone)) {
                    errorMessages.add("Invalid phone number.");
                }
            }

            if (email == null || email.isEmpty() || !InputValidator.isEmailValid(email)) {
                errorMessages.add("Email is required.");
            }
            // Thêm các kiểm tra khác nếu cần

            if (!errorMessages.isEmpty()) {
                // Lấy lại dữ liệu từ database nếu có lỗi validation
                ProfileManagementDAO profileManagementDAO = new ProfileManagementDAO();
                Users profile = profileManagementDAO.getUserById(currentUser.getUser_id());

                // Chuyển dữ liệu từ database vào request attributes để hiển thị lại form
                request.setAttribute("name", profile.getName());
                request.setAttribute("email", profile.getEmail());
                request.setAttribute("phone", profile.getPhone());
                request.setAttribute("gender", profile.getGender());
                request.setAttribute("address", profile.getAddress());
                request.setAttribute("birthdate", profile.getBirthdate() != null ? profile.getBirthdate().toString() : "");

                session.setAttribute("error", String.join(", ", errorMessages));
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/update-profile.jsp").forward(request, response);
                return;
            }

            // Tiến hành cập nhật thông tin người dùng
            ProfileManagementDAO profileDAO = new ProfileManagementDAO();
            boolean isUpdated = profileDAO.updateUser(new Users(currentUser.getUser_id(), name, email, phone, birthdateTimestamp, gender, address));

            if (isUpdated) {
                currentUser.setName(name);
                currentUser.setEmail(email);
                session.setAttribute("currentUser", currentUser);
                session.removeAttribute("error");
                session.setAttribute("success", "Profile updated successfully!");
                response.sendRedirect(request.getContextPath() + "/profile/view");
            } else {
                session.setAttribute("error", "Error updating profile.");
                // Lấy lại dữ liệu từ database nếu có lỗi cập nhật
                ProfileManagementDAO profileManagementDAO = new ProfileManagementDAO();
                Users profile = profileManagementDAO.getUserById(currentUser.getUser_id());

                // Chuyển dữ liệu từ database vào request attributes để hiển thị lại form
                request.setAttribute("name", profile.getName());
                request.setAttribute("email", profile.getEmail());
                request.setAttribute("phone", profile.getPhone());
                request.setAttribute("gender", profile.getGender());
                request.setAttribute("address", profile.getAddress());
                request.setAttribute("birthdate", profile.getBirthdate() != null ? profile.getBirthdate().toString() : "");
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
                session.setAttribute("error", "New password and confirmation do not match.");
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/change-password.jsp").forward(request, response);
                return;
            }

            // Kiểm tra mật khẩu cũ
            ProfileManagementDAO profileDAO = new ProfileManagementDAO();
            String hashedOldPassword = profileDAO.getHashedPassword(currentUser.getUser_id()); // Lấy mật khẩu đã mã hóa từ DB

            // Kiểm tra nếu mật khẩu cũ đúng
            boolean isOldPasswordValid = PasswordUtils.checkPassword(oldPassword, hashedOldPassword);

            if (!isOldPasswordValid) {
                session.setAttribute("error", "Old password is incorrect.");
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
                session.setAttribute("success", "Password changed successfully.");
                response.sendRedirect(request.getContextPath() + "/profile/view");
            } else {
                session.setAttribute("error", "Failed to update password.");
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
