/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.StaffTicket;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffManageBookingDAO extends DBContext {

    /**
     * Retrieves a paginated list of filtered booking tickets based on search
     * criteria.
     *
     * @param q search keyword to match invoice code or customer name (nullable)
     * @param routeId route ID to filter tickets by specific route (nullable)
     * @param date departure date to filter tickets (format: yyyy-MM-dd,
     * nullable)
     * @param status invoice payment status (e.g., Paid, Unpaid) (nullable)
     * @param page current page number (starting from 1)
     * @param recordsPerPage number of records per page
     * @return list of {@link StaffTicket} objects matching the filters and
     * pagination
     * @throws SQLException if a database access error occurs
     */
    public List<StaffTicket> getFilteredTicketsByPage(String q, String routeId, String date, String status, int page, int recordsPerPage) throws SQLException {
        List<StaffTicket> tickets = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM ( "
                + "SELECT ROW_NUMBER() OVER (ORDER BY tr.departure_time DESC) AS rownum, "
                + "i.invoice_id, i.invoice_code, "
                + "u.user_name AS customer_name, "
                + "ls.location_name + N' → ' + le.location_name AS route_name, "
                + "tr.departure_time, "
                + "d.user_name AS driver_name, "
                + "i.invoice_status, i.invoice_total_amount, t.ticket_id "
                + "FROM Invoices i "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
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
            sql.append("AND (i.invoice_code LIKE ? OR u.user_name LIKE ?) ");
            String keyword = "%" + q.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        if (routeId != null && !routeId.trim().isEmpty()) {
            sql.append("AND r.route_id = ? ");
            params.add(Integer.parseInt(routeId));
        }

        if (date != null && !date.trim().isEmpty()) {
            sql.append("AND CAST(tr.departure_time AS DATE) = ? ");
            params.add(Date.valueOf(date));
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND i.invoice_status = ? ");
            params.add(status.trim());
        }

        sql.append(") AS filtered WHERE rownum BETWEEN ? AND ?");

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
                } else {
                    ps.setObject(i + 1, param);
                }
            }

            try ( ResultSet rs = ps.executeQuery()) {
                int index = start;
                while (rs.next()) {
                    StaffTicket ticket = new StaffTicket();
                    ticket.setStt(index++);
                    ticket.setInvoiceId(rs.getInt("invoice_id"));
                    ticket.setInvoiceCode(rs.getString("invoice_code"));
                    ticket.setCustomerName(rs.getString("customer_name"));
                    ticket.setRouteName(rs.getString("route_name"));
                    ticket.setDepartureTime(rs.getTimestamp("departure_time"));
                    ticket.setDriverName(rs.getString("driver_name"));
                    ticket.setPaymentStatus(rs.getString("invoice_status"));
                    ticket.setInvoiceAmount(rs.getDouble("invoice_total_amount"));
                    ticket.setTicketId(rs.getString("ticket_id"));

                    tickets.add(ticket);
                }
            }
        }

        return tickets;
    }

    /**
     * Counts the total number of filtered booking tickets matching the given
     * criteria.
     *
     * @param q search keyword to match invoice code or customer name (nullable)
     * @param routeId route ID to filter tickets by specific route (nullable)
     * @param date departure date to filter tickets (format: yyyy-MM-dd,
     * nullable)
     * @param status invoice payment status (e.g., Paid, Unpaid) (nullable)
     * @return total number of matched records
     * @throws SQLException if a database access error occurs
     */
    public int countFilteredTickets(String q, String routeId, String date, String status) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) AS total FROM Invoices i "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
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
            sql.append("AND (i.invoice_code LIKE ? OR u.user_name LIKE ?) ");
            String keyword = "%" + q.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        if (routeId != null && !routeId.trim().isEmpty()) {
            sql.append("AND r.route_id = ? ");
            params.add(Integer.parseInt(routeId));
        }

        if (date != null && !date.trim().isEmpty()) {
            sql.append("AND CAST(tr.departure_time AS DATE) = ? ");
            params.add(Date.valueOf(date));
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND i.invoice_status = ? ");
            params.add(status.trim());
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
                } else {
                    ps.setObject(i + 1, param);
                }
            }

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }

        return 0;
    }
}
