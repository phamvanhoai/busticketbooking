/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.AdminBuses;
import busticket.model.AdminDrivers;
import busticket.model.AdminRouteStop;
import busticket.model.AdminRoutes;
import busticket.model.AdminTrips;
import busticket.model.AdminUsers;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminTripsDAO extends DBContext {
    
    private static final int BUFFER_MINUTES = 15; // Configurable buffer time between trips

    public List<AdminTrips> getAllTrips(String route, String busType, String driver, int offset, int limit) {
        List<AdminTrips> trips = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT "
                + " t.trip_id, "
                + " CONCAT(ls.location_name, N' → ', le.location_name) AS route, "
                + " CAST(t.departure_time AS date) AS trip_date, "
                + " CONVERT(varchar(5), t.departure_time, 108) AS trip_time, "
                + " bt.bus_type_name AS bus_type, "
                + " u.user_name AS driver, "
                + " t.bus_id, "
                + " t.trip_status AS status "
                + "FROM Trips t "
                + " JOIN Routes r ON t.route_id = r.route_id "
                + " JOIN Locations ls ON r.start_location_id = ls.location_id "
                + " JOIN Locations le ON r.end_location_id = le.location_id "
                + " JOIN Buses b ON t.bus_id = b.bus_id "
                + " JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + " LEFT JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + " LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + " LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE 1=1"
        );

        if (route != null && !route.isEmpty()) {
            sql.append(" AND (ls.location_name + ' → ' + le.location_name) LIKE ?");
        }
        if (busType != null && !busType.isEmpty()) {
            sql.append(" AND bt.bus_type_name LIKE ?");
        }
        if (driver != null && !driver.isEmpty()) {
            sql.append(" AND u.user_name LIKE ?");
        }

        sql.append(" ORDER BY t.trip_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
            int idx = 1;
            if (route != null && !route.isEmpty()) {
                ps.setString(idx++, "%" + route + "%");
            }
            if (busType != null && !busType.isEmpty()) {
                ps.setString(idx++, "%" + busType + "%");
            }
            if (driver != null && !driver.isEmpty()) {
                ps.setString(idx++, "%" + driver + "%");
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    trips.add(new AdminTrips(
                            rs.getInt("trip_id"),
                            rs.getString("route"),
                            rs.getDate("trip_date"),
                            rs.getString("trip_time"),
                            rs.getString("bus_type"),
                            rs.getString("driver"),
                            rs.getInt("bus_id"),
                            rs.getString("status")
                    ));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminTripsDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return trips;
    }

    public int getTotalTripsCount(String route, String busType, String driver) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM Trips t "
                + " JOIN Routes r ON t.route_id = r.route_id "
                + " JOIN Locations ls ON r.start_location_id = ls.location_id "
                + " JOIN Locations le ON r.end_location_id = le.location_id "
                + " JOIN Buses b ON t.bus_id = b.bus_id "
                + " JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + " LEFT JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + " LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + " LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE 1=1"
        );

        if (route != null && !route.isEmpty()) {
            sql.append(" AND (ls.location_name + ' → ' + le.location_name) LIKE ?");
        }
        if (busType != null && !busType.isEmpty()) {
            sql.append(" AND bt.bus_type_name LIKE ?");
        }
        if (driver != null && !driver.isEmpty()) {
            sql.append(" AND u.user_name LIKE ?");
        }

        try (PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
            int idx = 1;
            if (route != null && !route.isEmpty()) {
                ps.setString(idx++, "%" + route + "%");
            }
            if (busType != null && !busType.isEmpty()) {
                ps.setString(idx++, "%" + busType + "%");
            }
            if (driver != null && !driver.isEmpty()) {
                ps.setString(idx++, "%" + driver + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    public boolean hasConflictingTrip(int driverId, int busId, int routeId, Timestamp departureTime, int excludeTripId) throws SQLException {
        AdminRoutesDAO routesDAO = new AdminRoutesDAO();
        int newTripDuration = routesDAO.getEstimatedTimeByRouteId(routeId); // Duration in minutes
        if (newTripDuration <= 0) {
            Logger.getLogger(AdminTripsDAO.class.getName()).log(Level.WARNING, 
                "Invalid duration for routeId={0}: {1} minutes", new Object[]{routeId, newTripDuration});
            throw new SQLException("Invalid route duration for route ID: " + routeId);
        }
        Timestamp newTripEndTime = new Timestamp(departureTime.getTime() + (newTripDuration + BUFFER_MINUTES) * 60 * 1000);

        // Check for driver conflicts
        String driverSql = "SELECT t.trip_id, t.route_id, t.departure_time "
                + "FROM Trips t "
                + "JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + "WHERE td.driver_id = ? "
                + "AND t.trip_status NOT IN ('Cancelled', 'Completed') "
                + "AND t.trip_id != ?";

        Logger.getLogger(AdminTripsDAO.class.getName()).log(Level.INFO, 
            "Checking driver conflict: driverId={0}, routeId={1}, departureTime={2}, duration={3}, endTime={4}, excludeTripId={5}", 
            new Object[]{driverId, routeId, departureTime, newTripDuration, newTripEndTime, excludeTripId});

        try (PreparedStatement ps = getConnection().prepareStatement(driverSql)) {
            ps.setInt(1, driverId);
            ps.setInt(2, excludeTripId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int existingRouteId = rs.getInt("route_id");
                    Timestamp existingDepartureTime = rs.getTimestamp("departure_time");
                    int existingTripDuration = routesDAO.getEstimatedTimeByRouteId(existingRouteId);
                    if (existingTripDuration <= 0) {
                        Logger.getLogger(AdminTripsDAO.class.getName()).log(Level.WARNING, 
                            "Invalid duration for existing routeId={0}: {1} minutes", 
                            new Object[]{existingRouteId, existingTripDuration});
                        continue; // Skip invalid durations
                    }
                    Timestamp existingTripEndTime = new Timestamp(existingDepartureTime.getTime() + (existingTripDuration + BUFFER_MINUTES) * 60 * 1000);

                    Logger.getLogger(AdminTripsDAO.class.getName()).log(Level.INFO, 
                        "Existing driver trip: tripId={0}, routeId={1}, departureTime={2}, duration={3}, endTime={4}", 
                        new Object[]{rs.getInt("trip_id"), existingRouteId, existingDepartureTime, existingTripDuration, existingTripEndTime});

                    if (!newTripEndTime.before(existingDepartureTime) && !existingTripEndTime.before(departureTime)) {
                        Logger.getLogger(AdminTripsDAO.class.getName()).log(Level.INFO, 
                            "Driver conflict found for tripId={0}", new Object[]{rs.getInt("trip_id")});
                        throw new SQLException("Driver is already assigned to another trip (ID: " + rs.getInt("trip_id") + ") with an overlapping time window (including a " + BUFFER_MINUTES + "-minute buffer).");
                    }
                }
            }
        }

        // Check for bus conflicts
        String busSql = "SELECT t.trip_id, t.route_id, t.departure_time "
                + "FROM Trips t "
                + "WHERE t.bus_id = ? "
                + "AND t.trip_status NOT IN ('Cancelled', 'Completed') "
                + "AND t.trip_id != ?";

        Logger.getLogger(AdminTripsDAO.class.getName()).log(Level.INFO, 
            "Checking bus conflict: busId={0}, routeId={1}, departureTime={2}, duration={3}, endTime={4}, excludeTripId={5}", 
            new Object[]{busId, routeId, departureTime, newTripDuration, newTripEndTime, excludeTripId});

        try (PreparedStatement ps = getConnection().prepareStatement(busSql)) {
            ps.setInt(1, busId);
            ps.setInt(2, excludeTripId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int existingRouteId = rs.getInt("route_id");
                    Timestamp existingDepartureTime = rs.getTimestamp("departure_time");
                    int existingTripDuration = routesDAO.getEstimatedTimeByRouteId(existingRouteId);
                    if (existingTripDuration <= 0) {
                        Logger.getLogger(AdminTripsDAO.class.getName()).log(Level.WARNING, 
                            "Invalid duration for existing routeId={0}: {1} minutes", 
                            new Object[]{existingRouteId, existingTripDuration});
                        continue; // Skip invalid durations
                    }
                    Timestamp existingTripEndTime = new Timestamp(existingDepartureTime.getTime() + (existingTripDuration + BUFFER_MINUTES) * 60 * 1000);

                    Logger.getLogger(AdminTripsDAO.class.getName()).log(Level.INFO, 
                        "Existing bus trip: tripId={0}, routeId={1}, departureTime={2}, duration={3}, endTime={4}", 
                        new Object[]{rs.getInt("trip_id"), existingRouteId, existingDepartureTime, existingTripDuration, existingTripEndTime});

                    if (!newTripEndTime.before(existingDepartureTime) && !existingTripEndTime.before(departureTime)) {
                        Logger.getLogger(AdminTripsDAO.class.getName()).log(Level.INFO, 
                            "Bus conflict found for tripId={0}", new Object[]{rs.getInt("trip_id")});
                        throw new SQLException("Bus is already assigned to another trip (ID: " + rs.getInt("trip_id") + ") with an overlapping time window (including a " + BUFFER_MINUTES + "-minute buffer).");
                    }
                }
            }
        }

        return false;
    }

    public void addTrip(int routeId, int busId, int driverId, Timestamp departureTime, String status) throws SQLException {
        if (hasConflictingTrip(driverId, busId, routeId, departureTime, -1)) {
            // Exception thrown by hasConflictingTrip
        }

        String sqlTrip = "INSERT INTO Trips(route_id, bus_id, departure_time, trip_status) VALUES(?, ?, ?, ?)";
        try (PreparedStatement ps = getConnection().prepareStatement(sqlTrip, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, routeId);
            ps.setInt(2, busId);
            ps.setTimestamp(3, departureTime);
            ps.setString(4, status);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int tripId = -1;
            if (rs.next()) {
                tripId = rs.getInt(1);
            }

            if (tripId != -1) {
                String sqlDriver = "INSERT INTO Trip_Driver(trip_id, driver_id) VALUES(?, ?)";
                try (PreparedStatement psDriver = getConnection().prepareStatement(sqlDriver)) {
                    psDriver.setInt(1, tripId);
                    psDriver.setInt(2, driverId);
                    psDriver.executeUpdate();
                }
            }
        }
    }

    public void updateTrip(int tripId, int routeId, int busId, int driverId, Timestamp departureTime, String status) throws SQLException {
        if (hasConflictingTrip(driverId, busId, routeId, departureTime, tripId)) {
            // Exception thrown by hasConflictingTrip
        }

        String sqlTrip = "UPDATE Trips "
                + "SET route_id = ?, bus_id = ?, departure_time = ?, trip_status = ? "
                + "WHERE trip_id = ?";

        try (PreparedStatement ps = getConnection().prepareStatement(sqlTrip)) {
            ps.setInt(1, routeId);
            ps.setInt(2, busId);
            ps.setTimestamp(3, departureTime);
            ps.setString(4, status);
            ps.setInt(5, tripId);
            ps.executeUpdate();
        }

        String sqlDriver = "MERGE INTO Trip_Driver AS target "
                + "USING (SELECT ? AS trip_id, ? AS driver_id) AS source "
                + "ON target.trip_id = source.trip_id "
                + "WHEN MATCHED THEN "
                + "    UPDATE SET target.driver_id = source.driver_id "
                + "WHEN NOT MATCHED THEN "
                + "    INSERT (trip_id, driver_id) VALUES (source.trip_id, source.driver_id);";

        try (PreparedStatement psDriver = getConnection().prepareStatement(sqlDriver)) {
            psDriver.setInt(1, tripId);
            psDriver.setInt(2, driverId);
            psDriver.executeUpdate();
        }
    }

    public AdminTrips getTripById(int tripId) throws SQLException {
        String sql = "SELECT "
                + " t.trip_id, "
                + " t.route_id, "
                + " CONCAT(ls.location_name, N' → ', le.location_name) AS route, "
                + " CAST(t.departure_time AS DATE) AS tripDate, "
                + " CONVERT(VARCHAR(5), t.departure_time, 108) AS tripTime, "
                + " t.bus_id, "
                + " bt.bus_type_name AS busType, "
                + " u.user_name AS driver, "
                + " td.driver_id, "
                + " t.trip_status AS status "
                + "FROM Trips t "
                + " JOIN Routes r ON t.route_id = r.route_id "
                + " JOIN Locations ls ON r.start_location_id = ls.location_id "
                + " JOIN Locations le ON r.end_location_id = le.location_id "
                + " JOIN Buses b ON t.bus_id = b.bus_id "
                + " JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + " LEFT JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + " LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + " LEFT JOIN Users u ON d.user_id = u.user_id "
                + "WHERE t.trip_id = ?";

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new AdminTrips(
                            rs.getInt("trip_id"),
                            rs.getInt("route_id"),
                            rs.getString("route"),
                            rs.getDate("tripDate"),
                            rs.getString("tripTime"),
                            rs.getInt("bus_id"),
                            rs.getString("busType"),
                            rs.getInt("driver_id"),
                            rs.getString("driver"),
                            rs.getString("status")
                    );
                }
            }
        }
        return null;
    }

    public AdminTrips getTripDetailById(int tripId) throws SQLException {
        String sql = "SELECT "
                + " t.trip_id, "
                + " t.route_id, "
                + " CONCAT(ls.location_name, N' → ', le.location_name) AS route, "
                + " ls.location_name AS startLocation, "
                + " le.location_name AS endLocation, "
                + " CAST(t.departure_time AS DATE) AS tripDate, "
                + " CONVERT(VARCHAR(5), t.departure_time, 108) AS tripTime, "
                + " bt.bus_type_name AS busType, "
                + " b.plate_number AS plateNumber, "
                + " b.capacity AS capacity, "
                + " (SELECT COUNT(*) FROM Tickets tk WHERE tk.trip_id = t.trip_id AND tk.ticket_status = 'Booked') AS bookedSeats, "
                + " u.user_name AS driver, "
                + " t.trip_status AS status "
                + "FROM Trips t "
                + " JOIN Routes r ON t.route_id = r.route_id "
                + " JOIN Locations ls ON r.start_location_id = ls.location_id "
                + " JOIN Locations le ON r.end_location_id = le.location_id "
                + " JOIN Buses b ON t.bus_id = b.bus_id "
                + " JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + " LEFT JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + " LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + " LEFT JOIN Users u ON d.user_id = u.user_id "
                + " WHERE t.trip_id = ?";

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AdminTrips detail = new AdminTrips();
                    detail.setTripId(rs.getInt("trip_id"));
                    detail.setRouteId(rs.getInt("route_id"));
                    detail.setRoute(rs.getString("route"));
                    detail.setStartLocation(rs.getString("startLocation"));
                    detail.setEndLocation(rs.getString("endLocation"));
                    detail.setTripDate(rs.getDate("tripDate"));
                    detail.setTripTime(rs.getString("tripTime"));
                    detail.setBusType(rs.getString("busType"));
                    detail.setPlateNumber(rs.getString("plateNumber"));
                    detail.setCapacity(rs.getInt("capacity"));
                    detail.setBookedSeats(rs.getInt("bookedSeats"));
                    detail.setDriver(rs.getString("driver"));
                    detail.setStatus(rs.getString("status"));

                    AdminRoutesDAO routesDAO = new AdminRoutesDAO();
                    int duration = routesDAO.getEstimatedTimeByRouteId(detail.getRouteId());
                    detail.setDuration(duration);

                    // Calculate arrival date and time
                    String tripTime = detail.getTripTime();
                    LocalDateTime departureDateTime = LocalDateTime.of(
                        detail.getTripDate().toLocalDate(),
                        LocalTime.parse(tripTime)
                    );
                    LocalDateTime arrivalDateTime = departureDateTime.plusMinutes(duration);
                    detail.setArrivalDate(Date.valueOf(arrivalDateTime.toLocalDate()));
                    detail.setArrivalTime(arrivalDateTime.format(DateTimeFormatter.ofPattern("HH:mm")));

                    return detail;
                }
            }
        }
        return null;
    }

    public List<String> getAllLocations() {
        List<String> locations = new ArrayList<>();
        String query = "SELECT DISTINCT location_name FROM Locations";

        try (PreparedStatement ps = getConnection().prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                locations.add(rs.getString("location_name"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return locations;
    }

    public List<String> getAllBusTypes() {
        List<String> busTypes = new ArrayList<>();
        String query = "SELECT bus_type_name FROM Bus_Types";
        try (PreparedStatement ps = getConnection().prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                busTypes.add(rs.getString("bus_type_name"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return busTypes;
    }

    public List<AdminUsers> getPassengersByTripId(int tripId) throws SQLException {
        String sql = "SELECT u.user_id, u.user_name, ts.seat_number "
                + "FROM Tickets t "
                + "JOIN Users u ON t.user_id = u.user_id "
                + "LEFT JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id "
                + "WHERE t.trip_id = ? AND t.ticket_status = 'Booked'";

        List<AdminUsers> list = new ArrayList<>();
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new AdminUsers(
                            rs.getInt("user_id"),
                            rs.getString("user_name"),
                            rs.getString("seat_number")
                    ));
                }
            }
        }
        return list;
    }

    public void deleteTrip(int tripId) throws SQLException {
        String sqlDriver = "DELETE FROM Trip_Driver WHERE trip_id = ?";
        try (PreparedStatement psDriver = getConnection().prepareStatement(sqlDriver)) {
            psDriver.setInt(1, tripId);
            psDriver.executeUpdate();
        }

        String sqlTrip = "DELETE FROM Trips WHERE trip_id = ?";
        try (PreparedStatement psTrip = getConnection().prepareStatement(sqlTrip)) {
            psTrip.setInt(1, tripId);
            psTrip.executeUpdate();
        }
    }

    public List<AdminRoutes> getAllRoutes() {
        List<AdminRoutes> list = new ArrayList<>();
        String sql = "SELECT "
                + "  r.route_id, "
                + "  ls.location_name AS start_location, "
                + "  le.location_name AS end_location "
                + "FROM Routes r "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "ORDER BY r.route_id";
        try (PreparedStatement ps = getConnection().prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new AdminRoutes(
                        rs.getInt("route_id"),
                        rs.getString("start_location"),
                        rs.getString("end_location")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminRoutesDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<AdminBuses> getAllBuses() {
        List<AdminBuses> list = new ArrayList<>();
        String sql = "SELECT bus_id, plate_number FROM Buses WHERE bus_status = 'Active'";
        try (PreparedStatement ps = getConnection().prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new AdminBuses(
                        rs.getInt("bus_id"),
                        rs.getString("plate_number")
                ));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public List<AdminDrivers> getAllDrivers() {
        List<AdminDrivers> list = new ArrayList<>();
        String sql = "SELECT d.driver_id, u.user_name "
                + "FROM Drivers d "
                + "JOIN Users u ON d.user_id = u.user_id "
                + "WHERE d.driver_status = 'Active'";
        try (PreparedStatement ps = getConnection().prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new AdminDrivers(
                        rs.getInt("driver_id"),
                        rs.getString("user_name")
                ));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public List<AdminRouteStop> getRouteStops(int routeId) {
        List<AdminRouteStop> list = new ArrayList<>();
        String sql = "SELECT rs.route_id, rs.route_stop_number, rs.location_id, rs.route_stop_dwell_minutes, rs.travel_minutes, "
                + "l.location_name, l.address "
                + "FROM Route_Stops rs "
                + "JOIN Locations l ON rs.location_id = l.location_id "
                + "WHERE rs.route_id = ? "
                + "ORDER BY rs.route_stop_number ASC";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, routeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdminRouteStop stop = new AdminRouteStop();
                    stop.setRouteId(rs.getInt("route_id"));
                    stop.setStopNumber(rs.getInt("route_stop_number"));
                    stop.setLocationId(rs.getInt("location_id"));
                    stop.setDwellMinutes(rs.getInt("route_stop_dwell_minutes"));
                    stop.setTravelMinutes(rs.getInt("travel_minutes"));
                    stop.setLocationName(rs.getString("location_name"));
                    stop.setAddress(rs.getString("address"));
                    list.add(stop);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
