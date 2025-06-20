/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminLocationsDAO;
import busticket.model.AdminLocations;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminLocationsServlet extends HttpServlet {

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
        AdminLocationsDAO adminLocationsDAO = new AdminLocationsDAO();

        // Lấy tham số hành động (action)
        String action = request.getParameter("action");

        if (request.getParameter("add") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/locations/add-location.jsp")
                    .forward(request, response);
            return;
        }

        // View details
        String detail = request.getParameter("detail");
        if (detail != null) {
            try {
                int locId = Integer.parseInt(detail);
                AdminLocations loc = adminLocationsDAO.getLocationById(locId);
                request.setAttribute("location", loc);
            } catch (Exception e) {
                throw new ServletException("Invalid location ID for detail", e);
            }
            request.getRequestDispatcher("/WEB-INF/admin/locations/view-location-details.jsp")
                    .forward(request, response);
            return;
        }

        String editId = request.getParameter("editId");
        if (editId != null) {
            request.getRequestDispatcher("/WEB-INF/admin/locations/edit-location.jsp").forward(request, response);
        }

        //Delete
        String delete = request.getParameter("delete");
        if (delete != null) {
            request.getRequestDispatcher("/WEB-INF/admin/locations/delete-location.jsp").forward(request, response);

        }
        // 2. Phân trang + search
        String search = request.getParameter("search");  // từ ô input
        int currentPage = 1, rowsPerPage = 10;
        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                /* giữ currentPage = 1 */ }
        }
        int offset = (currentPage - 1) * rowsPerPage;

        try {
            List<AdminLocations> list = adminLocationsDAO.getLocations(search, offset, rowsPerPage);
            int total = adminLocationsDAO.getTotalLocationsCount(search);
            int totalPages = (int) Math.ceil((double) total / rowsPerPage);

            request.setAttribute("locations", list);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalLocations", total);
            request.setAttribute("search", search);
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        request.getRequestDispatcher("/WEB-INF/admin/locations/locations.jsp")
                .forward(request, response);
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
