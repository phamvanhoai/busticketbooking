/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.SearchTicket;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class SearchTicketDAO extends DBContext {

    // Phương thức tìm vé theo ticketId hoặc phone
    public List<SearchTicket> searchTickets(String ticketCode, String phone) {
        List<SearchTicket> tickets = new ArrayList<>();

        // Trường hợp không có gì để tìm kiếm
        if (ticketCode == null || ticketCode.isEmpty()) {
            ticketCode = "%";  // Nếu không có ticketCode, lấy tất cả
        }

        if (phone == null || phone.isEmpty()) {
            phone = "%";  // Nếu không có phone, lấy tất cả
        }

        // Câu truy vấn sử dụng ticket_code để liên kết, tìm kiếm bằng ticket_code và invoice_phone
        String query = "SELECT t.ticket_id, t.ticket_code, i.invoice_full_name, ts.seat_number, t.trip_id, "
                + "CONCAT(ls.location_name, ' → ', le.location_name) AS route, "
                + "t.ticket_status, t.ticket_date "
                + "FROM Tickets t "
                + "JOIN Ticket_Seat ts ON t.ticket_code = ts.ticket_code "
                + "JOIN Invoices i ON t.ticket_code = i.ticket_code "
                + "JOIN Routes r ON t.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "WHERE (t.ticket_code LIKE ? OR i.invoice_phone LIKE ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, "%" + ticketCode + "%");  // Tìm theo ticket_code
            ps.setString(2, "%" + phone + "%");      // Tìm theo invoice_phone

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SearchTicket ticket = new SearchTicket();
                    ticket.setTicketId(rs.getInt("ticket_id"));
                    ticket.setTicketCode(rs.getString("ticket_code"));
                    ticket.setPassengerName(rs.getString("invoice_full_name"));
                    ticket.setSeat(rs.getString("seat_number"));
                    ticket.setTripId(rs.getInt("trip_id"));
                    ticket.setRoute(rs.getString("route"));
                    ticket.setStatus(rs.getString("ticket_status"));
                    ticket.setDate(rs.getTimestamp("ticket_date"));
                    tickets.add(ticket);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tickets;
    }

}
