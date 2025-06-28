/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminUserDriverLicenseHistoryDAO;
import busticket.DAO.AdminUsersDAO;
import busticket.model.AdminDrivers;
import busticket.model.AdminUserDriverLicenseHistory;
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

        if (path.equals("/admin/users/add")) {
            request.getRequestDispatcher("/WEB-INF/admin/users/add-user.jsp").forward(request, response);
            return;
        }

        if (path.equals("/admin/users/edit")) {
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

                request.getRequestDispatcher("/WEB-INF/admin/users/edit-user.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                response.sendRedirect(contextPath + "/admin/users");
                return;
            }
        }

        if ("/admin/users/view".equals(path)) {
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

                    AdminUserDriverLicenseHistoryDAO historyDAO = new AdminUserDriverLicenseHistoryDAO();
                    List<AdminUserDriverLicenseHistory> licenseHistory = historyDAO.getLicenseHistoryByUserId(userId);
                    request.setAttribute("licenseHistory", licenseHistory);
                }

                request.getRequestDispatcher("/WEB-INF/admin/users/view-user.jsp").forward(request, response);
                return;

            } catch (NumberFormatException e) {
                response.sendRedirect(contextPath + "/admin/users");
                return;
            }
        }

        if (path.equals("/admin/users/upgrade-license")) {
            try {
                int userId = Integer.parseInt(request.getParameter("id"));
                AdminUsers user = adminUserDAO.getUserById(userId);
                if (user == null || !"Driver".equals(user.getRole())) {
                    response.sendRedirect(contextPath + "/pages/404.jsp");
                    return;
                }

                AdminDrivers driverInfo = adminUserDAO.getDriverByUserId(userId);
                request.setAttribute("user", user);
                request.setAttribute("driverInfo", driverInfo);

                request.getRequestDispatcher("/WEB-INF/admin/users/upgrade-license.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                response.sendRedirect(contextPath + "/admin/users");
                return;
            }
        }

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
            if ("upgradeLicense".equals(action)) {
                try {
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    String oldLicenseClass = request.getParameter("oldLicenseClass");
                    String newLicenseClass = request.getParameter("newLicenseClass");
                    String reason = request.getParameter("reason");

                    if (!"D".equals(oldLicenseClass) || !"D2".equals(newLicenseClass)) {
                        request.setAttribute("error", "Only upgrades from D to D2 are allowed.");
                        AdminUsers user = adminUsersDAO.getUserById(userId);
                        AdminDrivers driverInfo = adminUsersDAO.getDriverByUserId(userId);
                        request.setAttribute("user", user);
                        request.setAttribute("driverInfo", driverInfo);
                        request.getRequestDispatcher("/WEB-INF/admin/users/upgrade-license.jsp").forward(request, response);
                        return;
                    }

                    AdminUserDriverLicenseHistoryDAO historyDAO = new AdminUserDriverLicenseHistoryDAO();
                    AdminUsers currentAdmin = (AdminUsers) request.getSession().getAttribute("adminUser");
                    int adminId = currentAdmin != null ? currentAdmin.getUser_id() : 0;

                    int inserted = historyDAO.insertLicenseUpgradeHistory(userId, oldLicenseClass, newLicenseClass, adminId, reason);
                    if (inserted > 0) {
                        AdminDrivers driver = adminUsersDAO.getDriverByUserId(userId);
                        driver.setLicenseClass(newLicenseClass);
                        adminUsersDAO.updateDriver(driver);

                        response.sendRedirect(request.getContextPath() + "/admin/users/view?id=" + userId + "&message=license_upgraded");
                    } else {
                        request.setAttribute("error", "Failed to upgrade license. Please try again.");
                        AdminUsers user = adminUsersDAO.getUserById(userId);
                        AdminDrivers driverInfo = adminUsersDAO.getDriverByUserId(userId);
                        request.setAttribute("user", user);
                        request.setAttribute("driverInfo", driverInfo);
                        request.getRequestDispatcher("/WEB-INF/admin/users/upgrade-license.jsp").forward(request, response);
                    }
                    return;
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    return;
                }
            }

            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String confirmPassword = request.getParameter("confirmPassword");
                String role = request.getParameter("role");
                String status = request.getParameter("status");
                String phone = request.getParameter("phone");

                List<String> errorMessages = new ArrayList<>();

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
                if ("Driver".equals(role)) {
                    String licenseNumber = request.getParameter("licenseNumber");
                    String licenseClass = request.getParameter("licenseClass");
                    String hireDateStr = request.getParameter("hireDate");

                    if (licenseNumber == null || licenseNumber.trim().isEmpty()) {
                        errorMessages.add("License Number is required for drivers.");
                    } else if (!InputValidator.isLicenseNumberValid(licenseNumber)) {
                        errorMessages.add("License Number must be exactly 12 digits.");
                    } else if (adminUsersDAO.isLicenseNumberExists(licenseNumber)) {
                        errorMessages.add("License Number already exists.");
                    }

                    if (licenseClass == null || licenseClass.trim().isEmpty()) {
                        errorMessages.add("License Class is required for drivers.");
                    } else if (!InputValidator.isLicenseClassValid(licenseClass)) {
                        errorMessages.add("License Class must be D or D2.");
                    }

                    if (hireDateStr == null || hireDateStr.trim().isEmpty()) {
                        errorMessages.add("Hire Date is required for drivers.");
                    } else if (!InputValidator.isDateValid(hireDateStr)) {
                        errorMessages.add("Invalid Hire Date format.");
                    }

                    if (!errorMessages.isEmpty()) {
                        request.setAttribute("errors", errorMessages);
                        request.getRequestDispatcher("/WEB-INF/admin/users/add-user.jsp").forward(request, response);
                        return;
                    }
                }

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

                Timestamp createdAt = Timestamp.from(Instant.now());
                String hashedPassword = PasswordUtils.hashPassword(password);
                AdminUsers user = new AdminUsers(0, name, email, hashedPassword, phone, role, status != null ? status : "Active", birthdate, gender, address, createdAt);

                int newUserId = adminUsersDAO.addUser(user);

                if (newUserId > 0) {
                    if ("Driver".equals(role)) {
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
                            request.setAttribute("error", "User created, but failed to create driver info.");
                            request.getRequestDispatcher("/WEB-INF/admin/users/add-user.jsp").forward(request, response);
                            return;
                        }

                        response.sendRedirect(request.getContextPath() + "/admin/users?message=driver_created");
                        return;
                    }

                    response.sendRedirect(request.getContextPath() + "/admin/users?message=created");
                    return;
                }

                request.setAttribute("error", "Failed to create account.");
                request.getRequestDispatcher("/WEB-INF/admin/users/add-user.jsp").forward(request, response);
            }

            if ("edit".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                AdminUsers user = adminUsersDAO.getUserById(userId);

                if (user == null) {
                    response.sendRedirect(request.getContextPath() + "/pages/404.jsp");
                    return;
                }

                String originalRole = user.getRole();
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String roleFromForm = request.getParameter("role");
                String status = request.getParameter("status");
                String gender = request.getParameter("gender");
                String address = request.getParameter("address");
                String newLicenseClass = request.getParameter("newLicenseClass");
                String reason = request.getParameter("reason");

                Timestamp birthdate = null;
                try {
                    String birthdateStr = request.getParameter("birthdate");
                    if (birthdateStr != null && !birthdateStr.trim().isEmpty()) {
                        birthdate = new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(birthdateStr).getTime());
                    }
                } catch (ParseException ignored) {
                }

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
                        errorMessages.add("Invalid Vietnamese phone number.");
                    } else if (!phone.equals(user.getPhone()) && adminUsersDAO.isPhoneExists(phone)) {
                        errorMessages.add("Phone number already exists.");
                    }
                }

                List<String> validRoles = Arrays.asList("Admin", "Staff", "Driver", "Customer");
                if (!validRoles.contains(roleFromForm)) {
                    errorMessages.add("Invalid role selected.");
                }

                String finalRole = originalRole;
                if ("Customer".equalsIgnoreCase(originalRole) && !"Customer".equalsIgnoreCase(roleFromForm)) {
                    errorMessages.add("Cannot upgrade Customer to higher roles.");
                } else if (!"Customer".equalsIgnoreCase(originalRole) && "Customer".equalsIgnoreCase(roleFromForm)) {
                    errorMessages.add("Cannot downgrade Admin/Staff/Driver to Customer.");
                } else {
                    finalRole = roleFromForm;
                }

                if (!errorMessages.isEmpty()) {
                    request.setAttribute("errors", errorMessages);
                    request.setAttribute("user", user);
                    if ("Driver".equals(originalRole)) {
                        AdminDrivers driverInfo = adminUsersDAO.getDriverByUserId(userId);
                        request.setAttribute("driverInfo", driverInfo);
                    }
                    request.getRequestDispatcher("/WEB-INF/admin/users/edit-user.jsp").forward(request, response);
                    return;
                }

                user.setName(name);
                user.setEmail(email);
                user.setPhone(phone);
                user.setRole(finalRole);
                user.setStatus(status);
                user.setGender(gender);
                user.setAddress(address);
                user.setBirthdate(birthdate);
                adminUsersDAO.updateUser(user);

                if ("Driver".equals(finalRole)) {
                    AdminDrivers driver = adminUsersDAO.getDriverByUserId(userId);
                    if (driver == null) {
                        driver = new AdminDrivers();
                        driver.setUserId(userId);
                    }

                    String licenseNumber = request.getParameter("licenseNumber");
                    String licenseClass = request.getParameter("licenseClass");
                    String hireDateStr = request.getParameter("hireDate");
                    String driverStatus = request.getParameter("driverStatus");

                    boolean valid = true;
                    if (!InputValidator.isLicenseNumberValid(licenseNumber)) {
                        errorMessages.add("License Number must be exactly 12 digits.");
                        valid = false;
                    }
                    String currentLicense = adminUsersDAO.getDriverByUserId(userId).getLicenseNumber();
                    if (!licenseNumber.equals(currentLicense)
                            && adminUsersDAO.isLicenseNumberExists(licenseNumber)) {
                        errorMessages.add("License Number already exists.");
                        valid = false;
                    }

                    if (!InputValidator.isLicenseClassValid(licenseClass)) {
                        errorMessages.add("License Class must be D or D2.");
                        valid = false;
                    }
                    if (!InputValidator.isDateValid(hireDateStr)) {
                        errorMessages.add("Invalid hire date.");
                        valid = false;
                    }
                    if (!InputValidator.isDriverStatusValid(driverStatus)) {
                        errorMessages.add("Invalid driver status.");
                        valid = false;
                    }

                    if (!valid) {
                        request.setAttribute("errors", errorMessages);
                        request.setAttribute("user", user);
                        driver.setLicenseNumber(licenseNumber);
                        driver.setLicenseClass(licenseClass);
                        driver.setDriverStatus(driverStatus);
                        try {
                            driver.setHireDate(java.sql.Date.valueOf(hireDateStr));
                        } catch (IllegalArgumentException ignored) {
                        }
                        request.setAttribute("driverInfo", driver);
                        request.getRequestDispatcher("/WEB-INF/admin/users/edit-user.jsp").forward(request, response);
                        return;
                    }

                    String oldLicense = adminUsersDAO.getDriverByUserId(userId).getLicenseClass();
                    if ("D".equals(oldLicense) && "D2".equals(newLicenseClass)) {
                        driver.setLicenseClass("D2");

                        AdminUserDriverLicenseHistoryDAO historyDAO = new AdminUserDriverLicenseHistoryDAO();
                        AdminUsers currentAdmin = (AdminUsers) request.getSession().getAttribute("adminUser");
                        int adminId = currentAdmin != null
                                ? currentAdmin.getUser_id()
                                : 1;

                        historyDAO.insertLicenseUpgradeHistory(
                                userId,
                                oldLicense,
                                "D2",
                                adminId,
                                reason
                        );
                    } else {
                        driver.setLicenseClass(licenseClass);
                    }

                    driver.setLicenseNumber(licenseNumber);
                    driver.setHireDate(java.sql.Date.valueOf(hireDateStr));
                    driver.setDriverStatus(driverStatus);

                    if (driver.getDriverId() > 0) {
                        adminUsersDAO.updateDriver(driver);
                    } else {
                        adminUsersDAO.addDriver(driver);
                    }

                } else if ("Driver".equals(originalRole) && !"Driver".equals(finalRole)) {
                    adminUsersDAO.setDriverStatusInactiveByUserId(userId);
                }

                response.sendRedirect(request.getContextPath() + "/admin/users?message=updated");
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
