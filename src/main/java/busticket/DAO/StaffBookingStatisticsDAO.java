/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.StaffBookingStatistics;
import busticket.model.StaffBookingStatisticsTopDriver;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffBookingStatisticsDAO extends DBContext {

    /**
     * Retrieves a list of booking statistics filtered by route and/or date.
     *
     * @param routeFilter the name of the route in "A → B" format, or "All" to
     * include all routes
     * @param dateFilter the specific departure date to filter by (nullable)
     * @param onlyPaid true to include only bookings with payments, false to
     * include all
     * @return a list of booking statistics matching the filters
     * @throws SQLException if a database error occurs
     */
    public List<StaffBookingStatistics> getStats(String routeFilter, LocalDate dateFilter, boolean onlyPaid) throws SQLException {
        List<StaffBookingStatistics> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT CAST(tr.departure_time AS DATE) AS stat_date, "
                + "ISNULL(ls.location_name, '') + ' &rarr; ' + ISNULL(le.location_name, '') AS route_name, "
                + "COUNT(DISTINCT ts.seat_number) AS tickets_sold, "
                + "CAST(COUNT(DISTINCT ts.seat_number) * 100.0 / NULLIF(b.capacity, 0) AS INT) AS occupancy_percent, "
                + "u.user_name AS driver_name, "
                + "COUNT(DISTINCT CASE WHEN i.invoice_id IS NOT NULL THEN ts.seat_number END) AS paid_tickets, "
                + "COUNT(DISTINCT CASE WHEN i.invoice_id IS NULL THEN ts.seat_number END) AS unpaid_tickets, "
                + "t.ticket_id AS booking_id, "
                + "cu.user_name AS customer_name "
                + "FROM Trips tr "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "JOIN Users u ON d.user_id = u.user_id "
                + "JOIN Tickets t ON tr.trip_id = t.trip_id "
                + "JOIN Users cu ON t.user_id = cu.user_id "
                + "LEFT JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "LEFT JOIN Invoice_Items ii ON t.ticket_id = ii.ticket_id "
                + "LEFT JOIN Invoices i ON ii.invoice_id = i.invoice_id "
                + "JOIN Trip_Bus tb ON tr.trip_id = tb.trip_id "
                + "JOIN Buses b ON tb.bus_id = b.bus_id "
        );

        boolean hasCondition = false;
        if (routeFilter != null && !"All".equalsIgnoreCase(routeFilter)) {
            sql.append("WHERE ISNULL(ls.location_name, '') + ' &rarr; ' + ISNULL(le.location_name, '') = ? ");
            hasCondition = true;
        }

        if (dateFilter != null) {
            sql.append(hasCondition ? "AND " : "WHERE ");
            sql.append("CAST(tr.departure_time AS DATE) = ? ");
            hasCondition = true;
        }

        if (onlyPaid) {
            sql.append(hasCondition ? "AND " : "WHERE ");
            sql.append("i.invoice_id IS NOT NULL ");
        }

        sql.append("GROUP BY CAST(tr.departure_time AS DATE), ls.location_name, le.location_name, u.user_name, b.capacity, t.ticket_id, cu.user_name ");
        sql.append("ORDER BY stat_date DESC, route_name, tickets_sold DESC");

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (routeFilter != null && !"All".equalsIgnoreCase(routeFilter)) {
                ps.setString(paramIndex++, routeFilter);
            }
            if (dateFilter != null) {
                ps.setDate(paramIndex++, Date.valueOf(dateFilter));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StaffBookingStatistics stat = new StaffBookingStatistics(
                        rs.getDate("stat_date"),
                        rs.getString("route_name"),
                        rs.getInt("tickets_sold"),
                        rs.getInt("occupancy_percent"),
                        rs.getString("driver_name"),
                        rs.getInt("paid_tickets"),
                        rs.getInt("unpaid_tickets")
                );
                stat.setBookingId(rs.getString("booking_id"));
                stat.setCustomerName(rs.getString("customer_name"));
                list.add(stat);
            }
        }

        return list;
    }

    /**
     * Retrieves booking statistics with pagination support.
     *
     * @param routeFilter filter by route name ("A → B") or "All"
     * @param dateFilter filter by specific departure date (nullable)
     * @param onlyPaid filter only paid bookings if true
     * @param offset starting row index for pagination
     * @param limit number of rows to fetch
     * @return paginated list of booking statistics
     * @throws SQLException if a database error occurs
     */
    public List<StaffBookingStatistics> getStatsWithPagination(String routeFilter, LocalDate dateFilter, boolean onlyPaid, int offset, int limit) throws SQLException {
        List<StaffBookingStatistics> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT CAST(tr.departure_time AS DATE) AS stat_date, "
                + "ISNULL(ls.location_name, '') + ' &rarr; ' + ISNULL(le.location_name, '') AS route_name, "
                + "COUNT(DISTINCT ts.seat_number) AS tickets_sold, "
                + "CAST(COUNT(DISTINCT ts.seat_number) * 100.0 / NULLIF(b.capacity, 0) AS INT) AS occupancy_percent, "
                + "u.user_name AS driver_name, "
                + "COUNT(DISTINCT CASE WHEN i.invoice_id IS NOT NULL THEN ts.seat_number END) AS paid_tickets, "
                + "COUNT(DISTINCT CASE WHEN i.invoice_id IS NULL THEN ts.seat_number END) AS unpaid_tickets, "
                + "t.ticket_id AS booking_id, cu.user_name AS customer_name "
                + "FROM Trips tr "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "JOIN Users u ON d.user_id = u.user_id "
                + "JOIN Tickets t ON tr.trip_id = t.trip_id "
                + "JOIN Users cu ON t.user_id = cu.user_id "
                + "LEFT JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "LEFT JOIN Invoice_Items ii ON t.ticket_id = ii.ticket_id "
                + "LEFT JOIN Invoices i ON ii.invoice_id = i.invoice_id "
                + "JOIN Trip_Bus tb ON tr.trip_id = tb.trip_id "
                + "JOIN Buses b ON tb.bus_id = b.bus_id "
        );

        boolean hasCondition = false;
        if (routeFilter != null && !"All".equalsIgnoreCase(routeFilter)) {
            sql.append("WHERE ISNULL(ls.location_name, '') + ' &rarr; ' + ISNULL(le.location_name, '') = ? ");
            hasCondition = true;
        }

        if (dateFilter != null) {
            sql.append(hasCondition ? "AND " : "WHERE ");
            sql.append("CAST(tr.departure_time AS DATE) = ? ");
            hasCondition = true;
        }

        if (onlyPaid) {
            sql.append(hasCondition ? "AND " : "WHERE ");
            sql.append("i.invoice_id IS NOT NULL ");
        }

        sql.append("GROUP BY CAST(tr.departure_time AS DATE), ls.location_name, le.location_name, u.user_name, b.capacity, t.ticket_id, cu.user_name ");
        sql.append("ORDER BY stat_date DESC, route_name, tickets_sold DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (routeFilter != null && !"All".equalsIgnoreCase(routeFilter)) {
                ps.setString(paramIndex++, routeFilter);
            }
            if (dateFilter != null) {
                ps.setDate(paramIndex++, Date.valueOf(dateFilter));
            }
            if (onlyPaid) {
                // no additional param
            }

            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StaffBookingStatistics stat = new StaffBookingStatistics(
                        rs.getDate("stat_date"),
                        rs.getString("route_name"),
                        rs.getInt("tickets_sold"),
                        rs.getInt("occupancy_percent"),
                        rs.getString("driver_name"),
                        rs.getInt("paid_tickets"),
                        rs.getInt("unpaid_tickets")
                );
                stat.setBookingId(rs.getString("booking_id"));
                stat.setCustomerName(rs.getString("customer_name"));
                list.add(stat);
            }
        }

        return list;
    }

    /**
     * Counts the total number of booking records matching the given filters.
     *
     * @param routeFilter the route name ("A → B") or "All"
     * @param dateFilter filter by date (nullable)
     * @param onlyPaid true to count only paid bookings
     * @return total count of records
     * @throws SQLException if a database error occurs
     */
    public int countStats(String routeFilter, LocalDate dateFilter, boolean onlyPaid) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(DISTINCT t.ticket_id) AS total "
                + "FROM Trips tr "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "JOIN Users u ON d.user_id = u.user_id "
                + "JOIN Tickets t ON tr.trip_id = t.trip_id "
                + "JOIN Users cu ON t.user_id = cu.user_id "
                + "LEFT JOIN Invoice_Items ii ON t.ticket_id = ii.ticket_id "
                + "LEFT JOIN Invoices i ON ii.invoice_id = i.invoice_id "
        );

        boolean hasCondition = false;
        if (routeFilter != null && !"All".equalsIgnoreCase(routeFilter)) {
            sql.append("WHERE ISNULL(ls.location_name, '') + ' &rarr; ' + ISNULL(le.location_name, '') = ? ");
            hasCondition = true;
        }

        if (dateFilter != null) {
            sql.append(hasCondition ? "AND " : "WHERE ");
            sql.append("CAST(tr.departure_time AS DATE) = ? ");
            hasCondition = true;
        }

        if (onlyPaid) {
            sql.append(hasCondition ? "AND " : "WHERE ");
            sql.append("i.invoice_id IS NOT NULL ");
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (routeFilter != null && !"All".equalsIgnoreCase(routeFilter)) {
                ps.setString(paramIndex++, routeFilter);
            }
            if (dateFilter != null) {
                ps.setDate(paramIndex++, Date.valueOf(dateFilter));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        }

        return 0;
    }

    /**
     * Retrieves the top N drivers based on total tickets sold.
     *
     * @param topN the number of top drivers to retrieve
     * @return a list of top drivers with their ticket count
     * @throws SQLException if a database error occurs
     */
    public List<StaffBookingStatisticsTopDriver> getTopDriversByTicketsSold(int topN) throws SQLException {
        List<StaffBookingStatisticsTopDriver> topDrivers = new ArrayList<>();

        String sql = "SELECT TOP " + topN + " u.user_name AS driver_name, "
                + "COUNT(*) AS tickets_sold " // hoặc COUNT(ts.seat_number)
                + "FROM Trips tr "
                + "JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "JOIN Drivers d ON td.driver_id = d.driver_id "
                + "JOIN Users u ON d.user_id = u.user_id "
                + "JOIN Tickets t ON tr.trip_id = t.trip_id "
                + "JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "GROUP BY u.user_name "
                + "ORDER BY tickets_sold DESC";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                topDrivers.add(new StaffBookingStatisticsTopDriver(
                        rs.getString("driver_name"),
                        rs.getInt("tickets_sold")
                ));
            }
        }

        return topDrivers;
    }

}
