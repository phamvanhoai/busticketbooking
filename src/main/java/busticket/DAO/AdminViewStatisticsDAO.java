/*
 * AdminViewStatisticsDAO.java
 * DAO for retrieving admin statistics
 */
package busticket.DAO;

import busticket.db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * DAO for admin statistics Author: Pham Van Hoai - CE181744
 */
public class AdminViewStatisticsDAO extends DBContext {

    public int countTotalTrips(String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Trips", timeFrame, "departure_time");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            setTimeFrameParameters(ps, timeFrame, timeValue, 1);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countCompletedTrips(String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Trips WHERE trip_status = 'Completed'", timeFrame, "departure_time");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            setTimeFrameParameters(ps, timeFrame, timeValue, 1);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countOngoingTrips(String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Trips WHERE trip_status = 'Ongoing'", timeFrame, "departure_time");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            setTimeFrameParameters(ps, timeFrame, timeValue, 1);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countCancelledTrips(String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Trips WHERE trip_status = 'Cancelled'", timeFrame, "departure_time");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            setTimeFrameParameters(ps, timeFrame, timeValue, 1);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countTotalTicketsSold(String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Tickets WHERE check_in IS NOT NULL", timeFrame, "check_in");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            setTimeFrameParameters(ps, timeFrame, timeValue, 1);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countCheckedInPassengers(String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Tickets WHERE check_in IS NOT NULL", timeFrame, "check_in");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            setTimeFrameParameters(ps, timeFrame, timeValue, 1);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getTotalRevenue(String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery(
            "SELECT SUM(COALESCE(ii.invoice_amount, 0)) AS total_revenue " +
            "FROM Invoice_Items ii " +
            "JOIN Invoices inv ON ii.invoice_id = inv.invoice_id " +
            "JOIN Tickets t ON ii.ticket_id = t.ticket_id " +
            "JOIN Trips tr ON t.trip_id = tr.trip_id", 
            timeFrame, "inv.paid_at");
        System.out.println("getTotalRevenue Query: " + query + ", timeFrame: " + timeFrame + ", timeValue: " + timeValue);
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            setTimeFrameParameters(ps, timeFrame, timeValue, 1);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total_revenue");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public List<Integer> getTicketsSoldByTimeFrame(String timeFrame, String timeValue) {
        List<Integer> tickets = new ArrayList<>();
        String query;
        int periodCount;
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        String defaultTimeValue = dateFormat.format(new Date());

        switch (timeFrame) {
            case "all":
                periodCount = cal.get(Calendar.YEAR) - 2020 + 1;
                query = "SELECT YEAR(t.check_in) AS period, COUNT(*) AS ticket_count " +
                        "FROM Tickets t WHERE t.check_in IS NOT NULL " +
                        "GROUP BY YEAR(t.check_in) ORDER BY period ASC";
                break;
            case "day":
                periodCount = 1;
                query = "SELECT CAST(t.check_in AS DATE) AS period, COUNT(*) AS ticket_count " +
                        "FROM Tickets t WHERE t.check_in IS NOT NULL AND CAST(t.check_in AS DATE) = ? " +
                        "GROUP BY CAST(t.check_in AS DATE)";
                break;
            case "last7days":
                periodCount = 7;
                query = "SELECT CAST(t.check_in AS DATE) AS period, COUNT(*) AS ticket_count " +
                        "FROM Tickets t WHERE t.check_in IS NOT NULL AND t.check_in >= ? AND t.check_in < DATEADD(day, 7, ?) " +
                        "GROUP BY CAST(t.check_in AS DATE) ORDER BY period ASC";
                break;
            case "month":
                periodCount = 4;
                query = "SELECT DATEPART(week, t.check_in) AS period, COUNT(*) AS ticket_count " +
                        "FROM Tickets t WHERE t.check_in IS NOT NULL AND YEAR(t.check_in) = ? AND MONTH(t.check_in) = ? " +
                        "GROUP BY DATEPART(week, t.check_in) ORDER BY period ASC";
                break;
            case "quarter":
                periodCount = 3;
                query = "SELECT DATEPART(month, t.check_in) AS period, COUNT(*) AS ticket_count " +
                        "FROM Tickets t WHERE t.check_in IS NOT NULL AND YEAR(t.check_in) = ? AND DATEPART(quarter, t.check_in) = ? " +
                        "GROUP BY DATEPART(month, t.check_in) ORDER BY period ASC";
                break;
            case "year":
                periodCount = 12;
                query = "SELECT DATEPART(month, t.check_in) AS period, COUNT(*) AS ticket_count " +
                        "FROM Tickets t WHERE t.check_in IS NOT NULL AND YEAR(t.check_in) = ? " +
                        "GROUP BY DATEPART(month, t.check_in) ORDER BY period ASC";
                break;
            default:
                periodCount = 7;
                query = "SELECT CAST(t.check_in AS DATE) AS period, COUNT(*) AS ticket_count " +
                        "FROM Tickets t WHERE t.check_in IS NOT NULL AND t.check_in >= DATEADD(day, -6, GETDATE()) " +
                        "GROUP BY CAST(t.check_in AS DATE) ORDER BY period ASC";
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            if (!timeFrame.equals("all") && !timeFrame.equals("default")) {
                if (timeValue == null || timeValue.isEmpty()) {
                    timeValue = defaultTimeValue;
                }
                if (timeFrame.equals("last7days")) {
                    // Set start and end date for last7days
                    cal.setTime(new Date());
                    cal.add(Calendar.DAY_OF_YEAR, -6);
                    ps.setDate(1, new java.sql.Date(cal.getTimeInMillis()));
                    ps.setDate(2, new java.sql.Date(cal.getTimeInMillis()));
                } else {
                    setTimeFrameParameters(ps, timeFrame, timeValue, 1);
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                for (int i = 0; i < periodCount; i++) {
                    tickets.add(0);
                }
                while (rs.next()) {
                    int index;
                    if (timeFrame.equals("all")) {
                        int period = rs.getInt("period");
                        index = period - 2020;
                        if (index < 0 || index >= periodCount) continue;
                    } else if (timeFrame.equals("day")) {
                        index = 0;
                    } else if (timeFrame.equals("last7days")) {
                        Date periodDate = rs.getDate("period");
                        cal.setTime(new Date());
                        cal.add(Calendar.DAY_OF_YEAR, -6);
                        long daysDiff = (periodDate.getTime() - cal.getTimeInMillis()) / (1000 * 60 * 60 * 24);
                        index = (int) daysDiff;
                        if (index < 0 || index >= periodCount) continue;
                    } else if (timeFrame.equals("month")) {
                        int period = rs.getInt("period");
                        String[] parts = timeValue.split("-");
                        int year = Integer.parseInt(parts[0]);
                        int month = Integer.parseInt(parts[1]);
                        cal.set(year, month - 1, 1);
                        int firstWeekOfMonth = cal.get(Calendar.WEEK_OF_YEAR);
                        index = period - firstWeekOfMonth;
                        if (index < 0) index = 0;
                        if (index >= periodCount) index = periodCount - 1;
                    } else if (timeFrame.equals("quarter")) {
                        int period = rs.getInt("period");
                        String[] parts = timeValue.split("-");
                        int quarter = Integer.parseInt(parts[1]);
                        int quarterStartMonth = (quarter - 1) * 3 + 1;
                        index = period - quarterStartMonth;
                        if (index < 0) index = 0;
                        if (index >= periodCount) index = periodCount - 1;
                    } else if (timeFrame.equals("year")) {
                        int period = rs.getInt("period");
                        index = period - 1;
                        if (index < 0 || index >= periodCount) continue;
                    } else {
                        Date periodDate = rs.getDate("period");
                        Date startDate = new Date(System.currentTimeMillis() - 6 * 24 * 60 * 60 * 1000L);
                        long daysDiff = (periodDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24);
                        index = (int) daysDiff;
                        if (index < 0 || index >= periodCount) continue;
                    }
                    int ticketCount = rs.getInt("ticket_count");
                    tickets.set(index, ticketCount);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tickets;
    }

    private String buildTimeFrameQuery(String baseQuery, String timeFrame, String timeColumn) {
        String condition;
        switch (timeFrame) {
            case "all":
                return baseQuery; // No WHERE clause for 'all'
            case "day":
                condition = "CAST(" + timeColumn + " AS DATE) = ?";
                break;
            case "last7days":
                condition = timeColumn + " >= ? AND " + timeColumn + " < DATEADD(day, 7, ?)";
                break;
            case "month":
                condition = "YEAR(" + timeColumn + ") = ? AND MONTH(" + timeColumn + ") = ?";
                break;
            case "quarter":
                condition = "YEAR(" + timeColumn + ") = ? AND DATEPART(quarter, " + timeColumn + ") = ?";
                break;
            case "year":
                condition = "YEAR(" + timeColumn + ") = ?";
                break;
            default:
                condition = timeColumn + " >= DATEADD(day, -6, GETDATE()) AND " + timeColumn + " < GETDATE()";
        }
        // Append condition to base query, handling existing WHERE clauses
        if (baseQuery.toUpperCase().contains("WHERE")) {
            return baseQuery + " AND " + condition;
        } else {
            return baseQuery + " WHERE " + condition;
        }
    }

    private void setTimeFrameParameters(PreparedStatement ps, String timeFrame, String timeValue, int startIndex) throws SQLException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String defaultTimeValue = dateFormat.format(new Date());
        
        // Use defaultTimeValue if timeValue is null or empty, except for 'all'
        if (timeValue == null || timeValue.isEmpty()) {
            if (timeFrame.equals("all")) {
                return; // No parameters needed for 'all'
            }
            timeValue = defaultTimeValue;
        }

        try {
            switch (timeFrame) {
                case "day":
                    Date parsedDate = dateFormat.parse(timeValue);
                    ps.setDate(startIndex, new java.sql.Date(parsedDate.getTime()));
                    break;
                case "last7days":
                    Calendar cal = Calendar.getInstance();
                    cal.add(Calendar.DAY_OF_YEAR, -6);
                    ps.setDate(startIndex, new java.sql.Date(cal.getTimeInMillis()));
                    ps.setDate(startIndex + 1, new java.sql.Date(cal.getTimeInMillis()));
                    break;
                case "month":
                    String[] monthParts = timeValue.split("-");
                    ps.setInt(startIndex, Integer.parseInt(monthParts[0]));
                    ps.setInt(startIndex + 1, Integer.parseInt(monthParts[1]));
                    break;
                case "quarter":
                    String[] quarterParts = timeValue.split("-");
                    ps.setInt(startIndex, Integer.parseInt(quarterParts[0]));
                    ps.setInt(startIndex + 1, Integer.parseInt(quarterParts[1]));
                    break;
                case "year":
                    ps.setInt(startIndex, Integer.parseInt(timeValue));
                    break;
                case "all":
                    // No parameters to set
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error parsing timeValue: " + timeValue + " for timeFrame: " + timeFrame);
            e.printStackTrace();
        }
    }
}
