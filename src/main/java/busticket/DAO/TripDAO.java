/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.Trip;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class TripDAO extends DBContext {

    /**
     * Get all trips that have not been assigned any driver yet.
     */
    public List<Trip> getAllAvailableTrips() {
        List<Trip> trips = new ArrayList<>();
        String sql
                = "SELECT trip_id, route_id, departure_time "
                + "FROM Trips "
                + "WHERE trip_id NOT IN ( "
                + "    SELECT trip_id FROM Trip_Driver "
                + ")";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Trip t = new Trip();
                t.setTripId(rs.getString("trip_id"));
                t.setRouteId(rs.getString("route_id"));
                t.setDepartureTime(rs.getTimestamp("departure_time"));
                trips.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return trips;
    }
}
