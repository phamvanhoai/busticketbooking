/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.AdminBusTypes;
import busticket.model.AdminLocations;
import busticket.model.AdminRoutePrice;
import busticket.model.AdminRouteStop;
import busticket.model.AdminRoutes;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class AdminRoutesDAO extends DBContext {

    /**
     * Lấy tất cả các tuyến đường với phân trang, join bảng Locations để lấy tên
     * và cả trạng thái
     */
    public List<AdminRoutes> getAllRoutes(int offset, int limit) {
        List<AdminRoutes> list = new ArrayList<>();
        String sql = "SELECT r.route_id, "
                + "       ls.location_id        AS start_location_id, "
                + "       ls.location_name      AS start_location, "
                + "       le.location_id        AS end_location_id, "
                + "       le.location_name      AS end_location, "
                + "       r.distance_km, "
                + "       r.estimated_time, "
                + "       r.route_status        AS route_status "
                + "FROM Routes r "
                + "  JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "  JOIN Locations le ON r.end_location_id   = le.location_id "
                + "ORDER BY r.route_id ASC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, limit);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdminRoutes route = new AdminRoutes();
                    route.setRouteId(rs.getInt("route_id"));
                    route.setStartLocationId(rs.getInt("start_location_id"));
                    route.setStartLocation(rs.getString("start_location"));
                    route.setEndLocationId(rs.getInt("end_location_id"));
                    route.setEndLocation(rs.getString("end_location"));
                    route.setDistanceKm(rs.getDouble("distance_km"));
                    route.setEstimatedTime(rs.getInt("estimated_time"));
                    route.setRouteStatus(rs.getString("route_status"));  // set status
                    list.add(route);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error loading routes", e);
        }

        return list;
    }

    /**
     * Đếm tổng số tuyến đường
     */
    public int countRoutes() {
        String sql = "SELECT COUNT(*) AS total FROM Routes";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error counting routes", e);
        }
        return 0;
    }

    /**
     * Tạo mới 1 route và trả về route_id được sinh tự động
     */
    public int createRoute(AdminRoutes route) throws SQLException {
        String sql = "INSERT INTO Routes "
                + "(start_location_id, end_location_id, distance_km, estimated_time, route_status) "
                + "VALUES(?,?,?,?,?)";
        try ( PreparedStatement ps = getConnection()
                .prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, route.getStartLocationId());
            ps.setInt(2, route.getEndLocationId());
            ps.setDouble(3, route.getDistanceKm());
            ps.setInt(4, route.getEstimatedTime());
            ps.setString(5, route.getRouteStatus());
            ps.executeUpdate();
            try ( ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new SQLException("Failed to create route, no ID obtained.");
    }

    /**
     * Cập nhật thông tin của một route đã tồn tại
     */
    public void updateRoute(AdminRoutes route) {
        String sql = "UPDATE Routes SET "
                + "    start_location_id = ?, "
                + "    end_location_id   = ?, "
                + "    distance_km       = ?, "
                + "    estimated_time    = ?, "
                + "    route_status      = ? "
                + "WHERE route_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, route.getStartLocationId());
            ps.setInt(2, route.getEndLocationId());
            ps.setDouble(3, route.getDistanceKm());
            ps.setInt(4, route.getEstimatedTime());
            ps.setString(5, route.getRouteStatus());  // thêm status
            ps.setInt(6, route.getRouteId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating route", e);
        }
    }

    /**
     * Xóa hết các bản ghi giá cho một route
     */
    public void deleteRoutePrices(int routeId) throws SQLException {
        String sql = "DELETE FROM Route_Prices WHERE route_id = ?";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, routeId);
            ps.executeUpdate();
        }
    }

    /**
     * Xóa tuyến đường
     */
    public void deleteRoute(int routeId) throws SQLException {
        // 1) Xoá giá
        deleteRoutePrices(routeId);
        // 2) Xoá stops
        deleteRouteStops(routeId);
        // 3) Xoá route
        String sql = "DELETE FROM Routes WHERE route_id = ?";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, routeId);
            ps.executeUpdate();
        }
    }

    /**
     * Lấy thông tin chi tiết tuyến đường theo ID
     */
    public AdminRoutes getRouteById(int routeId) {
        AdminRoutes route = null;
        String sql = "SELECT "
                + "    r.route_id, "
                + "    ls.location_id AS start_location_id, "
                + "    ls.location_name AS start_location, "
                + "    le.location_id AS end_location_id, "
                + "    le.location_name AS end_location, "
                + "    r.distance_km, "
                + "    r.estimated_time, "
                + "    r.route_status "
                + "FROM Routes r "
                + "JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "JOIN Locations le ON r.end_location_id   = le.location_id "
                + "WHERE r.route_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, routeId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    route = new AdminRoutes();
                    route.setRouteId(rs.getInt("route_id"));
                    route.setStartLocationId(rs.getInt("start_location_id"));
                    route.setStartLocation(rs.getString("start_location"));
                    route.setEndLocationId(rs.getInt("end_location_id"));
                    route.setEndLocation(rs.getString("end_location"));
                    route.setDistanceKm(rs.getDouble("distance_km"));
                    route.setEstimatedTime(rs.getInt("estimated_time"));
                    route.setRouteStatus(rs.getString("route_status"));  
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error loading route", e);
        }
        return route;
    }

    /**
     * Lấy tất cả các địa điểm (id + name) để dùng làm filter trong AdminTrips
     */
    public List<AdminLocations> getAllLocations() {
        List<AdminLocations> locations = new ArrayList<>();
        String sql = "SELECT location_id, location_name FROM Locations ORDER BY location_name";

        try ( PreparedStatement ps = getConnection().prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AdminLocations loc = new AdminLocations();
                loc.setLocationId(rs.getInt("location_id"));
                loc.setLocationName(rs.getString("location_name"));
                locations.add(loc);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            // bạn có thể log hoặc rethrow exception tuỳ nhu cầu
        }

        return locations;
    }

    /**
     * Lấy tất cả các loại xe (id + name) để dùng làm dropdown filter hoặc form
     */
    public List<AdminBusTypes> getAllBusTypes() {
        List<AdminBusTypes> list = new ArrayList<>();
        String sql = "SELECT bus_type_id, bus_type_name FROM Bus_Types ORDER BY bus_type_name";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AdminBusTypes bt = new AdminBusTypes();
                bt.setBusTypeId(rs.getInt("bus_type_id"));
                bt.setBusTypeName(rs.getString("bus_type_name"));
                list.add(bt);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    // Add new route_price for a route + busType
    public void addRoutePrice(int routeId, int busTypeId, BigDecimal route_price) throws SQLException {
        String sql = "INSERT INTO Route_Prices(route_id, bus_type_id, route_price) VALUES(?, ?, ?)";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, routeId);
            ps.setInt(2, busTypeId);
            ps.setBigDecimal(3, route_price);
            ps.executeUpdate();
        }
    }

    // Expire any existing price (set route_price_effective_to)
    public void expireOldRoutePrices(int routeId, int busTypeId) throws SQLException {
        String sql = "UPDATE Route_Prices SET route_price_effective_to = GETDATE() "
                + "WHERE route_id = ? AND bus_type_id = ? AND route_price_effective_to IS NULL";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, routeId);
            ps.setInt(2, busTypeId);
            ps.executeUpdate();
        }
    }

    // Get current route_price for route + busType
    public BigDecimal getCurrentRoutePrice(int routeId, int busTypeId) throws SQLException {
        String sql = "SELECT route_price FROM Route_Prices "
                + "WHERE route_id = ? AND bus_type_id = ? AND route_price_effective_to IS NULL";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, routeId);
            ps.setInt(2, busTypeId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("route_price");
                }
            }
        }
        return null;
    }

    // Add list of route stops
    public void addRouteStops(int routeId, List<AdminRouteStop> stops) throws SQLException {
        String sql = "INSERT INTO Route_Stops(route_id, route_stop_number, location_id, route_stop_dwell_minutes) "
                + "VALUES(?, ?, ?, ?)";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            for (AdminRouteStop stop : stops) {
                ps.setInt(1, routeId);
                ps.setInt(2, stop.getStopNumber());
                ps.setInt(3, stop.getLocationId());
                ps.setInt(4, stop.getDwellMinutes());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    // Delete existing stops for a route (useful for update)
    public void deleteRouteStops(int routeId) throws SQLException {
        String sql = "DELETE FROM Route_Stops WHERE route_id = ?";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, routeId);
            ps.executeUpdate();
        }
    }

    /**
     * Lấy danh sách giá hiện hành (effective_to IS NULL) cho một route
     */
    public List<AdminRoutePrice> getPricesByRouteId(int routeId) throws SQLException {
        List<AdminRoutePrice> list = new ArrayList<>();
        String sql = "SELECT bus_type_id, route_price"
                + "  FROM Route_Prices"
                + " WHERE route_id = ?"
                + " AND route_price_effective_to IS NULL"
                + " ORDER BY bus_type_id";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, routeId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdminRoutePrice rp = new AdminRoutePrice();
                    rp.setRouteId(routeId);
                    rp.setBusTypeId(rs.getInt("bus_type_id"));
                    rp.setPrice(rs.getBigDecimal("route_price"));
                    list.add(rp);
                }
            }
        }
        return list;
    }

    /**
     * Lấy danh sách điểm dừng của một route, theo thứ tự stop_number
     */
    public List<AdminRouteStop> getRouteStops(int routeId) throws SQLException {
        List<AdminRouteStop> list = new ArrayList<>();
        String sql = "SELECT route_stop_number, location_id, route_stop_dwell_minutes"
                + " FROM Route_Stops"
                + " WHERE route_id = ?"
                + " ORDER BY route_stop_number";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, routeId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdminRouteStop stop = new AdminRouteStop();
                    stop.setRouteId(routeId);
                    stop.setStopNumber(rs.getInt("route_stop_number"));
                    stop.setLocationId(rs.getInt("location_id"));
                    stop.setDwellMinutes(rs.getInt("route_stop_dwell_minutes"));
                    list.add(stop);
                }
            }
        }
        return list;
    }

}
