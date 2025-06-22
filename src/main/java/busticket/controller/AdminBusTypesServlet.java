/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminBusTypesDAO;
import busticket.model.AdminBusTypes;
import busticket.model.AdminSeatTemplate;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminBusTypesServlet extends HttpServlet {

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

        AdminBusTypesDAO adminBusTypesDAO = new AdminBusTypesDAO();
        // Lấy tham số hành động (action)
        String action = request.getParameter("action");
        if (request.getParameter("add") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/bus-types/add-bus-type.jsp").forward(request, response);
            return;
        }

        if (request.getParameter("delete") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/bus-types/delete-bus-type.jsp").forward(request, response);
            return;
        }

        if (request.getParameter("editId") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/bus-types/edit-bus-type.jsp").forward(request, response);
            return;
        }

        // --- PHÂN TRANG ---
        int currentPage = 1, rowsPerPage = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                /* giữ page=1 */ }
        }
        int offset = (currentPage - 1) * rowsPerPage;

        try {
            // 1. Lấy danh sách bus types phân trang
            List<AdminBusTypes> busTypes = adminBusTypesDAO.getBusTypes(offset, rowsPerPage);
            request.setAttribute("busTypes", busTypes);

            // 2. Tạo map seat templates nếu cần hiển thị
            Map<Integer, List<AdminSeatTemplate>> templatesMap = new HashMap<>();
            for (AdminBusTypes bt : busTypes) {
                templatesMap.put(bt.getBusTypeId(),
                        adminBusTypesDAO.getSeatTemplatesForType(bt.getBusTypeId()));
            }
            request.setAttribute("templatesMap", templatesMap);

            // 3. Tính toán tổng số trang
            int total = adminBusTypesDAO.getTotalBusTypesCount();
            int totalPages = (int) Math.ceil((double) total / rowsPerPage);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);

        } catch (SQLException e) {
            throw new ServletException(e);
        }

        request.getRequestDispatcher("/WEB-INF/admin/bus-types/bus-types.jsp")
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
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        AdminBusTypesDAO adminBusTypesDAO = new AdminBusTypesDAO();
        HttpSession session = request.getSession();

        try {
            if ("add".equals(action)) {
                session.setAttribute("success", "Location added successfully!");

            } else if ("edit".equals(action)) {
                session.setAttribute("success", "Location updated successfully!");

            } else if ("delete".equals(action)) {
                session.setAttribute("success", "Location deleted successfully!");
            }

        } catch (Exception ex) {
            session.setAttribute("error", "Error processing location: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/bus-types");
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
