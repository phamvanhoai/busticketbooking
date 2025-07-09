/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.DriverManageAssignedTrips;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author pc
 */
public class DriverManageAssignedTripsDAO extends DBContext {

    public List<DriverManageAssignedTrips> getAssignedTripsByDriver(int driverId) {
        List<DriverManageAssignedTrips> list = new ArrayList<>();

        String sql =
              "SELECT t.trip_id, t.departure_time, r.route_name, b.bus_type, "
            + "ISNULL(p.passenger_count, 0) AS passenger_count, t.trip_status "
            + "FROM Trips t "
            + "JOIN Routes r ON t.route_id = r.route_id "
            + "JOIN Buses b ON t.bus_id = b.bus_id "
            + "LEFT JOIN ( "
            + "  SELECT trip_id, COUNT(*) AS passenger_count FROM Tickets GROUP BY trip_id "
            + ") p ON t.trip_id = p.trip_id "
            + "WHERE t.driver_id = ? "
            + "ORDER BY t.departure_time ASC";

        try (ResultSet rs = execSelectQuery(sql, new Object[]{driverId})) {
            while (rs.next()) {
                DriverManageAssignedTrips trip = new DriverManageAssignedTrips();
                trip.setTripId(rs.getInt("trip_id"));
                trip.setDepartureTime(rs.getTimestamp("departure_time"));
                trip.setRoute(rs.getString("route_name"));
                trip.setBusType(rs.getString("bus_type"));
                trip.setPassengerCount(rs.getInt("passenger_count"));
                trip.setStatus(rs.getString("trip_status"));
                list.add(trip);
            }

            rs.getStatement().getConnection().close(); // đóng connection
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}