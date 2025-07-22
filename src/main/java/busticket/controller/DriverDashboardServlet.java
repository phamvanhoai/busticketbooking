/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.controller;

import busticket.DAO.DriverDashboardDAO;
import busticket.model.DriverAssignedTrip;
import busticket.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Calendar;
import org.json.JSONObject;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class DriverDashboardServlet extends HttpServlet {

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
        // Check if user is a driver
        if (!SessionUtil.isDriver(request)) {
            response.sendRedirect(request.getContextPath());
            return;
        }

        // Get user_id from session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = ((busticket.model.Users) session.getAttribute("currentUser")).getUser_id();
        DriverDashboardDAO dao = new DriverDashboardDAO();

        // Get timeFrame and timeValue from request
        String timeFrame = request.getParameter("timeFrame");
        String timeValue = request.getParameter("timeValue");
        String customTimeFrame = request.getParameter("customTimeFrame");
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat monthFormat = new SimpleDateFormat("yyyy-MM");

        // Set default timeFrame and timeValue if not provided
        if (timeFrame == null || timeFrame.isEmpty()) {
            timeFrame = "today";
            timeValue = dateFormat.format(new Date());
        }

        // Set displayTimeValue for chart titles
        String displayTimeValue;

        // Set timeValue for predefined time frames
        try {
            switch (timeFrame) {
                case "all":
                    timeValue = "";
                    displayTimeValue = "All Time";
                    break;
                case "today":
                    timeValue = dateFormat.format(new Date());
                    displayTimeValue = timeValue;
                    break;
                case "last7days":
                    cal.add(Calendar.DAY_OF_YEAR, -6);
                    timeValue = dateFormat.format(cal.getTime());
                    displayTimeValue = "Last 7 Days";
                    break;
                case "thismonth":
                    timeValue = monthFormat.format(new Date());
                    displayTimeValue = timeValue;
                    break;
                case "thisquarter":
                    int quarter = (cal.get(Calendar.MONTH) / 3) + 1;
                    timeValue = cal.get(Calendar.YEAR) + "-" + quarter;
                    displayTimeValue = "Q" + quarter + " " + cal.get(Calendar.YEAR);
                    break;
                case "thisyear":
                    timeValue = String.valueOf(cal.get(Calendar.YEAR));
                    displayTimeValue = timeValue;
                    break;
                case "custom":
                    if (customTimeFrame == null || customTimeFrame.isEmpty()) {
                        customTimeFrame = "day";
                        timeValue = dateFormat.format(new Date());
                    }
                    switch (customTimeFrame) {
                        case "day":
                            if (timeValue == null || !timeValue.matches("\\d{4}-\\d{2}-\\d{2}")) {
                                timeValue = dateFormat.format(new Date());
                            }
                            displayTimeValue = timeValue;
                            timeFrame = "day";
                            break;
                        case "month":
                            if (timeValue == null || !timeValue.matches("\\d{4}-\\d{2}")) {
                                timeValue = monthFormat.format(new Date());
                            }
                            displayTimeValue = timeValue;
                            timeFrame = "month";
                            break;
                        case "quarter":
                            if (timeValue == null || !timeValue.matches("\\d{4}-[1-4]")) {
                                int q = (cal.get(Calendar.MONTH) / 3) + 1;
                                timeValue = cal.get(Calendar.YEAR) + "-" + q;
                            }
                            String[] quarterParts = timeValue.split("-");
                            displayTimeValue = "Q" + quarterParts[1] + " " + quarterParts[0];
                            timeFrame = "quarter";
                            break;
                        case "year":
                            if (timeValue == null || !timeValue.matches("\\d{4}")) {
                                timeValue = String.valueOf(cal.get(Calendar.YEAR));
                            }
                            displayTimeValue = timeValue;
                            timeFrame = "year";
                            break;
                        default:
                            customTimeFrame = "day";
                            timeValue = dateFormat.format(new Date());
                            displayTimeValue = timeValue;
                            timeFrame = "day";
                    }
                    break;
                default:
                    timeFrame = "today";
                    timeValue = dateFormat.format(new Date());
                    displayTimeValue = timeValue;
            }
        } catch (Exception e) {
            System.err.println("Invalid timeValue format: " + timeValue);
            timeFrame = "today";
            timeValue = dateFormat.format(new Date());
            displayTimeValue = timeValue;
        }

        // Get timeValueForYear for year dropdown
        String timeValueForYear = timeValue;
        if (timeFrame.equals("day") || timeFrame.equals("week")) {
            timeValueForYear = timeValue.split("-")[0];
        } else if (timeFrame.equals("month") || timeFrame.equals("quarter")) {
            timeValueForYear = timeValue.split("-")[0];
        }

        // Fetch statistics
        String driverName = dao.getDriverName(userId);
        DriverAssignedTrip upcomingTrip = dao.getUpcomingTrip(userId);
        int completedTrips = dao.countCompletedTrips(userId, timeFrame, timeValue);
        int totalTrips = dao.countTotalTrips(userId, timeFrame, timeValue);
        int pendingChangeRequests = dao.countPendingChangeRequests(userId, timeFrame, timeValue);
        int checkedInPassengers = dao.countCheckedInPassengers(userId, timeFrame, timeValue);
        int ongoingTrips = dao.countOngoingTrips(userId, timeFrame, timeValue);
        int cancelledTrips = dao.countCancelledTrips(userId, timeFrame, timeValue);
        int totalTicketsSold = dao.countTotalTicketsSold(userId, timeFrame, timeValue);
        double approvedChangeRequestRate = dao.getApprovedChangeRequestRate(userId, timeFrame, timeValue);
        List<Integer> checkedInPassengersByTimeFrame = dao.getCheckedInPassengersByTimeFrame(userId, timeFrame, timeValue);

        // Calculate completion rate
        double completionRate = totalTrips > 0 ? (double) completedTrips / totalTrips * 100 : 0;

        // Generate time labels for charts
        List<String> timeLabels = new ArrayList<>();
        switch (timeFrame) {
            case "all":
                // Assuming data from 2020 to current year
                int startYear = 2020;
                int currentYear = cal.get(Calendar.YEAR);
                for (int i = startYear; i <= currentYear; i++) {
                    timeLabels.add(String.valueOf(i));
                }
                break;
            case "today":
            case "day":
                timeLabels.add(timeValue);
                break;
            case "last7days":
            case "week":
                cal.setTime(java.sql.Date.valueOf(timeValue));
                for (int i = 0; i < 7; i++) {
                    timeLabels.add(dateFormat.format(cal.getTime()));
                    cal.add(Calendar.DAY_OF_YEAR, 1);
                }
                break;
            case "thismonth":
            case "month":
                String[] monthParts = timeValue.split("-");
                int year = Integer.parseInt(monthParts[0]);
                int month = Integer.parseInt(monthParts[1]) - 1;
                cal.set(year, month, 1);
                for (int i = 0; i < 4; i++) {
                    timeLabels.add("Week " + (i + 1));
                    cal.add(Calendar.WEEK_OF_MONTH, 1);
                }
                break;
            case "thisquarter":
            case "quarter":
                String[] quarterParts = timeValue.split("-");
                int qYear = Integer.parseInt(quarterParts[0]);
                int quarter = Integer.parseInt(quarterParts[1]);
                for (int i = 0; i < 3; i++) {
                    int monthInQuarter = (quarter - 1) * 3 + i;
                    timeLabels.add(new SimpleDateFormat("MMM yyyy").format(new Date(qYear - 1900, monthInQuarter, 1)));
                }
                break;
            case "thisyear":
            case "year":
                for (int i = 0; i < 12; i++) {
                    timeLabels.add(new SimpleDateFormat("MMM").format(new Date(Integer.parseInt(timeValue) - 1900, i, 1)));
                }
                break;
            default:
                long currentTime = System.currentTimeMillis();
                for (int i = 6; i >= 0; i--) {
                    timeLabels.add(dateFormat.format(new Date(currentTime - i * 24 * 60 * 60 * 1000L)));
                }
        }

        // Set request attributes
        request.setAttribute("driverName", driverName != null ? driverName : "Unknown Driver");
        request.setAttribute("upcomingTrip", upcomingTrip);
        request.setAttribute("completedTrips", completedTrips);
        request.setAttribute("totalTrips", totalTrips);
        request.setAttribute("pendingChangeRequests", pendingChangeRequests);
        request.setAttribute("checkedInPassengers", checkedInPassengers);
        request.setAttribute("ongoingTrips", ongoingTrips);
        request.setAttribute("cancelledTrips", cancelledTrips);
        request.setAttribute("totalTicketsSold", totalTicketsSold);
        request.setAttribute("approvedChangeRequestRate", String.format("%.1f", approvedChangeRequestRate));
        request.setAttribute("checkedInPassengersByTimeFrame", checkedInPassengersByTimeFrame);
        request.setAttribute("timeLabels", timeLabels);
        request.setAttribute("timeFrame", timeFrame);
        request.setAttribute("timeValue", timeValue);
        request.setAttribute("timeValueForYear", timeValueForYear);
        request.setAttribute("customTimeFrame", customTimeFrame);
        request.setAttribute("displayTimeValue", displayTimeValue);

        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/driver/driver-dashboard.jsp").forward(request, response);
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
        String timeFrame = request.getParameter("timeFrame");
        String timeValue = request.getParameter("timeValue");
        String customTimeFrame = request.getParameter("customTimeFrame");
        String redirectUrl = request.getContextPath() + "/driver/dashboard";
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
