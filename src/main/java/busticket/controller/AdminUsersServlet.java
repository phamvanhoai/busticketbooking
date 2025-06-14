/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminUsersDAO;
import busticket.model.AdminUsers;
import busticket.util.InputValidator;
import busticket.util.PasswordUtils;
import busticket.util.SessionUtil;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminUsersServlet extends HttpServlet {

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

        AdminUsersDAO adminUserDAO = new AdminUsersDAO();

        // Check if the user is an admin; redirect to home if not
//        if (!SessionUtil.isAdmin(request)) {
//            response.sendRedirect(request.getContextPath() + "/pages/home.jsp");
//            return;
//        }
        // Handle request to display the add coupon form
        if (request.getParameter("add") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/users/add-user.jsp").forward(request, response);
            return;
        }
        // Handle request to edit a specific user
        String editId = request.getParameter("editId");
        if (editId != null) {
            try {
                int userId = Integer.parseInt(editId);
                AdminUsers user = adminUserDAO.getUserById(userId);

                // Redirect to 404 page if the user is not found
                if (user == null) {
                    response.sendRedirect(request.getContextPath() + "/pages/404.jsp");
                    return;
                }

                // Set user data and forward to edit page
                request.setAttribute("user", user);
                request.getRequestDispatcher("/WEB-INF/admin/users/edit-user.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                // Redirect to user list if editId is invalid
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
        }

        // Retrieve search query parameter
        String searchQuery = request.getParameter("search");

        // Pagination setup
        int usersPerPage = 10; // Number of users per page
        int currentPage = 1;   // Default to page 1
        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1; // Fallback to page 1 if parsing fails
            }
        }
        int offset = (currentPage - 1) * usersPerPage; // Calculate offset for pagination

        // Fetch paginated and filtered list of users
        List<AdminUsers> adminUsers = adminUserDAO.getAllAdminUsers(searchQuery, offset, usersPerPage);
        int totalUsers = adminUserDAO.countUsersByFilter(searchQuery); // Get total number of users
        int totalPages = (int) Math.ceil((double) totalUsers / usersPerPage); // Calculate total pages

        // Calculate the current total users displayed (full page size or remaining users on the last page)
        int currentTotalUsers = (currentPage < totalPages ? usersPerPage * currentPage : totalUsers);

        // Set attributes for JSP rendering
        request.setAttribute("users", adminUsers);             // List of users
        request.setAttribute("totalUsers", totalUsers);       // Total number of users
        request.setAttribute("searchQuery", searchQuery);     // Search query for reuse in JSP
        request.setAttribute("totalPages", totalPages);       // Total number of pages for pagination
        request.setAttribute("currentPage", currentPage);     // Current page number
        request.setAttribute("currentTotalUsers", currentTotalUsers); // Current total users displayed

        // Forward request to the users JSP page
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
        AdminUsersDAO adminUsersDAO = new AdminUsersDAO();  // Sử dụng AdminUsersDAO thay cho AdminCouponsDAO

        try {
            if ("add".equals(action)) {
                // Add a new user
                // Get user data from the form
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String confirmPassword = request.getParameter("confirmPassword");
                String role = request.getParameter("role");
                String status = request.getParameter("status");

                List<String> errorMessages = new ArrayList<>();

                // Validate form input
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

                // Check if email already exists
                if (adminUsersDAO.isEmailExists(email)) {
                    errorMessages.add("Email already exists!");
                }

                // Validate email format
                if (!InputValidator.isEmailValid(email)) {
                    errorMessages.add("Invalid email format. Example: user@example.com");
                }

                // Validate password strength
                if (!InputValidator.isPasswordValid(password)) {
                    errorMessages.add("Password must be at least 8 characters with 1 letter & 1 number.");
                }

                // If errors exist, forward back to add-user.jsp
                if (!errorMessages.isEmpty()) {
                    request.setAttribute("errors", errorMessages);
                    request.getRequestDispatcher("/WEB-INF/admin/add-user.jsp").forward(request, response);
                    return;
                }

                // Hash password before storing it
                String hashedPassword = PasswordUtils.hashPassword(password);
                System.out.println("Hashed password: " + hashedPassword);


                // Set created_at to the current time if it's null
                Timestamp createdAt = Timestamp.from(Instant.now());

                // Create user object
                AdminUsers user = new AdminUsers(0, name, email, hashedPassword, role, status, createdAt);

                // Add user to the database
                int isAdded = adminUsersDAO.addUser(user);

                // If user added successfully, redirect to user list
                if (isAdded > 0) {
                    request.setAttribute("message", "Account created successfully!");
                    request.getRequestDispatcher("/WEB-INF/admin/users/users.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Add failed. Please try again.");
                    request.getRequestDispatcher("/WEB-INF/admin/users/add-user.jsp").forward(request, response);
                }
            } else if ("edit".equals(action)) {
                // Edit an existing user
                int userId = Integer.parseInt(request.getParameter("userId"));
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String role = request.getParameter("role");
                String gender = request.getParameter("gender");
                String birthdate = request.getParameter("birthdate");  // Get birthdate
                String address = request.getParameter("address");
                String status = request.getParameter("status");  // Include status

                // Validate input data
                if (name == null || name.isEmpty() || email == null || email.isEmpty()
                        || phone == null || phone.isEmpty()
                        || role == null || role.isEmpty() || gender == null || gender.isEmpty()
                        || birthdate.isEmpty() || address == null || address.isEmpty() || status == null || status.isEmpty()) {

                    request.setAttribute("error", "Please enter valid information!");
                    request.getRequestDispatcher("/WEB-INF/admin/edit-user.jsp").forward(request, response);
                    return;
                }

                // Convert birthdate from String to Timestamp (or Date if you prefer)
                Timestamp birthdateTimestamp = null;
                if (birthdate != null && !birthdate.isEmpty()) {
                    try {
                        // Convert the birthdate to a Timestamp (using "yyyy-MM-dd" format)
                        birthdateTimestamp = Timestamp.valueOf(birthdate + " 00:00:00");  // Set default time to midnight
                    } catch (IllegalArgumentException e) {
                        // If the date format is invalid, show error
                        request.setAttribute("error", "Invalid birthdate format!");
                        request.getRequestDispatcher("/WEB-INF/admin/edit-user.jsp").forward(request, response);
                        return;
                    }
                }

                // Create and update the user
                AdminUsers user = new AdminUsers(userId, name, email, phone, role, status, birthdateTimestamp, gender, address);
                adminUsersDAO.updateUser(user);
            }

        } catch (Exception e) {
            // Handle any exceptions during processing
            request.setAttribute("error", "Error occurred during processing!");
        }

        // Redirect to the user list page after processing
        response.sendRedirect(request.getContextPath() + "/admin/users");
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
