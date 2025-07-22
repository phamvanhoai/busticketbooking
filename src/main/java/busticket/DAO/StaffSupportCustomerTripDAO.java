/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.StaffSupportCustomerTrip;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author pc
 */
public class StaffSupportCustomerTripDAO extends DBContext {

    /**
     * Lấy danh sách yêu cầu theo search/filter và phân trang
     */
    public List<StaffSupportCustomerTrip> getRequests(
            String search, String status,
            int offset, int limit) {

        List<StaffSupportCustomerTrip> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT icr.request_id, icr.invoice_id, inv.invoice_code, "
                + "       u.user_name AS customerName, icr.request_date, "
                + "       icr.cancel_reason, icr.request_status, "
                + "       icr.approved_by_staff_id, icr.approval_date "
                + "FROM Invoice_Cancel_Requests icr "
                + "  JOIN Users u    ON icr.user_id    = u.user_id "
                + "  JOIN Invoices inv ON icr.invoice_id = inv.invoice_id "
                + "WHERE 1=1"
        );

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (CAST(icr.request_id AS varchar) LIKE ? ")
                    .append("      OR inv.invoice_code LIKE ? ")
                    .append("      OR u.user_name LIKE ?)");
        }
        if (status != null && !status.isEmpty() && !"All".equals(status)) {
            sql.append(" AND icr.request_status = ?");
        }
        sql.append(" ORDER BY icr.request_date DESC")
                .append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try ( PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                String like = "%" + search.trim() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            if (status != null && !status.isEmpty() && !"All".equals(status)) {
                ps.setString(idx++, status);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, limit);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StaffSupportCustomerTrip r = new StaffSupportCustomerTrip();
                    r.setRequestId(rs.getInt("request_id"));
                    r.setInvoiceId(rs.getInt("invoice_id"));
                    r.setInvoiceCode(rs.getString("invoice_code"));
                    r.setCustomerName(rs.getString("customerName"));
                    r.setRequestDate(rs.getTimestamp("request_date"));
                    r.setCancelReason(rs.getString("cancel_reason"));
                    r.setRequestStatus(rs.getString("request_status"));
                    r.setApprovedByStaffId(
                            (Integer) rs.getObject("approved_by_staff_id")
                    );
                    r.setApprovalDate(rs.getTimestamp("approval_date"));
                    list.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm tổng số bản ghi theo cùng điều kiện search/filter
     */
    public int getTotalCount(String search, String status) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM Invoice_Cancel_Requests icr "
                + "  JOIN Users u    ON icr.user_id    = u.user_id "
                + "  JOIN Invoices inv ON icr.invoice_id = inv.invoice_id "
                + "WHERE 1=1"
        );

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (CAST(icr.request_id AS varchar) LIKE ? ")
                    .append("      OR inv.invoice_code LIKE ? ")
                    .append("      OR u.user_name LIKE ?)");
        }
        if (status != null && !status.isEmpty() && !"All".equals(status)) {
            sql.append(" AND icr.request_status = ?");
        }

        try ( PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                String like = "%" + search.trim() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            if (status != null && !status.isEmpty() && !"All".equals(status)) {
                ps.setString(idx, status);
            }
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Cập nhật status (Approved/Rejected) trên yêu cầu hủy hoá đơn, nếu
     * Approved thì đánh dấu hoá đơn là Cancelled, nếu Rejected thì đánh dấu hoá
     * đơn về Paid.
     */
//    public void updateStatus(int requestId, String newStatus, int staffId) {
//        Connection conn = null;
//        try {
//            conn = getConnection();
//            conn.setAutoCommit(false);
//
//            // 1) Cập nhật request
//            String sql1 = "UPDATE Invoice_Cancel_Requests "
//                    + "SET request_status = ?, approved_by_staff_id = ?, approval_date = GETDATE() "
//                    + "WHERE request_id = ?";
//            try ( PreparedStatement ps1 = conn.prepareStatement(sql1)) {
//                ps1.setString(1, newStatus);
//                ps1.setInt(2, staffId);
//                ps1.setInt(3, requestId);
//                ps1.executeUpdate();
//            }
//
//            // 2) Cập nhật status của Invoice
//            if ("Approved".equalsIgnoreCase(newStatus)) {
//                String sql2 = "UPDATE Invoices "
//                        + "SET invoice_status = 'Cancelled' "
//                        + "WHERE invoice_id = ("
//                        + "  SELECT invoice_id FROM Invoice_Cancel_Requests WHERE request_id = ?"
//                        + ")";
//                try ( PreparedStatement ps2 = conn.prepareStatement(sql2)) {
//                    ps2.setInt(1, requestId);
//                    ps2.executeUpdate();
//                }
//
//            } else if ("Rejected".equalsIgnoreCase(newStatus)) {
//                String sql3 = "UPDATE Invoices "
//                        + "SET invoice_status = 'Paid' "
//                        + "WHERE invoice_id = ("
//                        + "  SELECT invoice_id FROM Invoice_Cancel_Requests WHERE request_id = ?"
//                        + ")";
//                try ( PreparedStatement ps3 = conn.prepareStatement(sql3)) {
//                    ps3.setInt(1, requestId);
//                    ps3.executeUpdate();
//                }
//            }
//
//            conn.commit();
//        } catch (Exception e) {
//            e.printStackTrace();
//            if (conn != null) {
//                try {
//                    conn.rollback();
//                } catch (Exception ex) {
//                    ex.printStackTrace();
//                }
//            }
//        } finally {
//            if (conn != null) {
//                try {
//                    conn.setAutoCommit(true);
//                    conn.close();
//                } catch (Exception ex) {
//                    ex.printStackTrace();
//                }
//            }
//        }
//    }
//    /**
//     * Updates the status (Approved/Rejected) of an invoice cancellation
//     * request. If Approved, marks the invoice as Cancelled and logs seat
//     * cancellations in Seat_History. If Rejected, marks the invoice as Paid.
//     *
//     * @param requestId the ID of the cancellation request
//     * @param newStatus the new status ("Approved" or "Rejected")
//     * @param staffId the ID of the staff processing the request
//     */
//    public void updateStatus(int requestId, String newStatus, int staffId) {
//        Connection conn = null;
//        try {
//            conn = getConnection();
//            conn.setAutoCommit(false); // Start transaction
//
//            // 1) Update the request status
//            String sql1 = "UPDATE Invoice_Cancel_Requests "
//                    + "SET request_status = ?, approved_by_staff_id = ?, approval_date = GETDATE() "
//                    + "WHERE request_id = ?";
//            try ( PreparedStatement ps1 = conn.prepareStatement(sql1)) {
//                ps1.setString(1, newStatus);
//                ps1.setInt(2, staffId);
//                ps1.setInt(3, requestId);
//                ps1.executeUpdate();
//            }
//
//            // 2) Update the invoice status
//            if ("Approved".equalsIgnoreCase(newStatus)) {
//                // Change invoice status to 'Cancelled'
//                String sql2 = "UPDATE Invoices "
//                        + "SET invoice_status = 'Cancelled' "
//                        + "WHERE invoice_id = ("
//                        + "  SELECT invoice_id FROM Invoice_Cancel_Requests WHERE request_id = ?"
//                        + ")";
//                try ( PreparedStatement ps2 = conn.prepareStatement(sql2)) {
//                    ps2.setInt(1, requestId);
//                    ps2.executeUpdate();
//                }
//
//                // 3) Insert into Seat_History from Ticket_Seat via Invoice_Items
//                String sql3 = "INSERT INTO Seat_History (ticket_id, history_seat_number, trip_id, "
//                        + "history_previous_status, history_current_status, history_changed_at, history_change_reason, invoice_id) "
//                        + "SELECT ts.ticket_id, ts.seat_number, t.trip_id, 'Booked', 'Cancelled', GETDATE(), 'Invoice Cancelled', ii.invoice_id "
//                        + "FROM Ticket_Seat ts "
//                        + "JOIN Tickets t ON ts.ticket_id = t.ticket_id "
//                        + "JOIN Invoice_Items ii ON t.ticket_id = ii.ticket_id "
//                        + "WHERE ii.invoice_id = (SELECT invoice_id FROM Invoice_Cancel_Requests WHERE request_id = ?)";
//                try ( PreparedStatement ps3 = conn.prepareStatement(sql3)) {
//                    ps3.setInt(1, requestId);
//                    int rowsAffected = ps3.executeUpdate();
//                    if (rowsAffected == 0) {
//                        throw new SQLException("No seats found for the invoice to log in Seat_History.");
//                    }
//                }
//
//            } else if ("Rejected".equalsIgnoreCase(newStatus)) {
//                // Change invoice status to 'Paid'
//                String sql4 = "UPDATE Invoices "
//                        + "SET invoice_status = 'Paid' "
//                        + "WHERE invoice_id = ("
//                        + "  SELECT invoice_id FROM Invoice_Cancel_Requests WHERE request_id = ?"
//                        + ")";
//                try ( PreparedStatement ps4 = conn.prepareStatement(sql4)) {
//                    ps4.setInt(1, requestId);
//                    ps4.executeUpdate();
//                }
//            }
//
//            conn.commit(); // Commit transaction
//        } catch (SQLException e) {
//            e.printStackTrace();
//            if (conn != null) {
//                try {
//                    conn.rollback(); // Rollback in case of error
//                } catch (SQLException ex) {
//                    ex.printStackTrace();
//                }
//            }
//            throw new RuntimeException("Failed to update cancellation request status: " + e.getMessage(), e);
//        } finally {
//            if (conn != null) {
//                try {
//                    conn.setAutoCommit(true); // Restore auto-commit
//                    conn.close();
//                } catch (SQLException ex) {
//                    ex.printStackTrace();
//                }
//            }
//        }
//    }
    /**
     * Updates the status (Approved/Rejected) of an invoice cancellation
     * request. If Approved, marks the invoice as Cancelled, updates related
     * tickets to Cancelled, and logs seat cancellations in Seat_History. If
     * Rejected, marks the invoice as Paid.
     *
     * @param requestId the ID of the cancellation request
     * @param newStatus the new status ("Approved" or "Rejected")
     * @param staffId the ID of the staff processing the request
     */
    public void updateStatus(int requestId, String newStatus, int staffId) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1) Update the request status
            String sql1 = "UPDATE Invoice_Cancel_Requests "
                    + "SET request_status = ?, approved_by_staff_id = ?, approval_date = GETDATE() "
                    + "WHERE request_id = ?";
            try ( PreparedStatement ps1 = conn.prepareStatement(sql1)) {
                ps1.setString(1, newStatus);
                ps1.setInt(2, staffId);
                ps1.setInt(3, requestId);
                int rowsAffected1 = ps1.executeUpdate();
                System.out.println("Rows affected in Invoice_Cancel_Requests: " + rowsAffected1);
            }

            // 2) Update the invoice status and related tickets
            if ("Approved".equalsIgnoreCase(newStatus)) {
                // Change invoice status to 'Cancelled'
                String sql2 = "UPDATE Invoices "
                        + "SET invoice_status = 'Cancelled' "
                        + "WHERE invoice_id = ("
                        + "  SELECT invoice_id FROM Invoice_Cancel_Requests WHERE request_id = ?"
                        + ")";
                try ( PreparedStatement ps2 = conn.prepareStatement(sql2)) {
                    ps2.setInt(1, requestId);
                    int rowsAffected2 = ps2.executeUpdate();
                    System.out.println("Rows affected in Invoices: " + rowsAffected2);
                }

                // Update related tickets to 'Cancelled'
                String sql3 = "UPDATE Tickets "
                        + "SET ticket_status = 'Cancelled' "
                        + "WHERE ticket_id IN ("
                        + "  SELECT ticket_id FROM Invoice_Items "
                        + "  WHERE invoice_id = (SELECT invoice_id FROM Invoice_Cancel_Requests WHERE request_id = ?)"
                        + ")";
                try ( PreparedStatement ps3 = conn.prepareStatement(sql3)) {
                    ps3.setInt(1, requestId);
                    int rowsAffected3 = ps3.executeUpdate();
                    System.out.println("Rows affected in Tickets: " + rowsAffected3);
                    if (rowsAffected3 == 0) {
                        System.err.println("Warning: No tickets updated for request_id = " + requestId);
                    }
                }

                // 3) Insert into Seat_History from Ticket_Seat via Invoice_Items
                String sql4 = "INSERT INTO Seat_History (ticket_id, history_seat_number, trip_id, "
                        + "history_previous_status, history_current_status, history_changed_at, history_change_reason, invoice_id) "
                        + "SELECT ts.ticket_id, ts.seat_number, t.trip_id, 'Booked', 'Cancelled', GETDATE(), 'Invoice Cancelled', ii.invoice_id "
                        + "FROM Ticket_Seat ts "
                        + "JOIN Tickets t ON ts.ticket_id = t.ticket_id "
                        + "JOIN Invoice_Items ii ON t.ticket_id = ii.ticket_id "
                        + "WHERE ii.invoice_id = (SELECT invoice_id FROM Invoice_Cancel_Requests WHERE request_id = ?)";
                try ( PreparedStatement ps4 = conn.prepareStatement(sql4)) {
                    ps4.setInt(1, requestId);
                    int rowsAffected4 = ps4.executeUpdate();
                    System.out.println("Rows affected in Seat_History: " + rowsAffected4);
                    if (rowsAffected4 == 0) {
                        System.err.println("Warning: No seats logged in Seat_History for request_id = " + requestId);
                    }
                }

            } else if ("Rejected".equalsIgnoreCase(newStatus)) {
                // Change invoice status to 'Paid'
                String sql5 = "UPDATE Invoices "
                        + "SET invoice_status = 'Paid' "
                        + "WHERE invoice_id = ("
                        + "  SELECT invoice_id FROM Invoice_Cancel_Requests WHERE request_id = ?"
                        + ")";
                try ( PreparedStatement ps5 = conn.prepareStatement(sql5)) {
                    ps5.setInt(1, requestId);
                    int rowsAffected5 = ps5.executeUpdate();
                    System.out.println("Rows affected in Invoices (Rejected): " + rowsAffected5);
                }
            }

            conn.commit(); // Commit transaction
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback in case of error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw new RuntimeException("Failed to update cancellation request status: " + e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Restore auto-commit
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

}
