/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.BookingStatisticsDAO;
import busticket.DAO.RouteDAO;
import busticket.model.BookingStatistics;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;
import java.util.Map.Entry;
import java.util.Comparator;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffBookingStatisticsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int ROWS_PER_PAGE = 4;

    private final BookingStatisticsDAO statsDao = new BookingStatisticsDAO();
    private final RouteDAO routeDao = new RouteDAO();

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
        try {
            // Get filters
            String selectedRoute = Optional.ofNullable(request.getParameter("route"))
                    .filter(s -> !s.isEmpty()).orElse("All");

            String dateStr = request.getParameter("date");
            LocalDate dateFilter = (dateStr == null || dateStr.isEmpty())
                    ? null : LocalDate.parse(dateStr);

            // Fetch stats from DB
            List<BookingStatistics> allStats = statsDao.getStats(selectedRoute, dateFilter);

            // Pagination
            int page = 1;
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (Exception ignored) {
            }

            int totalPages = (int) Math.ceil(allStats.size() / (double) ROWS_PER_PAGE);
            int fromIndex = (page - 1) * ROWS_PER_PAGE;
            int toIndex = Math.min(fromIndex + ROWS_PER_PAGE, allStats.size());
            List<BookingStatistics> pageStats = allStats.subList(fromIndex, toIndex);

            //Compute top-3 drivers
            Map<String, Long> driverCounts = allStats.stream()
                    .collect(Collectors.groupingBy(
                            BookingStatistics::getDriverName,
                            Collectors.counting()
                    ));
            List<String> topDrivers = driverCounts.entrySet().stream()
                    .sorted(Entry.<String, Long>comparingByValue(Comparator.reverseOrder()))
                    .map(Map.Entry::getKey)
                    .limit(3)
                    .collect(Collectors.toList());

            // Fetch route list from DB
            List<String> allRoutes = new ArrayList<>();
            allRoutes.add("All");
            allRoutes.addAll(routeDao.getAllRouteNames());

            // Set attributes
            request.setAttribute("stats", pageStats);
            request.setAttribute("allRoutes", allRoutes);
            request.setAttribute("selectedRoute", selectedRoute);
            request.setAttribute("selectedDate", dateStr);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            request.setAttribute("topDrivers", topDrivers);

            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/staff/booking-statistics.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error while fetching booking statistics", e);
        }
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
        // Redirect POST to GET
        String route = Optional.ofNullable(request.getParameter("route")).orElse("");
        String date = Optional.ofNullable(request.getParameter("date")).orElse("");

        String redirect = request.getContextPath()
                + "/staff/booking-statistics?route=" + route + "&date=" + date;

        response.sendRedirect(redirect);
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
