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
     * @return List of StaffRoute objects
     * @throws SQLException if any SQL error occurs
     */
    public List<StaffRoute> getAllRoutes() throws SQLException {
        List<StaffRoute> routeList = new ArrayList<>();

        String sql = "SELECT r.route_id, "
                + "       CONCAT(ls.location_name, ' &rarr; ', le.location_name) AS route_name "
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
     * Retrieves a distinct list of route names for dropdowns. Format:
     * "StartLocation → EndLocation"
     *
     * @return List of route name strings
     */
    public List<String> getAllRouteNames() {
        List<String> routeNames = new ArrayList<>();

        String sql = "SELECT DISTINCT CONCAT(ls.location_name, ' &rarr; ', le.location_name) AS route_name "
                + "FROM Routes r "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id = le.location_id "
                + "ORDER BY route_name";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                routeNames.add(rs.getString("route_name"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return routeNames;
    }
}
