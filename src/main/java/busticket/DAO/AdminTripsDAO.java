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
                + " CONCAT(ls.location_name, N' → ', le.location_name) AS route, "
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
                + " LEFT JOIN Trip_Driver td    ON t.trip_id = td.trip_id " // LEFT JOIN với bảng Trip_Driver
                + " LEFT JOIN Drivers d         ON td.driver_id = d.driver_id " // LEFT JOIN với bảng Drivers
                + " LEFT JOIN Users u           ON d.user_id = u.user_id " // LEFT JOIN với bảng Users để lấy tên tài xế
                + "WHERE 1=1"
        );

        // Apply filters
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
                            rs.getString("driver"), // driver có thể là null
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
                + " JOIN Locations le           ON r.end_location_id = le.location_id "
                + " JOIN Buses b                ON t.bus_id = b.bus_id "
                + " JOIN Bus_Types bt           ON b.bus_type_id = bt.bus_type_id "
                + " LEFT JOIN Trip_Driver td    ON t.trip_id = td.trip_id "
                + " LEFT JOIN Drivers d         ON td.driver_id = d.driver_id "
                + " LEFT JOIN Users u           ON d.user_id = u.user_id "
                + "WHERE 1=1"
        );

        // Apply filters
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
            ex.printStackTrace();
        }
        return 0;
    }

    // 1) Thêm trip 
    public void addTrip(int routeId, int busId, int driverId, Timestamp departureTime, String status) throws SQLException {
        // Bước 1: Thêm thông tin chuyến đi vào bảng Trips
        String sqlTrip = "INSERT INTO Trips(route_id, bus_id, departure_time, trip_status) VALUES(?, ?, ?, ?)";
        try ( PreparedStatement ps = getConnection().prepareStatement(sqlTrip, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, routeId);
            ps.setInt(2, busId);
            ps.setTimestamp(3, departureTime);
            ps.setString(4, status);
            ps.executeUpdate();

            // Lấy trip_id vừa được tạo ra
            ResultSet rs = ps.getGeneratedKeys();
            int tripId = -1;
            if (rs.next()) {
                tripId = rs.getInt(1);
            }

            // Bước 2: Thêm thông tin tài xế vào bảng Trip_Driver
            if (tripId != -1) {
                String sqlDriver = "INSERT INTO Trip_Driver(trip_id, driver_id) VALUES(?, ?)";
                try ( PreparedStatement psDriver = getConnection().prepareStatement(sqlDriver)) {
                    psDriver.setInt(1, tripId);
                    psDriver.setInt(2, driverId);
                    psDriver.executeUpdate();
                }
            }
        }
    }

// 2) Lấy thông tin trip cơ bản để edit/view list
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
                + " td.driver_id, " // Lấy driver_id từ bảng Trip_Driver
                + " t.trip_status AS status "
                + "FROM Trips t "
                + " JOIN Routes r   ON t.route_id = r.route_id "
                + " JOIN Locations ls ON r.start_location_id = ls.location_id "
                + " JOIN Locations le ON r.end_location_id   = le.location_id "
                + " JOIN Buses b    ON t.bus_id   = b.bus_id "
                + " JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + " LEFT JOIN Trip_Driver td ON t.trip_id = td.trip_id "
                + " LEFT JOIN Drivers d ON td.driver_id = d.driver_id "
                + " LEFT JOIN Users u ON d.user_id = u.user_id "
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
                            rs.getInt("driver_id"), // driver_id từ bảng Trip_Driver
                            rs.getString("driver"), // driver tên tài xế
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
                + " u.user_name AS driver, " // Cập nhật để lấy tài xế từ bảng Trip_Driver
                + " t.trip_status AS status "
                + "FROM Trips t "
                + " JOIN Routes r     ON t.route_id = r.route_id "
                + " JOIN Locations ls ON r.start_location_id = ls.location_id "
                + " JOIN Locations le ON r.end_location_id   = le.location_id "
                + " JOIN Buses b      ON t.bus_id   = b.bus_id "
                + " JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + " LEFT JOIN Trip_Driver td ON t.trip_id = td.trip_id " // Thêm bảng phụ Trip_Driver
                + " LEFT JOIN Drivers d    ON td.driver_id = d.driver_id " // Liên kết tài xế từ bảng Trip_Driver
                + " LEFT JOIN Users u      ON d.user_id    = u.user_id " // Liên kết với Users để lấy tên tài xế
                + " WHERE t.trip_id = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try ( ResultSet rs = ps.executeQuery()) {
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
                    detail.setDriver(rs.getString("driver"));  // Tài xế lấy từ bảng Users thông qua Trip_Driver
                    detail.setStatus(rs.getString("status"));

                    // Tính estimatedTime và arrivalTime dựa vào ROUTE_STOPS
                    AdminRoutesDAO routesDAO = new AdminRoutesDAO();
                    int duration = routesDAO.getEstimatedTimeByRouteId(detail.getRouteId());
                    detail.setDuration(duration); // phút

                    // Tính arrivalTime
                    String tripTime = detail.getTripTime(); // dạng "HH:mm"
                    java.time.LocalTime time = java.time.LocalTime.parse(tripTime);
                    java.time.LocalTime arrival = time.plusMinutes(duration);
                    detail.setArrivalTime(arrival.toString().substring(0, 5)); // dạng "HH:mm"

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
        String sql = "SELECT u.user_id, u.user_name, ts.seat_number " // Thêm seat_number từ Ticket_Seat
                + "FROM Tickets t "
                + "JOIN Users u ON t.user_id = u.user_id "
                + "LEFT JOIN Ticket_Seat ts ON t.ticket_id = ts.ticket_id " // Join với Ticket_Seat
                + "WHERE t.trip_id = ? AND t.ticket_status = 'Booked'";

        List<AdminUsers> list = new ArrayList<>();
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new AdminUsers(
                            rs.getInt("user_id"),
                            rs.getString("user_name"),
                            rs.getString("seat_number") // Lưu seat_number vào đối tượng AdminUsers
                    ));
                }
            }
        }
        return list;
    }

    /**
     * Cập nhật một trip đã có
     */
    public void updateTrip(int tripId, int routeId, int busId, int driverId, Timestamp departureTime, String status) throws SQLException {
        // Bước 1: Cập nhật thông tin chuyến đi trong bảng Trips
        String sqlTrip = "UPDATE Trips "
                + "SET route_id = ?, bus_id = ?, departure_time = ?, trip_status = ? "
                + "WHERE trip_id = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(sqlTrip)) {
            ps.setInt(1, routeId);
            ps.setInt(2, busId);
            ps.setTimestamp(3, departureTime);
            ps.setString(4, status);
            ps.setInt(5, tripId);
            ps.executeUpdate();
        }

        // Bước 2: Cập nhật bảng Trip_Driver (hoặc thêm nếu không có tài xế cho chuyến đi)
        String sqlDriver = "MERGE INTO Trip_Driver AS target "
                + "USING (SELECT ? AS trip_id, ? AS driver_id) AS source "
                + "ON target.trip_id = source.trip_id "
                + "WHEN MATCHED THEN "
                + "    UPDATE SET target.driver_id = source.driver_id "
                + "WHEN NOT MATCHED THEN "
                + "    INSERT (trip_id, driver_id) VALUES (source.trip_id, source.driver_id);";

        try ( PreparedStatement psDriver = getConnection().prepareStatement(sqlDriver)) {
            psDriver.setInt(1, tripId);  // trip_id
            psDriver.setInt(2, driverId);  // driver_id
            psDriver.executeUpdate();
        }
    }

    /**
     * Xóa một trip
     */
    public void deleteTrip(int tripId) throws SQLException {
        // Bước 1: Xóa thông tin tài xế từ bảng Trip_Driver
        String sqlDriver = "DELETE FROM Trip_Driver WHERE trip_id = ?";
        try ( PreparedStatement psDriver = getConnection().prepareStatement(sqlDriver)) {
            psDriver.setInt(1, tripId);
            psDriver.executeUpdate();
        }

        // Bước 2: Xóa thông tin chuyến đi từ bảng Trips
        String sqlTrip = "DELETE FROM Trips WHERE trip_id = ?";
        try ( PreparedStatement psTrip = getConnection().prepareStatement(sqlTrip)) {
            psTrip.setInt(1, tripId);
            psTrip.executeUpdate();
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

    public List<AdminRouteStop> getRouteStops(int routeId) {
        List<AdminRouteStop> list = new ArrayList<>();
        String sql = "SELECT rs.route_id, rs.route_stop_number, rs.location_id, rs.route_stop_dwell_minutes, rs.travel_minutes, "
                + "l.location_name, l.address "
                + "FROM Route_Stops rs "
                + "JOIN Locations l ON rs.location_id = l.location_id "
                + "WHERE rs.route_id = ? "
                + "ORDER BY rs.route_stop_number ASC";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, routeId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdminRouteStop stop = new AdminRouteStop();
                    stop.setRouteId(rs.getInt("route_id"));
                    stop.setStopNumber(rs.getInt("route_stop_number"));
                    stop.setLocationId(rs.getInt("location_id"));
                    stop.setDwellMinutes(rs.getInt("route_stop_dwell_minutes"));
                    stop.setTravelMinutes(rs.getInt("travel_minutes"));
                    stop.setLocationName(rs.getString("location_name")); // thêm thuộc tính này vào model nếu chưa có
                    stop.setAddress(rs.getString("address"));           // thêm thuộc tính này vào model nếu chưa có
                    list.add(stop);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
