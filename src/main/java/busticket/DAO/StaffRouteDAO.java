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
     * Retrieves a list of all routes in the system with route ID and route
     * name. The route name is formatted as: "StartLocation → EndLocation"
     *
     * @return List of StaffRoute containing route ID and route name
     * @throws SQLException if any SQL error occurs
     */
    public List<StaffRoute> getAllRoutes() throws SQLException {
        List<StaffRoute> routeList = new ArrayList<>();

        // SQL: Join with Locations to get human-readable location_name for both start and end
        String sql = "SELECT r.route_id, "
                + "       CONCAT(ls.location_name, ' → ', le.location_name) AS route_name "
                + "FROM Routes r "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                StaffRoute route = new StaffRoute();
                route.setRouteId(rs.getInt("route_id"));
                route.setRouteName(rs.getString("route_name"));
                routeList.add(route);
            }
        }

        return routeList;
    }

    /**
     * Retrieves all route names from the database. Each route name is formatted
     * as: "Start Location → End Location".
     *
     * @return a list of route name strings (e.g., "Hà Nội → TP Hồ Chí Minh").
     * Returns empty list if no routes found or exception occurs.
     */
    public List<String> getAllRouteNames() {
        List<String> routeNames = new ArrayList<>();

        String sql = "SELECT start_location, end_location FROM Routes";

        try (
                 Connection conn = getConnection(); // Connect to DB
                  PreparedStatement ps = conn.prepareStatement(sql); // Prepare SQL
                  ResultSet rs = ps.executeQuery(); // Execute query
                ) {
            // Iterate through result set and format each route name
            while (rs.next()) {
                String start = rs.getString("start_location");
                String end = rs.getString("end_location");
                routeNames.add(start + " → " + end); // Format: Start → End
            }

        } catch (Exception e) {
            e.printStackTrace(); // You may replace this with logging
        }

        return routeNames;
    }
}
