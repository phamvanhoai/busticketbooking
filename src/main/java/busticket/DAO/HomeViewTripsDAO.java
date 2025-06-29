/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.HomeTrip;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class HomeViewTripsDAO extends DBContext {

    public List<String> getAllLocations() {
        List<String> locations = new ArrayList<>();
        String sql = "SELECT DISTINCT location_name FROM Locations";
        try (PreparedStatement ps = getConnection().prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                locations.add(rs.getString(1));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return locations;
    }

    public List<HomeTrip> getTrips(String origin, String destination, Date date) {
        List<HomeTrip> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT " +
            "  t.trip_id, " +
            "  ls.location_name AS origin, " +
            "  le.location_name AS destination, " +
            "  CAST(t.departure_time AS date) AS tripDate, " +
            "  CONVERT(varchar(5), t.departure_time, 108) AS tripTime, " +
            "  bt.bus_type_name AS busType, " +
            "  b.capacity, " +
            "  (SELECT COUNT(*) FROM Tickets tk " +
            "     WHERE tk.trip_id = t.trip_id AND tk.ticket_status = 'Booked') AS bookedSeats, " +
            "  (SELECT SUM(rs.travel_minutes + rs.route_stop_dwell_minutes) " +
            "     FROM Route_Stops rs WHERE rs.route_id = t.route_id) AS durationMinutes, " +
            "  (SELECT TOP 1 rp.route_price " +
            "     FROM Route_Prices rp " +
            "     WHERE rp.route_id = t.route_id " +
            "       AND rp.bus_type_id = b.bus_type_id " +
            "       AND rp.route_price_effective_from <= CAST(t.departure_time AS date) " +
            "     ORDER BY rp.route_price_effective_from DESC) AS price " +
            "FROM Trips t " +
            "  JOIN Routes r ON t.route_id = r.route_id " +
            "  JOIN Locations ls ON r.start_location_id = ls.location_id " +
            "  JOIN Locations le ON r.end_location_id   = le.location_id " +
            "  JOIN Buses b    ON t.bus_id   = b.bus_id " +
            "  JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id " +
            "WHERE t.departure_time > GETDATE()"
        );
        if (origin != null)  sql.append(" AND ls.location_name = ?");
        if (destination != null) sql.append(" AND le.location_name = ?");
        if (date != null)       sql.append(" AND CAST(t.departure_time AS date) = ?");

        try (PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
            int idx = 1;
            if (origin != null)        ps.setString(idx++, origin);
            if (destination != null)   ps.setString(idx++, destination);
            if (date != null)          ps.setDate(idx++, date);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int tripId       = rs.getInt("trip_id");
                    String or        = rs.getString("origin");
                    String dest      = rs.getString("destination");
                    Date tripDate    = rs.getDate("tripDate");
                    String tripTime  = rs.getString("tripTime");
                    int duration     = rs.getInt("durationMinutes");
                    BigDecimal price = rs.getBigDecimal("price");

                    LocalTime dep    = LocalTime.parse(tripTime);
                    String arrival   = dep.plusMinutes(duration)
                                            .toString()
                                            .substring(0, 5);

                    String busType   = rs.getString("busType");
                    int capacity     = rs.getInt("capacity");
                    int bookedSeats  = rs.getInt("bookedSeats");

                    list.add(new HomeTrip(
                        tripId, or, dest, tripDate, tripTime,
                        duration, arrival, busType,
                        capacity, bookedSeats, price
                    ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }
}
