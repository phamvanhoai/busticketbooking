/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.model.Booking;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author lyric
 */
public class ViewBookingDAO {

    private Connection conn;

    public ViewBookingDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> bookings = new ArrayList<>();

        String sql 
                = "SELECT "
                + "   t.ticket_code, "
                + "   r.start_location, "
                + "   r.end_location, "
                + "   ts.seat_number, "
                + "   rp.price, "
                + "   tr.departure_time, "
                + "   t.ticket_status "
                + "FROM Tickets t "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "LEFT JOIN Route_Pricing rp ON r.route_id = rp.route_id "
                + "WHERE t.user_id = ? "
                + "AND rp.effective_from <= tr.departure_time "
                + "AND rp.effective_to >= tr.departure_time";

        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String ticketCode = rs.getString("ticket_code");
                String startLocation = rs.getString("start_location");
                String endLocation = rs.getString("end_location");
                String seat = rs.getString("seat_number");
                double fare = rs.getDouble("price");
                String departure = rs.getString("departure_time");
                String status = rs.getString("ticket_status");

                bookings.add(new Booking(ticketCode, startLocation, endLocation, seat, fare, departure, status));
            }

        } catch (SQLException e) {
            e.printStackTrace(); // hoặc ghi log
        }

        return bookings;
    }
}
