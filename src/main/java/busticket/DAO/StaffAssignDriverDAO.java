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
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class StaffAssignDriverDAO extends DBContext {

    /**
     * Retrieves a list of trips based on filter criteria. Includes trip ID,
     * route ID, departure time, locations, and assigned driver (if any).
     *
     * @param search keyword for Trip ID or Route ID
     * @param date filter by departure date (yyyy-MM-dd)
     * @param routeId filter by specific route ID
     * @param status "Assigned" or "NotAssigned" or null for all
     * @return list of StaffTrip objects
     */
    public List<StaffTrip> getAvailableTrips(String search, String date, String routeId, String status) {
        List<StaffTrip> trips = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT t.trip_id, t.route_id, t.departure_time, "
                + "l1.location_name AS start_location, l2.location_name AS end_location, "
                + "u.user_name AS driver_name "
                + "FROM Trips t "
                + "JOIN Routes r ON t.route_id = r.route_id "
                + "JOIN Locations l1 ON r.start_location_id = l1.location_id "
                + "JOIN Locations l2 ON r.end_location_id = l2.location_id "
                + "LEFT JOIN Trip_Driver td ON td.trip_id = t.trip_id "
                + "LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE 1=1 ");

        if (search != null && !search.isEmpty()) {
            sql.append("AND (CAST(t.trip_id AS VARCHAR) LIKE ? OR CAST(t.route_id AS VARCHAR) LIKE ?) ");
        }
        if (date != null && !date.isEmpty()) {
            sql.append("AND CAST(t.departure_time AS DATE) = ? ");
        }
        if (routeId != null && !routeId.isEmpty()) {
            sql.append("AND t.route_id = ? ");
        }
        if (status != null && !status.isEmpty()) {
            if (status.equals("Assigned")) {
                sql.append("AND td.driver_id IS NOT NULL ");
            } else if (status.equals("NotAssigned")) {
                sql.append("AND td.driver_id IS NULL ");
            }
        }

        sql.append("ORDER BY t.departure_time DESC");

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            if (search != null && !search.isEmpty()) {
                ps.setString(index++, "%" + search + "%");
                ps.setString(index++, "%" + search + "%");
            }
            if (date != null && !date.isEmpty()) {
                ps.setDate(index++, java.sql.Date.valueOf(date));
            }
            if (routeId != null && !routeId.isEmpty()) {
                ps.setString(index++, routeId);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StaffTrip trip = new StaffTrip();
                trip.setTripId(rs.getInt("trip_id"));
                trip.setRouteId(rs.getInt("route_id"));
                trip.setDepartureTime(rs.getTimestamp("departure_time"));
                trip.setStartLocation(rs.getString("start_location"));
                trip.setEndLocation(rs.getString("end_location"));
                trip.setAssignedDriver(rs.getString("driver_name"));
                trips.add(trip);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return trips;
    }

    /**
     * Retrieves a list of available active drivers who can be assigned to
     * trips.
     *
     * @return list of {@link Driver} objects with ID and full name
     */
    public List<Driver> getAvailableDrivers() {
        List<Driver> drivers = new ArrayList<>();
        String sql = "SELECT d.driver_id, u.user_name AS full_name "
                + "FROM Drivers d "
                + "JOIN Users u ON d.user_id = u.user_id "
                + "WHERE u.role = 'Driver' AND u.user_status = 'Active'";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Driver d = new Driver();
                d.setDriverId(rs.getString("driver_id"));
                d.setFullName(rs.getString("full_name")); // Alias from SQL
                drivers.add(d);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return drivers;
    }

    /**
     * Checks whether a driver has already been assigned to the specified trip.
     *
     * @param tripId ID of the trip to check
     * @return true if a driver is already assigned; false otherwise
     */
    public boolean isDriverAssigned(int tripId) {
        String sql = "SELECT 1 FROM Trip_Driver WHERE trip_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try ( ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return true; // assume assigned in case of error
        }
    }

    /**
     * Assigns a new driver to the specified trip.
     *
     * @param driverId ID of the driver to assign
     * @param tripId ID of the trip to assign the driver to
     * @return true if the assignment was successful; false otherwise
     */
    public boolean assignDriverToTrip(int driverId, int tripId) {
        String sql = "INSERT INTO Trip_Driver (driver_id, trip_id, assigned_at) VALUES (?, ?, GETDATE())";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ps.setInt(2, tripId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates the driver assignment for a specific trip.
     *
     * @param driverId ID of the new driver
     * @param tripId ID of the trip to update
     * @return true if the update was successful; false otherwise
     */
    public boolean updateDriverAssignment(int driverId, int tripId) {
        String sql = "UPDATE Trip_Driver SET driver_id = ?, assigned_at = GETDATE() WHERE trip_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ps.setInt(2, tripId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves a paginated list of trips based on filters. Includes route and
     * driver information.
     *
     * @param search keyword for Trip ID, Route ID, or location names (nullable)
     * @param date departure date filter (format: yyyy-MM-dd, nullable)
     * @param routeId exact route ID to filter (nullable)
     * @param status "Assigned", "NotAssigned", or null
     * @param offset number of rows to skip (used for pagination)
     * @param limit maximum number of records to return
     * @return list of matching {@link StaffTrip} objects for the page
     */
    public List<StaffTrip> getAvailableTripsWithPaging(String search, String date, String routeId, String status, int offset, int limit) {
        List<StaffTrip> trips = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT t.trip_id, t.route_id, t.departure_time, "
                + "l1.location_name AS start_location, l2.location_name AS end_location, "
                + "u.user_name AS driver_name "
                + "FROM Trips t "
                + "JOIN Routes r ON t.route_id = r.route_id "
                + "JOIN Locations l1 ON r.start_location_id = l1.location_id "
                + "JOIN Locations l2 ON r.end_location_id = l2.location_id "
                + "LEFT JOIN Trip_Driver td ON td.trip_id = t.trip_id "
                + "LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE 1=1 ");

        // Apply filters dynamically
        if (search != null && !search.isEmpty()) {
            sql.append("AND (CAST(t.trip_id AS VARCHAR) LIKE ? OR ")
                    .append("CAST(t.route_id AS VARCHAR) LIKE ? OR ")
                    .append("LOWER(u.user_name) LIKE ? OR ")
                    .append("LOWER(l1.location_name) LIKE ? OR ")
                    .append("LOWER(l2.location_name) LIKE ?) ");
        }
        if (date != null && !date.isEmpty()) {
            sql.append("AND CAST(t.departure_time AS DATE) = ? ");
        }
        if (routeId != null && !routeId.isEmpty()) {
            sql.append("AND t.route_id = ? ");
        }
        if (status != null && !status.isEmpty()) {
            if (status.equals("Assigned")) {
                sql.append("AND td.driver_id IS NOT NULL ");
            } else if (status.equals("NotAssigned")) {
                sql.append("AND td.driver_id IS NULL ");
            }
        }

        sql.append("ORDER BY t.departure_time DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            if (search != null && !search.isEmpty()) {
                String pattern = "%" + search.toLowerCase() + "%";
                for (int i = 0; i < 5; i++) {
                    ps.setString(index++, pattern);
                }
            }
            if (date != null && !date.isEmpty()) {
                ps.setDate(index++, java.sql.Date.valueOf(date));
            }
            if (routeId != null && !routeId.isEmpty()) {
                ps.setString(index++, routeId);
            }

            ps.setInt(index++, offset);
            ps.setInt(index++, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StaffTrip trip = new StaffTrip();
                trip.setTripId(rs.getInt("trip_id"));
                trip.setRouteId(rs.getInt("route_id"));
                trip.setDepartureTime(rs.getTimestamp("departure_time"));
                trip.setStartLocation(rs.getString("start_location"));
                trip.setEndLocation(rs.getString("end_location"));
                trip.setAssignedDriver(rs.getString("driver_name"));
                trips.add(trip);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return trips;
    }

    /**
     * Counts how many trips match the provided filters. Used to determine total
     * pages for pagination.
     *
     * @param search keyword for Trip ID, Route ID, or location names (nullable)
     * @param date departure date filter (format: yyyy-MM-dd, nullable)
     * @param routeId exact route ID to filter (nullable)
     * @param status "Assigned", "NotAssigned", or null
     * @return total number of matching trips
     */
    public int countAvailableTrips(String search, String date, String routeId, String status) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Trips t "
                + "JOIN Routes r ON t.route_id = r.route_id "
                + "JOIN Locations l1 ON r.start_location_id = l1.location_id "
                + "JOIN Locations l2 ON r.end_location_id = l2.location_id "
                + "LEFT JOIN Trip_Driver td ON td.trip_id = t.trip_id "
                + "LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + "LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE 1=1 ");

        if (search != null && !search.isEmpty()) {
            sql.append("AND (CAST(t.trip_id AS VARCHAR) LIKE ? OR ")
                    .append("CAST(t.route_id AS VARCHAR) LIKE ? OR ")
                    .append("LOWER(u.user_name) LIKE ? OR ")
                    .append("LOWER(l1.location_name) LIKE ? OR ")
                    .append("LOWER(l2.location_name) LIKE ?) ");
        }
        if (date != null && !date.isEmpty()) {
            sql.append("AND CAST(t.departure_time AS DATE) = ? ");
        }
        if (routeId != null && !routeId.isEmpty()) {
            sql.append("AND t.route_id = ? ");
        }
        if (status != null && !status.isEmpty()) {
            if (status.equals("Assigned")) {
                sql.append("AND td.driver_id IS NOT NULL ");
            } else if (status.equals("NotAssigned")) {
                sql.append("AND td.driver_id IS NULL ");
            }
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            if (search != null && !search.isEmpty()) {
                String pattern = "%" + search.toLowerCase() + "%";
                for (int i = 0; i < 5; i++) {
                    ps.setString(index++, pattern);
                }
            }
            if (date != null && !date.isEmpty()) {
                ps.setDate(index++, java.sql.Date.valueOf(date));
            }
            if (routeId != null && !routeId.isEmpty()) {
                ps.setString(index++, routeId);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }

    /**
     * Retrieves distinct routes to populate a dropdown filter. Each route
     * includes ID and name in the format: Start → End.
     *
     * @return list of {@link StaffRoute} objects with ID and route name
     */
    public List<StaffRoute> getDistinctRoutes() {
        List<StaffRoute> list = new ArrayList<>();
        String sql = "SELECT DISTINCT r.route_id, "
                + "l1.location_name AS start_location, "
                + "l2.location_name AS end_location "
                + "FROM Routes r "
                + "JOIN Locations l1 ON r.start_location_id = l1.location_id "
                + "JOIN Locations l2 ON r.end_location_id = l2.location_id";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("route_id");
                String name = rs.getString("start_location") + " → " + rs.getString("end_location");
                list.add(new StaffRoute(id, name));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
