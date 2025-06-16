/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import busticket.model.AdminUsers;
import busticket.db.DBContext;
import java.sql.Timestamp;
import java.time.Instant;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class AdminUsersDAO extends DBContext {

    /**
     * Retrieves a paginated list of users with optional search by username.
     *
     * @param searchQuery The search term to filter users by username
     * (nullable).
     * @param offset The starting point for pagination.
     * @param limit The number of users to retrieve per page.
     * @return A list of AdminUser objects matching the search criteria.
     */
    public List<AdminUsers> getAllAdminUsers(String searchQuery, int offset, int limit) {
        List<AdminUsers> users = new ArrayList<>();
        // Base SQL query to fetch user details
        StringBuilder query = new StringBuilder(
                "SELECT user_id, user_name, user_email, user_phone, role, user_status, user_created_at FROM Users WHERE 1=1"
        );

        // Add search condition if a search query is provided
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            query.append(" AND user_email LIKE ?");
        }

        // Add pagination and sorting by user_id
        query.append(" ORDER BY user_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try ( PreparedStatement ps = getConnection().prepareStatement(query.toString())) {
            int paramIndex = 1;

            // Set the search parameter if applicable
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchQuery.trim() + "%");
            }

            // Set pagination parameters
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Create AdminUser object from result set and add to list
                users.add(new AdminUsers(
                        rs.getInt("user_id"),
                        rs.getString("user_name"),
                        rs.getString("user_email"),
                        rs.getString("user_phone"),
                        rs.getString("role"),
                        rs.getString("user_status"),
                        rs.getTimestamp("user_created_at")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return users;
    }

    // Method to update an existing user in the database
    public int updateUser(AdminUsers user) {
        String query = "UPDATE Users SET user_name = ?, user_email = ?, user_phone = ?, role = ?, user_status = ?, "
                + "gender = ?, birthdate = ?, user_address = ? WHERE user_id = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(query)) {
            // Set the parameters in the PreparedStatement
            ps.setString(1, user.getName());        // Set name
            ps.setString(2, user.getEmail());       // Set email
            ps.setString(3, user.getPhone());       // Set phone number
            ps.setString(4, user.getRole());        // Set role
            ps.setString(5, user.getStatus());      // Set status
            ps.setString(6, user.getGender());      // Set gender
            ps.setTimestamp(7, user.getBirthdate());  // Set birthdate (as Timestamp)
            ps.setString(8, user.getAddress());     // Set address
            ps.setInt(9, user.getUser_id());        // Set user_id (to update the correct record)

            // Execute the update
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    // Method to add a new user to the database
    public int addUser(AdminUsers user) {
        String query = "INSERT INTO Users (user_name, user_email, password, role, user_status, user_created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try ( PreparedStatement ps = getConnection().prepareStatement(query)) {
            // Set values for each parameter in PreparedStatement
            ps.setString(1, user.getName());        // Set name
            ps.setString(2, user.getEmail());       // Set email
            ps.setString(3, user.getPassword());    // Set password (hashed)
            ps.setString(4, user.getRole());        // Set role
            ps.setString(5, user.getStatus());      // Set status

            // Set created_at - if null, use the current time
            if (user.getCreated_at() == null) {
                ps.setTimestamp(6, Timestamp.from(Instant.now()));  // Use current timestamp if created_at is null
            } else {
                ps.setTimestamp(6, user.getCreated_at());  // Use provided created_at timestamp
            }

            // Execute the INSERT operation and return the number of affected rows
            return ps.executeUpdate();  // This will return the number of rows affected
        } catch (SQLException ex) {
            // Log the exception if there's an error during execution
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw new RuntimeException("Error while inserting user", ex);  // Throw runtime exception for debugging purposes
        }
    }

    /**
     *
     * @param email
     * @return
     */
    public boolean isEmailExists(String email) {
        String query = "SELECT COUNT(user_id) FROM Users WHERE user_email = ?;";
        try ( ResultSet rs = execSelectQuery(query, new Object[]{email})) {
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public AdminUsers getUserById(int userId) {
        AdminUsers user = null;
        String query = "SELECT * FROM Users WHERE user_id = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(query)) {
            // Set the user_id parameter for the query
            ps.setInt(1, userId);

            // Execute the query and retrieve the result
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Map the result set to the AdminUsers object
                user = new AdminUsers(
                        rs.getInt("user_id"), // user_id
                        rs.getString("user_name"), // name
                        rs.getString("user_email"), // email
                        rs.getString("password"), // password
                        rs.getString("user_phone"), // phone
                        rs.getString("role"), // role
                        rs.getString("user_status"), // status
                        rs.getTimestamp("birthdate"), // birthdate
                        rs.getString("gender"), // gender
                        rs.getString("user_address"), // address
                        rs.getTimestamp("user_created_at") // created_at
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return user;
    }

    /**
     * Counts the total number of users matching the search query.
     *
     * @param searchQuery The search term to filter users by username
     * (nullable).
     * @return The total count of users, or 0 if an error occurs.
     */
    public int countUsersByFilter(String searchQuery) {
        // Base SQL query to count users
        StringBuilder query = new StringBuilder("SELECT COUNT(*) FROM Users WHERE 1=1");

        // Add search condition if a search query is provided
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            query.append(" AND user_email LIKE ?");
        }

        try ( PreparedStatement ps = getConnection().prepareStatement(query.toString())) {
            // Set the search parameter if applicable
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                ps.setString(1, "%" + searchQuery.trim() + "%");
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1); // Return the total count
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0; // Return 0 if an error occurs
    }
}
