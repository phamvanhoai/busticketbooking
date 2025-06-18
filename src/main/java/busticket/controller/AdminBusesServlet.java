/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminBusesDAO;
import busticket.model.AdminBusTypes;
import busticket.model.AdminBuses;
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
public class AdminBusesServlet extends HttpServlet {

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
        AdminBusesDAO adminBusesDAO = new AdminBusesDAO();

        if (request.getParameter("add") != null) {

            List<AdminBusTypes> busTypes = adminBusesDAO.getAllBusTypes();
            request.setAttribute("busTypes", busTypes);
            request.getRequestDispatcher("/WEB-INF/admin/buses/add-bus.jsp").forward(request, response);
            return;
        }

        if (request.getParameter("delete") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/buses/delete-bus.jsp").forward(request, response);
            return;
        }

        if (request.getParameter("editId") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/buses/edit-bus.jsp").forward(request, response);
            return;
        }

        // Pagination setup
        int busesPerPage = 10;
        int currentPage = 1;
        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        int offset = (currentPage - 1) * busesPerPage;

        List<AdminBuses> busesList = adminBusesDAO.getAllBuses(offset, busesPerPage);
        //int totalBuses = adminBusesDAO.countTotalBuses();  // Lấy tổng số xe buýt
        //int totalPages = (int) Math.ceil((double) totalBuses / busesPerPage);  // Tính số trang

        // Set attributes
        request.setAttribute("busesList", busesList);
        //request.setAttribute("totalBuses", totalBuses);
        request.setAttribute("currentPage", currentPage);
        //request.setAttribute("totalPages", totalPages);

        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/admin/buses/buses.jsp").forward(request, response);

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
        AdminBusesDAO adminBusesDAO = new AdminBusesDAO();

        try {
            if ("add".equals(action)) {
                // --- ADD NEW TRIP ---
                String code = request.getParameter("busCode");
                String plate = request.getParameter("plateNumber");
                int typeId = Integer.parseInt(request.getParameter("busTypeId"));
                int cap = Integer.parseInt(request.getParameter("capacity"));
                String status = request.getParameter("busStatus");
                AdminBuses bus = new AdminBuses(0, code, plate, typeId, null, cap, status);
                boolean ok = adminBusesDAO.addBus(bus);
                response.sendRedirect(request.getContextPath() + "/admin/buses");

            } else if ("edit".equals(action)) {
                // --- UPDATE bus ---

            } else if ("delete".equals(action)) {
                // --- DELETE bus ---
            }

        } catch (Exception ex) {
            // Nếu có lỗi, đưa thông báo vào request và forward về trang error hoặc list
            response.sendRedirect(request.getContextPath() + "/admin/trips");
            return;
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
