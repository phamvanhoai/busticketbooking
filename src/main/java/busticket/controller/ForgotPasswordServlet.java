/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.UsersDAO;
import busticket.model.Users;
import busticket.util.EmailUtils;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class ForgotPasswordServlet extends HttpServlet {

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
        request.getRequestDispatcher("/WEB-INF/pages/auth/forgot-password.jsp").forward(request, response);
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
        String email = request.getParameter("email");

        // Create an instance of UsersDAO
        UsersDAO usersDAO = new UsersDAO();

        // Check if the user exists with the given email
        Users user = usersDAO.getUserByEmail(email);

        if (user != null) {
            // Generate a reset token
            String resetToken = UUID.randomUUID().toString(); // Create a unique token
            usersDAO.storeResetToken(user.getUser_id(), resetToken); // Store the token in the DB

            // Send email with reset link
            String resetLink = request.getRequestURL().toString().replace(request.getServletPath(), "") + "/reset-password?token=" + resetToken;
            String subject = "Reset your password";
            String body = "Click the link to reset your password: " + resetLink;

            boolean emailSent = EmailUtils.sendEmail(user.getEmail(), subject, body);

            if (emailSent) {
                request.setAttribute("message", "Password reset link has been sent to your email.");
            } else {
                request.setAttribute("error", "Failed to send the reset link. Please try again.");
            }
        } else {
            request.setAttribute("error", "Email not found.");
        }

        request.getRequestDispatcher("/WEB-INF/pages/auth/forgot-password.jsp").forward(request, response);
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
