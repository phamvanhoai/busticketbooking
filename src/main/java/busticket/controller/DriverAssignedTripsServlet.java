/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.DriverAssignedTripsDAO;
import busticket.model.DriverAssignedTrip;
import busticket.model.Users;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class DriverAssignedTripsServlet extends HttpServlet {

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
        // Get driver_id from session or request
        // Lấy thông tin người dùng từ session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("currentUser");
        int driverId = currentUser.getUser_id();
        
        if (request.getParameter("roll-call") != null) {
            request.getRequestDispatcher("/WEB-INF/driver/assigned-trips/passenger-roll-call.jsp")
                    .forward(request, response);
            return;
        }

// Lấy thông tin bộ lọc từ request
        String route = request.getParameter("route");
        String status = request.getParameter("status");
        String date = request.getParameter("date");

// Phân trang
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

// Lấy danh sách chuyến theo bộ lọc và phân trang
        DriverAssignedTripsDAO driverAssignedTripsDAO = new DriverAssignedTripsDAO();
        List<DriverAssignedTrip> assignedTrips = driverAssignedTripsDAO.getAssignedTrips(driverId, route, status, date, offset, tripsPerPage);
        int totalTrips = driverAssignedTripsDAO.getTotalAssignedTripsCount(driverId, route, status, date);
        int totalPages = (int) Math.ceil((double) totalTrips / tripsPerPage);

// Lấy các địa điểm cho bộ lọc
        List<String> locations = driverAssignedTripsDAO.getAllLocations();

// Thiết lập các tham số vào request để JSP có thể sử dụng
        request.setAttribute("assignedTrips", assignedTrips);
        request.setAttribute("locations", locations);
        request.setAttribute("route", route);
        request.setAttribute("status", status);
        request.setAttribute("date", date);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

// Chuyển tiếp tới JSP
        request.getRequestDispatcher("/WEB-INF/driver/assigned-trips/assigned-trips.jsp").forward(request, response);
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
