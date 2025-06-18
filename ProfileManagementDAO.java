/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.model.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProfileManagementDAO {

    private final Connection connection;

    public ProfileManagementDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * Retrieve user information by user ID
     *
     * @param userId user ID
     * @return user information or null if not found
     * @throws java.sql.SQLException
     */
    public Users getUserById(int userId) throws SQLException {
        String query = "SELECT * FROM users WHERE id = ?";
        try ( PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Users(
                            rs.getInt("id"),
                            rs.getString("username"),
                            rs.getString("email"),
                            rs.getString("fullname"),
                            rs.getString("password") // It may need to be encrypted or skipped if unnecessary
                    );
                }
            }
        }
        return null;
    }

    /**
     * Update user profile information
     *
     * @param user user object with updated information
     * @return true if update is successful
     * @throws java.sql.SQLException
     */
    public boolean updateUserProfile(Users user) throws SQLException {
        String query = "UPDATE users SET fullname = ?, email = ? WHERE id = ?";
        try ( PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, user.getFullname());
            ps.setString(2, user.getEmail());
            ps.setInt(3, user.getId());
            return ps.executeUpdate() > 0;
        }
    }2

    /**
     * Change user password
     *
     * @param userId user ID
     * @param newPassword new password (encrypted)
     * @return true if password change is successful
     * @throws java.sql.SQLException
     */
    public boolean changePassword(int userId, String newPassword) throws SQLException {
        String query = "UPDATE users SET password = ? WHERE id = ?";
        try ( PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }
}
