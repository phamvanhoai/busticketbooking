/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.AdminBusTypes;
import busticket.model.AdminBuses;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author lyric
 */
public class AdminBusesDAO extends DBContext {

    /**
     * Lấy tất cả các xe buýt
     */
    public List<AdminBuses> getAllBuses(int offset, int limit) {
        List<AdminBuses> buses = new ArrayList<>();
        String sql = "SELECT b.bus_id, b.bus_code, b.plate_number, bt.bus_type_id, bt.bus_type_name, "
                + "b.capacity, b.bus_status "
                + "FROM Buses b "
                + "JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + "ORDER BY b.bus_id ASC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";  // OFFSET và FETCH cho phân trang

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AdminBuses bus = new AdminBuses(
                        rs.getInt("bus_id"),
                        rs.getString("bus_code"),
                        rs.getString("plate_number"),
                        rs.getInt("bus_type_id"),
                        rs.getString("bus_type_name"),
                        rs.getInt("capacity"),
                        rs.getString("bus_status")
                );
                buses.add(bus);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();  // In lỗi ra console
        }
        return buses;
    }

    /**
     * Lấy tất cả các loại xe buýt
     */
    public List<AdminBusTypes> getAllBusTypes() {
        List<AdminBusTypes> list = new ArrayList<>();
        String sql = "SELECT bus_type_id, bus_type_name, bus_type_description FROM Bus_Types ORDER BY bus_type_name";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AdminBusTypes type = new AdminBusTypes(
                        rs.getInt("bus_type_id"),
                        rs.getString("bus_type_name"),
                        rs.getString("bus_type_description")
                );
                list.add(type);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();  // In lỗi ra console
        }
        return list;
    }

    public int countTotalBuses() {
    String sql = "SELECT COUNT(*) AS total FROM Buses";
    int total = 0;

    // Dùng try-with-resources để tự động đóng kết nối khi ra khỏi block này
    try (Connection conn = getConnection();  
         PreparedStatement ps = conn.prepareStatement(sql);  
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            total = rs.getInt("total");
        }
    } catch (SQLException ex) {
        ex.printStackTrace();  // In lỗi ra console
    }
    return total;
}


    /**
     * Lấy một xe buýt theo ID
     */
    public AdminBuses getBusById(int busId) {
        AdminBuses bus = null;
        // Thay 'license_plate' thành 'plate_number' nếu đúng trong bảng của bạn
        String sql = "SELECT b.bus_id, b.bus_code, b.plate_number, bt.bus_type_id, bt.bus_type_name, b.capacity, b.bus_status "
                + "FROM Buses b JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id WHERE b.bus_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, busId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    bus = new AdminBuses(
                            rs.getInt("bus_id"),
                            rs.getString("bus_code"),
                            rs.getString("plate_number"), // Thay 'license_plate' bằng 'plate_number'
                            rs.getInt("bus_type_id"),
                            rs.getString("bus_type_name"),
                            rs.getInt("capacity"),
                            rs.getString("bus_status") // Thay 'status' thành 'bus_status'
                    );
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();  // In lỗi ra console
        }
        return bus;
    }

    /**
     * Lấy BusType ID từ tên BusType
     */
    public int getBusTypeIdByName(String busTypeName) {
        String sql = "SELECT bus_type_id FROM Bus_Types WHERE bus_type_name = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, busTypeName);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("bus_type_id");
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();  // In lỗi ra console
        }
        return -1;  // Trả về -1 nếu không tìm thấy kiểu
    }

    /**
     * Thêm một xe buýt mới
     */
    public boolean addBus(AdminBuses bus) {
        String sql = "INSERT INTO Buses (bus_code, plate_number, bus_type_id, capacity, bus_status) VALUES (?, ?, ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, bus.getBusCode());
            ps.setString(2, bus.getPlateNumber());  // Thay đổi thành plate_number
            ps.setInt(3, bus.getBusTypeId());
            ps.setInt(4, bus.getCapacity());
            ps.setString(5, bus.getBusStatus());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();  // In lỗi ra console
            return false;
        }
    }

    /**
     * Cập nhật thông tin xe buýt
     */
    public boolean updateBus(AdminBuses bus) {
        String sql = "UPDATE Buses SET bus_code = ?, plate_number = ?, bus_type_id = ?, capacity = ?, status = ? WHERE bus_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, bus.getBusCode());
            ps.setString(2, bus.getPlateNumber());  // Thay 'license_plate' bằng 'plate_number'
            ps.setInt(3, bus.getBusTypeId());
            ps.setInt(4, bus.getCapacity());
            ps.setString(5, bus.getBusStatus());
            ps.setInt(6, bus.getBusId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();  // In lỗi ra console
            return false;
        }
    }

    /**
     * Xóa xe buýt theo ID
     */
    public boolean deleteBus(int busId) {
        String sql = "DELETE FROM Buses WHERE bus_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, busId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            // In lỗi nếu vi phạm ràng buộc khóa ngoại
            if (ex.getSQLState().startsWith("23")) {
                System.out.println("Cannot delete bus ID " + busId + ": It is linked to existing trips or other data.");
            } else {
                ex.printStackTrace();  // In lỗi ra console
            }
            return false;
        }
    }

    /**
     * Kiểm tra mã bus hoặc biển số xe có bị trùng không
     */
    public boolean isBusCodeOrLicensePlateExists(String busCode, String licensePlate, Integer excludeBusId) {
        String sql = "SELECT COUNT(*) FROM Buses WHERE (bus_code = ? OR license_plate = ?)";
        if (excludeBusId != null) {
            sql += " AND bus_id <> ?";  // Loại trừ bus hiện tại khi chỉnh sửa
        }

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, busCode);
            ps.setString(2, licensePlate);
            if (excludeBusId != null) {
                ps.setInt(3, excludeBusId);
            }
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();  // In lỗi ra console
        }
        return false;
    }
}
