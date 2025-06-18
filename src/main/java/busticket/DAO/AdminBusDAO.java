/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.Buses;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author lyric
 */
public class AdminBusDAO extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(AdminBusDAO.class.getName());

    // Phương thức để lấy tất cả các xe buýt
    public List<Buses> getAllBuses() {
        List<Buses> buses = new ArrayList<>();
        // Đảm bảo tên bảng và cột khớp với schema DB của bạn
        String sql = "SELECT b.bus_id, b.bus_code, b.license_plate, bt.bus_type_id, bt.bus_type_name, b.capacity, b.status "
                + "FROM Buses b JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id ORDER BY b.bus_id DESC";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Buses bus = new Buses(
                        rs.getInt("bus_id"),
                        rs.getString("bus_code"),
                        rs.getString("license_plate"),
                        rs.getInt("bus_type_id"),
                        rs.getString("bus_type_name"),
                        rs.getInt("capacity"),
                        rs.getString("status")
                );
                buses.add(bus);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting all buses", ex);
        }
        return buses;
    }

    // Phương thức để lấy một xe buýt theo ID
    public Buses getBusById(int busId) {
        Buses bus = null;
        String sql = "SELECT b.bus_id, b.bus_code, b.license_plate, bt.bus_type_id, bt.bus_type_name, b.capacity, b.status "
                + "FROM Buses b JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id WHERE b.bus_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, busId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    bus = new Buses(
                            rs.getInt("bus_id"),
                            rs.getString("bus_code"),
                            rs.getString("license_plate"),
                            rs.getInt("bus_type_id"),
                            rs.getString("bus_type_name"),
                            rs.getInt("capacity"),
                            rs.getString("status")
                    );
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting bus by ID: " + busId, ex);
        }
        return bus;
    }

    // Phương thức để lấy BusType ID từ tên BusType
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
            LOGGER.log(Level.SEVERE, "Error getting bus type ID by name: " + busTypeName, ex);
        }
        return -1; // Trả về -1 hoặc ném một ngoại lệ nếu không tìm thấy kiểu
    }

//    // Phương thức để lấy tất cả các loại xe buýt (dùng cho dropdown trong form)
//    public List<BusTypes> getAllBusTypes() {
//        List<BusTypes> busTypes = new ArrayList<>();
//        String sql = "SELECT bus_type_id, bus_type_name FROM Bus_Types";
//        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                busTypes.add(new BusTypes(rs.getInt("bus_type_id"), rs.getString("bus_type_name")));
//            }
//        } catch (SQLException ex) {
//            LOGGER.log(Level.SEVERE, "Error getting all bus types", ex);
//        }
//        return busTypes;
//    }

    // Phương thức để thêm một xe buýt mới
    public boolean addBus(Buses bus) {
        String sql = "INSERT INTO Buses (bus_code, license_plate, bus_type_id, capacity, status) VALUES (?, ?, ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bus.getBusCode());
            ps.setString(2, bus.getLicensePlate());
            ps.setInt(3, bus.getBusTypeId());
            ps.setInt(4, bus.getCapacity());
            ps.setString(5, bus.getStatus());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error adding new bus: " + bus.getBusCode(), ex);
            return false;
        }
    }

    // Phương thức để cập nhật thông tin xe buýt
    public boolean updateBus(Buses bus) {
        String sql = "UPDATE Buses SET bus_code = ?, license_plate = ?, bus_type_id = ?, capacity = ?, status = ? WHERE bus_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bus.getBusCode());
            ps.setString(2, bus.getLicensePlate());
            ps.setInt(3, bus.getBusTypeId());
            ps.setInt(4, bus.getCapacity());
            ps.setString(5, bus.getStatus());
            ps.setInt(6, bus.getBusId());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating bus: " + bus.getBusId(), ex);
            return false;
        }
    }

    // Phương thức để xóa xe buýt theo ID
    public boolean deleteBus(int busId) {
        String sql = "DELETE FROM Buses WHERE bus_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, busId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            // Ghi log một thông báo cụ thể hơn nếu đó là lỗi vi phạm ràng buộc khóa ngoại
            if (ex.getSQLState().startsWith("23")) { // SQLState cho lỗi vi phạm ràng buộc toàn vẹn
                LOGGER.log(Level.WARNING, "Cannot delete bus ID " + busId + ": It is linked to existing trips or other data.", ex);
            } else {
                LOGGER.log(Level.SEVERE, "Error deleting bus ID: " + busId, ex);
            }
            return false;
        }
    }

    // Phương thức kiểm tra mã bus hoặc biển số xe có bị trùng không
    public boolean isBusCodeOrLicensePlateExists(String busCode, String licensePlate, Integer excludeBusId) {
        String sql = "SELECT COUNT(*) FROM Buses WHERE (bus_code = ? OR license_plate = ?)";
        if (excludeBusId != null) {
            sql += " AND bus_id <> ?"; // Loại trừ bus hiện tại khi chỉnh sửa
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
            LOGGER.log(Level.SEVERE, "Error checking for existing bus code/license plate", ex);
        }
        return false;
    }
}
