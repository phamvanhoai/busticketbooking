/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminUsersDAO;
import busticket.model.AdminDrivers;
import busticket.model.AdminUsers;
import busticket.util.InputValidator;
import busticket.util.PasswordUtils;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Arrays;
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

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // Route: Show Add User form
        if (path.equals("/admin/users/add")) {
            request.getRequestDispatcher("/WEB-INF/admin/users/add-user.jsp").forward(request, response);
            return;
        }

        // Route: Show Edit User form
        if (path.equals("/admin/users/edit")) {
            try {
                int userId = Integer.parseInt(request.getParameter("id"));
                AdminUsers user = adminUserDAO.getUserById(userId);
                if (user == null) {
                    response.sendRedirect(contextPath + "/pages/404.jsp");
                    return;
                }
                request.setAttribute("user", user);

                // Load extra driver info if user is a Driver
                if ("Driver".equals(user.getRole())) {
                    AdminDrivers driverInfo = adminUserDAO.getDriverByUserId(userId);
                    request.setAttribute("driverInfo", driverInfo);
                }
                request.getRequestDispatcher("/WEB-INF/admin/users/edit-user.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                response.sendRedirect(contextPath + "/admin/users");
                return;
            }
        }

        // Route: Show User Details
        if (path.equals("/admin/users/view")) {
            try {
                int userId = Integer.parseInt(request.getParameter("id"));
                AdminUsers user = adminUserDAO.getUserById(userId);
                if (user == null) {
                    response.sendRedirect(contextPath + "/pages/404.jsp");
                    return;
                }
                request.setAttribute("user", user);
                if ("Driver".equals(user.getRole())) {
                    AdminDrivers driverInfo = adminUserDAO.getDriverByUserId(userId);
                    request.setAttribute("driverInfo", driverInfo);
                }
                request.getRequestDispatcher("/WEB-INF/admin/users/view-user.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                response.sendRedirect(contextPath + "/admin/users");
                return;
            }
        }

        // Default route: list users with pagination and filtering
        String searchQuery = request.getParameter("search");
        String roleFilter = request.getParameter("role");

        int usersPerPage = 10;
        int currentPage = 1;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null && pageStr.matches("\\d+")) {
                currentPage = Integer.parseInt(pageStr);
            }
        } catch (NumberFormatException ignored) {
        }

        int offset = (currentPage - 1) * usersPerPage;
        List<AdminUsers> adminUsers = adminUserDAO.getAllAdminUsers(searchQuery, roleFilter, offset, usersPerPage);
        int totalUsers = adminUserDAO.countAllAdminUsers(searchQuery, roleFilter);
        int totalPages = (int) Math.ceil((double) totalUsers / usersPerPage);
        int currentTotalUsers = (currentPage < totalPages ? usersPerPage * currentPage : totalUsers);

        // Set attributes for UI rendering
        request.setAttribute("users", adminUsers);
        request.setAttribute("search", searchQuery);
        request.setAttribute("role", roleFilter);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("currentTotalUsers", currentTotalUsers);

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
        boolean redirected = false;

        try {
            if ("add".equals(action)) {
                // === Handle Add User ===
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String confirmPassword = request.getParameter("confirmPassword");
                String role = request.getParameter("role");
                String status = request.getParameter("status");
                String phone = request.getParameter("phone");

                List<String> errorMessages = new ArrayList<>();

                // === Validation ===
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
                if (!InputValidator.isEmailValid(email)) {
                    errorMessages.add("Invalid email format.");
                }
                if (!InputValidator.isPasswordValid(password)) {
                    errorMessages.add("Password must be at least 8 characters, including 1 letter and 1 number.");
                }
                if (adminUsersDAO.isEmailExists(email)) {
                    errorMessages.add("Email already exists.");
                }
                if (phone != null && !phone.trim().isEmpty()) {
                    if (!InputValidator.isVietnamesePhoneValid(phone)) {
                        errorMessages.add("Invalid Vietnamese phone number.");
                    } else if (adminUsersDAO.isPhoneExists(phone)) {
                        errorMessages.add("Phone number already exists.");
                    }
                }

                List<String> validRoles = Arrays.asList("Staff", "Admin", "Customer", "Driver");
                if (!validRoles.contains(role)) {
                    errorMessages.add("Invalid role selected.");
                }

                if (!errorMessages.isEmpty()) {
                    request.setAttribute("errors", errorMessages);
                    request.getRequestDispatcher("/WEB-INF/admin/users/add-user.jsp").forward(request, response);
                    redirected = true;
                    return;
                }

                // Optional fields
                String gender = request.getParameter("gender");
                String address = request.getParameter("address");
                Timestamp birthdate = null;
                try {
                    String birthdateStr = request.getParameter("birthdate");
                    if (birthdateStr != null && !birthdateStr.trim().isEmpty()) {
                        birthdate = new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(birthdateStr).getTime());
                    }
                } catch (ParseException ignored) {
                }

                // Create AdminUsers object
                Timestamp createdAt = Timestamp.from(Instant.now());
                String hashedPassword = PasswordUtils.hashPassword(password);
                AdminUsers user = new AdminUsers(0, name, email, hashedPassword, phone, role, status != null ? status : "Active", birthdate, gender, address, createdAt);

                // Insert user
                int newUserId = adminUsersDAO.addUser(user);

                // Insert driver info if role is Driver
                if (newUserId > 0 && "Driver".equals(role)) {
                    AdminDrivers driver = new AdminDrivers();
                    driver.setUserId(newUserId);
                    driver.setLicenseNumber(request.getParameter("licenseNumber"));
                    driver.setLicenseClass(request.getParameter("licenseClass"));
                    try {
                        String hireDateStr = request.getParameter("hireDate");
                        if (hireDateStr != null && !hireDateStr.isEmpty()) {
                            driver.setHireDate(java.sql.Date.valueOf(hireDateStr));
                        }
                    } catch (IllegalArgumentException ignored) {
                    }
                    driver.setDriverStatus("Active");

                    int driverAdded = adminUsersDAO.addDriver(driver);
                    if (driverAdded == 0) {
                        request.setAttribute("error", "Failed to create driver information.");
                        request.getRequestDispatcher("/WEB-INF/admin/users/add-user.jsp").forward(request, response);
                        redirected = true;
                        return;
                    }
                }

                // Redirect to list page after successful insert
                if (newUserId > 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?message=created");
                } else {
                    request.setAttribute("error", "Failed to create account.");
                    request.getRequestDispatcher("/WEB-INF/admin/users/add-user.jsp").forward(request, response);
                }
                redirected = true;
            }

            if ("edit".equals(action)) {
                // === Handle Edit User ===
                int userId = Integer.parseInt(request.getParameter("userId"));
                AdminUsers user = adminUsersDAO.getUserById(userId);
                if (user == null) {
                    response.sendRedirect(request.getContextPath() + "/pages/404.jsp");
                    return;
                }

                // Get form data
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String role = request.getParameter("role");
                String status = request.getParameter("status");
                String gender = request.getParameter("gender");
                String address = request.getParameter("address");
                Timestamp birthdate = null;
                try {
                    String birthdateStr = request.getParameter("birthdate");
                    if (birthdateStr != null && !birthdateStr.trim().isEmpty()) {
                        birthdate = new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(birthdateStr).getTime());
                    }
                } catch (ParseException ignored) {
                }

                // Validate form
                List<String> errorMessages = new ArrayList<>();
                if (name == null || name.trim().isEmpty()) {
                    errorMessages.add("Full Name is required.");
                }
                if (email == null || email.trim().isEmpty()) {
                    errorMessages.add("Email is required.");
                } else if (!InputValidator.isEmailValid(email)) {
                    errorMessages.add("Invalid email format.");
                } else if (!email.equals(user.getEmail()) && adminUsersDAO.isEmailExists(email)) {
                    errorMessages.add("Email already exists.");
                }
                if (phone != null && !phone.trim().isEmpty()) {
                    if (!InputValidator.isVietnamesePhoneValid(phone)) {
                        request.setAttribute("message", "Invalid Vietnamese phone number.");
                        request.setAttribute("messageType", "error");
                        request.setAttribute("user", user);
                        if ("Driver".equals(user.getRole())) {
                            AdminDrivers driverInfo = adminUsersDAO.getDriverByUserId(userId);
                            request.setAttribute("driverInfo", driverInfo);
                        }
                        request.getRequestDispatcher("/WEB-INF/admin/users/edit-user.jsp").forward(request, response);
                        return;
                    } else if (!phone.equals(user.getPhone()) && adminUsersDAO.isPhoneExists(phone)) {
                        request.setAttribute("message", "Phone number already exists.");
                        request.setAttribute("messageType", "error");
                        request.setAttribute("user", user);
                        if ("Driver".equals(user.getRole())) {
                            AdminDrivers driverInfo = adminUsersDAO.getDriverByUserId(userId);
                            request.setAttribute("driverInfo", driverInfo);
                        }
                        request.getRequestDispatcher("/WEB-INF/admin/users/edit-user.jsp").forward(request, response);
                        return;
                    }
                }

                if (!Arrays.asList("Staff", "Admin", "Customer", "Driver").contains(role)) {
                    errorMessages.add("Invalid role selected.");
                }

                if (!errorMessages.isEmpty()) {
                    request.setAttribute("errors", errorMessages);
                    request.setAttribute("user", user);
                    if ("Driver".equals(user.getRole())) {
                        AdminDrivers driverInfo = adminUsersDAO.getDriverByUserId(userId);
                        request.setAttribute("driverInfo", driverInfo);
                    }
                    request.getRequestDispatcher("/WEB-INF/admin/users/edit-user.jsp").forward(request, response);
                    redirected = true;
                    return;
                }

                // Update user
                user.setName(name);
                user.setEmail(email);
                user.setPhone(phone);
                user.setRole(role);
                user.setStatus(status);
                user.setGender(gender);
                user.setAddress(address);
                user.setBirthdate(birthdate);
                adminUsersDAO.updateUser(user);

                // Handle driver info if role is Driver
                if ("Driver".equals(role)) {
                    AdminDrivers driver = adminUsersDAO.getDriverByUserId(userId);
                    if (driver == null) {
                        driver = new AdminDrivers();
                        driver.setUserId(userId);
                    }
                    driver.setLicenseNumber(request.getParameter("licenseNumber"));
                    driver.setLicenseClass(request.getParameter("licenseClass"));
                    try {
                        String hireDateStr = request.getParameter("hireDate");
                        if (hireDateStr != null && !hireDateStr.isEmpty()) {
                            driver.setHireDate(java.sql.Date.valueOf(hireDateStr));
                        }
                    } catch (IllegalArgumentException ignored) {
                    }

                    driver.setDriverStatus(request.getParameter("driverStatus"));

                    if (driver.getDriverId() > 0) {
                        adminUsersDAO.updateDriver(driver);
                    } else {
                        adminUsersDAO.addDriver(driver);
                    }
                } else if ("Driver".equals(user.getRole()) && !"Driver".equals(role)) {
                    // If changed from Driver → Other role, deactivate driver info
                    adminUsersDAO.setDriverStatusInactiveByUserId(userId);
                }

                response.sendRedirect(request.getContextPath() + "/admin/users?message=updated");
                redirected = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error occurred.");
            request.getRequestDispatcher("/WEB-INF/admin/users/edit-user.jsp").forward(request, response);
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
