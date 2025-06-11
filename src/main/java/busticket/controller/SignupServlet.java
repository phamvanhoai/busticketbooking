/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.UsersDAO;
import busticket.model.Users;
import busticket.util.InputValidator;
import busticket.util.PasswordUtils;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class SignupServlet extends HttpServlet {

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
        request.getRequestDispatcher("/WEB-INF/pages/auth/signup.jsp").forward(request, response);
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

        UsersDAO uDAO = new UsersDAO();
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        List<String> errorMessages = new ArrayList<>();

        // Validate the input data
        if (name == null || name.isEmpty()) {
            errorMessages.add("Name is required!");
        }
        if (email == null || email.isEmpty()) {
            errorMessages.add("Email is required!");
        }
        if (password == null || password.isEmpty()) {
            errorMessages.add("Password is required!");
        }
        if (confirmPassword == null || confirmPassword.isEmpty()) {
            errorMessages.add("Confirm password is required!");
        }

        if (!password.equals(confirmPassword)) {
            errorMessages.add("Passwords do not match!");
        }
        if (uDAO.isEmailExists(email)) {
            errorMessages.add("Email already exists!");
        }
        if (!InputValidator.isEmailValid(email)) {
            errorMessages.add("Invalid email format. Example: user@example.com");
        }
        if (!InputValidator.isPasswordValid(password)) {
            errorMessages.add("Password must be at least 8 characters with 1 letter & 1 number.");
        }

        // If there are errors, return
        if (!errorMessages.isEmpty()) {
            // Set the error messages as a request attribute to show on the signup page
            request.setAttribute("errors", errorMessages);
            request.getRequestDispatcher("/WEB-INF/pages/auth/signup.jsp").forward(request, response);
            return;
        }

        // Hash the password before storing it
        String hashedPassword = PasswordUtils.hashPassword(password); // Hash the password before storing it

        // Try signing up the user
        if (uDAO.signup(new Users(name, email, hashedPassword)) > 0) { // Signup successful
            // Set a success message for the user and redirect to login
            request.setAttribute("message", "Account created successfully! Please log in.");
            request.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp").forward(request, response);
        } else {
            // Signup failed, set error message and redirect back to signup page
            request.setAttribute("error", "Signup failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/pages/auth/signup.jsp").forward(request, response);
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
