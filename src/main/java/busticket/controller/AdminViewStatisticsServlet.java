/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.AdminViewStatisticsDAO;
import busticket.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

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
        // Check if user is an admin
        if (!SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath());
            return;
        }

        // Get user_id from session
        HttpSession session = request.getSession(false);

        AdminViewStatisticsDAO dao = new AdminViewStatisticsDAO();

        // Get timeFrame, customTimeFrame, and timeValue from request
        String timeFrame = request.getParameter("timeFrame");
        String customTimeFrame = request.getParameter("customTimeFrame");
        String timeValue = request.getParameter("timeValue");
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat monthFormat = new SimpleDateFormat("yyyy-MM");

        // Set default timeFrame if not provided
        if (timeFrame == null || timeFrame.isEmpty()) {
            timeFrame = "today";
        }

        // Initialize DAO parameters
        String daoTimeFrame = timeFrame;
        String daoTimeValue = timeValue;
        String displayTimeValue;

        // Set timeValue and displayTimeValue for predefined and custom time frames
        try {
            if (timeFrame.equals("custom") && customTimeFrame != null && timeValue != null) {
                switch (customTimeFrame) {
                    case "day":
                        if (!timeValue.matches("\\d{4}-\\d{2}-\\d{2}")) {
                            timeValue = dateFormat.format(new Date());
                        }
                        daoTimeFrame = "day";
                        daoTimeValue = timeValue;
                        displayTimeValue = timeValue;
                        break;
                    case "month":
                        if (!timeValue.matches("\\d{4}-\\d{2}")) {
                            timeValue = monthFormat.format(new Date());
                        }
                        daoTimeFrame = "month";
                        daoTimeValue = timeValue;
                        displayTimeValue = timeValue;
                        break;
                    case "quarter":
                        if (!timeValue.matches("\\d{4}-[1-4]")) {
                            int q = (cal.get(Calendar.MONTH) / 3) + 1;
                            timeValue = cal.get(Calendar.YEAR) + "-" + q;
                        }
                        daoTimeFrame = "quarter";
                        daoTimeValue = timeValue;
                        String[] quarterParts = timeValue.split("-");
                        displayTimeValue = "Q" + quarterParts[1] + " " + quarterParts[0];
                        break;
                    case "year":
                        if (!timeValue.matches("\\d{4}")) {
                            timeValue = String.valueOf(cal.get(Calendar.YEAR));
                        }
                        daoTimeFrame = "year";
                        daoTimeValue = timeValue;
                        displayTimeValue = timeValue;
                        break;
                    default:
                        daoTimeFrame = "day";
                        daoTimeValue = dateFormat.format(new Date());
                        displayTimeValue = daoTimeValue;
                }
            } else {
                switch (timeFrame) {
                    case "all":
                        daoTimeFrame = "all";
                        daoTimeValue = null;
                        displayTimeValue = "All Time";
                        break;
                    case "today":
                        daoTimeFrame = "day";
                        daoTimeValue = dateFormat.format(new Date());
                        displayTimeValue = daoTimeValue;
                        break;
                    case "last7days":
                        daoTimeFrame = "last7days";
                        daoTimeValue = null;
                        displayTimeValue = "Last 7 Days";
                        break;
                    case "thismonth":
                        daoTimeFrame = "month";
                        daoTimeValue = monthFormat.format(new Date());
                        displayTimeValue = daoTimeValue;
                        break;
                    case "thisquarter":
                        daoTimeFrame = "quarter";
                        int quarter = (cal.get(Calendar.MONTH) / 3) + 1;
                        daoTimeValue = cal.get(Calendar.YEAR) + "-" + quarter;
                        displayTimeValue = "Q" + quarter + " " + cal.get(Calendar.YEAR);
                        break;
                    case "thisyear":
                        daoTimeFrame = "year";
                        daoTimeValue = String.valueOf(cal.get(Calendar.YEAR));
                        displayTimeValue = daoTimeValue;
                        break;
                    default:
                        daoTimeFrame = "day";
                        daoTimeValue = dateFormat.format(new Date());
                        displayTimeValue = daoTimeValue;
                }
            }
        } catch (Exception e) {
            System.err.println("Invalid timeValue format: " + timeValue);
            daoTimeFrame = "day";
            daoTimeValue = dateFormat.format(new Date());
            displayTimeValue = daoTimeValue;
        }

        // Get timeValueForYear for year dropdown
        String timeValueForYear = daoTimeValue;
        if (daoTimeFrame.equals("day") || daoTimeFrame.equals("month") || daoTimeFrame.equals("quarter")) {
            timeValueForYear = daoTimeValue != null ? daoTimeValue.split("-")[0] : String.valueOf(cal.get(Calendar.YEAR));
        }

        // Fetch statistics
        int totalTrips = dao.countTotalTrips(daoTimeFrame, daoTimeValue);
        int completedTrips = dao.countCompletedTrips(daoTimeFrame, daoTimeValue);
        int ongoingTrips = dao.countOngoingTrips(daoTimeFrame, daoTimeValue);
        int cancelledTrips = dao.countCancelledTrips(daoTimeFrame, daoTimeValue);
        int totalTicketsSold = dao.countTotalTicketsSold(daoTimeFrame, daoTimeValue);
        int checkedInPassengers = dao.countCheckedInPassengers(daoTimeFrame, daoTimeValue);
        double totalRevenue = dao.getTotalRevenue(daoTimeFrame, daoTimeValue);
        List<Integer> ticketsSoldByTimeFrame = dao.getTicketsSoldByTimeFrame(daoTimeFrame, daoTimeValue);

        // Calculate completion rate
        double completionRate = totalTrips > 0 ? (double) completedTrips / totalTrips * 100 : 0;

        // Generate time labels for charts
        List<String> timeLabels = new ArrayList<>();
        switch (daoTimeFrame) {
            case "all":
                int startYear = 2020;
                int currentYear = cal.get(Calendar.YEAR);
                for (int i = startYear; i <= currentYear; i++) {
                    timeLabels.add(String.valueOf(i));
                }
                break;
            case "day":
                timeLabels.add(daoTimeValue);
                break;
            case "last7days":
                cal.setTime(new Date());
                cal.add(Calendar.DAY_OF_YEAR, -6);
                for (int i = 0; i < 7; i++) {
                    timeLabels.add(dateFormat.format(cal.getTime()));
                    cal.add(Calendar.DAY_OF_YEAR, 1);
                }
                break;
            case "month":
                String[] monthParts = daoTimeValue.split("-");
                int year = Integer.parseInt(monthParts[0]);
                int month = Integer.parseInt(monthParts[1]) - 1;
                cal.set(year, month, 1);
                int maxDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
                for (int i = 1; i <= maxDay; i += 7) {
                    timeLabels.add("Week " + ((i - 1) / 7 + 1));
                }
                break;
            case "quarter":
                String[] quarterParts = daoTimeValue.split("-");
                int qYear = Integer.parseInt(quarterParts[0]);
                int quarter = Integer.parseInt(quarterParts[1]);
                for (int i = 0; i < 3; i++) {
                    int monthInQuarter = (quarter - 1) * 3 + i;
                    timeLabels.add(new SimpleDateFormat("MMM yyyy").format(new Date(qYear - 1900, monthInQuarter, 1)));
                }
                break;
            case "year":
                for (int i = 0; i < 12; i++) {
                    timeLabels.add(new SimpleDateFormat("MMM").format(new Date(Integer.parseInt(daoTimeValue) - 1900, i, 1)));
                }
                break;
            default:
                long currentTime = System.currentTimeMillis();
                for (int i = 6; i >= 0; i--) {
                    timeLabels.add(dateFormat.format(new Date(currentTime - i * 24 * 60 * 60 * 1000L)));
                }
        }
        
        // Format totalRevenue for VND
        NumberFormat vndFormat = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
        vndFormat.setMinimumFractionDigits(0); // No decimal places for VND
        vndFormat.setMaximumFractionDigits(0);
        String formattedRevenue = vndFormat.format(totalRevenue);

        // Set request attributes
        request.setAttribute("totalTrips", totalTrips);
        request.setAttribute("completedTrips", completedTrips);
        request.setAttribute("ongoingTrips", ongoingTrips);
        request.setAttribute("cancelledTrips", cancelledTrips);
        request.setAttribute("totalTicketsSold", totalTicketsSold);
        request.setAttribute("checkedInPassengers", checkedInPassengers);
        request.setAttribute("totalRevenue", formattedRevenue);
        request.setAttribute("completionRate", String.format("%.1f", completionRate));
        request.setAttribute("ticketsSoldByTimeFrame", ticketsSoldByTimeFrame);
        request.setAttribute("timeLabels", timeLabels);
        request.setAttribute("timeFrame", timeFrame);
        request.setAttribute("timeValue", timeValue);
        request.setAttribute("timeValueForYear", timeValueForYear);
        request.setAttribute("customTimeFrame", customTimeFrame);
        request.setAttribute("displayTimeValue", displayTimeValue);

        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/admin/statistics/view-statistics.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String timeFrame = request.getParameter("timeFrame");
        String timeValue = request.getParameter("timeValue");
        String customTimeFrame = request.getParameter("customTimeFrame");
        String redirectUrl = request.getContextPath() + "/admin/statistics";
        if (timeFrame != null && !timeFrame.isEmpty()) {
            redirectUrl += "?timeFrame=" + timeFrame;
            if (timeValue != null && !timeValue.isEmpty()) {
                redirectUrl += "&timeValue=" + timeValue;
            }
            if (customTimeFrame != null && !customTimeFrame.isEmpty()) {
                redirectUrl += "&customTimeFrame=" + customTimeFrame;
            }
        }
        response.sendRedirect(redirectUrl);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for viewing admin statistics";
    }
}
