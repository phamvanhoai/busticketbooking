package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.Users;
import busticket.util.PasswordUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

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
            // Có thể throw new RuntimeException(e) hoặc log chi tiết hơn tuỳ yêu cầu
        }
        return null;
    }

// Cập nhật thông tin người dùng (bao gồm mật khẩu)
    public boolean updateUser(Users user) {
        String sql = "UPDATE Users SET "
                + "user_name = ?, user_email = ?, user_phone = ?, "
                + "birthdate = ?, gender = ?, user_address = ? "
                + "WHERE user_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setTimestamp(4, user.getBirthdate());
            ps.setString(5, user.getGender());
            ps.setString(6, user.getAddress());
            ps.setInt(7, user.getUser_id());

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Thay đổi mật khẩu người dùng
     */
    public boolean changePassword(int userId, String newPassword) {
        String sql = "UPDATE Users SET password = ? WHERE user_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            // Mã hóa mật khẩu mới
            String hashedPassword = PasswordUtils.hashPassword(newPassword);
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;  // Nếu có ít nhất 1 dòng được cập nhật, trả về true
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public String getHashedPassword(int userId) {
        String sql = "SELECT password FROM Users WHERE user_id = ?";
        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("password");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật mật khẩu mới
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE Users SET password = ? WHERE user_id = ?";
        try ( Connection conn = new DBContext().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userId);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ProfileManagementDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

}
