/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminViewStatisticsDAO;
import busticket.model.AdminStatistics;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.text.ParseException;
import java.sql.SQLException;

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
        AdminViewStatisticsDAO dao = new AdminViewStatisticsDAO();
        AdminStatistics statistics = new AdminStatistics();

        // Get parameters
        String period = request.getParameter("period");
        String customPeriod = request.getParameter("customPeriod");
        String dateValue = request.getParameter("dateValue");

        // Initialize date formats
        SimpleDateFormat displayDateFormat = new SimpleDateFormat("dd-MM-yyyy");
        SimpleDateFormat displayMonthFormat = new SimpleDateFormat("MM-yyyy");
        SimpleDateFormat daoDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat daoMonthFormat = new SimpleDateFormat("yyyy-MM");
        Calendar cal = Calendar.getInstance();

        // Set default period if invalid or empty
        if (period == null || period.isEmpty() || !isValidPeriod(period)) {
            period = "year";
            dateValue = String.valueOf(cal.get(Calendar.YEAR)); // e.g., "2025"
        } else if (dateValue == null || dateValue.isEmpty()) {
            dateValue = getDefaultDateValue(period);
        }

        // Initialize DAO parameters
        String daoPeriod = period;
        String daoDateValue = dateValue;
        String displayDateValue;

        // Handle custom period
        if (period.equals("custom") && customPeriod != null) {
            try {
                if (customPeriod.equals("day") && dateValue.matches("\\d{4}-\\d{2}-\\d{2}")) {
                    Date date = daoDateFormat.parse(dateValue);
                    daoDateValue = daoDateFormat.format(date); // yyyy-MM-dd
                    displayDateValue = displayDateFormat.format(date); // dd-MM-yyyy
                } else if (customPeriod.equals("month") && dateValue.matches("\\d{4}-\\d{2}")) {
                    Date date = daoMonthFormat.parse(dateValue);
                    daoDateValue = daoMonthFormat.format(date); // yyyy-MM
                    displayDateValue = displayMonthFormat.format(date); // MM-yyyy
                } else if (customPeriod.equals("quarter") && dateValue.matches("\\d{4}-[1-4]")) {
                    daoDateValue = dateValue; // yyyy-q
                    String[] parts = dateValue.split("-");
                    displayDateValue = "Q" + parts[1] + " " + parts[0]; // Q1 2025
                } else if (customPeriod.equals("year") && dateValue.matches("\\d{4}")) {
                    daoDateValue = dateValue; // yyyy
                    displayDateValue = dateValue; // yyyy
                } else {
                    throw new IllegalArgumentException("Invalid dateValue format for custom period: " + dateValue);
                }
            } catch (ParseException e) {
                System.err.println("Invalid dateValue format: " + dateValue);
                daoPeriod = "year";
                daoDateValue = String.valueOf(cal.get(Calendar.YEAR));
                displayDateValue = daoDateValue;
            }
        } else {
            // Handle non-custom periods
            try {
                switch (period.toLowerCase()) {
                    case "day":
                        Date date = daoDateFormat.parse(dateValue);
                        daoDateValue = daoDateFormat.format(date); // yyyy-MM-dd
                        displayDateValue = displayDateFormat.format(date); // dd-MM-yyyy
                        break;
                    case "week":
                        date = daoDateFormat.parse(dateValue);
                        daoDateValue = daoDateFormat.format(date); // yyyy-MM-dd
                        displayDateValue = displayDateFormat.format(date); // dd-MM-yyyy
                        break;
                    case "month":
                        date = daoMonthFormat.parse(dateValue);
                        daoDateValue = daoMonthFormat.format(date); // yyyy-MM
                        displayDateValue = displayMonthFormat.format(date); // MM-yyyy
                        break;
                    case "quarter":
                        if (!dateValue.matches("\\d{4}-[1-4]")) {
                            throw new IllegalArgumentException("Invalid quarter format: " + dateValue);
                        }
                        daoDateValue = dateValue; // yyyy-q
                        String[] parts = dateValue.split("-");
                        displayDateValue = "Q" + parts[1] + " " + parts[0]; // Q1 2025
                        break;
                    case "year":
                        daoDateValue = dateValue; // yyyy
                        displayDateValue = dateValue; // yyyy
                        break;
                    default:
                        daoPeriod = "year";
                        daoDateValue = String.valueOf(cal.get(Calendar.YEAR));
                        displayDateValue = daoDateValue;
                }
            } catch (ParseException e) {
                System.err.println("Invalid dateValue format: " + dateValue);
                daoPeriod = "year";
                daoDateValue = String.valueOf(cal.get(Calendar.YEAR));
                displayDateValue = daoDateValue;
            }
        }

        // Generate time labels for charts
        List<String> timeLabels = new ArrayList<>();
        switch (daoPeriod.toLowerCase()) {
            case "day":
                timeLabels.add(displayDateValue); // e.g., 23-07-2025
                break;
            case "week":
                try {
                Date startDate = daoDateFormat.parse(daoDateValue);
                cal.setTime(startDate);
                cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY); // Start of week
                for (int i = 0; i < 7; i++) {
                    timeLabels.add(displayDateFormat.format(cal.getTime()));
                    cal.add(Calendar.DAY_OF_YEAR, 1);
                }
            } catch (ParseException e) {
                timeLabels.add(displayDateFormat.format(new Date()));
            }
            break;
            case "month":
                String[] monthParts = daoDateValue.split("-");
                int year = Integer.parseInt(monthParts[0]);
                int month = Integer.parseInt(monthParts[1]) - 1;
                cal.set(year, month, 1);
                int maxDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
                for (int i = 1; i <= maxDay; i += 7) {
                    timeLabels.add("Week " + ((i - 1) / 7 + 1));
                }
                break;
            case "quarter":
                String[] quarterParts = daoDateValue.split("-");
                int qYear = Integer.parseInt(quarterParts[0]);
                int quarter = Integer.parseInt(quarterParts[1]);
                for (int i = 0; i < 3; i++) {
                    int monthInQuarter = (quarter - 1) * 3 + i;
                    timeLabels.add(new SimpleDateFormat("MMM yyyy").format(new Date(qYear - 1900, monthInQuarter, 1)));
                }
                break;
            case "year":
                for (int i = 0; i < 12; i++) {
                    timeLabels.add(new SimpleDateFormat("MMM").format(new Date(Integer.parseInt(daoDateValue) - 1900, i, 1)));
                }
                break;
        }

        try {
            // Fetch statistics
            statistics.setRevenue(dao.getRevenueByPeriod(daoPeriod, daoDateValue));
            statistics.setOccupancyRate(dao.getOccupancyRateByPeriod(daoPeriod, daoDateValue));
            statistics.setTicketTypeBreakdown(dao.getTicketTypeBreakdownByPeriod(daoPeriod, daoDateValue));
            statistics.setTopRoutesRevenue(dao.getTopRoutesRevenueByPeriod(daoPeriod, daoDateValue));
            statistics.setDriverPerformance(dao.getDriverPerformanceByPeriod(daoPeriod, daoDateValue));
            statistics.setDetailedStatistics(dao.getDetailedStatisticsByPeriod(daoPeriod, daoDateValue));
            statistics.setPeriod(daoPeriod);
            statistics.setDateValue(daoDateValue);

            // Set request attributes
            request.setAttribute("statistics", statistics);
            request.setAttribute("displayDateValue", displayDateValue);
            request.setAttribute("customPeriod", customPeriod);
            request.setAttribute("timeLabels", timeLabels);

            // Debug logging
            System.out.println("DEBUG: doGet period=" + daoPeriod + ", dateValue=" + daoDateValue + ", displayDateValue=" + displayDateValue);

            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/admin/statistics/view-statistics.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching statistics: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String period = request.getParameter("period");
        String customPeriod = request.getParameter("customPeriod");
        String dateValue = request.getParameter("dateValue");

        // Set default period if invalid
        if (period == null || period.isEmpty() || !isValidPeriod(period)) {
            period = "year";
            dateValue = String.valueOf(Calendar.getInstance().get(Calendar.YEAR));
        } else if (dateValue == null || dateValue.isEmpty()) {
            dateValue = getDefaultDateValue(period);
        }

        // Debug logging
        System.out.println("DEBUG: doPost period=" + period + ", customPeriod=" + customPeriod + ", dateValue=" + dateValue);

        // Redirect with parameters
        String redirectUrl = request.getContextPath() + "/admin/statistics?period=" + period;
        if (dateValue != null && !dateValue.isEmpty()) {
            redirectUrl += "&dateValue=" + dateValue;
        }
        if (customPeriod != null && !customPeriod.isEmpty()) {
            redirectUrl += "&customPeriod=" + customPeriod;
        }
        response.sendRedirect(redirectUrl);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for viewing admin statistics";
    }

    private boolean isValidPeriod(String period) {
        return period != null && (
            period.equalsIgnoreCase("day") ||
            period.equalsIgnoreCase("week") ||
            period.equalsIgnoreCase("month") ||
            period.equalsIgnoreCase("quarter") ||
            period.equalsIgnoreCase("year") ||
            period.equalsIgnoreCase("custom")
        );
    }

    private String getDefaultDateValue(String period) {
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat daoDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat daoMonthFormat = new SimpleDateFormat("yyyy-MM");
        switch (period.toLowerCase()) {
            case "day":
            case "week":
                return daoDateFormat.format(new Date()); // yyyy-MM-dd
            case "month":
                return daoMonthFormat.format(new Date()); // yyyy-MM
            case "quarter":
                int quarter = (cal.get(Calendar.MONTH) / 3) + 1;
                return cal.get(Calendar.YEAR) + "-" + quarter; // yyyy-q
            case "year":
            case "custom":
            default:
                return String.valueOf(cal.get(Calendar.YEAR)); // yyyy
        }
    }
}
