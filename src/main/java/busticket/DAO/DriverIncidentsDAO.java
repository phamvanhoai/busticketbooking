/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.DriverAssignedTrip;
import busticket.model.DriverIncidents;
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
public class DriverIncidentsDAO extends DBContext {

    public boolean createIncident(int driverId, Integer tripId, String description, String location, String photoUrl, String incidentType) {
        String query = "INSERT INTO Driver_Incidents (driver_id, trip_id, incident_description, incident_location, incident_photo_url, incident_type, incident_status) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'Pending')";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, driverId);
            ps.setObject(2, tripId); // Cho phép NULL
            ps.setString(3, description);
            ps.setString(4, location);
            ps.setString(5, photoUrl);
            ps.setString(6, incidentType);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error creating incident: driverId=" + driverId + ", tripId=" + tripId + ", description=" + description + ", error=" + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean isValidTripId(int tripId) {
        String query = "SELECT COUNT(*) FROM Trips WHERE trip_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, tripId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error validating tripId=" + tripId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public List<DriverIncidents> getIncidentsByDriver(int driverId, int offset, int limit) {
        List<DriverIncidents> incidents = new ArrayList<>();
        String query = "SELECT incident_id, driver_id, trip_id, incident_description, incident_location, incident_photo_url, incident_type, incident_status, incident_created_at "
                + "FROM Driver_Incidents WHERE driver_id = ? "
                + "ORDER BY incident_created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, driverId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    incidents.add(new DriverIncidents(
                            rs.getInt("incident_id"),
                            rs.getInt("driver_id"),
                            rs.getInt("trip_id") != 0 ? rs.getInt("trip_id") : null,
                            rs.getString("incident_description"),
                            rs.getString("incident_location"),
                            rs.getString("incident_photo_url"),
                            rs.getString("incident_type"),
                            rs.getString("incident_status"),
                            rs.getTimestamp("incident_created_at")
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching incidents: " + e.getMessage());
            e.printStackTrace();
        }
        return incidents;
    }

    public int countIncidentsByDriver(int driverId) {
        String query = "SELECT COUNT(*) AS total FROM Driver_Incidents WHERE driver_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, driverId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error counting incidents: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public int getDriverIdFromUser(int userId) {
        String query = "SELECT driver_id FROM Drivers WHERE user_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("driver_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

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
                + "AND t.trip_status NOT IN ('Cancelled', 'Completed', 'Pending', 'Scheduled')";  // Lọc trạng thái

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
}
