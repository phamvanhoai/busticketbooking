/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.AdminRoutes;
import java.sql.*;
import java.util.*;

public class AdminRoutesDAO extends DBContext {

    // Lấy tất cả các tuyến đường với phân trang
    public List<AdminRoutes> getAllRoutes(int offset, int limit) {
        List<AdminRoutes> list = new ArrayList<>();
        String sql = "SELECT route_id, start_location, end_location, distance_km, estimated_time "
                + "FROM Routes "
                + "ORDER BY route_id ASC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AdminRoutes route = new AdminRoutes();
                route.setRouteId(rs.getInt("route_id"));
                route.setStartLocation(rs.getString("start_location"));
                route.setEndLocation(rs.getString("end_location"));
                route.setDistanceKm(rs.getDouble("distance_km"));
                route.setEstimatedTime(rs.getString("estimated_time")); // Giá trị theo HH:mm:ss
                list.add(route);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Đếm số tuyến đường trong cơ sở dữ liệu
    public int countRoutes() {
        String sql = "SELECT COUNT(*) AS total FROM Routes";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tạo tuyến đường mới
    public void createRoute(AdminRoutes route) {
        String sql = "INSERT INTO Routes (start_location, end_location, distance_km, estimated_time) VALUES (?, ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, route.getStartLocation());
            ps.setString(2, route.getEndLocation());
            ps.setDouble(3, route.getDistanceKm());

            // Chuyển estimatedTime từ dạng "X minutes" sang số phút (int)
            String estimatedTimeStr = route.getEstimatedTime();  // Ví dụ: "150 minutes"
            if (estimatedTimeStr != null && estimatedTimeStr.matches("\\d+ minutes")) {
                int minutes = Integer.parseInt(estimatedTimeStr.replace(" minutes", "").trim());
                ps.setInt(4, minutes);  // Lưu vào cơ sở dữ liệu với dạng INT (số phút)
            }

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error executing query: " + e.getMessage());
        }
    }

    // Cập nhật tuyến đường
    public void updateRoute(AdminRoutes route) {
        String sql = "UPDATE Routes SET start_location=?, end_location=?, distance_km=?, estimated_time=? WHERE route_id=?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, route.getStartLocation());
            ps.setString(2, route.getEndLocation());
            ps.setDouble(3, route.getDistanceKm());

            // Chuyển estimatedTime từ dạng "X minutes" sang số phút (int)
            String estimatedTimeStr = route.getEstimatedTime();  // Ví dụ: "150 minutes"
            if (estimatedTimeStr != null && estimatedTimeStr.matches("\\d+ minutes")) {
                int minutes = Integer.parseInt(estimatedTimeStr.replace(" minutes", "").trim());
                ps.setInt(4, minutes);  // Lưu vào cơ sở dữ liệu với dạng INT (số phút)
            }

            ps.setInt(5, route.getRouteId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error executing query: " + e.getMessage());
        }
    }

    // Xóa tuyến đường
    public void deleteRoute(int id) {
        String sql = "DELETE FROM Routes WHERE route_id=?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Lấy tuyến đường theo ID
    public AdminRoutes getRouteById(int routeId) {
        AdminRoutes route = null;
        String sql = "SELECT route_id, start_location, end_location, distance_km, estimated_time "
                + "FROM Routes WHERE route_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, routeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                route = new AdminRoutes();
                route.setRouteId(rs.getInt("route_id"));
                route.setStartLocation(rs.getString("start_location"));
                route.setEndLocation(rs.getString("end_location"));
                route.setDistanceKm(rs.getDouble("distance_km"));
                route.setEstimatedTime(rs.getInt("estimated_time") + " minutes");  // Đọc và trả về với định dạng "minutes"
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return route;
    }
}
