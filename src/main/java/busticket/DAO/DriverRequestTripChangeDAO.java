/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.DriverRequestTripChange;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author pc
 */
public class DriverRequestTripChangeDAO extends DBContext  {
 
    // 1. Thêm yêu cầu đổi chuyến
    public boolean addRequest(DriverRequestTripChange req) {
        String sql = "INSERT INTO Driver_Trip_Change_Request (driver_id, trip_id, request_date, change_reason, request_status) "
                   + "VALUES (?, ?, GETDATE(), ?, 'Pending')";
        try {
            Object[] params = {
                req.getDriverId(),
                req.getTripId(),
                req.getChangeReason()
            };
            return execQuery(sql, params) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Lấy danh sách yêu cầu của tài xế
    public List<DriverRequestTripChange> getRequestsByDriverId(int driverId) {
        List<DriverRequestTripChange> list = new ArrayList<>();
        String sql = "SELECT * FROM Driver_Trip_Change_Request WHERE driver_id = ?";
        try (ResultSet rs = execSelectQuery(sql, new Object[]{driverId})) {
            while (rs.next()) {
                DriverRequestTripChange req = new DriverRequestTripChange();
                req.setRequestId(rs.getInt("request_id"));
                req.setDriverId(rs.getInt("driver_id"));
                req.setTripId(rs.getInt("trip_id"));
                req.setRequestDate(rs.getTimestamp("request_date"));
                req.setChangeReason(rs.getString("change_reason"));
                req.setRequestStatus(rs.getString("request_status"));
                req.setApprovedByDriverId(rs.getInt("approved_by_driver_id"));
                req.setApprovalDate(rs.getTimestamp("approval_date"));
                list.add(req);
            }
            rs.getStatement().getConnection().close(); // đóng connection
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}


