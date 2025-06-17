/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.StaffSupportDriverTrip;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author pc
 */
public class StaffSupportDriverTripDAO extends DBContext {

    public List<StaffSupportDriverTrip> getDriverCancelTripRequests(int offset, int limit) {
        List<StaffSupportDriverTrip> list = new ArrayList<>();

        String sql = "SELECT dr.request_id, t.trip_id, t.route_id, t.departure_time, t.trip_status, "
                + "d.driver_id, u.user_name AS driver_name, "
                + "dr.change_reason, dr.request_status, dr.request_date, "
                + "dr.approved_by_driver_id AS approved_by_staff_id, dr.approval_date "
                + "FROM Driver_Trip_Change_Request dr "
                + "INNER JOIN Drivers d ON dr.driver_id = d.driver_id "
                + "INNER JOIN Users u ON d.user_id = u.user_id "
                + "INNER JOIN Trips t ON dr.trip_id = t.trip_id "
                + "ORDER BY dr.request_date DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StaffSupportDriverTrip req = new StaffSupportDriverTrip();
                req.setRequestId(rs.getInt("request_id"));
                req.setTripId(rs.getInt("trip_id"));
                req.setRouteId(rs.getInt("route_id"));
                req.setDepartureTime(rs.getTimestamp("departure_time"));
                req.setTripStatus(rs.getString("trip_status"));
                req.setDriverId(rs.getInt("driver_id"));
                req.setDriverName(rs.getString("driver_name"));
                req.setChangeReason(rs.getString("change_reason"));
                req.setRequestStatus(rs.getString("request_status"));
                req.setRequestDate(rs.getTimestamp("request_date"));
                req.setApprovedByStaffId(rs.getInt("approved_by_staff_id"));
                req.setApprovalDate(rs.getTimestamp("approval_date"));

                list.add(req);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countDriverCancelTripRequests() {
        String sql = "SELECT COUNT(*) AS total FROM Driver_Trip_Change_Request";

        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public void updateRequestStatus(int requestId, String status) {
        String sql = "UPDATE Driver_Trip_Change_Request "
                + "SET request_status = ?, approval_date = GETDATE() "
                + "WHERE request_id = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, requestId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
