/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.model.InvoiceView;
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
public class InvoiceDAO {

    private Connection conn;

    public InvoiceDAO(Connection conn) {
        this.conn = conn;
    }

    public List<InvoiceView> getInvoicesWithCancelStatusByUserId(int userId) {
        List<InvoiceView> list = new ArrayList<>();

        String sql = "SELECT i.invoice_id, i.invoice_code, i.invoice_total_amount, "
                + "i.payment_method, i.invoice_status, ii.ticket_id, "
                + "tcr.cancel_reason, tr.departure_time "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "LEFT JOIN Ticket_Cancel_Requests tcr ON ii.ticket_id = tcr.ticket_id "
                + "WHERE i.user_id = ?";

        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int invoiceId = rs.getInt("invoice_id");
                String invoiceCode = rs.getString("invoice_code");
                double totalAmount = rs.getDouble("invoice_total_amount");
                String paymentMethod = rs.getString("payment_method");
                String status = rs.getString("invoice_status");
                int ticketId = rs.getInt("ticket_id");
                String cancelReason = rs.getString("cancel_reason");
                String departure = rs.getString("departure_time");

                // ✅ Đây là chỗ bạn cần gõ dòng sau:
                InvoiceView invoice = new InvoiceView(
                        invoiceId, invoiceCode, totalAmount,
                        paymentMethod, status, ticketId,
                        cancelReason, departure
                );

                list.add(invoice);
            }

        } catch (SQLException e) {
            e.printStackTrace(); // hoặc log lỗi
        }

        return list;
    }

    public List<InvoiceView> searchInvoices(int userId, String ticketCode, String departureDate, String route, String status) {
        List<InvoiceView> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT i.invoice_id, i.invoice_code, i.invoice_total_amount, "
                + "i.payment_method, i.invoice_status, ii.ticket_id, "
                + "tcr.cancel_reason, tr.departure_time, r.start_location, r.end_location "
                + "FROM Invoices i "
                + "JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id "
                + "JOIN Tickets t ON ii.ticket_id = t.ticket_id "
                + "JOIN Trips tr ON t.trip_id = tr.trip_id "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "LEFT JOIN Ticket_Cancel_Requests tcr ON ii.ticket_id = tcr.ticket_id "
                + "WHERE i.user_id = ?");

        // Thêm các điều kiện nếu có
        if (ticketCode != null && !ticketCode.isEmpty()) {
            sql.append(" AND i.invoice_code LIKE ?");
        }
        if (departureDate != null && !departureDate.isEmpty()) {
            sql.append(" AND CAST(tr.departure_time AS DATE) = ?");
        }
        if (route != null && !route.isEmpty()) {
            sql.append(" AND (r.start_location + ' → ' + r.end_location) LIKE ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND i.invoice_status = ?");
        }

        try ( PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setInt(index++, userId);

            if (ticketCode != null && !ticketCode.isEmpty()) {
                ps.setString(index++, "%" + ticketCode + "%");
            }
            if (departureDate != null && !departureDate.isEmpty()) {
                ps.setString(index++, departureDate);
            }
            if (route != null && !route.isEmpty()) {
                ps.setString(index++, "%" + route + "%");
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int invoiceId = rs.getInt("invoice_id");
                String invoiceCode = rs.getString("invoice_code");
                double totalAmount = rs.getDouble("invoice_total_amount");
                String paymentMethod = rs.getString("payment_method");
                String invoiceStatus = rs.getString("invoice_status");
                int ticketId = rs.getInt("ticket_id");
                String cancelReason = rs.getString("cancel_reason");
                String departureTime = rs.getString("departure_time");

                InvoiceView iv = new InvoiceView(
                        invoiceId, invoiceCode, totalAmount,
                        paymentMethod, invoiceStatus, ticketId,
                        cancelReason, departureTime
                );

                list.add(iv);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
