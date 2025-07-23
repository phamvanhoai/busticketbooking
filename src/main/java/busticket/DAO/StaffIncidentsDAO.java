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
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now())); // Cập nhật thời gian hiện tại
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
