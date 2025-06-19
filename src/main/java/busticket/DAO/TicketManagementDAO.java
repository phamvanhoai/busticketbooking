/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext; // Import lớp DBContext
import busticket.model.Tickets; // Import mô hình Ticket (đã đổi tên từ Ticket thành Tickets theo code của bạn)
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class TicketManagementDAO extends DBContext {

     private static final Logger LOGGER = Logger.getLogger(TicketManagementDAO.class.getName());

    public List<Tickets> getBookingsByUserId(int userId) {
        List<Tickets> bookings = new ArrayList<>();
        String sql = "SELECT t.ticket_id, sl.location_name AS start_location_name, el.location_name AS end_location_name, " +
                     "ts.seat_number, t.ticket_code, rp.price, tr.departure_time, t.ticket_status, " +
                     "pl.location_name AS pickup_location_name, dl.location_name AS dropoff_location_name " +
                     "FROM Tickets t " +
                     "JOIN Trips tr ON t.trip_id = tr.trip_id " +
                     "JOIN Routes r ON tr.route_id = r.route_id " +
                     "JOIN Locations sl ON r.start_location_id = sl.location_id " +
                     "JOIN Locations el ON r.end_location_id = el.location_id " +
                     "JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id " +
                     "LEFT JOIN Route_Pricing rp ON tr.route_id = rp.route_id AND GETDATE() BETWEEN rp.effective_from AND rp.effective_to " +
                     "LEFT JOIN Locations pl ON t.pickup_location_id = pl.location_id " +
                     "LEFT JOIN Locations dl ON t.dropoff_location_id = dl.location_id " +
                     "WHERE t.user_id = ? " +
                     "ORDER BY tr.departure_time DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tickets ticket = new Tickets();
                    ticket.setTicketId(rs.getInt("ticket_id"));
                    ticket.setRouteStartLocation(rs.getString("start_location_name"));
                    ticket.setRouteEndLocation(rs.getString("end_location_name"));
                    ticket.setSeatNumber(rs.getString("seat_number"));
                    ticket.setTicketCode(rs.getString("ticket_code"));
                    ticket.setFare(rs.getDouble("price"));
                    ticket.setDepartureTime(rs.getTimestamp("departure_time"));
                    ticket.setTicketStatus(rs.getString("ticket_status"));
                    bookings.add(ticket);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching bookings for user ID: " + userId, ex);
        }
        return bookings;
    }

    public Tickets getTicketById(int ticketId) {
        // Implementation remains the same
        return null;
    }

    public boolean cancelTicket(int ticketId) {
        String sql = "UPDATE Tickets SET ticket_status = 'Cancelled' WHERE ticket_id = ? AND ticket_status NOT IN ('Cancelled', 'Checked Out')";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error canceling ticket with ID: " + ticketId, ex);
            return false;
        }
    }

    public List<Tickets> getCancellableTicketsByUserId(int userId) {
        List<Tickets> cancellableTickets = new ArrayList<>();
        String sql = "SELECT t.ticket_id, sl.location_name AS start_location_name, el.location_name AS end_location_name, " +
                     "bt.bus_type_name, b.capacity - ISNULL(SUM(CASE WHEN t2.ticket_status NOT IN ('Cancelled', 'Checked Out') THEN 1 ELSE 0 END), 0) AS current_available_seats, " +
                     "rp.price " +
                     "FROM Tickets t " +
                     "JOIN Trips tr ON t.trip_id = tr.trip_id " +
                     "JOIN Routes r ON tr.route_id = r.route_id " +
                     "JOIN Locations sl ON r.start_location_id = sl.location_id " +
                     "JOIN Locations el ON r.end_location_id = el.location_id " +
                     "JOIN Buses b ON tr.bus_id = b.bus_id " +
                     "JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id " +
                     "LEFT JOIN Route_Pricing rp ON tr.route_id = rp.route_id AND GETDATE() BETWEEN rp.effective_from AND rp.effective_to " +
                     "LEFT JOIN Tickets t2 ON tr.trip_id = t2.trip_id AND t2.ticket_status NOT IN ('Cancelled', 'Checked Out') " +
                     "WHERE t.user_id = ? AND t.ticket_status IN ('Confirmed', 'Pending') AND tr.departure_time > GETDATE() " +
                     "GROUP BY t.ticket_id, sl.location_name, el.location_name, bt.bus_type_name, b.capacity, rp.price " +
                     "ORDER BY tr.departure_time ASC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tickets ticket = new Tickets();
                    ticket.setTicketId(rs.getInt("ticket_id"));
                    ticket.setRouteStartLocation(rs.getString("start_location_name"));
                    ticket.setRouteEndLocation(rs.getString("end_location_name"));
                    ticket.setBusType(rs.getString("bus_type_name"));
                    ticket.setAvailableSeats(rs.getInt("current_available_seats"));
                    ticket.setFare(rs.getDouble("price"));
                    cancellableTickets.add(ticket);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching cancellable tickets for user ID: " + userId, ex);
        }
        return cancellableTickets;
    }
}
