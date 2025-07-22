/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.DriverAssignedTrip;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class DriverDashboardDAO extends DBContext {

    public String getDriverName(int userId) {
        String query = "SELECT user_name FROM Users WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("user_name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public DriverAssignedTrip getUpcomingTrip(int userId) {
        String query = "SELECT t.trip_id, CONCAT(ls.location_name, N' → ', le.location_name) AS route, " +
                      "t.departure_time, CONVERT(varchar(5), t.departure_time, 108) AS trip_time " +
                      "FROM Trips t " +
                      "JOIN Routes r ON t.route_id = r.route_id " +
                      "JOIN Locations ls ON r.start_location_id = ls.location_id " +
                      "JOIN Locations le ON r.end_location_id = le.location_id " +
                      "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                      "JOIN Drivers d ON td.driver_id = d.driver_id " +
                      "WHERE d.user_id = ? AND t.trip_status = 'Scheduled' AND t.departure_time > GETDATE() " +
                      "ORDER BY t.departure_time ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DriverAssignedTrip trip = new DriverAssignedTrip();
                    trip.setTripId(rs.getInt("trip_id"));
                    trip.setRoute(rs.getString("route"));
                    trip.setDepartureTime(rs.getTimestamp("departure_time"));
                    trip.setTime(rs.getString("trip_time"));
                    return trip;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int countCompletedTrips(int userId, String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Trips t " +
                                          "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                                          "JOIN Drivers d ON td.driver_id = d.driver_id " +
                                          "WHERE d.user_id = ? AND t.trip_status = 'Completed'", timeFrame, "t.departure_time");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            setTimeFrameParameters(ps, timeFrame, timeValue, 2);
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

    public int countPendingChangeRequests(int userId, String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Driver_Trip_Change_Request r " +
                                          "JOIN Drivers d ON r.driver_id = d.driver_id " +
                                          "WHERE d.user_id = ? AND r.request_status = 'Pending'", timeFrame, "r.request_time");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            setTimeFrameParameters(ps, timeFrame, timeValue, 2);
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

    public int countTotalTrips(int userId, String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Trips t " +
                                          "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                                          "JOIN Drivers d ON td.driver_id = d.driver_id " +
                                          "WHERE d.user_id = ?", timeFrame, "t.departure_time");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            setTimeFrameParameters(ps, timeFrame, timeValue, 2);
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

    public int countCheckedInPassengers(int userId, String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Tickets t " +
                                          "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                                          "JOIN Drivers d ON td.driver_id = d.driver_id " +
                                          "WHERE d.user_id = ? AND t.check_in IS NOT NULL", timeFrame, "t.check_in");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            setTimeFrameParameters(ps, timeFrame, timeValue, 2);
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

    public int countOngoingTrips(int userId, String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Trips t " +
                                          "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                                          "JOIN Drivers d ON td.driver_id = d.driver_id " +
                                          "WHERE d.user_id = ? AND t.trip_status = 'Ongoing'", timeFrame, "t.departure_time");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            setTimeFrameParameters(ps, timeFrame, timeValue, 2);
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

    public int countCancelledTrips(int userId, String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Trips t " +
                                          "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                                          "JOIN Drivers d ON td.driver_id = d.driver_id " +
                                          "WHERE d.user_id = ? AND t.trip_status = 'Cancelled'", timeFrame, "t.departure_time");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            setTimeFrameParameters(ps, timeFrame, timeValue, 2);
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

    public int countTotalTicketsSold(int userId, String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Tickets t " +
                                          "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                                          "JOIN Drivers d ON td.driver_id = d.driver_id " +
                                          "WHERE d.user_id = ?", timeFrame, "t.purchase_date");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            setTimeFrameParameters(ps, timeFrame, timeValue, 2);
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

    public double getApprovedChangeRequestRate(int userId, String timeFrame, String timeValue) {
        String query = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Driver_Trip_Change_Request r " +
                                          "JOIN Drivers d ON r.driver_id = d.driver_id " +
                                          "WHERE d.user_id = ? AND r.request_status = 'Approved'", timeFrame, "r.request_time");
        String totalQuery = buildTimeFrameQuery("SELECT COUNT(*) AS count FROM Driver_Trip_Change_Request r " +
                                               "JOIN Drivers d ON r.driver_id = d.driver_id " +
                                               "WHERE d.user_id = ?", timeFrame, "r.request_time");
        try (Connection conn = getConnection();
             PreparedStatement psApproved = conn.prepareStatement(query);
             PreparedStatement psTotal = conn.prepareStatement(totalQuery)) {
            psApproved.setInt(1, userId);
            psTotal.setInt(1, userId);
            setTimeFrameParameters(psApproved, timeFrame, timeValue, 2);
            setTimeFrameParameters(psTotal, timeFrame, timeValue, 2);
            int approvedCount = 0, totalCount = 0;
            try (ResultSet rsApproved = psApproved.executeQuery()) {
                if (rsApproved.next()) {
                    approvedCount = rsApproved.getInt("count");
                }
            }
            try (ResultSet rsTotal = psTotal.executeQuery()) {
                if (rsTotal.next()) {
                    totalCount = rsTotal.getInt("count");
                }
            }
            return totalCount > 0 ? (double) approvedCount / totalCount * 100 : 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Integer> getCheckedInPassengersByTimeFrame(int userId, String timeFrame, String timeValue) {
        List<Integer> passengers = new ArrayList<>();
        String query;
        int periodCount;

        switch (timeFrame) {
            case "all":
                periodCount = Calendar.getInstance().get(Calendar.YEAR) - 2020 + 1;
                query = "SELECT YEAR(t.check_in) AS period, COUNT(*) AS passenger_count " +
                        "FROM Tickets t " +
                        "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                        "JOIN Drivers d ON td.driver_id = d.driver_id " +
                        "WHERE d.user_id = ? AND t.check_in IS NOT NULL " +
                        "GROUP BY YEAR(t.check_in) " +
                        "ORDER BY period ASC";
                break;
            case "day":
                periodCount = 1;
                query = "SELECT CAST(t.check_in AS DATE) AS period, COUNT(*) AS passenger_count " +
                        "FROM Tickets t " +
                        "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                        "JOIN Drivers d ON td.driver_id = d.driver_id " +
                        "WHERE d.user_id = ? AND t.check_in IS NOT NULL " +
                        "AND CAST(t.check_in AS DATE) = ? " +
                        "GROUP BY CAST(t.check_in AS DATE)";
                break;
            case "week":
                periodCount = 7;
                query = "SELECT CAST(t.check_in AS DATE) AS period, COUNT(*) AS passenger_count " +
                        "FROM Tickets t " +
                        "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                        "JOIN Drivers d ON td.driver_id = d.driver_id " +
                        "WHERE d.user_id = ? AND t.check_in IS NOT NULL " +
                        "AND t.check_in >= ? AND t.check_in < DATEADD(day, 7, ?) " +
                        "GROUP BY CAST(t.check_in AS DATE) " +
                        "ORDER BY period ASC";
                break;
            case "month":
                periodCount = 4;
                query = "SELECT DATEPART(week, t.check_in) AS period, COUNT(*) AS passenger_count " +
                        "FROM Tickets t " +
                        "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                        "JOIN Drivers d ON td.driver_id = d.driver_id " +
                        "WHERE d.user_id = ? AND t.check_in IS NOT NULL " +
                        "AND YEAR(t.check_in) = ? AND MONTH(t.check_in) = ? " +
                        "GROUP BY DATEPART(week, t.check_in) " +
                        "ORDER BY period ASC";
                break;
            case "quarter":
                periodCount = 3;
                query = "SELECT DATEPART(month, t.check_in) AS period, COUNT(*) AS passenger_count " +
                        "FROM Tickets t " +
                        "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                        "JOIN Drivers d ON td.driver_id = d.driver_id " +
                        "WHERE d.user_id = ? AND t.check_in IS NOT NULL " +
                        "AND YEAR(t.check_in) = ? AND DATEPART(quarter, t.check_in) = ? " +
                        "GROUP BY DATEPART(month, t.check_in) " +
                        "ORDER BY period ASC";
                break;
            case "year":
                periodCount = 12;
                query = "SELECT DATEPART(month, t.check_in) AS period, COUNT(*) AS passenger_count " +
                        "FROM Tickets t " +
                        "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                        "JOIN Drivers d ON td.driver_id = d.driver_id " +
                        "WHERE d.user_id = ? AND t.check_in IS NOT NULL " +
                        "AND YEAR(t.check_in) = ? " +
                        "GROUP BY DATEPART(month, t.check_in) " +
                        "ORDER BY period ASC";
                break;
            default:
                periodCount = 7;
                query = "SELECT CAST(t.check_in AS DATE) AS period, COUNT(*) AS passenger_count " +
                        "FROM Tickets t " +
                        "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                        "JOIN Drivers d ON td.driver_id = d.driver_id " +
                        "WHERE d.user_id = ? AND t.check_in IS NOT NULL " +
                        "AND t.check_in >= DATEADD(day, -6, GETDATE()) " +
                        "GROUP BY CAST(t.check_in AS DATE) " +
                        "ORDER BY period ASC";
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            if (!timeFrame.equals("all")) {
                setTimeFrameParameters(ps, timeFrame, timeValue, 2);
            }
            try (ResultSet rs = ps.executeQuery()) {
                for (int i = 0; i < periodCount; i++) {
                    passengers.add(0);
                }
                while (rs.next()) {
                    int period = rs.getInt("period");
                    int passengerCount = rs.getInt("passenger_count");
                    int index;
                    if (timeFrame.equals("all")) {
                        index = period - 2020;
                        if (index < 0 || index >= periodCount) continue;
                    } else if (timeFrame.equals("day")) {
                        index = 0;
                    } else if (timeFrame.equals("week")) {
                        long daysDiff = (rs.getDate("period").getTime() - java.sql.Date.valueOf(timeValue).getTime()) / (1000 * 60 * 60 * 24);
                        index = (int) daysDiff;
                        if (index < 0 || index >= periodCount) continue;
                    } else if (timeFrame.equals("month")) {
                        int firstWeek = java.util.Calendar.getInstance().get(java.util.Calendar.WEEK_OF_YEAR);
                        index = periodCount - 1 - (firstWeek - period);
                        if (index < 0 || index >= periodCount) continue;
                    } else if (timeFrame.equals("quarter")) {
                        String[] parts = timeValue.split("-");
                        int quarterStartMonth = (Integer.parseInt(parts[1]) - 1) * 3 + 1;
                        index = period - quarterStartMonth;
                        if (index < 0 || index >= periodCount) continue;
                    } else {
                        index = period - 1;
                        if (index < 0 || index >= periodCount) continue;
                    }
                    passengers.set(index, passengerCount);
                }
                System.out.println("Checked-In Passengers for userId " + userId + " by " + timeFrame + " (" + timeValue + "): " + passengers);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return passengers;
    }

    private String buildTimeFrameQuery(String baseQuery, String timeFrame, String timeColumn) {
        switch (timeFrame) {
            case "all":
                return baseQuery;
            case "day":
                return baseQuery + " AND CAST(" + timeColumn + " AS DATE) = ?";
            case "week":
                return baseQuery + " AND " + timeColumn + " >= ? AND " + timeColumn + " < DATEADD(day, 7, ?)";
            case "month":
                return baseQuery + " AND YEAR(" + timeColumn + ") = ? AND MONTH(" + timeColumn + ") = ?";
            case "quarter":
                return baseQuery + " AND YEAR(" + timeColumn + ") = ? AND DATEPART(quarter, " + timeColumn + ") = ?";
            case "year":
                return baseQuery + " AND YEAR(" + timeColumn + ") = ?";
            default:
                return baseQuery + " AND " + timeColumn + " >= DATEADD(day, -6, GETDATE())";
        }
    }

    private void setTimeFrameParameters(PreparedStatement ps, String timeFrame, String timeValue, int startIndex) throws SQLException {
        if (timeValue == null || timeValue.isEmpty() || timeFrame.equals("all")) return;
        try {
            switch (timeFrame) {
                case "day":
                case "week":
                    ps.setDate(startIndex, java.sql.Date.valueOf(timeValue));
                    if (timeFrame.equals("week")) {
                        ps.setDate(startIndex + 1, java.sql.Date.valueOf(timeValue));
                    }
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
            }
        } catch (IllegalArgumentException e) {
            System.err.println("Invalid timeValue format: " + timeValue);
            e.printStackTrace();
        }
    }
}
