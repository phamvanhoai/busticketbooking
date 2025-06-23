/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.StaffBookingInfo;
import busticket.model.StaffTicket;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffBookingDAO extends DBContext {

    /**
     * Retrieves general booking information by a given invoice ID.
     *
     * @param invoiceId the unique ID of the invoice
     * @return a {@link StaffBookingInfo} object containing customer name,
     * invoice status, payment method, total amount, and paid time; or
     * {@code null} if no such invoice is found
     * @throws SQLException if a database access error occurs
     */
    public StaffBookingInfo getBookingInfoByInvoiceId(int invoiceId) throws SQLException {
        String sql = "SELECT i.invoice_id, 'INV' + RIGHT('0000' + CAST(i.invoice_id AS VARCHAR), 4) AS invoice_code, "
                + "u.user_name AS customer_name, i.invoice_status, i.invoice_total_amount, i.paid_at, i.payment_method "
                + "FROM Invoices i "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.invoice_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    StaffBookingInfo info = new StaffBookingInfo();
                    info.setInvoiceId(rs.getInt("invoice_id"));
                    info.setInvoiceCode(rs.getString("invoice_code"));
                    info.setCustomerName(rs.getString("customer_name"));
                    info.setPaymentStatus(rs.getString("invoice_status"));
                    info.setTotalAmount(rs.getDouble("invoice_total_amount"));
                    info.setBookingDate(rs.getTimestamp("paid_at"));  // Dùng paid_at thay cho booking_date
                    info.setPaymentMethod(rs.getString("payment_method"));  // <-- thêm dòng này
                    return info;
                }
            }
        }
        return null;
    }

    /**
     * Retrieves a list of all tickets associated with a given invoice ID.
     *
     * @param invoiceId the unique ID of the invoice
     * @return a list of {@link StaffTicket} containing detailed ticket and trip
     * information
     * @throws SQLException if a database access error occurs
     */
    public List<StaffTicket> getTicketsByInvoiceId(int invoiceId) throws SQLException {
        List<StaffTicket> tickets = new ArrayList<>();
        String sql = "SELECT t.ticket_id, r.route_id, ls.location_name + N' → ' + le.location_name AS route_name, "
                + "tr.departure_time, ts.seat_number AS seat_code, d.user_name AS driver_name, bt.bus_type_name, "
                + "i.invoice_status, i.invoice_total_amount, i.invoice_id, 'INV' + RIGHT('0000' + CAST(i.invoice_id AS VARCHAR), 4) AS invoice_code, "
                + "u.user_name AS customer_name "
                + "FROM Tickets t "
                + "JOIN Invoice_Items ii ON t.ticket_id = ii.ticket_id "
                + "JOIN Invoices i ON ii.invoice_id = i.invoice_id "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "JOIN Drivers dr ON td.driver_id = dr.driver_id "
                + "JOIN Users d ON dr.user_id = d.user_id "
                + "JOIN Buses b ON tr.bus_id = b.bus_id "
                + "JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + "WHERE i.invoice_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try ( ResultSet rs = ps.executeQuery()) {
                int index = 1;
                while (rs.next()) {
                    StaffTicket ticket = new StaffTicket();
                    ticket.setStt(index++);
                    ticket.setTicketId(rs.getString("ticket_id"));
                    ticket.setRouteName(rs.getString("route_name"));
                    ticket.setDepartureTime(rs.getTimestamp("departure_time"));
                    ticket.setSeatCode(rs.getString("seat_code"));
                    ticket.setDriverName(rs.getString("driver_name"));
                    ticket.setBusType(rs.getString("bus_type_name"));
                    ticket.setPaymentStatus(rs.getString("invoice_status"));
                    ticket.setInvoiceAmount(rs.getDouble("invoice_total_amount"));
                    ticket.setInvoiceId(rs.getInt("invoice_id"));
                    ticket.setInvoiceCode(rs.getString("invoice_code"));
                    ticket.setCustomerName(rs.getString("customer_name"));
                    tickets.add(ticket);
                }
            }
        }
        return tickets;
    }

    /**
     * Counts the total number of tickets associated with a specific invoice.
     *
     * @param invoiceId the unique ID of the invoice
     * @return the total number of tickets in the invoice; 0 if none found
     * @throws SQLException if a database access error occurs
     */
    public int countTicketsByInvoiceId(int invoiceId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tickets t "
                + "JOIN Invoice_Items ii ON t.ticket_id = ii.ticket_id "
                + "WHERE ii.invoice_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Retrieves a paginated list of tickets for a given invoice ID.
     *
     * @param invoiceId the unique ID of the invoice
     * @param offset the starting position for pagination (0-based index)
     * @param pageSize the maximum number of tickets to retrieve
     * @return a paginated list of {@link StaffTicket} objects
     * @throws SQLException if a database access error occurs
     */
    public List<StaffTicket> getTicketsByInvoiceIdPaging(int invoiceId, int offset, int pageSize) throws SQLException {
        List<StaffTicket> tickets = new ArrayList<>();
        String sql = "SELECT t.ticket_id, r.route_id, ls.location_name + N' → ' + le.location_name AS route_name, "
                + "tr.departure_time, ts.seat_number AS seat_code, d.user_name AS driver_name, bt.bus_type_name, "
                + "i.invoice_status, i.invoice_total_amount, i.invoice_id, 'INV' + RIGHT('0000' + CAST(i.invoice_id AS VARCHAR), 4) AS invoice_code, "
                + "u.user_name AS customer_name "
                + "FROM Tickets t "
                + "JOIN Invoice_Items ii ON t.ticket_id = ii.ticket_id "
                + "JOIN Invoices i ON ii.invoice_id = i.invoice_id "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "JOIN Drivers dr ON td.driver_id = dr.driver_id "
                + "JOIN Users d ON dr.user_id = d.user_id "
                + "JOIN Buses b ON tr.bus_id = b.bus_id "
                + "JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + "WHERE i.invoice_id = ? "
                + "ORDER BY t.ticket_id "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            try ( ResultSet rs = ps.executeQuery()) {
                int index = offset + 1;
                while (rs.next()) {
                    StaffTicket ticket = new StaffTicket();
                    ticket.setStt(index++);
                    ticket.setTicketId(rs.getString("ticket_id"));
                    ticket.setRouteName(rs.getString("route_name"));
                    ticket.setDepartureTime(rs.getTimestamp("departure_time"));
                    ticket.setSeatCode(rs.getString("seat_code"));
                    ticket.setDriverName(rs.getString("driver_name"));
                    ticket.setBusType(rs.getString("bus_type_name"));
                    ticket.setPaymentStatus(rs.getString("invoice_status"));
                    ticket.setInvoiceAmount(rs.getDouble("invoice_total_amount"));
                    ticket.setInvoiceId(rs.getInt("invoice_id"));
                    ticket.setInvoiceCode(rs.getString("invoice_code"));
                    ticket.setCustomerName(rs.getString("customer_name"));
                    tickets.add(ticket);
                }
            }
        }
        return tickets;
    }

}
