/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package busticket.controller;

import busticket.DAO.AdminUsersDAO;
import busticket.model.AdminUsers;
import busticket.util.SessionUtil;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminUsersServlet extends HttpServlet {
   
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
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
        request.getRequestDispatcher("/WEB-INF/admin/users.jsp").forward(request, response);
        
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
