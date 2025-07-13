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
    private int getDriverIdFromUser(int userId) {
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

    public List<DriverRequestTripChange> getCancelledTripsForDriver(int userId) {
        List<DriverRequestTripChange> cancelledTrips = new ArrayList<>();

        int driverId = getDriverIdFromUser(userId); // Lấy driver_id từ user_id

        if (driverId == -1) { // Nếu không tìm thấy driverId thì trả về danh sách rỗng
            return cancelledTrips;
        }

        // Updated query to get the route information from the Trips and Locations tables
        String query = "SELECT r.request_id, t.trip_id, "
                + "CONCAT(ls.location_name, N' → ', le.location_name) AS route, " // Join trips for route
                + "r.driver_id, r.change_reason, r.request_status, "
                + "r.request_date, r.approval_date "
                + "FROM Driver_Trip_Change_Request r "
                + "JOIN Trips t ON r.trip_id = t.trip_id "
                + "JOIN Routes rt ON t.route_id = rt.route_id "
                + "JOIN Locations ls ON rt.start_location_id = ls.location_id "
                + "JOIN Locations le ON rt.end_location_id = le.location_id "
                + "WHERE r.driver_id = ? AND r.request_status IN ('Pending', 'Approved', 'Rejected')";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, driverId); // Đặt driverId vào câu truy vấn

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

}
