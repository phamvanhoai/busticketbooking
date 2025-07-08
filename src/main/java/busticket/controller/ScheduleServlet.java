/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.ScheduleDAO;
import busticket.model.AdminLocations;
import busticket.model.Schedule;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class ScheduleServlet extends HttpServlet {

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
        ScheduleDAO scheduleDAO = new ScheduleDAO();

        // 1) Đọc filter
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");

        // 2) Đọc phân trang
        int PER_PAGE = 10;
        int page = 1;
        String p = request.getParameter("page");
        if (p != null) {
            try {
                page = Integer.parseInt(p);
            } catch (NumberFormatException ignored) {
            }
        }
        int offset = (page - 1) * PER_PAGE;

        try {
            // 3) Lấy dữ liệu
            int total = scheduleDAO.countSchedules(origin, destination);
            List<Schedule> list = scheduleDAO.getSchedules(origin, destination, offset, PER_PAGE);
            List<AdminLocations> locations = scheduleDAO.getAllLocations();

            int totalPages = (int) Math.ceil((double) total / PER_PAGE);

            // 4) Set attributes
            request.setAttribute("schedules", list);
            request.setAttribute("locations", locations);
            request.setAttribute("filterOrigin", origin);
            request.setAttribute("filterDestination", destination);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải lịch: " + e.getMessage());
        }

        // 5) Forward to JSP
        request.getRequestDispatcher("/WEB-INF/pages/schedule.jsp")
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
