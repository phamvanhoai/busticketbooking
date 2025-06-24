/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.Driver;
import busticket.model.StaffRoute;
import busticket.model.StaffTrip;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffAssignDriverDAO extends DBContext {

    /**
     * Retrieves all trips that depart on a specific date.
     *
     * @param dateFilter The date to filter trips by.
     * @return A list of StaffTrip objects for the given date.
     * @throws SQLException if a database access error occurs.
     */
    public List<StaffTrip> getTripsByDate(java.time.LocalDate dateFilter) throws SQLException {
        List<StaffTrip> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT tr.trip_id, tr.departure_time, "
                + "CONCAT(ls.location_name, N' → ', le.location_name) AS route_name, "
                + "u.user_name AS driver_name, "
                + "b.plate_number, bt.bus_type_name "
                + "FROM Trips tr "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Buses b ON tr.bus_id = b.bus_id "
                + "JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + "LEFT JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE CAST(tr.departure_time AS DATE) = ? "
                + "ORDER BY tr.departure_time";

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDate(1, Date.valueOf(dateFilter));
            rs = ps.executeQuery();
            while (rs.next()) {
                StaffTrip trip = new StaffTrip();
                trip.setTripId(rs.getInt("trip_id"));
                trip.setDepartureTime(rs.getTimestamp("departure_time"));
                trip.setRouteName(rs.getString("route_name"));
                trip.setDriverName(rs.getString("driver_name"));
                trip.setPlateNumber(rs.getString("plate_number"));
                trip.setBusTypeName(rs.getString("bus_type_name"));
                list.add(trip);
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return list;
    }

    /**
     * Retrieves all drivers who are marked as "Active" and available for
     * assignment.
     *
     * @return A list of available Driver objects.
     * @throws SQLException if a database access error occurs.
     */
    public List<Driver> getAvailableDrivers() throws SQLException {
        List<Driver> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT d.driver_id, u.user_name "
                + "FROM Drivers d "
                + "JOIN Users u ON d.user_id = u.user_id "
                + "WHERE d.driver_status = 'Active' "
                + "ORDER BY u.user_name";

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Driver d = new Driver();
                d.setDriverId(rs.getInt("driver_id"));
                d.setDriverName(rs.getString("user_name"));
                list.add(d);
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

        return list;
    }

    /**
     * Assigns a driver to a trip by inserting a new record into the Trip_Driver
     * table.
     *
     * @param tripId The ID of the trip to assign.
     * @param driverId The ID of the driver to assign.
     * @throws SQLException if a database access error occurs.
     */
    public void assignDriver(int tripId, int driverId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "INSERT INTO Trip_Driver (trip_id, driver_id) VALUES (?, ?)";

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, tripId);
            ps.setInt(2, driverId);
            ps.executeUpdate();
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }

    /**
     * Removes a driver assignment from a trip.
     *
     * @param tripId The ID of the trip to remove the driver from.
     * @throws SQLException if a database access error occurs.
     */
    public void removeDriver(int tripId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "DELETE FROM Trip_Driver WHERE trip_id = ?";

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, tripId);
            ps.executeUpdate();
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }

    /**
     * Checks whether a driver has already been assigned to a given trip.
     *
     * @param tripId The ID of the trip to check.
     * @return true if a driver is already assigned, false otherwise.
     * @throws SQLException if a database access error occurs.
     */
    public boolean isDriverAssigned(int tripId) throws SQLException {
        String sql = "SELECT 1 FROM Trip_Driver WHERE trip_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try ( ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Inserts a new driver assignment for a trip.
     *
     * @param driverId The ID of the driver to assign.
     * @param tripId The ID of the trip to assign the driver to.
     * @return true if the insertion is successful, false otherwise.
     * @throws SQLException if a database access error occurs.
     */
    public boolean assignDriverToTrip(int driverId, int tripId) throws SQLException {
        String sql = "INSERT INTO Trip_Driver (trip_id, driver_id) VALUES (?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            ps.setInt(2, driverId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Updates the existing driver assignment of a trip.
     *
     * @param driverId The ID of the new driver to assign.
     * @param tripId The ID of the trip to update.
     * @return true if the update is successful, false otherwise.
     * @throws SQLException if a database access error occurs or if the update
     * violates constraints (e.g., duplicate assignment).
     */
    public boolean updateDriverAssignment(int driverId, int tripId) throws SQLException {
        String sql = "UPDATE Trip_Driver SET driver_id = ? WHERE trip_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ps.setInt(2, tripId);
            return ps.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            throw new SQLException("This driver has already been assigned to a trip by another staff member.", e);
        }
    }

    /**
     * Counts the total number of trips based on search filters.
     *
     * @param search Keyword to search for trip ID, route, or driver name.
     * @param date Date string to filter trips.
     * @param routeId Route ID to filter trips.
     * @param status Trip status ("assigned" or "unassigned").
     * @return The total count of filtered trips.
     * @throws SQLException if a database access error occurs.
     */
    public int countAvailableTrips(String search, String date, String routeId, String status) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Trips tr "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Buses b ON tr.bus_id = b.bus_id "
                + "JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + "LEFT JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            search = search.trim().toLowerCase().replaceAll("\\s+", " ");
            sql.append("AND (")
                    .append("LOWER('Trip ' + CAST(tr.trip_id AS VARCHAR)) LIKE ? ")
                    .append("OR LOWER(u.user_name) LIKE ? ")
                    .append("OR LOWER(ls.location_name) LIKE ? ")
                    .append("OR LOWER(le.location_name) LIKE ? ")
                    .append("OR LOWER(b.plate_number) LIKE ? ")
                    .append("OR LOWER(bt.bus_type_name) LIKE ? ")
                    .append(") ");
            for (int i = 0; i < 6; i++) {
                params.add("%" + search + "%");
            }
        }

        if (date != null && !date.isEmpty()) {
            sql.append("AND CAST(tr.departure_time AS DATE) = ? ");
            params.add(Date.valueOf(date));
        }

        if (routeId != null && !routeId.isEmpty()) {
            sql.append("AND r.route_id = ? ");
            params.add(Integer.parseInt(routeId));
        }

        if (status != null && !status.isEmpty()) {
            if (status.equals("assigned")) {
                sql.append("AND td.driver_id IS NOT NULL ");
            } else if (status.equals("unassigned")) {
                sql.append("AND td.driver_id IS NULL ");
            }
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Retrieves a paginated list of trips based on filters.
     *
     * @param search Keyword to search for trip ID, route, or driver name.
     * @param date Date string to filter trips.
     * @param routeId Route ID to filter trips.
     * @param status Trip status ("assigned" or "unassigned").
     * @param offset Offset for pagination (starting index).
     * @param limit Maximum number of trips to return.
     * @return A list of StaffTrip objects that match the filters.
     * @throws SQLException if a database access error occurs.
     */
    public List<StaffTrip> getAvailableTripsWithPaging(String search, String date, String routeId, String status, int offset, int limit) throws SQLException {
        List<StaffTrip> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT tr.trip_id, tr.departure_time, b.plate_number, bt.bus_type_name, "
                + "CONCAT(ls.location_name, N' → ', le.location_name) AS route_name, "
                + "u.user_name AS driver_name "
                + "FROM Trips tr "
                + "JOIN Routes r ON tr.route_id = r.route_id "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "JOIN Buses b ON tr.bus_id = b.bus_id "
                + "JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + "LEFT JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
                + "LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            search = search.trim().toLowerCase().replaceAll("\\s+", " ");
            sql.append("AND (")
                    .append("LOWER('Trip ' + CAST(tr.trip_id AS VARCHAR)) LIKE ? ")
                    .append("OR LOWER(u.user_name) LIKE ? ")
                    .append("OR LOWER(ls.location_name) LIKE ? ")
                    .append("OR LOWER(le.location_name) LIKE ? ")
                    .append("OR LOWER(b.plate_number) LIKE ? ")
                    .append("OR LOWER(bt.bus_type_name) LIKE ? ")
                    .append(") ");
            for (int i = 0; i < 6; i++) {
                params.add("%" + search + "%");
            }
        }

        if (date != null && !date.isEmpty()) {
            sql.append("AND CAST(tr.departure_time AS DATE) = ? ");
            params.add(Date.valueOf(date));
        }

        if (routeId != null && !routeId.isEmpty()) {
            sql.append("AND r.route_id = ? ");
            params.add(Integer.parseInt(routeId));
        }

        if (status != null && !status.isEmpty()) {
            if (status.equals("assigned")) {
                sql.append("AND td.driver_id IS NOT NULL ");
            } else if (status.equals("unassigned")) {
                sql.append("AND td.driver_id IS NULL ");
            }
        }

        sql.append("ORDER BY tr.departure_time OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StaffTrip trip = new StaffTrip();
                trip.setTripId(rs.getInt("trip_id"));
                trip.setDepartureTime(rs.getTimestamp("departure_time"));
                trip.setRouteName(rs.getString("route_name"));
                trip.setDriverName(rs.getString("driver_name"));
                trip.setPlateNumber(rs.getString("plate_number"));
                trip.setBusTypeName(rs.getString("bus_type_name"));
                list.add(trip);
            }
        }
        return list;
    }

    /**
     * Retrieves a list of distinct routes for filtering purposes.
     *
     * @return A list of distinct StaffRoute objects.
     * @throws SQLException if a database access error occurs.
     */
    public List<StaffRoute> getDistinctRoutes() throws SQLException {
        List<StaffRoute> routes = new ArrayList<>();
        String sql = "SELECT DISTINCT r.route_id, CONCAT(ls.location_name, N' → ', le.location_name) AS route_name "
                + "FROM Routes r "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "ORDER BY route_name";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StaffRoute route = new StaffRoute();
                route.setRouteId(rs.getInt("route_id"));
                route.setRouteName(rs.getString("route_name"));
                routes.add(route);
            }
        }
        return routes;
    }

}
