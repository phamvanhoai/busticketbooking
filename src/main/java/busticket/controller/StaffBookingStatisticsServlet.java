/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.StaffBookingStatisticsDAO;
import busticket.DAO.StaffRouteDAO;
import busticket.model.StaffBookingStatistics;
import busticket.model.StaffBookingStatisticsTopDriver;
import busticket.model.StaffRoute;
import busticket.model.StaffTopCustomer;
import busticket.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.ArrayList;
import java.util.Map;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffBookingStatisticsServlet extends HttpServlet {

    private final int PAGE_SIZE = 10;

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
        // Check if the user is an Staff; redirect to home if not
        if (!SessionUtil.isStaff(request)) {
            response.sendRedirect(request.getContextPath());
            return;
        }

        try {
            // Retrieve query parameters
            String keyword = request.getParameter("q");
            String paymentStatus = request.getParameter("status");
            String departureDate = request.getParameter("date");
            String routeIdParam = request.getParameter("routeId");
            String pageParam = request.getParameter("page");

            if (keyword == null) {
                keyword = "";
            }
            if (paymentStatus != null && paymentStatus.trim().isEmpty()) {
                paymentStatus = null;
            }
            if (departureDate != null && departureDate.trim().isEmpty()) {
                departureDate = null;
            }

            int routeId = -1;
            try {
                routeId = Integer.parseInt(routeIdParam);
            } catch (Exception ignored) {
            }

            int page = 1;
            try {
                page = Integer.parseInt(pageParam);
            } catch (Exception ignored) {
            }

            StaffBookingStatisticsDAO dao = new StaffBookingStatisticsDAO();

            // Statistics list
            List<StaffBookingStatistics> stats = dao.getFilteredStatisticsByPage(
                    keyword, null, routeId, departureDate, paymentStatus, page, PAGE_SIZE
            );

            int totalRecords = dao.countFilteredStatistics(keyword, null, routeId, departureDate, paymentStatus);
            int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

            // Revenue calculation
            BigDecimal totalAmount = dao.getTotalAmount(keyword, null, routeId, departureDate, paymentStatus);
            BigDecimal paidAmount = dao.getTotalAmount(keyword, null, routeId, departureDate, "Paid");

            double paidPercentage = 0;
            if (totalAmount != null && totalAmount.compareTo(BigDecimal.ZERO) > 0) {
                paidPercentage = paidAmount
                        .divide(totalAmount, 2, BigDecimal.ROUND_HALF_UP)
                        .multiply(new BigDecimal("100"))
                        .doubleValue();
            }

            int paidCount = dao.countFilteredStatistics(keyword, null, routeId, departureDate, "Paid");
            int unpaidCount = dao.countFilteredStatistics(keyword, null, routeId, departureDate, "Unpaid");

            double paidRatio = 0, unpaidRatio = 0;
            if (totalRecords > 0) {
                paidRatio = ((double) paidCount * 100) / totalRecords;
                unpaidRatio = ((double) unpaidCount * 100) / totalRecords;
            }

            List<StaffRoute> allRoutes = new StaffRouteDAO().getAllRoutes();
            List<StaffBookingStatisticsTopDriver> topDrivers = dao.getTopDriversByRevenue(5);

            int totalTrips = 0, totalTickets = 0;
            BigDecimal totalRevenue = BigDecimal.ZERO;
            for (StaffBookingStatisticsTopDriver d : topDrivers) {
                totalTrips += d.getTripCount();
                totalTickets += d.getTicketCount();
                totalRevenue = totalRevenue.add(d.getRevenue());
            }

            BigDecimal avgRevenue = BigDecimal.ZERO;
            if (totalRecords > 0) {
                avgRevenue = totalAmount.divide(BigDecimal.valueOf(totalRecords), 2, BigDecimal.ROUND_HALF_UP);
            }

            BigDecimal avgTicketsPerTrip = BigDecimal.ZERO;
            if (totalTrips > 0) {
                avgTicketsPerTrip = BigDecimal.valueOf(totalTickets)
                        .divide(BigDecimal.valueOf(totalTrips), 2, BigDecimal.ROUND_HALF_UP);
            }

            List<String> routeNames = dao.getAllRouteNames();
            List<BigDecimal> routeRevenues = dao.getRevenuePerRoute();
            List<StaffTopCustomer> topCustomers = dao.getTopCustomers(5);
            Map<String, Integer> trendMap = dao.getBookingTrendLast7Days();
            List<String> trendDates = new ArrayList<>(trendMap.keySet());
            List<Integer> trendCounts = new ArrayList<>(trendMap.values());

            ObjectMapper mapper = new ObjectMapper();
            request.setAttribute("routeNamesJson", mapper.writeValueAsString(routeNames));
            request.setAttribute("routeRevenueJson", mapper.writeValueAsString(routeRevenues));
            request.setAttribute("trendDatesJson", mapper.writeValueAsString(trendDates));
            request.setAttribute("trendCountsJson", mapper.writeValueAsString(trendCounts));

            // Pagination attributes
            request.setAttribute("currentPage", page);
            request.setAttribute("numOfPages", totalPages);

            // Build base URL with filter params
            String baseUrl = request.getContextPath() + "/staff/booking-statistics";
            StringBuilder query = new StringBuilder();
            if (!keyword.isEmpty()) {
                query.append("&q=").append(keyword);
            }
            if (paymentStatus != null) {
                query.append("&status=").append(paymentStatus);
            }
            if (departureDate != null) {
                query.append("&date=").append(departureDate);
            }
            if (routeId != -1) {
                query.append("&routeId=").append(routeId);
            }
            String baseUrlWithSearch = baseUrl + "?" + query.toString().replaceFirst("&", "");

            request.setAttribute("baseUrlWithSearch", baseUrlWithSearch);

            // Data binding
            request.setAttribute("stats", stats);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("distinctRoutes", allRoutes);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("paidPercentage", paidPercentage);
            request.setAttribute("topDrivers", topDrivers);
            request.setAttribute("totalTrips", totalTrips);
            request.setAttribute("totalTickets", totalTickets);
            request.setAttribute("totalRevenueTopDrivers", totalRevenue);
            request.setAttribute("avgRevenue", avgRevenue);
            request.setAttribute("avgTicketsPerTrip", avgTicketsPerTrip);
            request.setAttribute("topCustomers", topCustomers);
            request.setAttribute("paidCount", paidCount);
            request.setAttribute("unpaidCount", unpaidCount);
            request.setAttribute("paidRatio", paidRatio);
            request.setAttribute("unpaidRatio", unpaidRatio);

            // Keep filter values for reuse
            request.setAttribute("q", keyword);
            request.setAttribute("status", paymentStatus);
            request.setAttribute("date", departureDate);
            request.setAttribute("routeId", routeId);

            request.getRequestDispatcher("/WEB-INF/staff/booking-statistics/booking-statistics.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "System error occurred!");
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
        doGet(request, response);
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
