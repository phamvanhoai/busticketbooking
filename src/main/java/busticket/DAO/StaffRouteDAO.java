/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.StaffRoute;
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
public class StaffRouteDAO extends DBContext {

    /**
     * Retrieves a list of all available routes for staff use. Each route
     * includes its ID and a formatted name in the format "Start → End".
     *
     * @return a list of {@link StaffRoute} objects representing all routes in
     * the system
     * @throws SQLException if a database access error occurs
     */
    public List<StaffRoute> getAllRoutes() throws SQLException {
        List<StaffRoute> routes = new ArrayList<>();

        String sql = "SELECT r.route_id, ls.location_name + N' → ' + le.location_name AS route_name "
                + "FROM Routes r "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "ORDER BY ls.location_name, le.location_name";

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
