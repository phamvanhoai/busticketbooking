/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.AdminBuses;
import busticket.model.AdminDrivers;
import busticket.model.AdminRoutes;
import busticket.model.AdminTrips;
import busticket.model.AdminUsers;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminTripsDAO extends DBContext {

    public List<AdminTrips> getAllTrips(String route, String busType, String driver, int offset, int limit) {
        List<AdminTrips> trips = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT "
                + " t.trip_id, "
                + " CONCAT(ls.location_name, ' → ', le.location_name) AS route, "
                + " CAST(t.departure_time AS date) AS trip_date, "
                + " CONVERT(varchar(5), t.departure_time, 108) AS trip_time, "
                + " bt.bus_type_name AS bus_type, "
                + " u.user_name AS driver, "
                + " t.bus_id, "
                + " t.trip_status AS status "
                + "FROM Trips t "
                + " JOIN Routes r               ON t.route_id = r.route_id "
                + " JOIN Locations ls           ON r.start_location_id = ls.location_id "
                + " JOIN Locations le           ON r.end_location_id   = le.location_id "
                + " JOIN Buses b                ON t.bus_id   = b.bus_id "
                + " JOIN Bus_Types bt           ON b.bus_type_id = bt.bus_type_id "
                + " JOIN Drivers d              ON t.driver_id = d.driver_id "
                + " JOIN Users u                ON d.user_id    = u.user_id "
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

        try ( PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
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

            try ( ResultSet rs = ps.executeQuery()) {
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
            Logger.getLogger(AdminTripsDAO.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
        return trips;
    }

    public int getTotalTripsCount(String route, String busType, String driver) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM Trips t "
                + " JOIN Routes r               ON t.route_id = r.route_id "
                + " JOIN Locations ls           ON r.start_location_id = ls.location_id "
                + " JOIN Locations le           ON r.end_location_id   = le.location_id "
                + " JOIN Buses b                ON t.bus_id   = b.bus_id "
                + " JOIN Bus_Types bt           ON b.bus_type_id = bt.bus_type_id "
                + " JOIN Drivers d              ON t.driver_id = d.driver_id "
                + " JOIN Users u                ON d.user_id    = u.user_id "
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

        try ( PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
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

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminTripsDAO.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    // 1) Thêm trip (không thay đổi)
    public void addTrip(int routeId, int busId, int driverId, Timestamp departureTime, String status)
            throws SQLException {
        String sql = "INSERT INTO Trips(route_id, bus_id, driver_id, departure_time, trip_status) VALUES(?, ?, ?, ?, ?)";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, routeId);
            ps.setInt(2, busId);
            ps.setInt(3, driverId);
            ps.setTimestamp(4, departureTime);
            ps.setString(5, status);
            ps.executeUpdate();
        }
    }

// 2) Lấy thông tin trip cơ bản để edit/view list
    public AdminTrips getTripById(int tripId) throws SQLException {
        String sql = "SELECT "
                + "  t.trip_id, "
                + "  t.route_id, "
                + "  CONCAT(ls.location_name, ' → ', le.location_name) AS route, "
                + "  CAST(t.departure_time AS DATE) AS tripDate, "
                + "  CONVERT(VARCHAR(5), t.departure_time, 108) AS tripTime, "
                + "  t.bus_id, "
                + "  bt.bus_type_name AS busType, "
                + "  t.driver_id, "
                + "  u.user_name AS driver, "
                + "  t.trip_status AS status "
                + "FROM Trips t "
                + " JOIN Routes r   ON t.route_id = r.route_id "
                + " JOIN Locations ls ON r.start_location_id = ls.location_id "
                + " JOIN Locations le ON r.end_location_id   = le.location_id "
                + " JOIN Buses b    ON t.bus_id   = b.bus_id "
                + " JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + " JOIN Drivers d ON t.driver_id = d.driver_id "
                + " JOIN Users u   ON d.user_id    = u.user_id "
                + "WHERE t.trip_id = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try ( ResultSet rs = ps.executeQuery()) {
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

// 3) Lấy chi tiết đầy đủ để hiện trang detail
    public AdminTrips getTripDetailById(int tripId) throws SQLException {
        String sql = "SELECT "
                + "  t.trip_id, "
                + "  CONCAT(ls.location_name, ' → ', le.location_name) AS route, "
                + "  ls.location_name AS startLocation, "
                + "  le.location_name AS endLocation, "
                + "  CAST(t.departure_time AS DATE) AS tripDate, "
                + "  CONVERT(VARCHAR(5), t.departure_time, 108) AS tripTime, "
                + "  r.estimated_time AS durationMinutes, "
                + "  CONVERT(VARCHAR(5), DATEADD(MINUTE, r.estimated_time, t.departure_time), 108) AS arrivalTime, "
                + "  bt.bus_type_name AS busType, "
                + "  b.plate_number AS plateNumber, "
                + "  b.capacity AS capacity, "
                + "  (SELECT COUNT(*) FROM Tickets tk WHERE tk.trip_id = t.trip_id AND tk.ticket_status = 'Booked') AS bookedSeats, "
                + "  u.user_name AS driver, "
                + "  t.trip_status AS status "
                + "FROM Trips t "
                + " JOIN Routes r     ON t.route_id = r.route_id "
                + " JOIN Locations ls ON r.start_location_id = ls.location_id "
                + " JOIN Locations le ON r.end_location_id   = le.location_id "
                + " JOIN Buses b      ON t.bus_id   = b.bus_id "
                + " JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + " JOIN Drivers d    ON t.driver_id = d.driver_id "
                + " JOIN Users u      ON d.user_id    = u.user_id "
                + "WHERE t.trip_id = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AdminTrips detail = new AdminTrips();
                    detail.setTripId(rs.getInt("trip_id"));
                    detail.setRoute(rs.getString("route"));
                    detail.setStartLocation(rs.getString("startLocation"));
                    detail.setEndLocation(rs.getString("endLocation"));
                    detail.setTripDate(rs.getDate("tripDate"));
                    detail.setTripTime(rs.getString("tripTime"));
                    detail.setDuration(rs.getInt("durationMinutes"));
                    detail.setArrivalTime(rs.getString("arrivalTime"));
                    detail.setBusType(rs.getString("busType"));
                    detail.setPlateNumber(rs.getString("plateNumber"));
                    detail.setCapacity(rs.getInt("capacity"));
                    detail.setBookedSeats(rs.getInt("bookedSeats"));
                    detail.setDriver(rs.getString("driver"));
                    detail.setStatus(rs.getString("status"));
                    return detail;
                }
            }
        }
        return null;
    }

    //get location name for admin trip filter
    public List<String> getAllLocations() {
        List<String> locations = new ArrayList<>();
        String query = "SELECT DISTINCT location_name FROM Locations";

        try ( PreparedStatement ps = getConnection().prepareStatement(query);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                locations.add(rs.getString("location_name"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return locations;
    }

    //get bus type for admin trip filter
    public List<String> getAllBusTypes() {
        List<String> busTypes = new ArrayList<>();
        String query = "SELECT bus_type_name FROM Bus_Types";
        try ( PreparedStatement ps = getConnection().prepareStatement(query);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                busTypes.add(rs.getString("bus_type_name"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return busTypes;
    }

    // details trip
    public List<AdminUsers> getPassengersByTripId(int tripId) throws SQLException {
        String sql
                = "SELECT u.user_id, u.user_name "
                + "FROM Tickets t "
                + " JOIN Users u ON t.user_id = u.user_id "
                + "WHERE t.trip_id = ? AND t.ticket_status = 'Booked'";
        List<AdminUsers> list = new ArrayList<>();
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new AdminUsers(
                            rs.getInt("user_id"),
                            rs.getString("user_name")
                    ));
                }
            }
        }
        return list;
    }

    /**
     * Cập nhật một trip đã có
     */
    public void updateTrip(int tripId, int routeId, int busId, int driverId,
            Timestamp departureTime, String status) throws SQLException {
        String sql = "UPDATE Trips "
                + "SET route_id = ?, bus_id = ?, driver_id = ?, departure_time = ?, trip_status = ? "
                + "WHERE trip_id = ?";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, routeId);
            ps.setInt(2, busId);
            ps.setInt(3, driverId);
            ps.setTimestamp(4, departureTime);
            ps.setString(5, status);
            ps.setInt(6, tripId);
            ps.executeUpdate();
        }
    }

    /**
     * Xóa một trip
     */
    public void deleteTrip(int tripId) throws SQLException {
        String sql = "DELETE FROM Trips WHERE trip_id = ?";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, tripId);
            ps.executeUpdate();
        }
    }

    /**
     * Lấy tất cả routes (với tên start/end lấy từ Locations)
     */
    public List<AdminRoutes> getAllRoutes() {
        List<AdminRoutes> list = new ArrayList<>();
        String sql = ""
                + "SELECT "
                + "  r.route_id, "
                + "  ls.location_name AS start_location, "
                + "  le.location_name AS end_location "
                + "FROM Routes r "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id   = le.location_id "
                + "ORDER BY r.route_id";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
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

// Lấy tất cả buses
    public List<AdminBuses> getAllBuses() {
        List<AdminBuses> list = new ArrayList<>();
        String sql = "SELECT bus_id, plate_number FROM Buses WHERE bus_status = 'Active'";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
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

    // Lấy tất cả drivers
    public List<AdminDrivers> getAllDrivers() {
        List<AdminDrivers> list = new ArrayList<>();
        String sql = "SELECT d.driver_id, u.user_name "
                + "FROM Drivers d "
                + "JOIN Users u ON d.user_id = u.user_id "
                + "WHERE d.driver_status = 'Active'";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
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

}
