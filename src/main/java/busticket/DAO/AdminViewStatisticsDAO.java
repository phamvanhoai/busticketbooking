/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminViewStatisticsDAO extends DBContext {

    // Lấy doanh thu theo khoảng thời gian
    // Lấy doanh thu theo khoảng thời gian
    public BigDecimal getRevenueByPeriod(String period, String dateValue) throws SQLException {
        String sql = "";
        switch (period.toLowerCase()) {
            case "day":
                sql = "SELECT SUM(invoice_total_amount) FROM Invoices WHERE CAST(paid_at AS DATE) = ?";
                break;
            case "week":
                sql = "SELECT SUM(invoice_total_amount) FROM Invoices WHERE DATEPART(WEEK, paid_at) = DATEPART(WEEK, ?) AND YEAR(paid_at) = YEAR(?)";
                break;
            case "month":
                sql = "SELECT SUM(invoice_total_amount) FROM Invoices WHERE MONTH(paid_at) = ? AND YEAR(paid_at) = ?";
                break;
            case "quarter":
                sql = "SELECT SUM(invoice_total_amount) FROM Invoices WHERE DATEPART(QUARTER, paid_at) = ? AND YEAR(paid_at) = ?";
                break;
            case "year":
                sql = "SELECT SUM(invoice_total_amount) FROM Invoices WHERE YEAR(paid_at) = ?";
                break;
            default:
                throw new SQLException("Invalid period: " + period);
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            if (period.equalsIgnoreCase("day")) {
                ps.setString(1, dateValue); // dateValue format: YYYY-MM-DD
            } else if (period.equalsIgnoreCase("week")) {
                ps.setString(1, dateValue); // dateValue: any date in the week
                ps.setString(2, dateValue);
            } else if (period.equalsIgnoreCase("month")) {
                String[] parts = dateValue.split("-"); // dateValue format: YYYY-MM
                ps.setInt(1, Integer.parseInt(parts[1])); // Month
                ps.setInt(2, Integer.parseInt(parts[0])); // Year
            } else if (period.equalsIgnoreCase("quarter")) {
                String[] parts = dateValue.split("-"); // dateValue format: YYYY-Q
                ps.setInt(1, Integer.parseInt(parts[1])); // Quarter
                ps.setInt(2, Integer.parseInt(parts[0])); // Year
            } else if (period.equalsIgnoreCase("year")) {
                ps.setInt(1, Integer.parseInt(dateValue)); // dateValue: YYYY
            }

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1) != null ? rs.getBigDecimal(1) : BigDecimal.ZERO;
                }
            }
        }
        return BigDecimal.ZERO;
    }

    // Lấy tỷ lệ chiếm chỗ (Occupancy Rate) theo khoảng thời gian
    public List<Map<String, Object>> getOccupancyRateByPeriod(String period, String dateValue) throws SQLException {
        String sql = "SELECT tr.trip_id, ls.location_name + ' → ' + le.location_name AS route_name, "
                + "(CAST(COUNT(t.ticket_id) AS FLOAT) / CAST(b.capacity AS FLOAT)) * 100 AS occupancy_rate "
                + "FROM Trips tr "
                + "JOIN Tickets t ON tr.trip_id = t.trip_id "
                + "JOIN Buses b ON tr.bus_id = b.bus_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id ";

        switch (period.toLowerCase()) {
            case "day":
                sql += "WHERE CAST(tr.departure_time AS DATE) = ?";
                break;
            case "week":
                sql += "WHERE DATEPART(WEEK, tr.departure_time) = DATEPART(WEEK, ?) AND YEAR(tr.departure_time) = YEAR(?)";
                break;
            case "month":
                sql += "WHERE MONTH(tr.departure_time) = ? AND YEAR(tr.departure_time) = ?";
                break;
            case "quarter":
                sql += "WHERE DATEPART(QUARTER, tr.departure_time) = ? AND YEAR(tr.departure_time) = ?";
                break;
            case "year":
                sql += "WHERE YEAR(tr.departure_time) = ?";
                break;
            default:
                throw new SQLException("Invalid period: " + period);
        }
        sql += " GROUP BY tr.trip_id, ls.location_name, le.location_name, b.capacity";

        List<Map<String, Object>> occupancyRates = new ArrayList<>();
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            if (period.equalsIgnoreCase("day")) {
                ps.setString(1, dateValue);
            } else if (period.equalsIgnoreCase("week")) {
                ps.setString(1, dateValue);
                ps.setString(2, dateValue);
            } else if (period.equalsIgnoreCase("month")) {
                String[] parts = dateValue.split("-");
                ps.setInt(1, Integer.parseInt(parts[1]));
                ps.setInt(2, Integer.parseInt(parts[0]));
            } else if (period.equalsIgnoreCase("quarter")) {
                String[] parts = dateValue.split("-");
                ps.setInt(1, Integer.parseInt(parts[1]));
                ps.setInt(2, Integer.parseInt(parts[0]));
            } else if (period.equalsIgnoreCase("year")) {
                ps.setInt(1, Integer.parseInt(dateValue));
            }

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("route_name", rs.getString("route_name"));
                    row.put("occupancy_rate", rs.getBigDecimal("occupancy_rate"));
                    occupancyRates.add(row);
                }
            }
        }
        return occupancyRates;
    }

    // Lấy phân loại vé (Ticket Type Breakdown) theo khoảng thời gian
    public List<Map<String, Object>> getTicketTypeBreakdownByPeriod(String period, String dateValue) throws SQLException {
        String sql = "SELECT ts.seat_number, COUNT(*) AS ticket_count "
                + "FROM Tickets t "
                + "JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "JOIN Invoice_Items ii ON t.ticket_id = ii.ticket_id "
                + "JOIN Invoices i ON ii.invoice_id = i.invoice_id ";

        switch (period.toLowerCase()) {
            case "day":
                sql += "WHERE CAST(i.paid_at AS DATE) = ?";
                break;
            case "week":
                sql += "WHERE DATEPART(WEEK, i.paid_at) = DATEPART(WEEK, ?) AND YEAR(i.paid_at) = YEAR(?)";
                break;
            case "month":
                sql += "WHERE MONTH(i.paid_at) = ? AND YEAR(i.paid_at) = ?";
                break;
            case "quarter":
                sql += "WHERE DATEPART(QUARTER, i.paid_at) = ? AND YEAR(i.paid_at) = ?";
                break;
            case "year":
                sql += "WHERE YEAR(i.paid_at) = ?";
                break;
            default:
                throw new SQLException("Invalid period: " + period);
        }
        sql += " GROUP BY ts.seat_number";

        List<Map<String, Object>> ticketTypeBreakdown = new ArrayList<>();
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            if (period.equalsIgnoreCase("day")) {
                ps.setString(1, dateValue);
            } else if (period.equalsIgnoreCase("week")) {
                ps.setString(1, dateValue);
                ps.setString(2, dateValue);
            } else if (period.equalsIgnoreCase("month")) {
                String[] parts = dateValue.split("-");
                ps.setInt(1, Integer.parseInt(parts[1]));
                ps.setInt(2, Integer.parseInt(parts[0]));
            } else if (period.equalsIgnoreCase("quarter")) {
                String[] parts = dateValue.split("-");
                ps.setInt(1, Integer.parseInt(parts[1]));
                ps.setInt(2, Integer.parseInt(parts[0]));
            } else if (period.equalsIgnoreCase("year")) {
                ps.setInt(1, Integer.parseInt(dateValue));
            }

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("seat_number", rs.getString("seat_number"));
                    row.put("ticket_count", rs.getInt("ticket_count"));
                    ticketTypeBreakdown.add(row);
                }
            }
        }
        return ticketTypeBreakdown;
    }

    // Lấy doanh thu theo tuyến xe (Top Routes by Revenue) theo khoảng thời gian
    public List<Map<String, Object>> getTopRoutesRevenueByPeriod(String period, String dateValue) throws SQLException {
        String sql = "SELECT TOP 5 ls.location_name + ' → ' + le.location_name AS route_name, "
                + "SUM(i.invoice_total_amount) AS total_revenue "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id ";

        switch (period.toLowerCase()) {
            case "day":
                sql += "WHERE CAST(i.paid_at AS DATE) = ?";
                break;
            case "week":
                sql += "WHERE DATEPART(WEEK, i.paid_at) = DATEPART(WEEK, ?) AND YEAR(i.paid_at) = YEAR(?)";
                break;
            case "month":
                sql += "WHERE MONTH(i.paid_at) = ? AND YEAR(i.paid_at) = ?";
                break;
            case "quarter":
                sql += "WHERE DATEPART(QUARTER, i.paid_at) = ? AND YEAR(i.paid_at) = ?";
                break;
            case "year":
                sql += "WHERE YEAR(i.paid_at) = ?";
                break;
            default:
                throw new SQLException("Invalid period: " + period);
        }
        sql += " GROUP BY ls.location_name, le.location_name ORDER BY total_revenue DESC";

        List<Map<String, Object>> topRoutes = new ArrayList<>();
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            if (period.equalsIgnoreCase("day")) {
                ps.setString(1, dateValue);
            } else if (period.equalsIgnoreCase("week")) {
                ps.setString(1, dateValue);
                ps.setString(2, dateValue);
            } else if (period.equalsIgnoreCase("month")) {
                String[] parts = dateValue.split("-");
                ps.setInt(1, Integer.parseInt(parts[1]));
                ps.setInt(2, Integer.parseInt(parts[0]));
            } else if (period.equalsIgnoreCase("quarter")) {
                String[] parts = dateValue.split("-");
                ps.setInt(1, Integer.parseInt(parts[1]));
                ps.setInt(2, Integer.parseInt(parts[0]));
            } else if (period.equalsIgnoreCase("year")) {
                ps.setInt(1, Integer.parseInt(dateValue));
            }

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("route_name", rs.getString("route_name"));
                    row.put("total_revenue", rs.getBigDecimal("total_revenue") != null ? rs.getBigDecimal("total_revenue") : BigDecimal.ZERO);
                    topRoutes.add(row);
                }
            }
        }
        return topRoutes;
    }

    // Lấy hiệu suất tài xế (Driver Performance) theo khoảng thời gian
    public List<String> getDriverPerformanceByPeriod(String period, String dateValue) throws SQLException {
        String sql = "SELECT u.user_name, COUNT(DISTINCT t.ticket_id) AS trips, SUM(i.invoice_total_amount) AS revenue "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "JOIN Users u ON d.user_id = u.user_id ";

        switch (period.toLowerCase()) {
            case "day":
                sql += "WHERE CAST(i.paid_at AS DATE) = ?";
                break;
            case "week":
                sql += "WHERE DATEPART(WEEK, i.paid_at) = DATEPART(WEEK, ?) AND YEAR(i.paid_at) = YEAR(?)";
                break;
            case "month":
                sql += "WHERE MONTH(i.paid_at) = ? AND YEAR(i.paid_at) = ?";
                break;
            case "quarter":
                sql += "WHERE DATEPART(QUARTER, i.paid_at) = ? AND YEAR(i.paid_at) = ?";
                break;
            case "year":
                sql += "WHERE YEAR(i.paid_at) = ?";
                break;
            default:
                throw new SQLException("Invalid period: " + period);
        }
        sql += " GROUP BY u.user_name ORDER BY revenue DESC";

        List<String> driverPerformance = new ArrayList<>();
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            if (period.equalsIgnoreCase("day")) {
                ps.setString(1, dateValue);
            } else if (period.equalsIgnoreCase("week")) {
                ps.setString(1, dateValue);
                ps.setString(2, dateValue);
            } else if (period.equalsIgnoreCase("month")) {
                String[] parts = dateValue.split("-");
                ps.setInt(1, Integer.parseInt(parts[1]));
                ps.setInt(2, Integer.parseInt(parts[0]));
            } else if (period.equalsIgnoreCase("quarter")) {
                String[] parts = dateValue.split("-");
                ps.setInt(1, Integer.parseInt(parts[1]));
                ps.setInt(2, Integer.parseInt(parts[0]));
            } else if (period.equalsIgnoreCase("year")) {
                ps.setInt(1, Integer.parseInt(dateValue));
            }

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    driverPerformance.add(rs.getString("user_name") + " - Trips: " + rs.getInt("trips") + " - Revenue: " + rs.getBigDecimal("revenue"));
                }
            }
        }
        return driverPerformance;
    }

    // Lấy chi tiết thống kê (Detailed Statistics) theo khoảng thời gian
    public List<Map<String, Object>> getDetailedStatisticsByPeriod(String period, String dateValue) throws SQLException {
        String sql = "SELECT CAST(tr.departure_time AS DATE) AS stat_date, "
                + "ls.location_name + ' → ' + le.location_name AS route_name, "
                + "COUNT(t.ticket_id) AS tickets_sold, "
                + "SUM(i.invoice_total_amount) AS revenue, "
                + "(CAST(COUNT(t.ticket_id) AS FLOAT) / CAST(b.capacity AS FLOAT)) * 100 AS occupancy_rate "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Buses b ON tr.bus_id = b.bus_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id ";

        switch (period.toLowerCase()) {
            case "day":
                sql += "WHERE CAST(i.paid_at AS DATE) = ?";
                break;
            case "week":
                sql += "WHERE DATEPART(WEEK, i.paid_at) = DATEPART(WEEK, ?) AND YEAR(i.paid_at) = YEAR(?)";
                break;
            case "month":
                sql += "WHERE MONTH(i.paid_at) = ? AND YEAR(i.paid_at) = ?";
                break;
            case "quarter":
                sql += "WHERE DATEPART(QUARTER, i.paid_at) = ? AND YEAR(i.paid_at) = ?";
                break;
            case "year":
                sql += "WHERE YEAR(i.paid_at) = ?";
                break;
            default:
                throw new SQLException("Invalid period: " + period);
        }
        sql += " GROUP BY CAST(tr.departure_time AS DATE), ls.location_name, le.location_name, b.capacity";

        List<Map<String, Object>> detailedStatistics = new ArrayList<>();
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            if (period.equalsIgnoreCase("day")) {
                ps.setString(1, dateValue);
            } else if (period.equalsIgnoreCase("week")) {
                ps.setString(1, dateValue);
                ps.setString(2, dateValue);
            } else if (period.equalsIgnoreCase("month")) {
                String[] parts = dateValue.split("-");
                ps.setInt(1, Integer.parseInt(parts[1]));
                ps.setInt(2, Integer.parseInt(parts[0]));
            } else if (period.equalsIgnoreCase("quarter")) {
                String[] parts = dateValue.split("-");
                ps.setInt(1, Integer.parseInt(parts[1]));
                ps.setInt(2, Integer.parseInt(parts[0]));
            } else if (period.equalsIgnoreCase("year")) {
                ps.setInt(1, Integer.parseInt(dateValue));
            }

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("stat_date", rs.getString("stat_date"));
                    row.put("route_name", rs.getString("route_name"));
                    row.put("tickets_sold", rs.getInt("tickets_sold"));
                    row.put("revenue", rs.getBigDecimal("revenue") != null ? rs.getBigDecimal("revenue") : BigDecimal.ZERO);
                    row.put("occupancy_rate", rs.getBigDecimal("occupancy_rate"));
                    detailedStatistics.add(row);
                }
            }
        }
        return detailedStatistics;
    }

    // Các phương thức hiện có (giữ nguyên)
    public BigDecimal getMonthlyRevenue() throws SQLException {
        String sql = "SELECT SUM(invoice_total_amount) FROM Invoices WHERE YEAR(paid_at) = YEAR(GETDATE())";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal(1) != null ? rs.getBigDecimal(1) : BigDecimal.ZERO;
            }
        }
        return BigDecimal.ZERO;
    }

    public List<Map<String, Object>> getOccupancyRate() throws SQLException {
        String sql = "SELECT tr.trip_id, ls.location_name + ' → ' + le.location_name AS route_name, "
                + "(CAST(COUNT(t.ticket_id) AS FLOAT) / CAST(b.capacity AS FLOAT)) * 100 AS occupancy_rate "
                + "FROM Trips tr "
                + "JOIN Tickets t ON tr.trip_id = t.ticket_id "
                + "JOIN Buses b ON tr.bus_id = b.bus_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "GROUP BY tr.trip_id, ls.location_name, le.location_name, b.capacity";

        List<Map<String, Object>> occupancyRates = new ArrayList<>();
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("route_name", rs.getString("route_name"));
                row.put("occupancy_rate", rs.getBigDecimal("occupancy_rate"));
                occupancyRates.add(row);
            }
        }
        return occupancyRates;
    }

    public List<Map<String, Object>> getTicketTypeBreakdown() throws SQLException {
        String sql = "SELECT ts.seat_number, COUNT(*) AS ticket_count "
                + "FROM Tickets t "
                + "JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "GROUP BY ts.seat_number";

        List<Map<String, Object>> ticketTypeBreakdown = new ArrayList<>();
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("seat_number", rs.getString("seat_number"));
                row.put("ticket_count", rs.getInt("ticket_count"));
                ticketTypeBreakdown.add(row);
            }
        }
        return ticketTypeBreakdown;
    }

    public List<Map<String, Object>> getTopRoutesRevenue() throws SQLException {
        String sql = "SELECT TOP 5 ls.location_name + ' → ' + le.location_name AS route_name, "
                + "SUM(i.invoice_total_amount) AS total_revenue "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "GROUP BY ls.location_name, le.location_name "
                + "ORDER BY total_revenue DESC";

        List<Map<String, Object>> topRoutes = new ArrayList<>();
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("route_name", rs.getString("route_name"));
                row.put("total_revenue", rs.getBigDecimal("total_revenue") != null ? rs.getBigDecimal("total_revenue") : BigDecimal.ZERO);
                topRoutes.add(row);
            }
        }
        return topRoutes;
    }

    public List<String> getDriverPerformance() throws SQLException {
        String sql = "SELECT u.user_name, COUNT(DISTINCT t.ticket_id) AS trips, SUM(i.invoice_total_amount) AS revenue "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "JOIN Users u ON d.user_id = u.user_id "
                + "GROUP BY u.user_name "
                + "ORDER BY revenue DESC";

        List<String> driverPerformance = new ArrayList<>();
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                driverPerformance.add(rs.getString("user_name") + " - Trips: " + rs.getInt("trips") + " - Revenue: " + rs.getBigDecimal("revenue"));
            }
        }
        return driverPerformance;
    }

}
