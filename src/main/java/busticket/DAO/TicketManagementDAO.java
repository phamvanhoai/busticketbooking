/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.Invoices;
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
public class TicketManagementDAO extends DBContext {

    public List<Invoices> getAllInvoices(String ticketCode, String route, String status, int offset, int limit) {
        List<Invoices> invoicesList = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT i.invoice_id, i.invoice_code, i.invoice_total_amount, i.payment_method, i.invoice_status, "
                + "       COUNT(t.ticket_id) AS ticket_count, "
                + "       CONCAT(ls.location_name, N' → ', le.location_name) AS route, "
                + "       tr.departure_time AS departure_time, " // Thêm dòng này để lấy departure_time
                + "       u.user_name AS customer_name "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON t.ticket_id = ii.ticket_id "
                + "JOIN Trips tr ON tr.trip_id = t.trip_id "
                + "JOIN Routes r ON r.route_id = tr.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "WHERE 1=1 "
        );

        // Lọc dữ liệu theo các tham số
        if (ticketCode != null && !ticketCode.isEmpty()) {
            sql.append(" AND i.invoice_code LIKE ?");
        }
        if (route != null && !route.isEmpty()) {
            sql.append(" AND (ls.location_name + ' → ' + le.location_name) LIKE ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND i.invoice_status = ?");
        }

        sql.append(" GROUP BY i.invoice_id, i.invoice_code, i.invoice_total_amount, i.payment_method, i.invoice_status, ls.location_name, le.location_name, u.user_name, tr.departure_time ");
        sql.append(" ORDER BY i.invoice_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (ticketCode != null && !ticketCode.isEmpty()) {
                ps.setString(idx++, "%" + ticketCode + "%");
            }
            if (route != null && !route.isEmpty()) {
                ps.setString(idx++, "%" + route + "%");
            }
            if (status != null && !status.isEmpty()) {
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
                    invoice.setCustomerName(rs.getString("customer_name"));// Gán departureTime cho invoice
                    invoicesList.add(invoice);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return invoicesList;
    }

    public int getTotalInvoicesCount(String ticketCode, String route, String status) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trips trip ON t.trip_id = trip.trip_id "
                + "JOIN Routes r ON trip.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "WHERE 1=1"
        );

        if (ticketCode != null && !ticketCode.isEmpty()) {
            sql.append(" AND i.invoice_code LIKE ?");
        }
        if (route != null && !route.isEmpty()) {
            sql.append(" AND (ls.location_name + ' → ' + le.location_name) LIKE ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND i.invoice_status = ?");
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (ticketCode != null && !ticketCode.isEmpty()) {
                ps.setString(idx++, "%" + ticketCode + "%");
            }
            if (route != null && !route.isEmpty()) {
                ps.setString(idx++, "%" + route + "%");
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
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

    // Để lấy thông tin hóa đơn cụ thể, bạn có thể sử dụng phương thức này trong Servlet
    public Invoices getInvoiceById(int invoiceId) {
        Invoices invoice = null;
        String sql = "SELECT i.invoice_id, i.invoice_code, i.invoice_total_amount, i.payment_method, i.invoice_full_name, "
                + "i.invoice_status, i.paid_at, CONCAT(ls.location_name, N' → ', le.location_name) AS route "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON t.ticket_id = ii.ticket_id "
                + "JOIN Trips tr ON tr.trip_id = t.trip_id "
                + "JOIN Routes r ON r.route_id = tr.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "WHERE i.invoice_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);  // Set the invoiceId parameter

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    invoice = new Invoices();
                    invoice.setInvoiceId(rs.getInt("invoice_id"));
                    invoice.setInvoiceCode(rs.getString("invoice_code"));
                    invoice.setInvoiceTotalAmount(rs.getFloat("invoice_total_amount"));
                    invoice.setPaymentMethod(rs.getString("payment_method"));
                    invoice.setInvoiceStatus(rs.getString("invoice_status"));
                    invoice.setPaidAt(rs.getTimestamp("paid_at"));  // Set the paid_at field
                    invoice.setRoute(rs.getString("route"));  // Set the route
                    invoice.setCustomerName(rs.getString("invoice_full_name")); // Set the customer name from invoice_full_name
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return invoice;
    }

}
