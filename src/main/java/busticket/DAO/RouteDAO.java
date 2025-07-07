/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
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
public class RouteDAO extends DBContext {

    public List<String> getAllRouteNames() throws SQLException {
        List<String> list = new ArrayList<>();
        String sql = "SELECT CONCAT(start_location, ' → ', end_location) AS route_name FROM Routes";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getString("route_name"));
            }

        } catch (SQLException e) {
            throw e;
        }

        return list;
    }
}
