/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.AdminLocations;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminLocationsDAO extends DBContext {

    // Lấy danh sách Locations có phân trang và search
    public List<AdminLocations> getLocations(String search, int offset, int limit) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT location_id, location_name, address, latitude, longitude, location_type, "
                + "location_description, location_created_at, location_status "
                + "FROM Locations WHERE 1=1"
        );
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (location_name LIKE ? OR address LIKE ?)");
        }
        sql.append(" ORDER BY location_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        List<AdminLocations> list = new ArrayList<>();
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (search != null && !search.isEmpty()) {
                String kw = "%" + search + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, limit);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdminLocations loc = new AdminLocations();
                    loc.setLocationId(rs.getInt("location_id"));
                    loc.setLocationName(rs.getString("location_name"));
                    loc.setAddress(rs.getString("address"));
                    loc.setLatitude(rs.getDouble("latitude"));
                    loc.setLongitude(rs.getDouble("longitude"));
                    loc.setLocationType(rs.getString("location_type"));
                    loc.setLocationDescription(rs.getString("location_description"));
                    loc.setLocationCreatedAt(rs.getTimestamp("location_created_at"));
                    loc.setLocationStatus(rs.getString("location_status"));
                    list.add(loc);
                }
            }
        }
        return list;
    }

    // Đếm tổng số Locations theo search
    public int getTotalLocationsCount(String search) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Locations WHERE 1=1");
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (location_name LIKE ? OR address LIKE ?)");
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (search != null && !search.isEmpty()) {
                String kw = "%" + search + "%";
                ps.setString(1, kw);
                ps.setString(2, kw);
            }
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // Lấy chi tiết Location theo ID
    public AdminLocations getLocationById(int id) throws SQLException {
        String sql = "SELECT location_id, location_name, address, latitude, longitude, location_type, "
                + "location_description, location_created_at, location_status "
                + "FROM Locations WHERE location_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AdminLocations loc = new AdminLocations();
                    loc.setLocationId(rs.getInt("location_id"));
                    loc.setLocationName(rs.getString("location_name"));
                    loc.setAddress(rs.getString("address"));
                    loc.setLatitude(rs.getDouble("latitude"));
                    loc.setLongitude(rs.getDouble("longitude"));
                    loc.setLocationType(rs.getString("location_type"));
                    loc.setLocationDescription(rs.getString("location_description"));
                    loc.setLocationCreatedAt(rs.getTimestamp("location_created_at"));
                    loc.setLocationStatus(rs.getString("location_status"));
                    return loc;
                }
            }
        }
        return null;
    }

    // Thêm mới Location
    public void insertLocation(AdminLocations loc) throws SQLException {
        String sql = "INSERT INTO Locations (location_name, address, latitude, longitude, location_type, "
                + "location_description, location_status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loc.getLocationName());
            ps.setString(2, loc.getAddress());
            ps.setDouble(3, loc.getLatitude());
            ps.setDouble(4, loc.getLongitude());
            ps.setString(5, loc.getLocationType());
            ps.setString(6, loc.getLocationDescription());
            ps.setString(7, loc.getLocationStatus());
            ps.executeUpdate();
        }
    }

    // Cập nhật Location
    public void updateLocation(AdminLocations loc) throws SQLException {
        String sql = "UPDATE Locations SET location_name = ?, address = ?, latitude = ?, longitude = ?, "
                + "location_type = ?, location_description = ?, location_status = ? WHERE location_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loc.getLocationName());
            ps.setString(2, loc.getAddress());
            ps.setDouble(3, loc.getLatitude());
            ps.setDouble(4, loc.getLongitude());
            ps.setString(5, loc.getLocationType());
            ps.setString(6, loc.getLocationDescription());
            ps.setString(7, loc.getLocationStatus());
            ps.setInt(8, loc.getLocationId());
            ps.executeUpdate();
        }
    }

    // Xóa Location
    public void deleteLocation(int id) throws SQLException {
        String sql = "DELETE FROM Locations WHERE location_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
