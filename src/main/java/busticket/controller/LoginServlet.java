/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.UsersDAO;
import busticket.model.Users;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class LoginServlet extends HttpServlet {

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
        request.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp").forward(request, response);
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

        // Destroy old session if any (to *prevent session fixation attacks)
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UsersDAO uDAO = new UsersDAO();
        Users user = uDAO.login(email, password); // Pass raw password (comparison is done inside login method)

        if (user == null) { // Something went wrong
            request.setAttribute("error", "Something went wrong");
            request.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp").forward(request, response);
        } else if (user.getUser_id() == -1) { // Account locked - *prevent brute force attacks
            request.setAttribute("error", "Your account is locked. Try again later.");
            request.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp").forward(request, response);
        } else if (user.getUser_id() == -2) { // Invalid password
            request.setAttribute("error", "Invalid password.");
            request.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp").forward(request, response);
        } else if (user.getUser_id() == -3) { // Invalid email
            request.setAttribute("error", "Invalid email.");
            request.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp").forward(request, response);
        } else { // If user exists (-4 meant OAuth user)
            session = request.getSession(true); // Create a new secure session
            session.setAttribute("currentUser", user); // Current user
            session.setAttribute("currentEmail", user.getEmail());
            // Set session timeout - *prevent Session Hijacking
            session.setMaxInactiveInterval(30 * 60); // 30 minutes without interacting
            response.sendRedirect(request.getContextPath() + "/");
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
