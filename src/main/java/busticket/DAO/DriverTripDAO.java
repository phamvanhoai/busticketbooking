/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class DriverTripDAO extends DBContext {

  
    /**
     * Check if a driver has already been assigned to a specific trip.
     * Only one driver is allowed per trip.
     *
     * @param tripId ID of the trip
     * @return true if a driver is already assigned, false otherwise
     */
    public boolean isDriverAssigned(int tripId) {
        String sql = "SELECT COUNT(*) FROM Trip_Driver WHERE trip_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tripId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Assign a driver to a trip by inserting into Trip_Driver table.
     *
     * @param driverId ID of the driver
     * @param tripId ID of the trip
     * @return true if assignment is successful, false otherwise
     */
    public boolean assignDriverToTrip(int driverId, int tripId) {
        String sql = "INSERT INTO Trip_Driver (trip_id, driver_id) VALUES (?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tripId);
            ps.setInt(2, driverId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}