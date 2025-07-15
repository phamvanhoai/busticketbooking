/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.Invoices;
import busticket.model.Review;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import busticket.model.Tickets;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class TicketManagementDAO extends DBContext {

    public List<Invoices> getAllInvoices(int userId, String ticketCode, String route, String status, int offset, int limit) throws SQLException {
        List<Invoices> invoicesList = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT i.invoice_id, i.invoice_code, i.invoice_total_amount, "
                + "i.payment_method, i.invoice_status, "
                + "COUNT(t.ticket_id) AS ticket_count, "
                + "CONCAT(ls.location_name, N' → ', le.location_name) AS route, "
                + "tr.departure_time, "
                + "u.user_name AS customer_name, "
                + "ir.review_rating, "
                + "ir.review_text "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON t.ticket_id = ii.ticket_id "
                + "JOIN Trips tr ON tr.trip_id = t.trip_id "
                + "JOIN Routes r ON r.route_id = tr.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "LEFT JOIN Invoice_Reviews ir ON i.invoice_id = ir.invoice_id "
                + "WHERE i.user_id = ?"
        );

        if (ticketCode != null && !ticketCode.trim().isEmpty()) {
            sql.append(" AND i.invoice_code LIKE ?");
        }
        if (route != null && !route.trim().isEmpty()) {
            sql.append(" AND (ls.location_name + N' → ' + le.location_name) LIKE ?");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND i.invoice_status = ?");
        }

        sql.append(" GROUP BY i.invoice_id, i.invoice_code, i.invoice_total_amount, "
                + "i.payment_method, i.invoice_status, "
                + "ls.location_name, le.location_name, u.user_name, tr.departure_time, "
                + "ir.review_rating, ir.review_text ");
        sql.append(" ORDER BY i.invoice_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, userId);
            if (ticketCode != null && !ticketCode.trim().isEmpty()) {
                ps.setString(idx++, "%" + ticketCode + "%");
            }
            if (route != null && !route.trim().isEmpty()) {
                ps.setString(idx++, "%" + route + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(idx++, status);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, limit);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoices invoice = new Invoices();
                    invoice.setInvoiceId(rs.getInt("invoice_id"));
                    invoice.setInvoiceCode(rs.getString("invoice_code"));
                    invoice.setInvoiceTotalAmount(rs.getFloat("invoice_total_amount"));
                    invoice.setPaymentMethod(rs.getString("payment_method"));
                    invoice.setInvoiceStatus(rs.getString("invoice_status"));
                    invoice.setTicketCount(rs.getInt("ticket_count"));
                    invoice.setRoute(rs.getString("route"));
                    invoice.setDepartureTime(rs.getTimestamp("departure_time"));
                    invoice.setCustomerName(rs.getString("customer_name"));
                    invoice.setReviewRating(rs.getObject("review_rating") != null ? rs.getInt("review_rating") : null);
                    invoice.setReviewText(rs.getString("review_text"));
                    invoice.setReviewed(rs.getObject("review_rating") != null);
                    invoice.setUserId(userId); // Gán userId
                    invoicesList.add(invoice);
                }
            }
        }
        return invoicesList;
    }

    public int getTotalInvoicesCount(int userId, String ticketCode, String route, String status) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(DISTINCT i.invoice_id) "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trips trip ON t.trip_id = trip.trip_id "
                + "JOIN Routes r ON trip.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "WHERE i.user_id = ?"
        );

        if (ticketCode != null && !ticketCode.trim().isEmpty()) {
            sql.append(" AND i.invoice_code LIKE ?");
        }
        if (route != null && !route.trim().isEmpty()) {
            sql.append(" AND (ls.location_name + N' → ' + le.location_name) LIKE ?");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND i.invoice_status = ?");
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, userId);
            if (ticketCode != null && !ticketCode.trim().isEmpty()) {
                ps.setString(idx++, "%" + ticketCode + "%");
            }
            if (route != null && !route.trim().isEmpty()) {
                ps.setString(idx++, "%" + route + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(idx++, status);
            }

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public List<String> getAllLocations() {
        List<String> locations = new ArrayList<>();
        String query = "SELECT DISTINCT location_name FROM Locations";

        try ( PreparedStatement ps = getConnection().prepareStatement(query);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                locations.add(rs.getString("location_name"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return locations;
    }

    // Cập nhật trạng thái hóa đơn và lưu yêu cầu hủy
    public boolean cancelInvoice(String invoiceId, String cancellationReason, int userId) {
        // SQL để cập nhật trạng thái hóa đơn thành 'Cancelled'
        String updateInvoiceSQL = "UPDATE Invoices SET invoice_status = 'Pending Cancellation' WHERE invoice_id = ?";

        // SQL để lưu thông tin yêu cầu hủy vào bảng Invoice_Cancel_Requests
        String insertCancelRequestSQL = "INSERT INTO Invoice_Cancel_Requests (invoice_id, cancel_reason, user_id) VALUES (?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;

        try {
            // Mở kết nối
            conn = getConnection();
            // Bắt đầu giao dịch (transaction)
            conn.setAutoCommit(false);

            // Cập nhật trạng thái hóa đơn
            ps1 = conn.prepareStatement(updateInvoiceSQL);
            ps1.setString(1, invoiceId);
            ps1.executeUpdate();

            // Lưu yêu cầu hủy vào bảng Invoice_Cancel_Requests
            ps2 = conn.prepareStatement(insertCancelRequestSQL);
            ps2.setString(1, invoiceId);
            ps2.setString(2, cancellationReason);
            ps2.setInt(3, userId);
            ps2.executeUpdate();

            // Nếu tất cả các câu lệnh SQL chạy thành công, commit giao dịch
            conn.commit();
            return true;
        } catch (SQLException ex) {
            // Nếu có lỗi xảy ra, rollback giao dịch
            ex.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback(); // Rollback nếu có lỗi
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return false;
        } finally {
            // Đảm bảo rằng các tài nguyên được đóng đúng cách
            try {
                if (ps1 != null) {
                    ps1.close();
                }
                if (ps2 != null) {
                    ps2.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public Invoices getInvoiceById(int invoiceId) {
        Invoices invoice = null;
        String sql = "SELECT i.invoice_id, i.invoice_code, i.invoice_total_amount, "
                + "i.payment_method, i.invoice_full_name, i.invoice_phone, i.invoice_status, i.paid_at, "
                + "CONCAT(ls.location_name, N' → ', le.location_name) AS route, "
                + "tr.departure_time, "
                + "pls.location_name AS pickup_location_name, "
                + "pds.location_name AS dropoff_location_name "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON t.ticket_id = ii.ticket_id "
                + "JOIN Trips tr ON tr.trip_id = t.trip_id "
                + "JOIN Routes r ON r.route_id = tr.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Locations pls ON t.pickup_location_id = pls.location_id " // Pickup location
                + "JOIN Locations pds ON t.dropoff_location_id = pds.location_id " // Dropoff location
                + "WHERE i.invoice_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, invoiceId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    invoice = new Invoices();
                    invoice.setInvoiceId(rs.getInt("invoice_id"));
                    invoice.setInvoiceCode(rs.getString("invoice_code"));
                    invoice.setInvoiceTotalAmount(rs.getFloat("invoice_total_amount"));
                    invoice.setPaymentMethod(rs.getString("payment_method"));
                    invoice.setInvoiceStatus(rs.getString("invoice_status"));
                    invoice.setPaidAt(rs.getTimestamp("paid_at"));
                    invoice.setRoute(rs.getString("route"));
                    invoice.setCustomerName(rs.getString("invoice_full_name"));
                    invoice.setCustomerPhone(rs.getString("invoice_phone"));
                    invoice.setDepartureTime(rs.getTimestamp("departure_time"));

                    // Lấy thông tin về pickup và dropoff location
                    invoice.setPickupLocationName(rs.getString("pickup_location_name"));
                    invoice.setDropoffLocationName(rs.getString("dropoff_location_name"));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return invoice;
    }

    // Thêm review mới
    public boolean addReview(int invoiceId, int rating, String text) {
        String sql = "INSERT INTO Invoice_Reviews (invoice_id, review_rating, review_text, review_created_at) VALUES (?, ?, ?, GETDATE())";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ps.setInt(2, rating);
            ps.setString(3, text);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

// Kiểm tra đã đánh giá chưa
    public boolean hasReviewed(int invoiceId) {
        String sql = "SELECT 1 FROM Invoice_Reviews WHERE invoice_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // Nếu có dòng kết quả nghĩa là đã đánh giá
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean addInvoiceReview(int invoiceId, int rating, String reviewText) {
        String sql = "INSERT INTO Invoice_Reviews (invoice_id, review_rating, review_text, review_created_at) "
                + "VALUES (?, ?, ?, GETDATE())";
        try (
                 Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, invoiceId);
            ps.setInt(2, rating);
            ps.setString(3, reviewText);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Review getReviewByInvoiceId(int invoiceId) {
        String sql = "SELECT review_rating, review_text FROM Invoice_Reviews WHERE invoice_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Review review = new Review();
                review.setRating(rs.getInt("review_rating"));
                review.setText(rs.getString("review_text"));
                return review;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public boolean updateReview(int invoiceId, int rating, String text) {
        String sql = "UPDATE Invoice_Reviews SET review_rating = ?, review_text = ?, review_updated_at = GETDATE() WHERE invoice_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rating);
            ps.setString(2, text);
            ps.setInt(3, invoiceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean updateInvoiceReview(int invoiceId, int rating, String reviewText) {
        String sql = "UPDATE Invoice_Reviews "
                + "SET review_rating = ?, review_text = ?, review_created_at = GETDATE() "
                + "WHERE invoice_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rating);
            ps.setString(2, reviewText);
            ps.setInt(3, invoiceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public List<Tickets> getTicketsByInvoice(int invoiceId) throws SQLException {
        List<Tickets> ticketList = new ArrayList<>();
        String sql = "SELECT t.ticket_id, t.ticket_code, t.ticket_status, ts.seat_number, tr.departure_time "
                + "FROM Tickets t "
                + "JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Invoice_Items ii ON t.ticket_id = ii.ticket_id "
                + "WHERE ii.invoice_id = ?";  // Sử dụng Invoice_Items để liên kết vé và hóa đơn

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId); // Set invoiceId thay vì tìm theo ticket_id

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tickets ticket = new Tickets();
                    ticket.setTicketId(rs.getInt("ticket_id"));
                    ticket.setTicketCode(rs.getString("ticket_code"));
                    ticket.setTicketStatus(rs.getString("ticket_status"));
                    ticket.setSeatNumber(rs.getString("seat_number"));
                    ticket.setDepartureTime(rs.getTimestamp("departure_time"));
                    ticketList.add(ticket);
                }
            }
        }
        return ticketList;
    }

}
