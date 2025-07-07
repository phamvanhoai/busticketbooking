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

    // Fetch all buses
    public List<AdminBuses> getAllBuses(int offset, int limit) {
        List<AdminBuses> buses = new ArrayList<>();
        String sql = "SELECT b.bus_id, b.bus_code, b.plate_number, b.capacity, b.bus_status, bt.bus_type_name "
                + "FROM Buses b "
                + "JOIN Bus_Types bt ON b.bus_type_id = bt.bus_type_id "
                + "ORDER BY b.bus_id ASC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, offset);
            ps.setInt(2, limit);

            rs = ps.executeQuery();
            while (rs.next()) {
                AdminBuses bus = new AdminBuses(
                        rs.getInt("bus_id"),
                        rs.getString("bus_code"),
                        rs.getString("plate_number"),
                        rs.getInt("capacity"),
                        rs.getString("bus_status"),
                        rs.getString("bus_type_name")
                );
                buses.add(bus);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Không đóng kết nối ở đây
            // Bạn có thể chọn khi nào muốn đóng kết nối thủ công
        }

        return buses;
    }

    // Count total number of buses
    public int countAllBuses() {
        String sql = "SELECT COUNT(*) AS total FROM Buses";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy thông tin xe buýt theo busId
    public AdminBuses getBusById(int busId) {
        AdminBuses bus = null;
        String sql = "SELECT * FROM Buses WHERE bus_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();  // Mở kết nối
            ps = conn.prepareStatement(sql);
            ps.setInt(1, busId);
            rs = ps.executeQuery();

            if (rs.next()) {
                bus = new AdminBuses(
                        rs.getInt("bus_id"),
                        rs.getString("bus_code"),
                        rs.getString("plate_number"),
                        rs.getInt("capacity"),
                        rs.getString("bus_status"),
                        rs.getInt("bus_type_id")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Không đóng kết nối tại đây
            // Không đóng kết nối vì muốn giữ kết nối mở cho toàn bộ phiên làm việc
        }

        return bus;
    }

    // Cập nhật xe buýt
    public void updateBus(AdminBuses bus) throws SQLException {
        String sql = "UPDATE Buses SET bus_code = ?, plate_number = ?, bus_type_id = ?, capacity = ?, bus_status = ? WHERE bus_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bus.getBusCode());
            ps.setString(2, bus.getPlateNumber()); // Số hiệu xe
            ps.setInt(3, bus.getBusTypeId()); // bus_type_id (loại xe buýt)
            ps.setInt(4, bus.getCapacity()); // Sức chứa
            ps.setString(5, bus.getBusStatus()); // Trạng thái xe
            ps.setInt(6, bus.getBusId()); // bus_id (ID của xe buýt)
            ps.executeUpdate(); // Thực hiện cập nhật
        }
    }

    // Lấy tất cả các loại xe buýt từ cơ sở dữ liệu
    public List<AdminBusTypes> getAllBusTypes() {
        List<AdminBusTypes> busTypes = new ArrayList<>();
        String sql = "SELECT bus_type_id, bus_type_name FROM Bus_Types";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();  // Mở kết nối
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                AdminBusTypes busType = new AdminBusTypes();
                busType.setBusTypeId(rs.getInt("bus_type_id"));
                busType.setBusTypeName(rs.getString("bus_type_name"));
                busTypes.add(busType);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Không đóng kết nối tại đây
        }

        return busTypes;
    }

    // Kiểm tra xem busCode hoặc plateNumber đã tồn tại hay chưa
    public boolean isBusExist(String busCode, String plateNumber) {
        String sql = "SELECT COUNT(*) FROM Buses WHERE bus_code = ? OR plate_number = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();  // Mở kết nối
            ps = conn.prepareStatement(sql);  // Chuẩn bị câu lệnh SQL
            ps.setString(1, busCode);
            ps.setString(2, plateNumber);
            rs = ps.executeQuery();  // Thực hiện truy vấn

            if (rs.next() && rs.getInt(1) > 0) {
                return true;  // busCode hoặc plateNumber đã tồn tại
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Không đóng kết nối tại đây, kết nối sẽ được giữ mở cho phiên làm việc
        return false;  // busCode và plateNumber không tồn tại
    }

    // Thêm xe buýt vào cơ sở dữ liệu mà không đóng kết nối
    public void addBus(AdminBuses bus) throws SQLException {
        String sql = "INSERT INTO Buses (bus_code, plate_number, bus_type_id, capacity, bus_status) "
                + "VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = getConnection(); // Mở kết nối
            ps = conn.prepareStatement(sql); // Chuẩn bị câu lệnh SQL
            ps.setString(1, bus.getBusCode());
            ps.setString(2, bus.getPlateNumber());
            ps.setInt(3, bus.getBusTypeId());
            ps.setInt(4, bus.getCapacity());
            ps.setString(5, bus.getBusStatus());

            ps.executeUpdate(); // Thực hiện truy vấn
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        // Không đóng kết nối tại đây
    }

    // Delete a bus
    public void deleteBus(int busId) throws SQLException {
        String sql = "DELETE FROM Buses WHERE bus_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, busId);  // Set busId vào PreparedStatement
            int rowsAffected = ps.executeUpdate();  // Thực hiện xóa xe buýt

            // Kiểm tra xem có bao nhiêu dòng bị ảnh hưởng
            if (rowsAffected == 0) {
                throw new SQLException("No bus found with the given ID.");
            }
        }
    }

}
