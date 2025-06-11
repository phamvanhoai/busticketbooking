/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.Users;
import busticket.util.PasswordUtils;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class UsersDAO extends DBContext {

    public void updatePassword(int userId, String newPassword) {
        String query = "UPDATE Users SET password = ? WHERE user_id = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(query)) {
            // Đảm bảo mật khẩu được mã hóa trước khi lưu vào cơ sở dữ liệu
            ps.setString(1, newPassword);  // Mật khẩu đã mã hóa
            ps.setInt(2, userId);  // ID người dùng cần cập nhật mật khẩu

            // Thực thi câu lệnh cập nhật
            int rowsUpdated = ps.executeUpdate();  // Kiểm tra xem có bản ghi nào được cập nhật không
            if (rowsUpdated > 0) {
                System.out.println("Password updated successfully.");
            } else {
                System.out.println("No user found with this ID.");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void markTokenAsUsed(String token) {
        String query = "UPDATE Password_Reset_Tokens SET used = 1 WHERE token = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(query)) {
            ps.setString(1, token);  // Set token value to mark it as used
            ps.executeUpdate();  // Cập nhật token là đã sử dụng
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Users getUserByResetToken(String token) {
        String query = "SELECT * FROM Users u "
                + "JOIN Password_Reset_Tokens prt ON u.user_id = prt.user_id "
                + "WHERE prt.token = ? AND prt.used = 0 AND prt.expires_at > ?";  // Dùng 0 thay vì 'false'

        Timestamp currentTime = Timestamp.from(Instant.now());  // Lấy thời gian hiện tại

        try ( PreparedStatement ps = getConnection().prepareStatement(query)) {
            ps.setString(1, token);  // Token từ URL
            ps.setTimestamp(2, currentTime);  // Kiểm tra xem token có hết hạn không

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Users(
                        rs.getInt("user_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("phone"),
                        rs.getString("role"),
                        rs.getTimestamp("birthdate"),
                        rs.getString("gender"),
                        rs.getString("address"),
                        rs.getTimestamp("created_at")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;  // Nếu không tìm thấy người dùng hợp lệ
    }

    public void storeResetToken(int userId, String resetToken) {
        String query = "INSERT INTO Password_Reset_Tokens (user_id, token, created_at, expires_at, used) VALUES (?, ?, ?, ?, ?)";

        // Set expiration time (1 hour from now)
        Timestamp createdAt = Timestamp.from(Instant.now());  // Current time
        Timestamp expiresAt = Timestamp.from(Instant.now().plus(1, ChronoUnit.HOURS));  // Expiration time (1 hour later)

        try ( PreparedStatement ps = getConnection().prepareStatement(query)) {
            ps.setInt(1, userId);  // user_id
            ps.setString(2, resetToken);  // token
            ps.setTimestamp(3, createdAt);  // created_at
            ps.setTimestamp(4, expiresAt);  // expires_at
            ps.setBoolean(5, false);  // used (false initially, because it hasn't been used yet)

            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Users getUserByEmail(String email) {
        String query = "SELECT * FROM Users WHERE email = ?";  // Query to find the user by email
        try ( PreparedStatement ps = getConnection().prepareStatement(query)) {
            // Set the email parameter in the query
            ps.setString(1, email);

            // Execute the query and get the result set
            ResultSet rs = ps.executeQuery();

            // If a user with the provided email exists, return the user object
            if (rs.next()) {
                return new Users(
                        rs.getInt("user_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("phone"),
                        rs.getString("role"),
                        rs.getTimestamp("birthdate"),
                        rs.getString("gender"),
                        rs.getString("address"),
                        rs.getTimestamp("created_at")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;  // Return null if no user found with the given email
    }

    /**
     *
     * @param email
     * @return
     */
    public boolean isEmailExists(String email) {
        String query = "SELECT COUNT(user_id) FROM Users WHERE email = ?;";
        try ( ResultSet rs = execSelectQuery(query, new Object[]{email})) {
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    /**
     * For traditional login only (Not using any other provider than local)
     *
     * @param email
     * @param password
     * @return
     */
    public Users login(String email, String password) {
        try {
            String query = "SELECT * FROM Users u WHERE u.email = ?;";
            Object[] params = {email};
            ResultSet rs = execSelectQuery(query, params); // Execute the query

            // Ensure the cursor is pointing to a valid row
            if (rs.next()) { // If a user is found
                String hashedPassword = rs.getString("password");

                // Step 4: check the password
                if (hashedPassword == null || hashedPassword.isEmpty() || !PasswordUtils.checkPassword(password, hashedPassword)) {
                    // If password doesn't match
                    return null;
                }

                // Return user if everything is fine
                return new Users(
                        rs.getInt("user_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("phone"),
                        rs.getString("role"),
                        rs.getTimestamp("birthdate"),
                        rs.getString("gender"),
                        rs.getString("address"),
                        rs.getTimestamp("created_at")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Return null if no user found or other issues
        return null;
    }

    /**
     *
     * @param user
     * @return
     */
    public int signup(Users user) {
        try {
            // Cập nhật câu lệnh SQL để phù hợp với các tham số
            String query = "INSERT INTO Users (name, email, password, role, status, created_at) VALUES (?, ?, ?, ?, ?, ?)";

            // Lấy thời gian hiện tại nếu `created_at` không được truyền từ phía người dùng
            Timestamp timestamp = Timestamp.from(Instant.now()); // Default created_at is the current time

            // Các tham số truyền vào câu lệnh SQL
            Object[] params = {
                user.getName(), // user name
                user.getEmail(), // user email
                user.getPassword(), // user password (hashed)
                user.getRole(), // user role (e.g., "user" or "admin")
                user.getStatus(), // user status (e.g., "active", "inactive")
                timestamp // created_at
            };

            // Thực thi câu lệnh SQL và trả về số bản ghi bị ảnh hưởng (inserted row count)
            return execQuery(query, params);

        } catch (SQLException ex) {
            // Log error if an exception occurs
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return 0; // Return 0 if there was an error
    }

}
