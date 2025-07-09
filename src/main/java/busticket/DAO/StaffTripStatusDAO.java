/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

/**
 *
 * @author admin
 */
import busticket.db.DBContext;
import busticket.model.StaffPassenger;
import busticket.model.StaffRouteStop;
import busticket.model.StaffTripStatus;
import busticket.model.StaffTripDetail;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StaffTripStatusDAO extends DBContext {

    public List<StaffTripStatus> getFilteredTrips(String search, int offset, int limit) {
        List<StaffTripStatus> trips = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT t.trip_id, ")
           .append("ls.location_name AS start_location, ")
           .append("le.location_name AS end_location, ")
           .append("t.departure_time, ")
           .append("DATEADD(MINUTE, 240, t.departure_time) AS arrival_time, ")
           .append("u.user_name AS driver_name, ")
           .append("bt.bus_type_name, ")
           .append("t.trip_status ")
           .append("FROM Trips t ")
           .append("JOIN Routes r ON t.route_id = r.route_id ")
           .append("JOIN Locations ls ON r.start_location_id = ls.location_id ")
           .append("JOIN Locations le ON r.end_location_id = le.location_id ")
           .append("JOIN Drivers d ON t.driver_id = d.driver_id ")
           .append("JOIN Users u ON d.user_id = u.user_id ")
           .append("JOIN Buses b ON t.bus_id = b.bus_id ")
           .append("JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id ")
           .append("WHERE 1=1 ");
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (CAST(t.trip_id AS VARCHAR) LIKE ? OR ls.location_name LIKE ? OR le.location_name LIKE ?)");
        }
        sql.append(" ORDER BY t.trip_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int i = 1;
            if (search != null && !search.isEmpty()) {
                ps.setString(i++, "%" + search + "%");
                ps.setString(i++, "%" + search + "%");
                ps.setString(i++, "%" + search + "%");
            }
            ps.setInt(i++, offset);
            ps.setInt(i, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StaffTripStatus trip = new StaffTripStatus();
                trip.setTripId(rs.getInt("trip_id"));
                trip.setStartLocation(rs.getString("start_location"));
                trip.setEndLocation(rs.getString("end_location"));
                trip.setDepartureTime(rs.getTimestamp("departure_time"));
                trip.setArrivalTime(rs.getTimestamp("arrival_time"));
                trip.setDriverName(rs.getString("driver_name"));
                trip.setBusType(rs.getString("bus_type_name"));
                trip.setTripStatus(rs.getString("trip_status"));
                trips.add(trip);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error retrieving filtered trips", e);
        }
        return trips;
    }

    public int countFilteredTrips(String search) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) AS total ")
           .append("FROM Trips t ")
           .append("JOIN Routes r ON t.route_id = r.route_id ")
           .append("JOIN Locations ls ON r.start_location_id = ls.location_id ")
           .append("JOIN Locations le ON r.end_location_id = le.location_id ")
           .append("JOIN Drivers d ON t.driver_id = d.driver_id ")
           .append("JOIN Users u ON d.user_id = u.user_id ")
           .append("JOIN Buses b ON t.bus_id = b.bus_id ")
           .append("JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id ")
           .append("WHERE 1=1 ");
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (CAST(t.trip_id AS VARCHAR) LIKE ? OR ls.location_name LIKE ? OR le.location_name LIKE ?)");
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int i = 1;
            if (search != null && !search.isEmpty()) {
                ps.setString(i++, "%" + search + "%");
                ps.setString(i++, "%" + search + "%");
                ps.setString(i++, "%" + search + "%");
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error counting filtered trips", e);
        }
        return 0;
    }

    public StaffTripDetail getTripDetail(int tripId) {
        StaffTripDetail detail = new StaffTripDetail();
        String sql = "SELECT t.trip_id, ls.location_name AS start_location, le.location_name AS end_location, " +
                     "t.departure_time, DATEADD(MINUTE, 240, t.departure_time) AS arrival_time, " +
                     "u.user_name AS driver_name, bt.bus_type_name, t.trip_status " +
                     "FROM Trips t " +
                     "JOIN Routes r ON t.route_id = r.route_id " +
                     "JOIN Locations ls ON r.start_location_id = ls.location_id " +
                     "JOIN Locations le ON r.end_location_id = le.location_id " +
                     "JOIN Drivers d ON t.driver_id = d.driver_id " +
                     "JOIN Users u ON d.user_id = u.user_id " +
                     "JOIN Buses b ON t.bus_id = b.bus_id " +
                     "JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id " +
                     "WHERE t.trip_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                detail.setTripId(rs.getInt("trip_id"));
                detail.setStartLocation(rs.getString("start_location"));
                detail.setEndLocation(rs.getString("end_location"));
                detail.setDepartureTime(rs.getTimestamp("departure_time"));
                detail.setArrivalTime(rs.getTimestamp("arrival_time"));
                detail.setDriverName(rs.getString("driver_name"));
                detail.setBusType(rs.getString("bus_type_name"));
                detail.setTripStatus(rs.getString("trip_status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return detail;
    }

    public List<StaffRouteStop> getRouteStops(int tripId) {
        List<StaffRouteStop> list = new ArrayList<>();
        StaffRouteStop stop = new StaffRouteStop();
        stop.setTime("08:00");
        stop.setLocation("Cà Mau");
        stop.setAddress("Phường 6, Tp. Cà Mau, Cà Mau, Việt Nam");
        list.add(stop);
        return list;
    }

    public List<StaffPassenger> getPassengerList(int tripId) {
        List<StaffPassenger> list = new ArrayList<>();
        StaffPassenger p = new StaffPassenger();
        p.setName("Nguyen Thi Lan");
        list.add(p);
        return list;
    }
}