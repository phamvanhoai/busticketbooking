/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminUsersDAO;
import busticket.model.AdminUsers;
import busticket.util.InputValidator;
import busticket.util.PasswordUtils;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class AdminUsersServlet extends HttpServlet {

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

        AdminUsersDAO adminUserDAO = new AdminUsersDAO();

        // Check if the request contains ?add → forward to the Add User form
        if (request.getParameter("add") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/users/add-user.jsp").forward(request, response);
            return;
        }

        // Handle request to edit a user if ?editId is present
        String editId = request.getParameter("editId");
        if (editId != null) {
            try {
                int userId = Integer.parseInt(editId);
                AdminUsers user = adminUserDAO.getUserById(userId);

                // If user not found → redirect to 404 page
                if (user == null) {
                    response.sendRedirect(request.getContextPath() + "/pages/404.jsp");
                    return;
                }

                // Set user data and forward to the edit-user.jsp page
                request.setAttribute("user", user);
                request.getRequestDispatcher("/WEB-INF/admin/users/edit-user.jsp").forward(request, response);
                return;

            } catch (NumberFormatException e) {
                // If editId is invalid (not a number) → redirect to user list
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
        }

        // Retrieve search query from the query string (?search=...)
        String searchQuery = request.getParameter("search");

        // Pagination setup: default to 10 users per page
        int usersPerPage = 10;
        int currentPage = 1;
        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1; // Fall back to page 1 if the page parameter is invalid
            }
        }
        int offset = (currentPage - 1) * usersPerPage;

        // Retrieve paginated user list (with optional search filter)
        List<AdminUsers> adminUsers = adminUserDAO.getAllAdminUsers(searchQuery, offset, usersPerPage);
        int totalUsers = adminUserDAO.countUsersByFilter(searchQuery);
        int totalPages = (int) Math.ceil((double) totalUsers / usersPerPage);

        // Calculate the number of users currently displayed (used for stats)
        int currentTotalUsers = (currentPage < totalPages ? usersPerPage * currentPage : totalUsers);

        // Set attributes for rendering in JSP
        request.setAttribute("users", adminUsers);                     // List of users
        request.setAttribute("totalUsers", totalUsers);               // Total number of users
        request.setAttribute("searchQuery", searchQuery);             // Search query (if any)
        request.setAttribute("totalPages", totalPages);               // Total number of pages
        request.setAttribute("currentPage", currentPage);             // Current page number
        request.setAttribute("currentTotalUsers", currentTotalUsers); // Users currently displayed

        // Forward to the user list page
        request.getRequestDispatcher("/WEB-INF/admin/users/users.jsp").forward(request, response);
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

        String action = request.getParameter("action");
        AdminUsersDAO adminUsersDAO = new AdminUsersDAO();
        boolean redirected = false; // Used to prevent multiple forwards or redirects

        try {
            // Handle account creation
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String confirmPassword = request.getParameter("confirmPassword");
                String role = request.getParameter("role");
                String status = request.getParameter("status");

                List<String> errorMessages = new ArrayList<>();

                // Validate input fields
                if (name == null || name.isEmpty()) {
                    errorMessages.add("Full Name is required.");
                }
                if (email == null || email.isEmpty()) {
                    errorMessages.add("Email is required.");
                }
                if (password == null || password.isEmpty()) {
                    errorMessages.add("Password is required.");
                }
                if (confirmPassword == null || confirmPassword.isEmpty()) {
                    errorMessages.add("Confirm password is required.");
                }
                if (!password.equals(confirmPassword)) {
                    errorMessages.add("Passwords do not match.");
                }
                if (adminUsersDAO.isEmailExists(email)) {
                    errorMessages.add("Email already exists!");
                }
                if (!InputValidator.isEmailValid(email)) {
                    errorMessages.add("Invalid email format. Example: user@example.com");
                }
                if (!InputValidator.isPasswordValid(password)) {
                    errorMessages.add("Password must be at least 8 characters with 1 letter & 1 number.");
                }

                // If there are validation errors, return to the add-user form
                if (!errorMessages.isEmpty()) {
                    request.setAttribute("errors", errorMessages);
                    request.getRequestDispatcher("/WEB-INF/admin/users/add-user.jsp").forward(request, response);
                    redirected = true;
                    return;
                }

                // Create new user with hashed password
                String hashedPassword = PasswordUtils.hashPassword(password);
                Timestamp createdAt = Timestamp.from(Instant.now());
                AdminUsers user = new AdminUsers(0, name, email, hashedPassword, role, status, createdAt);

                int isAdded = adminUsersDAO.addUser(user);
                if (isAdded > 0) {
                    request.setAttribute("message", "Account created successfully!");
                    request.getRequestDispatcher("/WEB-INF/admin/users/users.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Add failed. Please try again.");
                    request.getRequestDispatcher("/WEB-INF/admin/users/add-user.jsp").forward(request, response);
                }
                redirected = true;

                // Handle account editing
            } else if ("edit".equals(action)) {
                // Get form parameters
                int userId = Integer.parseInt(request.getParameter("userId"));
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String role = request.getParameter("role");
                String gender = request.getParameter("gender");
                String birthdateStr = request.getParameter("birthdate");
                String address = request.getParameter("address");
                String status = request.getParameter("status");

                List<String> errorMessages = new ArrayList<>();

                // Basic validation
                if (name == null || name.isEmpty() || email == null || email.isEmpty()
                        || role == null || role.isEmpty() || status == null || status.isEmpty()) {
                    errorMessages.add("Please enter all required fields.");
                }

                // Parse birthdate (input type="date" returns format yyyy-MM-dd)
                Timestamp birthdateTimestamp = null;
                if (birthdateStr != null && !birthdateStr.isEmpty()) {
                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        sdf.setLenient(false);
                        Date parsedDate = sdf.parse(birthdateStr);
                        birthdateTimestamp = new Timestamp(parsedDate.getTime());
                    } catch (ParseException e) {
                        errorMessages.add("Invalid birthdate format! Please use the date picker.");
                    }
                }

                // If errors exist, return to edit form with error messages
                if (!errorMessages.isEmpty()) {
                    request.setAttribute("error", String.join("<br>", errorMessages));
                    request.getRequestDispatcher("/WEB-INF/admin/users/edit-user.jsp?userId=" + userId).forward(request, response);
                    redirected = true;
                    return;
                }

                // Construct updated user object
                AdminUsers user = new AdminUsers(userId, name, email, phone, role, status, birthdateTimestamp, gender, address);

                // Update user in database
                int result = adminUsersDAO.updateUser(user);

                if (result > 0) {
                    // Redirect to user list with success message
                    response.sendRedirect(request.getContextPath() + "/admin/users?message=updated");
                } else {
                    // Forward back to edit page with failure message
                    request.setAttribute("error", "Update failed. Please try again.");
                    request.getRequestDispatcher("/WEB-INF/admin/users/edit-user.jsp?userId=" + userId).forward(request, response);
                }

                redirected = true;
            }

        } catch (Exception e) {
            // Handle unexpected exceptions
            request.setAttribute("error", "Error occurred during processing!");
        }

        // Redirect to the main user list if no forward has occurred
        if (!redirected) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
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
