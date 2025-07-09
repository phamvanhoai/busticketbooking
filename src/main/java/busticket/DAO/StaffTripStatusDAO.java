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
import busticket.model.AdminDrivers;
import busticket.model.AdminTrips;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StaffTripStatusDAO extends DBContext {

    public List<AdminTrips> getAllTrips(String route, String status, String driver, int offset, int limit) {
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
                // Sử dụng LEFT JOIN để lấy dữ liệu chuyến không có tài xế
                + " LEFT JOIN Trip_Driver td    ON t.trip_id = td.trip_id "
                + " LEFT JOIN Drivers d         ON td.driver_id = d.driver_id "
                + " LEFT JOIN Users u           ON d.user_id = u.user_id "
                + "WHERE 1=1"
        );

        // Apply filters
        if (route != null && !route.isEmpty()) {
            sql.append(" AND (ls.location_name + ' → ' + le.location_name) LIKE ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND t.trip_status LIKE ?");
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
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, "%" + status + "%");
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
            ex.printStackTrace();
        }
        return trips;
    }

    public int getTotalTripsCount(String route, String status, String driver) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM Trips t "
                + " JOIN Routes r               ON t.route_id = r.route_id "
                + " JOIN Locations ls           ON r.start_location_id = ls.location_id "
                + " JOIN Locations le           ON r.end_location_id = le.location_id "
                + " JOIN Buses b                ON t.bus_id = b.bus_id "
                + " JOIN Bus_Types bt           ON b.bus_type_id = bt.bus_type_id "
                // Sử dụng LEFT JOIN để không bỏ qua các chuyến không có tài xế
                + " LEFT JOIN Trip_Driver td    ON t.trip_id = td.trip_id "
                + " LEFT JOIN Drivers d         ON td.driver_id = d.driver_id "
                + " LEFT JOIN Users u           ON d.user_id = u.user_id "
                + "WHERE 1=1"
        );

        // Apply filters
        if (route != null && !route.isEmpty()) {
            sql.append(" AND (ls.location_name + ' → ' + le.location_name) LIKE ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND t.trip_status LIKE ?");
        }
        if (driver != null && !driver.isEmpty()) {
            sql.append(" AND u.user_name LIKE ?");
        }

        try ( PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
            int idx = 1;
            if (route != null && !route.isEmpty()) {
                ps.setString(idx++, "%" + route + "%");
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, "%" + status + "%");
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
}
