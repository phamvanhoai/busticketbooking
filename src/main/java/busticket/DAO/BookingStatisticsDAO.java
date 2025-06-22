/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.BookingStatistics;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class BookingStatisticsDAO extends DBContext {

    /**
     * Fetch all statistics matching optional route & date filters.
     */
    public List<BookingStatistics> getStats(String routeFilter, LocalDate dateFilter) throws SQLException {
    List<BookingStatistics> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder(
            "SELECT "
            + "   CAST(tr.departure_time AS DATE) AS stat_date, "
            + "   CONCAT(r.start_location, ' → ', r.end_location) AS route_name, "
            + "   COUNT(t.ticket_id) AS tickets_sold, "
            + "   FLOOR(COUNT(t.ticket_id)*100.0 / b.capacity) AS occupancy_percent, "
            + "   u.user_name AS driver_name "
            + "FROM Trips tr "
            + "JOIN Routes r ON tr.route_id = r.route_id "
            + "JOIN Trip_Driver td ON tr.trip_id = td.trip_id "
            + "JOIN Drivers d ON td.driver_id = d.driver_id "
            + "JOIN Users u ON d.user_id = u.user_id "
            + "JOIN Tickets t ON tr.trip_id = t.trip_id "
            + "JOIN Trip_Bus tb ON tr.trip_id = tb.trip_id "
            + "JOIN Buses b ON tb.bus_id = b.bus_id "
    );

    boolean whereAdded = false;
    if (routeFilter != null && !routeFilter.equals("All")) {
        sql.append("WHERE CONCAT(r.start_location,' → ',r.end_location)=? ");
        whereAdded = true;
    }
    if (dateFilter != null) {
        sql.append(whereAdded ? "AND " : "WHERE ");
        sql.append("CAST(tr.departure_time AS DATE)=? ");
    }

    sql.append(
            "GROUP BY CAST(tr.departure_time AS DATE), r.start_location, r.end_location, u.user_name, b.capacity "
            + "ORDER BY stat_date, route_name, tickets_sold DESC"
    );

    try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        int idx = 1;
        if (routeFilter != null && !routeFilter.equals("All")) {
            ps.setString(idx++, routeFilter);
        }
        if (dateFilter != null) {
            ps.setDate(idx++, Date.valueOf(dateFilter));
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            BookingStatistics bs = new BookingStatistics(
                    rs.getDate("stat_date").toLocalDate(),
                    rs.getString("route_name"),
                    rs.getInt("tickets_sold"),
                    rs.getInt("occupancy_percent"),
                    rs.getString("driver_name")
            );
            list.add(bs);
        }
    }

    return list;
}
}