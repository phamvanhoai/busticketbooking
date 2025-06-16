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
 * @author Nguyen Thanh Truong - CE180140
 */
public class UsersDAO extends DBContext {

    /**
     * Update the password for a specific user.
     *
     * @param userId The ID of the user.
     * @param newPassword The new (already hashed) password to store.
     */
    public void updatePassword(int userId, String newPassword) {
        String query = "UPDATE Users SET password = ? WHERE user_id = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(query)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userId);

            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("Password updated successfully.");
            } else {
                System.out.println("No user found with this ID.");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Mark a password reset token as used (after successful reset).
     *
     * @param token The token to mark as used.
     */
    public void markTokenAsUsed(String token) {
        String query = "UPDATE Password_Reset_Tokens SET token_used = 1 WHERE token = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(query)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Retrieve user information based on a valid, unexpired password reset
     * token.
     *
     * @param token The reset token from the URL.
     * @return The associated User object if valid, null otherwise.
     */
    public Users getUserByResetToken(String token) {
        String query = "SELECT * FROM Users u "
                + "JOIN Password_Reset_Tokens prt ON u.user_id = prt.user_id "
                + "WHERE prt.token = ? AND prt.token_used = 0 AND prt.token_expires_at > ?";

        Timestamp currentTime = Timestamp.from(Instant.now());

        try ( PreparedStatement ps = getConnection().prepareStatement(query)) {
            ps.setString(1, token);
            ps.setTimestamp(2, currentTime);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Users(
                        rs.getInt("user_id"),
                        rs.getString("user_name"),
                        rs.getString("user_email"),
                        rs.getString("password"),
                        rs.getString("user_phone"),
                        rs.getString("role"),
                        rs.getTimestamp("birthdate"),
                        rs.getString("gender"),
                        rs.getString("user_address"),
                        rs.getTimestamp("user_created_at")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }

    /**
     * Store a newly generated reset token in the database.
     *
     * @param userId ID of the user requesting password reset.
     * @param resetToken The generated token string.
     */
    public void storeResetToken(int userId, String resetToken) {
        String query = "INSERT INTO Password_Reset_Tokens (user_id, token, token_created_at, token_expires_at, token_used) VALUES (?, ?, ?, ?, ?)";

        Timestamp createdAt = Timestamp.from(Instant.now());
        Timestamp expiresAt = Timestamp.from(Instant.now().plus(1, ChronoUnit.HOURS)); // expires in 1 hour

        try ( PreparedStatement ps = getConnection().prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setString(2, resetToken);
            ps.setTimestamp(3, createdAt);
            ps.setTimestamp(4, expiresAt);
            ps.setBoolean(5, false); // token initially unused
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Retrieve a user from the database by email address.
     *
     * @param email The email to search for.
     * @return The User object if found, or null otherwise.
     */
    public Users getUserByEmail(String email) {
        String query = "SELECT * FROM Users WHERE user_email = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(query)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Users(
                        rs.getInt("user_id"),
                        rs.getString("user_name"),
                        rs.getString("user_email"),
                        rs.getString("password"),
                        rs.getString("user_phone"),
                        rs.getString("role"),
                        rs.getTimestamp("birthdate"),
                        rs.getString("gender"),
                        rs.getString("user_address"),
                        rs.getTimestamp("user_created_at")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }

    /**
     * Check if an email is already registered in the database.
     *
     * @param email The email address to check.
     * @return True if email exists, false otherwise.
     */
    public boolean isEmailExists(String email) {
        String query = "SELECT COUNT(user_id) FROM Users WHERE user_email = ?";

        try ( ResultSet rs = execSelectQuery(query, new Object[]{email})) {
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return false;
    }

    /**
     * Perform user login using email and password (hashed comparison).
     *
     * @param email The user's email.
     * @param password The raw password entered by the user.
     * @return The User object if login successful, or null otherwise.
     */
    public Users login(String email, String password) {
        try {
            String query = "SELECT * FROM Users u WHERE u.user_email = ?";
            ResultSet rs = execSelectQuery(query, new Object[]{email});

            if (rs.next()) {
                String hashedPassword = rs.getString("password");

                // Validate password using PasswordUtils
                if (hashedPassword == null || hashedPassword.isEmpty()
                        || !PasswordUtils.checkPassword(password, hashedPassword)) {
                    return null;
                }

                return new Users(
                        rs.getInt("user_id"),
                        rs.getString("user_name"),
                        rs.getString("user_email"),
                        rs.getString("password"),
                        rs.getString("user_phone"),
                        rs.getString("role"),
                        rs.getTimestamp("birthdate"),
                        rs.getString("gender"),
                        rs.getString("user_address"),
                        rs.getTimestamp("user_created_at")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }

    /**
     * Register (sign up) a new user into the system.
     *
     * @param user A User object with the necessary fields filled.
     * @return The number of rows affected (1 if success, 0 if failure).
     */
    public int signup(Users user) {
        try {
            String query = "INSERT INTO Users (user_name, user_email, password, role, user_status, user_created_at) VALUES (?, ?, ?, ?, ?, ?)";

            Timestamp timestamp = Timestamp.from(Instant.now());

            Object[] params = {
                user.getName(),
                user.getEmail(),
                user.getPassword(), // Already hashed
                user.getRole(),
                user.getStatus(),
                timestamp
            };

            return execQuery(query, params);

        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return 0;
    }
}
