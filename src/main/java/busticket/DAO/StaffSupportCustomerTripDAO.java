/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.model.StaffSupportCustomerTrip;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author pc
 */
public class StaffSupportCustomerTripDAO {
    private Connection conn;

    public StaffSupportCustomerTripDAO(Connection conn) {
        this.conn = conn;
    }

    public List<StaffSupportCustomerTrip> getAllRequests() {
        List<StaffSupportCustomerTrip> list = new ArrayList<>();

        try {
            String sql = "SELECT r.request_id, u.user_name AS customer_name, " +
                         "CONCAT(l1.location_name, ' → ', l2.location_name) AS old_trip_name, " +
                         "'' AS new_trip_name, " +  // tạm để rỗng vì DB chưa có new_trip_id
                         "r.request_date, r.request_status " +
                         "FROM Driver_Trip_Change_Request r " +
                         "JOIN Drivers d ON r.driver_id = d.driver_id " +
                         "JOIN Users u ON d.user_id = u.user_id " +
                         "JOIN Trips t ON r.trip_id = t.trip_id " +
                         "JOIN Routes ro ON t.route_id = ro.route_id " +
                         "JOIN Locations l1 ON ro.start_location_id = l1.location_id " +
                         "JOIN Locations l2 ON ro.end_location_id = l2.location_id " +
                         "ORDER BY r.request_date DESC";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                StaffSupportCustomerTrip req = new StaffSupportCustomerTrip();
                req.setRequestId(rs.getInt("request_id"));
                req.setCustomerName(rs.getString("customer_name"));
                req.setOldTripName(rs.getString("old_trip_name"));
                req.setNewTripName(rs.getString("new_trip_name"));  // hiện tại tạm rỗng
                req.setRequestDate(rs.getDate("request_date"));
                req.setRequestStatus(rs.getString("request_status"));

                list.add(req);
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
