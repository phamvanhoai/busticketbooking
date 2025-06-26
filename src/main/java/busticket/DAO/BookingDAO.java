/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.Tickets;
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
public class BookingDAO extends DBContext {

    public List<Tickets> getAllBookings() {
        List<Tickets> list = new ArrayList<>();
        String sql
                = "SELECT t.ticket_id, u.user_name, "
                + "       CONCAT(r.start_location,N' → ',r.end_location) AS route_name, "
                + "       tr.departure_time, ts.seat_number AS seat_code, "
                + "       d.full_name AS driver_name, bt.bus_type_name AS bus_type, "
                + "       CASE WHEN i.invoice_id IS NOT NULL THEN 'Paid' ELSE 'Unpaid' END AS payment_status "
                + "FROM Tickets t "
                + "JOIN Users u ON t.user_id=u.user_id "
                + "JOIN Trips tr ON t.trip_id=tr.trip_id "
                + "JOIN Routes r ON tr.route_id=r.route_id "
                + "JOIN Trip_Bus tb ON tr.trip_id=tb.trip_id "
                + "JOIN Buses b ON tb.bus_id=b.bus_id "
                + "JOIN Bus_Types bt ON b.bus_type_id=bt.bus_type_id "
                + "LEFT JOIN Ticket_Seat ts ON t.ticket_id=ts.ticket_id "
                + "LEFT JOIN Trip_Driver td ON tr.trip_id=td.trip_id "
                + "LEFT JOIN Drivers d ON td.driver_id=d.driver_id "
                + "LEFT JOIN Invoice_Items ii ON t.ticket_id=ii.ticket_id "
                + "LEFT JOIN Invoices i ON ii.invoice_id=i.invoice_id "
                + "ORDER BY t.ticket_id";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Tickets bk = new Tickets();
                bk.setTicketId(rs.getString("ticket_id"));
                bk.setUserName(rs.getString("user_name"));
                bk.setRouteName(rs.getString("route_name"));
                bk.setDepartureTime(rs.getTimestamp("departure_time"));
                bk.setSeatCode(rs.getString("seat_code"));
                bk.setDriverName(rs.getString("driver_name"));
                bk.setBusType(rs.getString("bus_type"));
                bk.setPaymentStatus(rs.getString("payment_status"));
                list.add(bk);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
