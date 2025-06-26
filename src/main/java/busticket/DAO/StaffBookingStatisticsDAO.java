/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.StaffBookingStatistics;
import busticket.model.StaffBookingStatisticsTopDriver;
import busticket.model.StaffTopCustomer;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffBookingStatisticsDAO extends DBContext {

    /**
     * Retrieves a paginated list of filtered booking statistics based on the
     * given criteria.
     *
     * @param q the keyword to search (invoice code, driver name, customer name)
     * @param driverKeyword keyword to filter by driver name
     * @param routeId ID of the route to filter (-1 means no filter)
     * @param date specific date (yyyy-MM-dd) to filter bookings
     * @param status invoice status to filter (e.g., "Paid", "Pending")
     * @param page current page number (1-based index)
     * @param recordsPerPage number of records per page
     * @return list of filtered booking statistics within the given page
     * @throws SQLException if a database access error occurs
     */
    public List<StaffBookingStatistics> getFilteredStatisticsByPage(
            String q, String driverKeyword, int routeId, String date, String status,
            int page, int recordsPerPage) throws SQLException {

        List<StaffBookingStatistics> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT * FROM ( "
                + "SELECT ROW_NUMBER() OVER (ORDER BY tr.departure_time DESC) AS rownum, "
                + "i.invoice_id, i.invoice_code, "
                + "u.user_name AS customer_name, "
                + "d.user_name AS driver_name, "
                + "ls.location_name + N' → ' + le.location_name AS route_name, "
                + "tr.departure_time, i.invoice_status, i.invoice_total_amount, "
                + "STRING_AGG(ts.seat_number, ', ') AS seat_list "
                + "FROM Invoices i "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "LEFT JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "JOIN Drivers dr ON td.driver_id = dr.driver_id "
                + "JOIN Users d ON dr.user_id = d.user_id "
                + "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (q != null && !q.trim().isEmpty()) {
            sql.append("AND (i.invoice_code LIKE ? OR d.user_name LIKE ? OR u.user_name LIKE ?) ");
            String keyword = "%" + q.trim() + "%";
            params.add(keyword);
            params.add(keyword);
            params.add(keyword);
        }

        if (driverKeyword != null && !driverKeyword.trim().isEmpty()) {
            sql.append("AND d.user_name LIKE ? ");
            params.add("%" + driverKeyword.trim() + "%");
        }

        if (routeId != -1) {
            sql.append("AND r.route_id = ? ");
            params.add(routeId);
        }

        if (date != null && !date.trim().isEmpty()) {
            sql.append("AND CAST(tr.departure_time AS DATE) = ? ");
            params.add(Date.valueOf(date));
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND i.invoice_status = ? ");
            params.add(status);
        }

        sql.append("GROUP BY i.invoice_id, i.invoice_code, u.user_name, d.user_name, ")
                .append("ls.location_name, le.location_name, tr.departure_time, ")
                .append("i.invoice_status, i.invoice_total_amount ");

        sql.append(") AS filtered WHERE rownum BETWEEN ? AND ? ");
        int start = (page - 1) * recordsPerPage + 1;
        int end = page * recordsPerPage;
        params.add(start);
        params.add(end);

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else if (param instanceof Date) {
                    ps.setDate(i + 1, (Date) param);
                }
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StaffBookingStatistics stat = new StaffBookingStatistics();
                stat.setInvoiceId(rs.getInt("invoice_id"));
                stat.setInvoiceCode(rs.getString("invoice_code"));
                stat.setCustomerName(rs.getString("customer_name"));
                stat.setDriverName(rs.getString("driver_name"));
                stat.setRouteName(rs.getString("route_name"));
                stat.setDepartureTime(rs.getTimestamp("departure_time"));
                stat.setPaymentStatus(rs.getString("invoice_status"));
                stat.setInvoiceAmount(rs.getDouble("invoice_total_amount"));
                list.add(stat);
            }
        }

        return list;
    }

    /**
     * Counts the number of filtered statistics based on the provided filters.
     *
     * @param q keyword to search (invoice code, driver name, customer name)
     * @param driverKeyword keyword to filter by driver name
     * @param routeId ID of the route (-1 means no filter)
     * @param date date string (yyyy-MM-dd) to filter
     * @param status invoice status filter
     * @return total count of matched filtered statistics
     * @throws SQLException if a database access error occurs
     */
    public int countFilteredStatistics(String q, String driverKeyword, int routeId, String date, String status) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(DISTINCT i.invoice_id) AS total FROM Invoices i "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "JOIN Drivers dr ON td.driver_id = dr.driver_id "
                + "JOIN Users d ON dr.user_id = d.user_id "
                + "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (q != null && !q.trim().isEmpty()) {
            sql.append("AND (i.invoice_code LIKE ? OR d.user_name LIKE ? OR u.user_name LIKE ?) ");
            String keyword = "%" + q.trim() + "%";
            params.add(keyword);
            params.add(keyword);
            params.add(keyword);
        }

        if (driverKeyword != null && !driverKeyword.trim().isEmpty()) {
            sql.append("AND d.user_name LIKE ? ");
            params.add("%" + driverKeyword.trim() + "%");
        }

        if (routeId != -1) {
            sql.append("AND r.route_id = ? ");
            params.add(routeId);
        }

        if (date != null && !date.trim().isEmpty()) {
            sql.append("AND CAST(tr.departure_time AS DATE) = ? ");
            params.add(Date.valueOf(date));
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND i.invoice_status = ? ");
            params.add(status);
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else if (param instanceof Date) {
                    ps.setDate(i + 1, (Date) param);
                }
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        }

        return 0;
    }

    /**
     * Calculates the total revenue of filtered bookings.
     *
     * @param q keyword to search
     * @param driverKeyword filter by driver name
     * @param routeId ID of route
     * @param date specific date
     * @param status invoice status
     * @return total amount as BigDecimal
     */
    public BigDecimal getTotalAmount(String q, String driverKeyword, int routeId, String date, String status) {
        BigDecimal total = BigDecimal.ZERO;

        StringBuilder sql = new StringBuilder(
                "SELECT SUM(i.invoice_total_amount) FROM Invoices i "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "JOIN Drivers dr ON td.driver_id = dr.driver_id "
                + "JOIN Users d ON dr.user_id = d.user_id "
                + "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (q != null && !q.trim().isEmpty()) {
            sql.append("AND (i.invoice_code LIKE ? OR d.user_name LIKE ? OR u.user_name LIKE ?) ");
            String keyword = "%" + q.trim() + "%";
            params.add(keyword);
            params.add(keyword);
            params.add(keyword);
        }

        if (driverKeyword != null && !driverKeyword.trim().isEmpty()) {
            sql.append("AND d.user_name LIKE ? ");
            params.add("%" + driverKeyword.trim() + "%");
        }

        if (routeId != -1) {
            sql.append("AND r.route_id = ? ");
            params.add(routeId);
        }

        if (date != null && !date.trim().isEmpty()) {
            sql.append("AND CAST(tr.departure_time AS DATE) = ? ");
            params.add(Date.valueOf(date));
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND i.invoice_status = ? ");
            params.add(status);
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else if (param instanceof Date) {
                    ps.setDate(i + 1, (Date) param);
                }
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getBigDecimal(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return total != null ? total : BigDecimal.ZERO;
    }

    /**
     * Retrieves the top N drivers ranked by total revenue.
     *
     * @param topN the number of top drivers to return
     * @return list of top drivers with their revenue, trip, and ticket counts
     * @throws SQLException if a database access error occurs
     */
    public List<StaffBookingStatisticsTopDriver> getTopDriversByRevenue(int topN) throws SQLException {
        List<StaffBookingStatisticsTopDriver> topDrivers = new ArrayList<>();

        String sql = "SELECT TOP " + topN + " d.user_name AS driver_name, "
                + "COUNT(DISTINCT tr.trip_id) AS trip_count, "
                + "COUNT(DISTINCT t.ticket_id) AS ticket_count, "
                + "SUM(i.invoice_total_amount) AS revenue "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "JOIN Drivers dr ON td.driver_id = dr.driver_id "
                + "JOIN Users d ON dr.user_id = d.user_id "
                + "GROUP BY d.user_name ORDER BY revenue DESC";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                StaffBookingStatisticsTopDriver driver = new StaffBookingStatisticsTopDriver();
                driver.setDriverName(rs.getString("driver_name"));
                driver.setTripCount(rs.getInt("trip_count"));
                driver.setTicketCount(rs.getInt("ticket_count"));
                driver.setRevenue(rs.getBigDecimal("revenue"));
                topDrivers.add(driver);
            }
        }

        return topDrivers;
    }

    /**
     * Gets total revenue per route (route name as key, revenue as value).
     *
     * @return map of route names and their corresponding revenue
     * @throws SQLException if a database access error occurs
     */
    public Map<String, BigDecimal> getRevenueByRoute() throws SQLException {
        Map<String, BigDecimal> revenueMap = new LinkedHashMap<>();

        String sql = "SELECT ls.location_name + N' → ' + le.location_name AS route_name, "
                + "SUM(i.invoice_total_amount) AS total_revenue "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "GROUP BY ls.location_name, le.location_name ORDER BY total_revenue DESC";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                revenueMap.put(rs.getString("route_name"), rs.getBigDecimal("total_revenue"));
            }
        }

        return revenueMap;
    }

    /**
     * Counts the number of 'Paid' invoices that match the filter criteria.
     *
     * @param q keyword for invoice code or driver name
     * @param driverKeyword filter by driver name
     * @param routeId route ID to filter
     * @param date date string
     * @return number of paid invoices
     * @throws SQLException if a database access error occurs
     */
    public int countPaidInvoices(String q, String driverKeyword, int routeId, String date) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "JOIN Drivers dr ON td.driver_id = dr.driver_id "
                + "JOIN Users d ON dr.user_id = d.user_id "
                + "WHERE i.invoice_status = 'Paid' ");

        List<Object> params = new ArrayList<>();

        if (q != null && !q.trim().isEmpty()) {
            sql.append("AND (i.invoice_code LIKE ? OR d.user_name LIKE ?) ");
            String keyword = "%" + q.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        if (driverKeyword != null && !driverKeyword.trim().isEmpty()) {
            sql.append("AND d.user_name LIKE ? ");
            params.add("%" + driverKeyword.trim() + "%");
        }

        if (routeId != -1) {
            sql.append("AND r.route_id = ? ");
            params.add(routeId);
        }

        if (date != null && !date.trim().isEmpty()) {
            sql.append("AND CAST(tr.departure_time AS DATE) = ? ");
            params.add(Date.valueOf(date));
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else if (param instanceof Date) {
                    ps.setDate(i + 1, (Date) param);
                }
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    /**
     * Retrieves all distinct route names from paid invoices.
     *
     * @return list of unique route names
     * @throws SQLException if a database access error occurs
     */
    public List<String> getAllRouteNames() throws SQLException {
        List<String> routes = new ArrayList<>();

        String sql = "SELECT DISTINCT ls.location_name + N' → ' + le.location_name AS route_name "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "WHERE i.invoice_status = 'Paid'";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                routes.add(rs.getString("route_name"));
            }
        }

        return routes;
    }

    /**
     * Retrieves total revenue (as list of values) per paid route. The index
     * corresponds to the order in getAllRouteNames().
     *
     * @return list of total revenue amounts per route
     * @throws SQLException if a database access error occurs
     */
    public List<BigDecimal> getRevenuePerRoute() throws SQLException {
        List<BigDecimal> revenues = new ArrayList<>();

        String sql = "SELECT ls.location_name + N' → ' + le.location_name AS route_name, "
                + "SUM(i.invoice_total_amount) AS revenue "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "WHERE i.invoice_status = 'Paid' "
                + "GROUP BY ls.location_name, le.location_name "
                + "ORDER BY ls.location_name, le.location_name";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                revenues.add(rs.getBigDecimal("revenue"));
            }
        }

        return revenues;
    }

    /**
     * Retrieves the top customers ranked by total amount spent and number of
     * invoices.
     *
     * @param limit number of top customers to return
     * @return list of top customers
     * @throws SQLException if a database access error occurs
     */
    public List<StaffTopCustomer> getTopCustomers(int limit) throws SQLException {
        List<StaffTopCustomer> list = new ArrayList<>();

        String sql = "SELECT TOP " + limit + " u.user_name AS customer_name, "
                + "COUNT(i.invoice_id) AS invoice_count, "
                + "SUM(i.invoice_total_amount) AS total_spent "
                + "FROM Invoices i "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.invoice_status = 'Paid' "
                + "GROUP BY u.user_name "
                + "ORDER BY total_spent DESC";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                StaffTopCustomer customer = new StaffTopCustomer();
                customer.setCustomerName(rs.getString("customer_name"));
                customer.setInvoiceCount(rs.getInt("invoice_count"));
                customer.setTotalSpent(rs.getDouble("total_spent"));
                list.add(customer);
            }
        }

        return list;
    }

    /**
     * Generates a list of formatted date strings for the last 7 days
     * (inclusive).
     *
     * @return list of last 7 day labels in 'yyyy-MM-dd' format
     */
    public List<String> getLast7DaysLabels() {
        List<String> dates = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        for (int i = 6; i >= 0; i--) {
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_MONTH, -i);
            dates.add(sdf.format(cal.getTime()));
        }

        return dates;
    }

    /**
     * Gets the number of paid bookings grouped by day in the last 7 days.
     * Ensures days with 0 bookings are also included.
     *
     * @return ordered map of dates and their booking counts
     * @throws SQLException if a database access error occurs
     */
    public Map<String, Integer> getBookingTrendLast7Days() throws SQLException {
        Map<String, Integer> map = new HashMap<>();

        String sql = "SELECT CAST(paid_at AS DATE) AS booking_date, "
                + "COUNT(*) AS booking_count "
                + "FROM Invoices "
                + "WHERE invoice_status = 'Paid' "
                + "AND paid_at >= DATEADD(DAY, -6, CAST(GETDATE() AS DATE)) "
                + "GROUP BY CAST(paid_at AS DATE) "
                + "ORDER BY booking_date ASC";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                map.put(rs.getString("booking_date"), rs.getInt("booking_count"));
            }
        }

        List<String> last7Days = getLast7DaysLabels();
        Map<String, Integer> ordered = new LinkedHashMap<>();
        for (String d : last7Days) {
            ordered.put(d, map.getOrDefault(d, 0));
        }

        return ordered;
    }

    /**
     * Retrieves the complete list of booking statistics for export purposes.
     *
     * This method queries the database to gather all invoice-related data,
     * including customer name, route information, departure time, driver, total
     * invoice amount, and payment status. The data is joined from multiple
     * tables including Invoices, Users, Routes, Trips, Tickets, and Drivers.
     *
     * @return a list of {@link StaffBookingStatistics} objects containing
     * complete booking statistics, ordered by invoice ID ascending.
     */

    public List<StaffBookingStatistics> getAllStatsForExport() {
        List<StaffBookingStatistics> list = new ArrayList<>();
        DBContext db = new DBContext();

        String sql = "SELECT\n"
                + "    i.invoice_id AS invoice_id,\n"
                + "    i.invoice_code AS invoice_code,\n"
                + "    u.user_name AS customer_name,\n"
                + "    l1.location_name + N' → ' + l2.location_name AS route_name,\n"
                + "    tr.departure_time AS departure_time,\n"
                + "    du.user_name AS driver_name,\n"
                + "    i.invoice_total_amount AS invoice_amount,\n"
                + "    i.payment_method AS payment_status\n"
                + "FROM Invoices i\n"
                + "JOIN Users u ON i.user_id = u.user_id\n"
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id\n"
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id\n"
                + "JOIN Trips tr ON t.trip_id = tr.trip_id\n"
                + "JOIN Routes r ON tr.route_id = r.route_id\n"
                + "JOIN Locations l1 ON r.start_location_id = l1.location_id\n"
                + "JOIN Locations l2 ON r.end_location_id = l2.location_id\n"
                + "JOIN Trip_Driver td ON tr.trip_id = td.trip_id\n"
                + "JOIN Drivers d ON td.driver_id = d.driver_id\n"
                + "JOIN Users du ON d.user_id = du.user_id\n"
                + "ORDER BY i.invoice_id ASC;";

        try (
                 Connection conn = db.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StaffBookingStatistics s = new StaffBookingStatistics();
                s.setInvoiceId(rs.getInt("invoice_id"));
                s.setInvoiceCode(rs.getString("invoice_code"));
                s.setCustomerName(rs.getString("customer_name"));
                s.setRouteName(rs.getString("route_name"));
                s.setDepartureTime(rs.getTimestamp("departure_time"));
                s.setDriverName(rs.getString("driver_name"));
                s.setInvoiceAmount(rs.getDouble("invoice_amount"));
                s.setPaymentStatus(rs.getString("payment_status"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
