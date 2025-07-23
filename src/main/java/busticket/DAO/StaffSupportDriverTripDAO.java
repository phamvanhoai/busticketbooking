/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.StaffSupportDriverTrip;
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
public class StaffSupportDriverTripDAO extends DBContext {

    public List<StaffSupportDriverTrip> getDriverCancelTripRequests(int offset, int limit) {
        List<StaffSupportDriverTrip> list = new ArrayList<>();
        String sql = "SELECT dr.request_id, t.trip_id, t.route_id, t.departure_time, t.trip_status, "
                + "d.driver_id, u.user_name AS driver_name, "
                + "dr.change_reason, dr.request_status, dr.request_date, "
                + "dr.approved_by_driver_id AS approved_by_staff_id, dr.approval_date "
                + "FROM Driver_Trip_Change_Request dr "
                + "INNER JOIN Drivers d ON dr.driver_id = d.driver_id "
                + "INNER JOIN Users u ON d.user_id = u.user_id "
                + "INNER JOIN Trips t ON dr.trip_id = t.trip_id "
                + "ORDER BY dr.request_date DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StaffSupportDriverTrip req = new StaffSupportDriverTrip();
                    req.setRequestId(rs.getInt("request_id"));
                    req.setTripId(rs.getInt("trip_id"));
                    req.setRouteId(rs.getInt("route_id"));
                    req.setDepartureTime(rs.getTimestamp("departure_time"));
                    req.setTripStatus(rs.getString("trip_status"));
                    req.setDriverId(rs.getInt("driver_id"));
                    req.setDriverName(rs.getString("driver_name"));
                    req.setChangeReason(rs.getString("change_reason"));
                    req.setRequestStatus(rs.getString("request_status"));
                    req.setRequestDate(rs.getTimestamp("request_date"));
                    req.setApprovedByStaffId(rs.getInt("approved_by_staff_id"));
                    req.setApprovalDate(rs.getTimestamp("approval_date"));
                    list.add(req);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching driver cancel trip requests: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public int countDriverCancelTripRequests() {
        String sql = "SELECT COUNT(*) AS total FROM Driver_Trip_Change_Request";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error counting driver cancel trip requests: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public int getTripIdByRequestId(int requestId) {
        String sql = "SELECT trip_id FROM Driver_Trip_Change_Request WHERE request_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("trip_id");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching trip_id for requestId=" + requestId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return -1; // Trả về -1 nếu không tìm thấy
    }

    public boolean updateRequestStatus(int requestId, String status, int staffId) {
        String sql = "UPDATE Driver_Trip_Change_Request "
                + "SET request_status = ?, approval_date = GETDATE(), approved_by_driver_id = ? "
                + "WHERE request_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, staffId);
            ps.setInt(3, requestId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating request status: requestId=" + requestId + ", status=" + status + ", error=" + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateTripStatusTrip(int tripId, String status) {
        String query = "UPDATE Trips SET trip_status = ? WHERE trip_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setInt(2, tripId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating trip status: tripId=" + tripId + ", status=" + status + ", error=" + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateRequestAndTripStatus(int requestId, String requestStatus, String tripStatus, int staffId) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Bắt đầu giao dịch

            // Lấy trip_id từ request_id
            int tripId = getTripIdByRequestId(requestId);
            if (tripId == -1) {
                conn.rollback();
                return false;
            }

            // Cập nhật Driver_Trip_Change_Request
            if (!updateRequestStatus(requestId, requestStatus, staffId)) {
                conn.rollback();
                return false;
            }

            // Cập nhật Trips
            if (!updateTripStatusTrip(tripId, tripStatus)) {
                conn.rollback();
                return false;
            }

            conn.commit(); // Xác nhận giao dịch
            return true;
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.err.println("Error updating request and trip status: requestId=" + requestId + ", error=" + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

}
