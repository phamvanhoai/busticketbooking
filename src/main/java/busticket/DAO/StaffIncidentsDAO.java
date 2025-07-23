/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.DriverIncidents;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class StaffIncidentsDAO extends DBContext{
    public List<DriverIncidents> getAllIncidents(int offset, int limit) {
        List<DriverIncidents> incidents = new ArrayList<>();
        String query = "SELECT incident_id, driver_id, trip_id, incident_description, incident_location, incident_photo_url, "
                + "incident_type, incident_status, incident_created_at, incident_updated_at, incident_note, incident_support_by "
                + "FROM Driver_Incidents "
                + "ORDER BY incident_created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
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
                            rs.getTimestamp("incident_created_at"),
                            rs.getTimestamp("incident_updated_at"),
                            rs.getString("incident_note"),
                            rs.getInt("incident_support_by") != 0 ? rs.getInt("incident_support_by") : null
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching incidents: " + e.getMessage());
            e.printStackTrace();
        }
        return incidents;
    }

    public DriverIncidents getIncidentById(int incidentId) {
        String query = "SELECT incident_id, driver_id, trip_id, incident_description, incident_location, incident_photo_url, "
                + "incident_type, incident_status, incident_created_at, incident_updated_at, incident_note, incident_support_by "
                + "FROM Driver_Incidents WHERE incident_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, incidentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new DriverIncidents(
                            rs.getInt("incident_id"),
                            rs.getInt("driver_id"),
                            rs.getInt("trip_id") != 0 ? rs.getInt("trip_id") : null,
                            rs.getString("incident_description"),
                            rs.getString("incident_location"),
                            rs.getString("incident_photo_url"),
                            rs.getString("incident_type"),
                            rs.getString("incident_status"),
                            rs.getTimestamp("incident_created_at"),
                            rs.getTimestamp("incident_updated_at"),
                            rs.getString("incident_note"),
                            rs.getInt("incident_support_by") != 0 ? rs.getInt("incident_support_by") : null
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching incident: incidentId=" + incidentId + ", error=" + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    public String getStaffNameById(int staffId) {
        String query = "SELECT user_name FROM Users WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("user_name");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching staff name: staffId=" + staffId + ", error=" + e.getMessage());
            e.printStackTrace();
        }
        return "N/A";
    }

    public String getDriverNameById(int driverId) {
        String query = "SELECT u.user_name FROM Users u JOIN Drivers d ON u.user_id = d.user_id WHERE d.driver_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, driverId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("user_name");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching driver name: driverId=" + driverId + ", error=" + e.getMessage());
            e.printStackTrace();
        }
        return "N/A";
    }

    public String getTripNameById(Integer tripId) {
        if (tripId == null) {
            return "N/A";
        }
        String query = "SELECT CONCAT(ls.location_name, N' → ', le.location_name) AS trip_name "
                + "FROM Trips t "
                + "JOIN Routes r ON t.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "WHERE t.trip_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, tripId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("trip_name");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching trip name: tripId=" + tripId + ", error=" + e.getMessage());
            e.printStackTrace();
        }
        return "N/A";
    }

    public int countAllIncidents() {
        String query = "SELECT COUNT(*) AS total FROM Driver_Incidents";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            try (ResultSet rs = ps.executeQuery()) {
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

    public boolean updateIncident(int incidentId, String status, String incidentNote, int staffId) {
        String query = "UPDATE Driver_Incidents SET incident_status = ?, incident_note = ?, incident_support_by = ?, incident_updated_at = ? WHERE incident_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setString(2, incidentNote);
            ps.setInt(3, staffId);
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(5, incidentId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating incident: incidentId=" + incidentId + ", error=" + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
