package busticket.controller;

import busticket.DAO.ProfileManagementDAO;
import busticket.model.Users;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ProfileManagementServlet extends HttpServlet {

<<<<<<< Updated upstream
    @Override
=======
 @Override
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
<<<<<<< Updated upstream
                        .forward(request, response);
=======
                       .forward(request, response);
>>>>>>> Stashed changes
=======
                       .forward(request, response);
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
<<<<<<< Updated upstream
        // Check if we are updating the user profile or changing the password
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            // Update profile data
=======
        // Handle update user profile
        if (request.getPathInfo().equals("/update")) {
>>>>>>> Stashed changes
=======
        // Handle update user profile
        if (request.getPathInfo().equals("/update")) {
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        } else if ("change-password".equals(action)) {
            // Change password data
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Check if the new password and confirmation match
=======
=======
>>>>>>> Stashed changes
        }

        // Handle change password
        if (request.getPathInfo().equals("/change-password")) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Check if new password and confirm password match
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "New password and confirmation do not match.");
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/change-password.jsp").forward(request, response);
                return;
            }

<<<<<<< Updated upstream
<<<<<<< Updated upstream
            // Check if the old password is correct
            if (!oldPassword.equals(currentUser.getPassword())) {
                request.setAttribute("error", "Old password is incorrect.");
=======
=======
>>>>>>> Stashed changes
            // Use DAO to check the current password
            ProfileManagementDAO profileDAO = new ProfileManagementDAO();
            boolean isPasswordValid = profileDAO.checkPassword(currentUser.getUser_id(), currentPassword);
            if (!isPasswordValid) {
                request.setAttribute("error", "Current password is incorrect.");
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/change-password.jsp").forward(request, response);
                return;
            }

            // Update the password in the database
<<<<<<< Updated upstream
<<<<<<< Updated upstream
            ProfileManagementDAO profileManagementDAO = new ProfileManagementDAO();
            boolean isPasswordUpdated = profileManagementDAO.changePassword(currentUser.getUser_id(), newPassword);

            if (isPasswordUpdated) {
                // Redirect to the profile view page after successful password change
                response.sendRedirect(request.getContextPath() + "/profile/view");
            } else {
                // If update fails, show error message
                request.setAttribute("error", "Failed to update password.");
=======
=======
>>>>>>> Stashed changes
            boolean isPasswordUpdated = profileDAO.updatePassword(currentUser.getUser_id(), newPassword);
            if (isPasswordUpdated) {
                // Update session data with the new password
                currentUser.setPassword(newPassword);
                session.setAttribute("currentUser", currentUser);
                response.sendRedirect(request.getContextPath() + "/profile/view");
            } else {
                request.setAttribute("error", "Error updating password.");
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
                request.getRequestDispatcher("/WEB-INF/pages/profile-management/change-password.jsp").forward(request, response);
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Profile Management Servlet";
    }
}
