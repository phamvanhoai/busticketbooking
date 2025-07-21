/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminViewStatisticsDAO;
import busticket.model.AdminStatistics;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.Year;
import java.time.YearMonth;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminViewStatisticsServlet extends HttpServlet {

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
        AdminViewStatisticsDAO adminViewStatisticsDAO = new AdminViewStatisticsDAO();
        AdminStatistics statistics = new AdminStatistics();

        // Lấy tham số period và dateValue từ request
        String period = request.getParameter("period");
        String dateValue = request.getParameter("dateValue");

        // Đặt giá trị mặc định nếu period hoặc dateValue rỗng
        if (period == null || period.isEmpty() || !isValidPeriod(period)) {
            period = "year";
            dateValue = String.valueOf(Year.now().getValue()); // Mặc định: 2025
        } else if (dateValue == null || dateValue.isEmpty()) {
            dateValue = getDefaultDateValue(period);
        }

        // Kiểm tra định dạng dateValue
        try {
            validateDateValue(period, dateValue);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/admin/statistics/view-statistics.jsp").forward(request, response);
            return;
        }

        try {
            // Lấy dữ liệu thống kê từ DAO
            statistics.setRevenue(adminViewStatisticsDAO.getRevenueByPeriod(period, dateValue));
            statistics.setOccupancyRate(adminViewStatisticsDAO.getOccupancyRateByPeriod(period, dateValue));
            statistics.setTicketTypeBreakdown(adminViewStatisticsDAO.getTicketTypeBreakdownByPeriod(period, dateValue));
            statistics.setTopRoutesRevenue(adminViewStatisticsDAO.getTopRoutesRevenueByPeriod(period, dateValue));
            statistics.setDriverPerformance(adminViewStatisticsDAO.getDriverPerformanceByPeriod(period, dateValue));
            statistics.setDetailedStatistics(adminViewStatisticsDAO.getDetailedStatisticsByPeriod(period, dateValue));
            statistics.setPeriod(period);
            statistics.setDateValue(dateValue);

            // In giá trị để gỡ lỗi
            System.out.println("DEBUG: doGet period=" + period + ", dateValue=" + dateValue);

            // Truyền dữ liệu vào request
            request.setAttribute("statistics", statistics);

            // Chuyển tiếp đến JSP
            request.getRequestDispatcher("/WEB-INF/admin/statistics/view-statistics.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching statistics: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý form lọc thống kê
        String period = request.getParameter("period");
        String dateValue = request.getParameter("dateValue");

        // Đặt giá trị mặc định nếu rỗng
        if (period == null || period.isEmpty() || !isValidPeriod(period)) {
            period = "year";
            dateValue = String.valueOf(Year.now().getValue());
        } else if (dateValue == null || dateValue.isEmpty()) {
            dateValue = getDefaultDateValue(period);
        }

        // In giá trị để gỡ lỗi
        System.out.println("DEBUG: doPost period=" + period + ", dateValue=" + dateValue);

        // Chuyển hướng với tham số
        response.sendRedirect(request.getContextPath() + "/admin/statistics?period=" + period + "&dateValue=" + dateValue);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for viewing admin statistics";
    }

    // Kiểm tra period hợp lệ
    private boolean isValidPeriod(String period) {
        return period != null && (
            period.equalsIgnoreCase("day") ||
            period.equalsIgnoreCase("week") ||
            period.equalsIgnoreCase("month") ||
            period.equalsIgnoreCase("quarter") ||
            period.equalsIgnoreCase("year")
        );
    }

    // Trả về dateValue mặc định
    private String getDefaultDateValue(String period) {
        switch (period.toLowerCase()) {
            case "day":
            case "week":
                return LocalDate.now().toString(); // YYYY-MM-DD
            case "month":
                return YearMonth.now().toString(); // YYYY-MM
            case "quarter":
                int quarter = (LocalDate.now().getMonthValue() - 1) / 3 + 1;
                return Year.now().getValue() + "-" + quarter; // YYYY-Q
            case "year":
            default:
                return String.valueOf(Year.now().getValue()); // YYYY
        }
    }

    // Kiểm tra định dạng dateValue
    private void validateDateValue(String period, String dateValue) {
        if (period.equalsIgnoreCase("day") || period.equalsIgnoreCase("week")) {
            if (!dateValue.matches("\\d{4}-\\d{2}-\\d{2}")) {
                throw new IllegalArgumentException("Invalid date format for day/week. Use YYYY-MM-DD.");
            }
        } else if (period.equalsIgnoreCase("month")) {
            if (!dateValue.matches("\\d{4}-\\d{2}")) {
                throw new IllegalArgumentException("Invalid month format. Use YYYY-MM.");
            }
        } else if (period.equalsIgnoreCase("quarter")) {
            if (!dateValue.matches("\\d{4}-[1-4]")) {
                throw new IllegalArgumentException("Invalid quarter format. Use YYYY-Q (e.g., 2025-1).");
            }
        } else if (period.equalsIgnoreCase("year")) {
            if (!dateValue.matches("\\d{4}")) {
                throw new IllegalArgumentException("Invalid year format. Use YYYY.");
            }
        }
    }
}
