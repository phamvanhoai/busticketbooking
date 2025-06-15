/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminTripsDAO;
import busticket.model.AdminTrips;
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
public class AdminTripsServlet extends HttpServlet {

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
        // Khởi tạo DAO để lấy danh sách chuyến đi
        AdminTripsDAO adminTripsDAO = new AdminTripsDAO();

        // Lấy tham số hành động (action)
        String action = request.getParameter("action");

        if (request.getParameter("add") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/trips/add-trip.jsp").forward(request, response);
            return;
        }

        if (request.getParameter("editId") != null) {
            request.getRequestDispatcher("/WEB-INF/admin/trips/edit-trip.jsp").forward(request, response);
            return;
        }

        String route = request.getParameter("route");
        String busType = request.getParameter("busType");
        String driver = request.getParameter("driver");

        int currentPage = 1;
        int tripsPerPage = 10;

        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int offset = (currentPage - 1) * tripsPerPage;

        // Lấy danh sách chuyến đi với filter và phân trang
        List<AdminTrips> trips = adminTripsDAO.getAllTrips(route, busType, driver, offset, tripsPerPage);
        int totalTrips = adminTripsDAO.getTotalTripsCount(route, busType, driver); // Lấy tổng số chuyến đi
        int totalPages = (int) Math.ceil((double) totalTrips / tripsPerPage);

        request.setAttribute("trips", trips);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTrips", totalTrips);

        request.getRequestDispatcher("/WEB-INF/admin/trips/trips.jsp").forward(request, response);
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
