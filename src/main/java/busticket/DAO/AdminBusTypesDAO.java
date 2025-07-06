/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.AdminBusTypes;
import busticket.model.AdminSeatPosition;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminBusTypesDAO extends DBContext {

    /**
     * 1. Lấy danh sách Bus Types có phân trang
     */
    public List<AdminBusTypes> getBusTypes(int offset, int limit) throws SQLException {
        String sql = "SELECT bus_type_id, bus_type_name, bus_type_description " +
                     "FROM Bus_Types ORDER BY bus_type_id " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<AdminBusTypes> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
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

    /**
     * 2. Đếm tổng số Bus_Types
     */
    public int getTotalBusTypesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Bus_Types";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * 3. Thêm mới Bus_Type và trả về ID
     */
    public int insertBusType(AdminBusTypes model) throws SQLException {
        String sql = "INSERT INTO Bus_Types (bus_type_name, bus_type_description, " +
                     "rowsDown, colsDown, prefixDown, " +
                     "rowsUp, colsUp, prefixUp) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?); " +
                     "SELECT SCOPE_IDENTITY()";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, model.getBusTypeName());
            ps.setString(2, model.getBusTypeDescription());
            ps.setInt(3, model.getRowsDown());
            ps.setInt(4, model.getColsDown());
            ps.setString(5, model.getPrefixDown());
            ps.setInt(6, model.getRowsUp());
            ps.setInt(7, model.getColsUp());
            ps.setString(8, model.getPrefixUp());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new SQLException("Insert bus type failed, no ID obtained.");
    }

    /**
     * 4. Chèn từng ô ghế vào Bus_Type_Seat_Template
     */
    public void insertSeatPosition(int busTypeId,
                                   String zone,
                                   int row,
                                   int col,
                                   int templateOrder,
                                   String seatCode) throws SQLException {
        String sql = "INSERT INTO Bus_Type_Seat_Template " +
                     "(bus_type_id, bus_type_seat_template_zone, " +
                     " bus_type_seat_template_row, bus_type_seat_template_col, " +
                     " bus_type_seat_template_order, bus_type_seat_code) " +
                     "VALUES (?,?,?,?,?,?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, busTypeId);
            ps.setString(2, zone);
            ps.setInt(3, row);
            ps.setInt(4, col);
            ps.setInt(5, templateOrder);
            if (seatCode != null) {
                ps.setString(6, seatCode);
            } else {
                ps.setNull(6, Types.NVARCHAR);
            }
            ps.executeUpdate();
        }
    }

    /**
     * 5. Xóa Bus_Type và các vị trí ghế liên quan
     */
    public void deleteBusType(int busTypeId) throws SQLException {
        String delSeats = "DELETE FROM Bus_Type_Seat_Template WHERE bus_type_id = ?";
        String delType  = "DELETE FROM Bus_Types WHERE bus_type_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps1 = conn.prepareStatement(delSeats);
             PreparedStatement ps2 = conn.prepareStatement(delType)) {
            conn.setAutoCommit(false);
            ps1.setInt(1, busTypeId);
            ps1.executeUpdate();
            ps2.setInt(1, busTypeId);
            ps2.executeUpdate();
            conn.commit();
        }
    }

    /**
     * Xóa toàn bộ seat template cho busType (dùng trong edit)
     */
    public void deleteSeatsForBusType(int busTypeId) throws SQLException {
        String sql = "DELETE FROM Bus_Type_Seat_Template WHERE bus_type_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, busTypeId);
            ps.executeUpdate();
        }
    }

    /**
     * Lấy thông tin 1 Bus Type theo ID
     */
    public AdminBusTypes getBusTypeById(int id) throws SQLException {
        String sql = "SELECT bus_type_id, bus_type_name, bus_type_description, " +
                     "rowsDown, colsDown, prefixDown, " +
                     "rowsUp, colsUp, prefixUp " +
                     "FROM Bus_Types WHERE bus_type_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AdminBusTypes busType = new AdminBusTypes();
                    busType.setBusTypeId(rs.getInt("bus_type_id"));
                    busType.setBusTypeName(rs.getString("bus_type_name"));
                    busType.setBusTypeDescription(rs.getString("bus_type_description"));
                    busType.setRowsDown(rs.getInt("rowsDown"));
                    busType.setColsDown(rs.getInt("colsDown"));
                    busType.setPrefixDown(rs.getString("prefixDown"));
                    busType.setRowsUp(rs.getInt("rowsUp"));
                    busType.setColsUp(rs.getInt("colsUp"));
                    busType.setPrefixUp(rs.getString("prefixUp"));
                    return busType;
                }
            }
        }
        return null;
    }

    /**
     * 6. Cập nhật full Bus_Type (tên, mô tả, cấu hình ghế)
     */
    public void updateBusType(AdminBusTypes model) throws SQLException {
        String sql = "UPDATE Bus_Types SET " +
                     "bus_type_name = ?, bus_type_description = ?, " +
                     "rowsDown = ?, colsDown = ?, prefixDown = ?, " +
                     "rowsUp = ?, colsUp = ?, prefixUp = ? " +
                     "WHERE bus_type_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, model.getBusTypeName());
            ps.setString(2, model.getBusTypeDescription());
            ps.setInt(3, model.getRowsDown());
            ps.setInt(4, model.getColsDown());
            ps.setString(5, model.getPrefixDown());
            ps.setInt(6, model.getRowsUp());
            ps.setInt(7, model.getColsUp());
            ps.setString(8, model.getPrefixUp());
            ps.setInt(9, model.getBusTypeId());
            ps.executeUpdate();
        }
    }

    /**
     * 7. Lấy danh sách ghế cho busType + zone
     */
    public List<AdminSeatPosition> getSeatPositionsForBusType(int busTypeId, String zone) throws SQLException {
        String sql = "SELECT * FROM Bus_Type_Seat_Template " +
                     "WHERE bus_type_id = ? AND bus_type_seat_template_zone = ? " +
                     "ORDER BY bus_type_seat_template_order";
        List<AdminSeatPosition> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, busTypeId);
            ps.setString(2, zone);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdminSeatPosition seat = new AdminSeatPosition();
                    seat.setBusTypeId(rs.getInt("bus_type_id"));
                    seat.setZone(rs.getString("bus_type_seat_template_zone"));
                    seat.setRow(rs.getInt("bus_type_seat_template_row"));
                    seat.setCol(rs.getInt("bus_type_seat_template_col"));
                    seat.setCode(rs.getString("bus_type_seat_code"));
                    list.add(seat);
                }
            }
        }
        return list;
    }

    /**
     * 8. Cập nhật seat position (chỉ code)
     */
    public void updateSeatPosition(int busTypeId, String zone, int row, int col, String seatCode) throws SQLException {
        String sql = "UPDATE Bus_Type_Seat_Template SET bus_type_seat_code = ? " +
                     "WHERE bus_type_id = ? AND bus_type_seat_template_zone = ? " +
                     "AND bus_type_seat_template_row = ? AND bus_type_seat_template_col = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, seatCode);
            ps.setInt(2, busTypeId);
            ps.setString(3, zone);
            ps.setInt(4, row);
            ps.setInt(5, col);
            ps.executeUpdate();
        }
    }

    /**
     * 9. Xóa 1 seat position
     */
    public void deleteSeatPosition(int busTypeId, String zone, int row, int col) throws SQLException {
        String sql = "DELETE FROM Bus_Type_Seat_Template WHERE bus_type_id = ? " +
                     "AND bus_type_seat_template_zone = ? AND bus_type_seat_template_row = ? " +
                     "AND bus_type_seat_template_col = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, busTypeId);
            ps.setString(2, zone);
            ps.setInt(3, row);
            ps.setInt(4, col);
            ps.executeUpdate();
        }
    }

}
