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

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class AdminUsersDAO extends DBContext {
    /**
     * Retrieves a paginated list of users with optional search by username.
     * @param searchQuery The search term to filter users by username (nullable).
     * @param offset The starting point for pagination.
     * @param limit The number of users to retrieve per page.
     * @return A list of AdminUser objects matching the search criteria.
     */
    public List<AdminUsers> getAllAdminUsers(String searchQuery, int offset, int limit) {
        List<AdminUsers> users = new ArrayList<>();
        // Base SQL query to fetch user details
        StringBuilder query = new StringBuilder(
            "SELECT user_id, name, email, phone, role, status, created_at FROM Users WHERE 1=1"
        );

        // Add search condition if a search query is provided
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            query.append(" AND name LIKE ?");
        }

        // Add pagination and sorting by user_id
        query.append(" ORDER BY user_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = getConnection().prepareStatement(query.toString())) {
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
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("role"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return users;
    }

    /**
     * Counts the total number of users matching the search query.
     * @param searchQuery The search term to filter users by username (nullable).
     * @return The total count of users, or 0 if an error occurs.
     */
    public int countUsersByFilter(String searchQuery) {
        // Base SQL query to count users
        StringBuilder query = new StringBuilder("SELECT COUNT(*) FROM Users WHERE 1=1");

        // Add search condition if a search query is provided
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            query.append(" AND name LIKE ?");
        }

        try (PreparedStatement ps = getConnection().prepareStatement(query.toString())) {
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
