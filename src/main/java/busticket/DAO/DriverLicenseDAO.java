/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.DriverLicense;
import busticket.model.DriverLicenseHistory;
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
public class DriverLicenseDAO extends DBContext {

    public DriverLicense getDriverLicenseByUserId(int userId) throws SQLException {
        String sql = "SELECT license_number, license_class, hire_date, driver_status FROM Drivers WHERE user_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DriverLicense license = new DriverLicense();
                    license.setUserId(userId);
                    license.setLicenseNumber(rs.getString("license_number"));
                    license.setLicenseClass(rs.getString("license_class"));
                    license.setHireDate(rs.getDate("hire_date"));
                    license.setDriverStatus(rs.getString("driver_status"));
                    return license;
                }
            }
        }
        return null;
    }

    public List<DriverLicenseHistory> getDriverLicenseHistoryByUserId(int userId) throws SQLException {
        List<DriverLicenseHistory> historyList = new ArrayList<>();
        String sql = "SELECT dlh.id, dlh.user_id, dlh.old_license_class, dlh.new_license_class, dlh.reason, dlh.changed_by, dlh.changed_at, u.user_name "
                + "FROM Driver_License_History dlh LEFT JOIN Users u ON dlh.changed_by = u.user_id "
                + "WHERE dlh.user_id = ? ORDER BY dlh.changed_at DESC";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DriverLicenseHistory history = new DriverLicenseHistory();
                    history.setId(rs.getInt("id"));
                    history.setUserId(rs.getInt("user_id"));
                    history.setOldLicenseClass(rs.getString("old_license_class"));
                    history.setNewLicenseClass(rs.getString("new_license_class"));
                    history.setReason(rs.getString("reason"));
                    history.setChangedBy(rs.getInt("changed_by"));
                    history.setUserName(rs.getString("user_name"));
                    history.setChangedAt(rs.getTimestamp("changed_at"));
                    historyList.add(history);
                }
            }
        }
        return historyList;
    }
}
