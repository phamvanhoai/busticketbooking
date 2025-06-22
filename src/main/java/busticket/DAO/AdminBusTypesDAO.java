/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.AdminBusTypes;
import busticket.model.AdminSeatTemplate;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminBusTypesDAO extends DBContext {

    public List<AdminBusTypes> getBusTypes(int offset, int limit) throws SQLException {
        String sql = "SELECT bus_type_id, bus_type_name, bus_type_description "
                + "FROM Bus_Types "
                + "ORDER BY bus_type_id "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<AdminBusTypes> list = new ArrayList<>();
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new AdminBusTypes(
                            rs.getInt("bus_type_id"),
                            rs.getString("bus_type_name"),
                            rs.getString("bus_type_description")
                    ));
                }
            }
        }
        return list;
    }

    // Đếm tổng số bus types
    public int getTotalBusTypesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bus_Types";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // 2. Lấy seat templates cho 1 bus type
    public List<AdminSeatTemplate> getSeatTemplatesForType(int busTypeId) throws SQLException {
        String sql = "SELECT st.seat_template_id, st.code, st.level "
                + "FROM Bus_Type_Seat_Template btst "
                + "  JOIN Seat_Templates st ON btst.seat_template_id = st.seat_template_id "
                + "WHERE btst.bus_type_id = ? AND btst.bus_type_seat_template_is_active = 1 "
                + "ORDER BY st.level, st.code";
        List<AdminSeatTemplate> list = new ArrayList<>();
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, busTypeId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new AdminSeatTemplate(
                            rs.getInt("seat_template_id"),
                            rs.getString("code"),
                            rs.getString("level")
                    ));
                }
            }
        }
        return list;
    }
    
    
    
    // Insert BusType and return generated bus_type_id
    public int insertBusType(AdminBusTypes bt) throws SQLException {
        String sql = "INSERT INTO Bus_Types(bus_type_name, bus_type_description) VALUES(?,?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, bt.getBusTypeName());
            ps.setString(2, bt.getBusTypeDescription());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Failed to insert bus type, no ID obtained.");
    }

    // Lookup seat_template_id by code
    public Integer getSeatTemplateIdByCode(String code) throws SQLException {
        String sql = "SELECT seat_template_id FROM Seat_Templates WHERE code = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("seat_template_id");
            }
        }
        return null;
    }

    // Insert one seat position or aisle
    public void insertSeatPosition(int busTypeId, String zone,
                                   int row, int col, boolean isAisle,
                                   int ord, Integer seatTemplateId) throws SQLException {
        String sql = "INSERT INTO Bus_Type_Seat_Template(" +
                     "bus_type_id, seat_template_id, bus_type_seat_template_is_active, " +
                     "bus_type_seat_template_zone, bus_type_seat_template_row, " +
                     "bus_type_seat_template_col, bus_type_seat_template_is_aisle, " +
                     "bus_type_seat_template_order) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, busTypeId);
            if (seatTemplateId != null) ps.setInt(2, seatTemplateId);
            else ps.setNull(2, Types.INTEGER);
            ps.setBoolean(3, true);
            ps.setString(4, zone);
            ps.setInt(5, row);
            ps.setInt(6, col);
            ps.setBoolean(7, isAisle);
            ps.setInt(8, ord);
            ps.executeUpdate();
        }
    }

}
