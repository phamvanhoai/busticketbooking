/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.AdminLocations;
import busticket.model.Schedule;
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
public class ScheduleDAO extends DBContext {

    /**
     * Lấy danh sách schedule (origin→destination) có phân trang và filter.
     *
     * @param originKeyword chuỗi tìm kiếm origin (LIKE '%...%'), null hoặc rỗng
     * = không filter
     * @param destKeyword chuỗi tìm kiếm destination (LIKE '%...%'), null hoặc
     * rỗng = không filter
     * @param offset số bản ghi bỏ qua (zero-based)
     * @param limit số bản ghi tối đa lấy về
     */
    public List<Schedule> getSchedules(String originKeyword,
            String destKeyword,
            int offset,
            int limit) throws SQLException {
        List<Schedule> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT "
                + "  ls.location_name               AS origin, "
                + "  le.location_name               AS destination, "
                + "  bt.bus_type_name               AS busType, "
                + "  r.distance_km, "
                + "  SUM(rs.travel_minutes + rs.route_stop_dwell_minutes) AS totalMinutes, "
                + "  rp.route_price                 AS price "
                + "FROM Routes r "
                + "  JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "  JOIN Locations le ON r.end_location_id   = le.location_id "
                + "  JOIN Route_Stops rs ON r.route_id        = rs.route_id "
                + "  JOIN Route_Prices rp ON r.route_id       = rp.route_id "
                + "  JOIN Bus_Types bt ON rp.bus_type_id      = bt.bus_type_id "
                + "WHERE rp.route_price_effective_to IS NULL "
        );
        // Filter origin/destination nếu có
        if (originKeyword != null && !originKeyword.isEmpty()) {
            sql.append("  AND ls.location_name LIKE ? ");
        }
        if (destKeyword != null && !destKeyword.isEmpty()) {
            sql.append("  AND le.location_name LIKE ? ");
        }
        sql.append(
                "GROUP BY ls.location_name, le.location_name, bt.bus_type_name, r.distance_km, rp.route_price "
                + "ORDER BY ls.location_name, le.location_name, bt.bus_type_name "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
        );

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (originKeyword != null && !originKeyword.isEmpty()) {
                ps.setString(idx++, "%" + originKeyword + "%");
            }
            if (destKeyword != null && !destKeyword.isEmpty()) {
                ps.setString(idx++, "%" + destKeyword + "%");
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, limit);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Schedule s = new Schedule();
                    s.setOrigin(rs.getString("origin"));
                    s.setDestination(rs.getString("destination"));
                    s.setBusType(rs.getString("busType"));
                    s.setDistanceKm(rs.getDouble("distance_km"));
                    s.setDurationMinutes(rs.getInt("totalMinutes"));
                    s.setPrice(rs.getBigDecimal("price"));
                    list.add(s);
                }
            }
        }

        return list;
    }

    /**
     * Đếm tổng số bản ghi schedule thỏa điều kiện filter
     */
    public int countSchedules(String originKeyword,
            String destKeyword) throws SQLException {
        // Đặt alias cho các cột để không trùng tên
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) AS total FROM ("
                + "  SELECT "
                + "    ls.location_name AS origin, "
                + "    le.location_name AS destination, "
                + "    bt.bus_type_name AS busType, "
                + "    r.distance_km, "
                + "    rp.route_price "
                + "  FROM Routes r "
                + "    JOIN Locations ls ON r.start_location_id = ls.location_id "
                + "    JOIN Locations le ON r.end_location_id   = le.location_id "
                + "    JOIN Route_Stops rs ON r.route_id        = rs.route_id "
                + "    JOIN Route_Prices rp ON r.route_id       = rp.route_id "
                + "    JOIN Bus_Types bt ON rp.bus_type_id      = bt.bus_type_id "
                + "  WHERE rp.route_price_effective_to IS NULL "
        );
        if (originKeyword != null && !originKeyword.isEmpty()) {
            sql.append(" AND ls.location_name LIKE ? ");
        }
        if (destKeyword != null && !destKeyword.isEmpty()) {
            sql.append(" AND le.location_name LIKE ? ");
        }
        sql.append(
                "  GROUP BY "
                + "    ls.location_name, "
                + "    le.location_name, "
                + "    bt.bus_type_name, "
                + "    r.distance_km, "
                + "    rp.route_price"
                + ") AS sub"
        );

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (originKeyword != null && !originKeyword.isEmpty()) {
                ps.setString(idx++, "%" + originKeyword + "%");
            }
            if (destKeyword != null && !destKeyword.isEmpty()) {
                ps.setString(idx++, "%" + destKeyword + "%");
            }
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }

    /**
     * Lấy tất cả địa điểm (location_id + location_name) để làm dropdown filter
     */
    public List<AdminLocations> getAllLocations() throws SQLException {
        List<AdminLocations> list = new ArrayList<>();
        String sql
                = "SELECT location_id, location_name "
                + "FROM Locations "
                + "WHERE location_status = 'Active' "
                + "ORDER BY location_name";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AdminLocations loc = new AdminLocations();
                loc.setLocationId(rs.getInt("location_id"));
                loc.setLocationName(rs.getString("location_name"));
                list.add(loc);
            }
        }
        return list;
    }
}
