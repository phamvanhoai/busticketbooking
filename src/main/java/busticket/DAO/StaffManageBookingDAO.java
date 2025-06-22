/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
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
public class StaffManageBookingDAO extends DBContext {

    /**
     * Retrieves all ticket bookings including customer, trip, seat, driver, bus
     * type, payment status, and invoice amount.
     *
     * @return a list of StaffTicket objects containing booking details
     */
    public List<StaffTicket> getAllBookings() {
        List<StaffTicket> list = new ArrayList<>();

        String sql = "SELECT t.ticket_id, u.user_name AS customer_name, "
                + "ISNULL(ls.location_name, '') + ' &rarr; ' + ISNULL(le.location_name, '') AS route_name, "
                + "tr.departure_time, ts.seat_number, u2.user_name AS driver_name, "
                + "bt.bus_type_name, "
                + "CASE WHEN i.invoice_id IS NOT NULL THEN 'Paid' ELSE 'Unpaid' END AS payment_status, "
                + "i.invoice_total_amount, i.payment_method, i.paid_at "
                + "FROM Tickets t "
                + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "LEFT JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "LEFT JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + "LEFT JOIN Users u2 ON d.user_id = u2.user_id "
                + "LEFT JOIN Trip_Bus tb ON tr.trip_id = tb.trip_id "
                + "LEFT JOIN Buses b ON tb.bus_id = b.bus_id "
                + "LEFT JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + "LEFT JOIN Invoice_Items ii ON t.ticket_id = ii.ticket_id "
                + "LEFT JOIN Invoices i ON ii.invoice_id = i.invoice_id "
                + "ORDER BY t.ticket_id DESC";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                StaffTicket s = new StaffTicket();
                s.setTicketId(rs.getString("ticket_id"));
                s.setUserName(rs.getString("customer_name"));
                s.setRouteName(rs.getString("route_name"));
                s.setDepartureTime(rs.getTimestamp("departure_time"));
                s.setSeatCode(rs.getString("seat_number"));
                s.setDriverName(rs.getString("driver_name"));
                s.setBusType(rs.getString("bus_type_name"));
                s.setPaymentStatus(rs.getString("payment_status"));
                s.setInvoiceAmount(rs.getBigDecimal("invoice_total_amount")); // ✅ Đã thêm
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Retrieves a specific booking by ticket ID, including invoice amount.
     *
     * @param ticketId the ID of the ticket to find
     * @return the StaffTicket object matching the given ID, or null if not
     * found
     */
    public StaffTicket getBookingById(String ticketId) {
        String sql = "SELECT t.ticket_id, u.user_name AS customer_name, "
                + "ISNULL(ls.location_name, '') + ' &rarr; ' + ISNULL(le.location_name, '') AS route_name, "
                + "tr.departure_time, ts.seat_number, u2.user_name AS driver_name, "
                + "bt.bus_type_name, "
                + "CASE WHEN i.invoice_id IS NOT NULL THEN 'Paid' ELSE 'Unpaid' END AS payment_status, "
                + "i.invoice_total_amount, i.payment_method, i.paid_at "
                + "FROM Tickets t "
                + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "LEFT JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "LEFT JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + "LEFT JOIN Users u2 ON d.user_id = u2.user_id "
                + "LEFT JOIN Trip_Bus tb ON tr.trip_id = tb.trip_id "
                + "LEFT JOIN Buses b ON tb.bus_id = b.bus_id "
                + "LEFT JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + "LEFT JOIN Invoice_Items ii ON t.ticket_id = ii.ticket_id "
                + "LEFT JOIN Invoices i ON ii.invoice_id = i.invoice_id "
                + "WHERE t.ticket_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ticketId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                StaffTicket ticket = new StaffTicket();
                ticket.setTicketId(rs.getString("ticket_id"));
                ticket.setUserName(rs.getString("customer_name"));
                ticket.setRouteName(rs.getString("route_name"));
                ticket.setDepartureTime(rs.getTimestamp("departure_time"));
                ticket.setSeatCode(rs.getString("seat_number"));
                ticket.setDriverName(rs.getString("driver_name"));
                ticket.setBusType(rs.getString("bus_type_name"));
                ticket.setPaymentStatus(rs.getString("payment_status"));
                ticket.setInvoiceAmount(rs.getBigDecimal("invoice_total_amount"));
                ticket.setPaymentMethod(rs.getString("payment_method"));
                ticket.setPaidAt(rs.getTimestamp("paid_at"));

                return ticket;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves all ticket bookings including customer, trip, seat, driver, bus
     * type, payment status, and invoice amount.
     *
     * @return a list of StaffTicket objects containing booking details
     */
    public List<StaffTicket> getFilteredBookings(String search, String date, String routeId) {
        List<StaffTicket> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT t.ticket_id, u.user_name AS customer_name, "
                + "ISNULL(ls.location_name, '') + ' &rarr; ' + ISNULL(le.location_name, '') AS route_name, "
                + "tr.departure_time, ts.seat_number, u2.user_name AS driver_name, "
                + "bt.bus_type_name, "
                + "CASE WHEN i.invoice_id IS NOT NULL THEN 'Paid' ELSE 'Unpaid' END AS payment_status, "
                + "i.invoice_total_amount, i.payment_method, i.paid_at "
                + "FROM Tickets t "
                + "JOIN Users u ON t.user_id = u.user_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "LEFT JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "LEFT JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + "LEFT JOIN Users u2 ON d.user_id = u2.user_id "
                + "LEFT JOIN Trip_Bus tb ON tr.trip_id = tb.trip_id "
                + "LEFT JOIN Buses b ON tb.bus_id = b.bus_id "
                + "LEFT JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + "LEFT JOIN Invoice_Items ii ON t.ticket_id = ii.ticket_id "
                + "LEFT JOIN Invoices i ON ii.invoice_id = i.invoice_id "
                + "WHERE 1=1 ");

        if (search != null && !search.isEmpty()) {
            sql.append("AND (t.ticket_id LIKE ? OR u.user_name LIKE ? OR ");
            sql.append("ISNULL(ls.location_name, '') + ' &rarr; ' + ISNULL(le.location_name, '') LIKE ?) ");
        }
        if (date != null && !date.isEmpty()) {
            sql.append("AND CAST(tr.departure_time AS DATE) = ? ");
        }
        if (routeId != null && !routeId.isEmpty()) {
            sql.append("AND r.route_id = ? ");
        }

        sql.append("ORDER BY t.ticket_id DESC");

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            if (search != null && !search.isEmpty()) {
                ps.setString(index++, "%" + search + "%");
                ps.setString(index++, "%" + search + "%");
                ps.setString(index++, "%" + search + "%");
            }

            if (date != null && !date.isEmpty()) {
                ps.setDate(index++, java.sql.Date.valueOf(date));
            }
            if (routeId != null && !routeId.isEmpty()) {
                ps.setString(index++, routeId);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StaffTicket s = new StaffTicket();
                s.setTicketId(rs.getString("ticket_id"));
                s.setUserName(rs.getString("customer_name"));
                s.setRouteName(rs.getString("route_name"));
                s.setDepartureTime(rs.getTimestamp("departure_time"));
                s.setSeatCode(rs.getString("seat_number"));
                s.setDriverName(rs.getString("driver_name"));
                s.setBusType(rs.getString("bus_type_name"));
                s.setPaymentStatus(rs.getString("payment_status"));
                s.setInvoiceAmount(rs.getBigDecimal("invoice_total_amount"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Retrieves a distinct list of route IDs and route names for filtering.
     *
     * @return List of route options
     */
    public List<StaffTicket> getDistinctRoutes() {
        List<StaffTicket> routes = new ArrayList<>();
        String sql = "SELECT DISTINCT r.route_id, "
                + "ISNULL(ls.location_name, '') + ' &rarr; ' + ISNULL(le.location_name, '') AS route_name "
                + "FROM Routes r "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                StaffTicket route = new StaffTicket();
                route.setRouteId(rs.getString("route_id"));
                route.setRouteName(rs.getString("route_name"));
                routes.add(route);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return routes;
    }

}
