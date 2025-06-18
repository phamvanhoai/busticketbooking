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

    public List<AdminRoutes> getAllRoutes() {
        List<AdminRoutes> list = new ArrayList<>();
        String sql = "SELECT route_id, start_location, end_location, distance_km, estimated_time "
                + "FROM Routes";  // Sửa câu lệnh chỉ lấy thông tin từ bảng Routes

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AdminRoutes route = new AdminRoutes();
                route.setRouteId(rs.getInt("route_id"));
                route.setStartLocation(rs.getString("start_location"));
                route.setEndLocation(rs.getString("end_location"));
                route.setDistanceKm(rs.getDouble("distance_km"));
                route.setEstimatedTime(rs.getString("estimated_time"));
                list.add(route);
            }
        } catch (SQLException e) {
            e.printStackTrace();  // Log lỗi chi tiết
        }

        return list;
    }

    public void createRoute(AdminRoutes route) {
        String sql = "INSERT INTO Routes (start_location, end_location, distance_km, estimated_time) VALUES (?, ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            // Ghi thông tin đầu vào
            System.out.println("Start Location: " + route.getStartLocation());
            System.out.println("End Location: " + route.getEndLocation());
            System.out.println("Distance (km): " + route.getDistanceKm());
            System.out.println("Estimated Time: " + route.getEstimatedTime());

            ps.setString(1, route.getStartLocation());
            ps.setString(2, route.getEndLocation());
            ps.setDouble(3, route.getDistanceKm());

            // Kiểm tra và xử lý estimatedTime trước khi insert
            try {
                String estimatedTimeStr = route.getEstimatedTime();

                // Nếu estimatedTime là dạng số phút, ví dụ "150 minutes"
                if (estimatedTimeStr != null && estimatedTimeStr.matches("\\d+ minutes")) {
                    int minutes = Integer.parseInt(estimatedTimeStr.replace(" minutes", "").trim());
                    int hours = minutes / 60;
                    minutes = minutes % 60;
                    estimatedTimeStr = String.format("%02d:%02d:%02d", hours, minutes, 0);  // Chuyển thành HH:mm:ss
                }

                // Kiểm tra định dạng HH:mm:ss
                if (estimatedTimeStr != null && !estimatedTimeStr.matches("^\\d{2}:\\d{2}:\\d{2}$")) {
                    throw new IllegalArgumentException("Invalid estimated time format. Please use HH:mm:ss format.");
                }

                // Chuyển đổi estimatedTime thành Time
                ps.setTime(4, Time.valueOf(estimatedTimeStr));  // Chuyển đổi estimatedTime thành Time
            } catch (IllegalArgumentException e) {
                e.printStackTrace();  // Log lỗi chi tiết
                throw new SQLException("Invalid estimated time format: " + e.getMessage());
            }

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();  // Log lỗi chi tiết
            throw new RuntimeException("Error executing query: " + e.getMessage());
        }
    }

    public void updateRoute(AdminRoutes route) {
        String sql = "UPDATE Routes SET start_location=?, end_location=?, distance_km=?, estimated_time=? WHERE route_id=?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, route.getStartLocation());
            ps.setString(2, route.getEndLocation());
            ps.setDouble(3, route.getDistanceKm());

            // Kiểm tra và chuyển đổi thời gian trước khi update
            try {
                ps.setTime(4, Time.valueOf(route.getEstimatedTime()));  // Chuyển đổi estimatedTime thành Time
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
                throw new SQLException("Invalid estimated time format.");
            }

            ps.setInt(5, route.getRouteId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();  // Log lỗi chi tiết
            throw new RuntimeException("Error executing query: " + e.getMessage());
        }
    }

    public void deleteRoute(int id) {
        String sql = "DELETE FROM Routes WHERE route_id=?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();  // Log lỗi chi tiết
        }
    }
}
