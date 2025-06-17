package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProfileManagementDAO extends DBContext {

    /**
     * Get user information by user_id
     */
    public Users getUserById(int userId) {
        String sql = "SELECT "
                + "user_id, user_name, user_email, password, user_phone, "
                + "role, user_status, birthdate, gender, user_address, user_created_at "
                + "FROM Users WHERE user_id = ?";
        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Users u = new Users();
                    u.setUser_id(rs.getInt("user_id"));
                    u.setName(rs.getString("user_name"));
                    u.setEmail(rs.getString("user_email"));
                    u.setPassword(rs.getString("password"));
                    u.setPhone(rs.getString("user_phone"));
                    u.setRole(rs.getString("role"));
                    u.setStatus(rs.getString("user_status"));
                    u.setBirthdate(rs.getTimestamp("birthdate"));
                    u.setGender(rs.getString("gender"));
                    u.setAddress(rs.getString("user_address"));
                    u.setCreated_at(rs.getTimestamp("user_created_at"));
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Update user information
     */
    public boolean updateUser(Users user) {
        String sql = "UPDATE Users SET "
                + "user_name = ?, user_email = ?, password = ?, user_phone = ?, role = ?, "
                + "user_status = ?, birthdate = ?, gender = ?, user_address = ? "
                + "WHERE user_id = ?";
        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getStatus());
            ps.setTimestamp(7, user.getBirthdate());
            ps.setString(8, user.getGender());
            ps.setString(9, user.getAddress());
            ps.setInt(10, user.getUser_id());

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;  // If at least one row is updated, return true
        } catch (SQLException e) {
        }
        return false;
    }

    /**
     * Change user password
     */
    public boolean changePassword(int userId, String newPassword) {
        String sql = "UPDATE Users SET password = ? WHERE user_id = ?";
        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setInt(2, userId);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0; // If at least one row is updated, return true
        } catch (SQLException e) {
        }
        return false;
    }
}
