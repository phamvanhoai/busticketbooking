/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.AdminTrips;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
        StringBuilder query = new StringBuilder(
                "SELECT "
                + " t.trip_id, "
                + " CONCAT(r.start_location, ' → ', r.end_location) AS route, "
                + " CAST(t.departure_time AS date) AS trip_date, "
                + " CONVERT(varchar(5), t.departure_time, 108) AS trip_time, "
                + " bt.bus_type_name AS bus_type, "
                + " u.user_name AS driver, "
                + " t.bus_id, "
                + " t.trip_status AS status "
                + "FROM Trips t "
                + " JOIN Routes r          ON t.route_id = r.route_id "
                + " JOIN Buses b           ON t.bus_id   = b.bus_id "
                + " JOIN Bus_Types bt      ON b.bus_type_id = bt.bus_type_id "
                + " JOIN Drivers d         ON t.driver_id = d.driver_id "
                + " JOIN Users u           ON d.user_id    = u.user_id "
                + "WHERE 1=1"
        );

        if (route != null && !route.isEmpty()) {
            query.append(" AND CONCAT(r.start_location, ' → ', r.end_location) LIKE ?");
        }
        if (busType != null && !busType.isEmpty()) {
            query.append(" AND bt.bus_type_name LIKE ?");
        }
        if (driver != null && !driver.isEmpty()) {
            query.append(" AND u.user_name LIKE ?");
        }
        query.append(" ORDER BY t.trip_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try ( PreparedStatement ps = getConnection().prepareStatement(query.toString())) {
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

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                trips.add(new AdminTrips(
                        rs.getInt("trip_id"),
                        rs.getString("route"),
                        rs.getDate("trip_date"),
                        rs.getString("trip_time"),
                        rs.getString("bus_type"),
                        rs.getString("driver"),
                        rs.getString("bus_id"),
                        rs.getString("status")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminTripsDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return trips;
    }

    // Hàm này sẽ lấy tổng số chuyến đi để tính phân trang
    public int getTotalTripsCount(String route, String busType, String driver) {
        StringBuilder query = new StringBuilder(
                "SELECT COUNT(*) FROM trips WHERE 1=1"
        );

        if (route != null && !route.isEmpty()) {
            query.append(" AND route LIKE ?");
        }
        if (busType != null && !busType.isEmpty()) {
            query.append(" AND bus_type LIKE ?");
        }
        if (driver != null && !driver.isEmpty()) {
            query.append(" AND driver LIKE ?");
        }

        try ( PreparedStatement ps = getConnection().prepareStatement(query.toString())) {
            int paramIndex = 1;
            if (route != null && !route.isEmpty()) {
                ps.setString(paramIndex++, "%" + route + "%");
            }
            if (busType != null && !busType.isEmpty()) {
                ps.setString(paramIndex++, "%" + busType + "%");
            }
            if (driver != null && !driver.isEmpty()) {
                ps.setString(paramIndex++, "%" + driver + "%");
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminTripsDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

}
