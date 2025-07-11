/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.DriverAssignedTrip;
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
public class DriverAssignedTripsDAO extends DBContext{
    
    
    // Get the trips assigned to the driver
    public List<DriverAssignedTrip> getAssignedTrips(int driverId) {
        List<DriverAssignedTrip> trips = new ArrayList<>();
        String query = "SELECT t.trip_id, t.date, t.time, t.route, t.bus_type, t.passengers, t.status " +
                       "FROM trips t " +
                       "JOIN Trip_Driver td ON t.trip_id = td.trip_id " +
                       "WHERE td.driver_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                DriverAssignedTrip trip = new DriverAssignedTrip();
                trip.setTripId(rs.getInt("trip_id"));
                trip.setDate(rs.getDate("date"));
                trip.setTime(rs.getTime("time"));
                trip.setRoute(rs.getString("route"));
                trip.setBusType(rs.getString("bus_type"));
                trip.setPassengers(rs.getInt("passengers"));
                trip.setStatus(rs.getString("status"));
                trips.add(trip);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trips;
    }

}
