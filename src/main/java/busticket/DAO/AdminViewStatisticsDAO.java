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

    // Lấy doanh thu theo tháng
    public BigDecimal getMonthlyRevenue() throws SQLException {
        // Sửa câu truy vấn để sử dụng GETDATE() thay vì CURRENT_DATE
        String sql = "SELECT SUM(invoice_total_amount) FROM Invoices WHERE YEAR(paid_at) = YEAR(GETDATE())";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        }
        return BigDecimal.ZERO;
    }

    // Lấy tỷ lệ chiếm chỗ (Occupancy Rate)
    public List<Map<String, Object>> getOccupancyRate() throws SQLException {
        String sql = "SELECT tr.trip_id, ls.location_name + ' → ' + le.location_name AS route_name, "
                + "(CAST(COUNT(t.ticket_id) AS FLOAT) / CAST(b.capacity AS FLOAT)) * 100 AS occupancy_rate "
                + "FROM Trips tr "
                + "JOIN Tickets t ON tr.trip_id = t.trip_id "
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

    // Lấy phân loại vé (ticket type breakdown)
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

    // Lấy doanh thu theo tuyến xe (Top Routes by Revenue)
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
                row.put("total_revenue", rs.getBigDecimal("total_revenue"));
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

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            List<String> driverPerformance = new ArrayList<>();
            while (rs.next()) {
                driverPerformance.add(rs.getString("user_name") + " - Trips: " + rs.getInt("trips") + " - Revenue: " + rs.getBigDecimal("revenue"));
            }
            return driverPerformance;
        }
    }

}
