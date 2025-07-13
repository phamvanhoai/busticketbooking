/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.DriverAssignedTrip;
import busticket.model.DriverRequestTripChange;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author pc
 */
public class DriverRequestTripChangeDAO extends DBContext {

    public List<DriverAssignedTrip> getAssignedTripsForDriver(int userId) {
        List<DriverAssignedTrip> trips = new ArrayList<>();
        int driverId = getDriverIdFromUser(userId); // Lấy driver_id từ user_id

        if (driverId == -1) { // Nếu không tìm thấy driverId thì trả về danh sách rỗng
            return trips;
        }

        // Truy vấn SQL để lấy danh sách chuyến đi của tài xế mà không có các trạng thái "Cancelled", "Completed", "Ongoing"
        String query = "SELECT t.trip_id, "
                + "CONCAT(ls.location_name, N' → ', le.location_name) AS route, "
                + "CAST(t.departure_time AS DATE) AS trip_date, "
                + "CONVERT(VARCHAR(5), t.departure_time, 108) AS trip_time "
                + "FROM Trips t "
                + "JOIN Routes r ON t.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "LEFT JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + "WHERE d.driver_id = ? "
                + "AND t.trip_status NOT IN ('Cancelled', 'Completed', 'Ongoing')";  // Lọc trạng thái

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, driverId); // Đặt driverId vào câu truy vấn

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DriverAssignedTrip trip = new DriverAssignedTrip();
                    trip.setTripId(rs.getInt("trip_id"));
                    trip.setRoute(rs.getString("route"));
                    trip.setDate(rs.getDate("trip_date"));
                    trip.setTime(rs.getString("trip_time"));
                    trips.add(trip);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trips;
    }

    // Phương thức lấy driver_id từ user_id
    public int getDriverIdFromUser(int userId) {
        String query = "SELECT driver_id FROM Drivers WHERE user_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);  // Đặt userId vào câu truy vấn

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("driver_id"); // Trả về driver_id nếu tìm thấy
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Trả về -1 nếu không tìm thấy driver_id
    }

    // Phương thức này lấy danh sách yêu cầu hủy chuyến cho tài xế với phân trang
    public List<DriverRequestTripChange> getCancelledTripsForDriver(int userId, int offset, int limit) {
        List<DriverRequestTripChange> cancelledTrips = new ArrayList<>();

        int driverId = getDriverIdFromUser(userId); // Lấy driver_id từ user_id

        if (driverId == -1) { // Nếu không tìm thấy driverId thì trả về danh sách rỗng
            return cancelledTrips;
        }

        // Cập nhật truy vấn để hỗ trợ phân trang
        String query = "SELECT r.request_id, t.trip_id, "
                + "CONCAT(ls.location_name, N' → ', le.location_name) AS route, " // Join trips for route
                + "r.driver_id, r.change_reason, r.request_status, "
                + "r.request_date, r.approval_date "
                + "FROM Driver_Trip_Change_Request r "
                + "JOIN Trips t ON r.trip_id = t.trip_id "
                + "JOIN Routes rt ON t.route_id = rt.route_id "
                + "JOIN Locations ls ON rt.start_location_id = ls.location_id "
                + "JOIN Locations le ON rt.end_location_id = le.location_id "
                + "WHERE r.driver_id = ? AND r.request_status IN ('Pending', 'Approved', 'Rejected') "
                + "ORDER BY r.request_date DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"; // Thêm phân trang với OFFSET và LIMIT

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, driverId); // Đặt driverId vào câu truy vấn
            ps.setInt(2, offset); // Thêm offset
            ps.setInt(3, limit); // Thêm limit

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DriverRequestTripChange request = new DriverRequestTripChange();
                    request.setRequestId(rs.getInt("request_id"));
                    request.setTripId(rs.getInt("trip_id"));
                    request.setRoute(rs.getString("route"));
                    request.setRequestedBy(rs.getString("driver_id"));
                    request.setRequestReason(rs.getString("change_reason"));
                    request.setStatus(rs.getString("request_status"));
                    request.setRequestDate(rs.getTimestamp("request_date"));
                    request.setApprovalDate(rs.getTimestamp("approval_date"));
                    cancelledTrips.add(request);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cancelledTrips;
    }

    // Phương thức này đếm tổng số yêu cầu hủy chuyến của tài xế
    public int countDriverCancelTripRequests(int userId) {
        int driverId = getDriverIdFromUser(userId); // Lấy driver_id từ user_id
        if (driverId == -1) {
            return 0; // Nếu không tìm thấy driverId thì trả về 0
        }

        String query = "SELECT COUNT(*) AS total FROM Driver_Trip_Change_Request "
                + "WHERE driver_id = ? AND request_status IN ('Pending', 'Approved', 'Rejected')";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, driverId); // Đặt driverId vào câu truy vấn

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public boolean createTripChangeRequest(DriverRequestTripChange request) {
        String query = "INSERT INTO Driver_Trip_Change_Request (trip_id, driver_id, change_reason, request_status, request_date) "
                + "VALUES (?, ?, ?, ?, ?)";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, request.getTripId());
            ps.setInt(2, request.getRequestId());
            ps.setString(3, request.getRequestReason());
            ps.setString(4, request.getStatus());
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis())); // Thời gian yêu cầu

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Nếu ít nhất 1 dòng được cập nhật, yêu cầu được tạo thành công
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateTripStatusToPending(int tripId) {
        String query = "UPDATE Trips SET trip_status = 'Pending' WHERE trip_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, tripId); // Đặt tripId vào câu truy vấn
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Nếu ít nhất 1 dòng được cập nhật, trả về true
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
