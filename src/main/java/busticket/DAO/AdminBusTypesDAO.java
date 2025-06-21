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
                + "WHERE btst.bus_type_id = ? AND btst.is_active = 1 "
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
}
