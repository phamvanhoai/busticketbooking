/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.ProfileManangementDAO;

import busticket.model.Users;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ProfileManagementServlet extends HttpServlet {


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

        // Get the path from the URL (excluding base path like "/ticket-management")
        String path = request.getPathInfo();
        ProfileManagementDAO profileManangementDAO = new ProfileManagementDAO();


        if (path == null) {
            response.sendRedirect(request.getContextPath() + "/profile/view");
            return;
        }

        switch (path) {
            case "/view":

                // Retrieve the logged-in user from session

                HttpSession session = request.getSession(false);
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
                Users profile = profileManangementDAO.getUserById(userId);
                // Pass the user profile to the JSP
                request.setAttribute("userProfile", profile != null ? profile : currentUser);
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/view-profile.jsp")
                        .forward(request, response);


                // Lấy lại thông tin user mới nhất từ DB
                Users profile = profileManangementDAO.getUserById(userId);
                // Đẩy xuống JSP
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
        // Retrieve the updated user data from the form
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("currentUser");

        // Check if we are updating the user profile or changing the password
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            // Update profile data

        // Handle update user profile
        if (request.getPathInfo().equals("/update")) {

            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            String status = request.getParameter("status");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");

            // Convert birthdate
            java.sql.Timestamp birthdate = java.sql.Timestamp.valueOf(request.getParameter("birthdate") + " 00:00:00");

            // Create a new Users object with the updated data
            Users updatedUser = new Users(currentUser.getUser_id(), name, email, password, phone, role, birthdate, gender, address, currentUser.getCreated_at());

            // Use DAO to update the user's data in the database
            ProfileManagementDAO profileDAO = new ProfileManagementDAO();
            boolean isUpdated = profileDAO.updateUser(updatedUser);

            if (isUpdated) {
                // Update session with the new user data
                session.setAttribute("currentUser", updatedUser);
                // Redirect to the profile view page
                response.sendRedirect(request.getContextPath() + "/profile/view");
            } else {
                // If the update fails, set an error message and forward back to update profile page
                request.setAttribute("error", "Error updating profile.");
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/update-profile.jsp").forward(request, response);
            }

        } else if ("change-password".equals(action)) {
            // Change password data
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Check if the new password and confirmation match

        }

        // Handle change password
        if (request.getPathInfo().equals("/change-password")) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Check if new password and confirm password match
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "New password and confirmation do not match.");
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/change-password.jsp").forward(request, response);
                return;
            }

            // Check if the old password is correct
            if (!oldPassword.equals(currentUser.getPassword())) {
                request.setAttribute("error", "Old password is incorrect.");

            // Use DAO to check the current password
            ProfileManagementDAO profileDAO = new ProfileManagementDAO();
            boolean isPasswordValid = profileDAO.checkPassword(currentUser.getUser_id(), currentPassword);
            if (!isPasswordValid) {
                request.setAttribute("error", "Current password is incorrect.");

                request.getRequestDispatcher("/WEB-INF/pages/profile-management/change-password.jsp").forward(request, response);
                return;
            }

            // Update the password in the database

            ProfileManagementDAO profileManagementDAO = new ProfileManagementDAO();
            boolean isPasswordUpdated = profileManagementDAO.changePassword(currentUser.getUser_id(), newPassword);

            if (isPasswordUpdated) {
                // Redirect to the profile view page after successful password change
                response.sendRedirect(request.getContextPath() + "/profile/view");
            } else {
                // If update fails, show error message
                request.setAttribute("error", "Failed to update password.");

            boolean isPasswordUpdated = profileDAO.updatePassword(currentUser.getUser_id(), newPassword);
            if (isPasswordUpdated) {
                // Update session data with the new password
                currentUser.setPassword(newPassword);
                session.setAttribute("currentUser", currentUser);
                response.sendRedirect(request.getContextPath() + "/profile/view");
            } else {
                request.setAttribute("error", "Error updating password.");

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
