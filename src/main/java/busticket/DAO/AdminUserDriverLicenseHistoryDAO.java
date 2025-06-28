/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.AdminUserDriverLicenseHistory;
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
 * @author Nguyen Thanh Truong - CE180140
 */
public class AdminUserDriverLicenseHistoryDAO extends DBContext {

    /**
     * Inserts a new record into the driver license upgrade history table.
     *
     * @param userId The ID of the driver whose license is being upgraded or
     * downgraded.
     * @param oldClass The previous license class of the driver.
     * @param newClass The new license class after the change.
     * @param changedBy The ID of the admin who performed the change.
     * @param reason The reason for the license upgrade/downgrade.
     * @return The number of rows affected (typically 1 if successful, 0 if
     * failed).
     */
    public int insertLicenseUpgradeHistory(int userId, String oldClass, String newClass, int changedBy, String reason) {
        String sql = "INSERT INTO Driver_License_History (user_id, old_license_class, new_license_class, changed_by, reason) "
                + "VALUES (?, ?, ?, ?, ?)";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, oldClass);
            ps.setString(3, newClass);
            ps.setInt(4, changedBy);
            ps.setString(5, reason);
            return ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AdminUserDriverLicenseHistoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Retrieves the license upgrade/downgrade history of a specific driver.
     *
     * @param userId The ID of the driver whose license history is being
     * retrieved.
     * @return A list of {@link AdminUserDriverLicenseHistory} records, sorted
     * by the change timestamp in descending order.
     */
    public List<AdminUserDriverLicenseHistory> getLicenseHistoryByUserId(int userId) {
        List<AdminUserDriverLicenseHistory> historyList = new ArrayList<>();
        String sql = "SELECT "
                + "h.id, "
                + "h.user_id, "
                + "h.old_license_class, "
                + "h.new_license_class, "
                + "h.changed_by, "
                + "h.changed_at, "
                + "h.reason, "
                + "a.user_name AS admin_name, "
                + "a.role AS admin_role "
                + "FROM Driver_License_History h "
                + "JOIN Users a ON h.changed_by = a.user_id AND a.role = 'Admin' "
                + "WHERE h.user_id = ? "
                + "ORDER BY h.changed_at DESC;";

        DBContext db = new DBContext();

        try ( Connection conn = db.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                AdminUserDriverLicenseHistory history = new AdminUserDriverLicenseHistory();
                history.setId(rs.getInt("id"));
                history.setUserId(rs.getInt("user_id"));
                history.setOldLicenseClass(rs.getString("old_license_class"));
                history.setNewLicenseClass(rs.getString("new_license_class"));
                history.setAdminId(rs.getInt("changed_by")); // sửa lại cột
                history.setReason(rs.getString("reason"));
                history.setCreatedAt(rs.getTimestamp("changed_at")); // sửa lại cột
                history.setAdminName(rs.getString("admin_name"));
                historyList.add(history);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return historyList;
    }

}
