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
import busticket.model.AdminDrivers;
import java.sql.Timestamp;
import java.time.Instant;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class AdminUsersDAO extends DBContext {

    /**
     * Retrieves a paginated list of users with optional search by username and
     * role.
     *
     * @param searchQuery The term to filter users by name or email.
     * @param role The role to filter users by.
     * @param offset Starting offset for pagination.
     * @param limit Number of records to return.
     * @return List of AdminUsers objects.
     */
    public List<AdminUsers> getAllAdminUsers(String searchQuery, String role, int offset, int limit) {
        List<AdminUsers> users = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT user_id, user_name, user_email, user_phone, role, user_status, birthdate, gender, user_address, user_created_at FROM Users WHERE 1=1"
        );

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            query.append(" AND (user_email LIKE ? OR user_name LIKE ?)");
        }

        if (role != null && !role.trim().isEmpty()) {
            query.append(" AND role = ?");
        }

        query.append(" ORDER BY user_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try ( PreparedStatement ps = getConnection().prepareStatement(query.toString())) {
            int paramIndex = 1;

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchQuery.trim() + "%");
                ps.setString(paramIndex++, "%" + searchQuery.trim() + "%");
            }

            if (role != null && !role.trim().isEmpty()) {
                ps.setString(paramIndex++, role);
            }

            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
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

    /**
     * Updates user details in the database.
     *
     * @param user AdminUsers object containing updated user info.
     * @return Number of rows affected.
     */
    public int updateUser(AdminUsers user) {
        String sql = "UPDATE Users SET user_name = ?, user_email = ?, user_phone = ?, role = ?, user_status = ?, birthdate = ?, gender = ?, user_address = ? WHERE user_id = ?";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getStatus());
            ps.setTimestamp(6, user.getBirthdate());
            ps.setString(7, user.getGender());
            ps.setString(8, user.getAddress());
            ps.setInt(9, user.getUser_id());

            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Adds a new user to the database.
     *
     * @param user AdminUsers object containing user info.
     * @return Newly created user ID.
     */
    public int addUser(AdminUsers user) {
        String query = "INSERT INTO Users "
                + "(user_name, user_email, password, user_phone, role, user_status, birthdate, gender, user_address, user_created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try ( PreparedStatement ps = getConnection().prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getStatus());
            ps.setTimestamp(7, user.getBirthdate());
            ps.setString(8, user.getGender());
            ps.setString(9, user.getAddress());
            ps.setTimestamp(10, user.getCreated_at() != null ? user.getCreated_at() : Timestamp.from(Instant.now()));

            int affectedRows = ps.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }

            try ( ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating user failed, no ID obtained.");
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, "Error inserting user", ex);
            throw new RuntimeException("Error inserting user: " + ex.getMessage(), ex);
        }
    }

    /**
     * Checks if a given email is already registered in the system.
     *
     * @param email The email to check.
     * @return True if email exists, false otherwise.
     */
    public boolean isEmailExists(String email) {
        String query = "SELECT COUNT(user_id) FROM Users WHERE user_email = ?;";
        try ( ResultSet rs = execSelectQuery(query, new Object[]{email})) {
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean isPhoneExists(String phone) {
        String query = "SELECT COUNT(user_id) FROM Users WHERE user_phone = ?";
        try ( ResultSet rs = execSelectQuery(query, new Object[]{phone})) {
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    /**
     * Retrieves user details by ID.
     *
     * @param userId ID of the user.
     * @return AdminUsers object if found, else null.
     */
    public AdminUsers getUserById(int userId) {
        AdminUsers user = null;
        String query = "SELECT * FROM Users WHERE user_id = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new AdminUsers(
                        rs.getInt("user_id"),
                        rs.getString("user_name"),
                        rs.getString("user_email"),
                        rs.getString("password"),
                        rs.getString("user_phone"),
                        rs.getString("role"),
                        rs.getString("user_status"),
                        rs.getTimestamp("birthdate"),
                        rs.getString("gender"),
                        rs.getString("user_address"),
                        rs.getTimestamp("user_created_at")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return user;
    }

    /**
     * Counts total users that match the given search and role filters.
     *
     * @param searchQuery Search keyword for email.
     * @param roleFilter Role to filter users by.
     * @return Number of matched users.
     */
    public int countAllAdminUsers(String searchQuery, String roleFilter) {
        StringBuilder query = new StringBuilder("SELECT COUNT(*) FROM Users WHERE 1=1");

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            query.append(" AND user_email LIKE ?");
        }
        if (roleFilter != null && !roleFilter.trim().isEmpty() && !roleFilter.equalsIgnoreCase("All")) {
            query.append(" AND role = ?");
        }

        try ( PreparedStatement ps = getConnection().prepareStatement(query.toString())) {
            int paramIndex = 1;

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchQuery.trim() + "%");
            }
            if (roleFilter != null && !roleFilter.trim().isEmpty() && !roleFilter.equalsIgnoreCase("All")) {
                ps.setString(paramIndex++, roleFilter);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Retrieves a driver's information by associated user ID.
     *
     * @param userId ID of the user.
     * @return AdminDrivers object containing driver info, or null if not found.
     */
    public AdminDrivers getDriverByUserId(int userId) {
        String sql = "SELECT d.driver_id, d.user_id, u.user_name, d.license_number, d.license_class, d.hire_date, d.driver_status "
                + "FROM Drivers d JOIN Users u ON d.user_id = u.user_id WHERE d.user_id = ?";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                AdminDrivers driver = new AdminDrivers();
                driver.setDriverId(rs.getInt("driver_id"));
                driver.setUserId(rs.getInt("user_id"));
                driver.setUserName(rs.getString("user_name"));
                driver.setLicenseNumber(rs.getString("license_number"));
                driver.setLicenseClass(rs.getString("license_class"));
                driver.setHireDate(rs.getDate("hire_date"));
                driver.setDriverStatus(rs.getString("driver_status"));
                return driver;
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * Retrieves the latest inserted user ID from the Users table.
     *
     * @return Last inserted user ID, or -1 if not found.
     */
    public int getLatestInsertedUserId() {
        String sql = "SELECT IDENT_CURRENT('Users') AS last_id";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("last_id");
            }
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }

    /**
     * Adds a new driver record to the Drivers table.
     *
     * @param driver AdminDrivers object to insert.
     * @return Number of rows affected.
     */
    public int addDriver(AdminDrivers driver) {
        String sql = "INSERT INTO Drivers (user_id, license_number, license_class, hire_date, driver_status) "
                + "VALUES (?, ?, ?, ?, ?)";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, driver.getUserId());
            ps.setString(2, driver.getLicenseNumber());
            ps.setString(3, driver.getLicenseClass());
            ps.setDate(4, driver.getHireDate());
            ps.setString(5, driver.getDriverStatus());

            return ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Sets a driver's status to 'Inactive' based on user ID.
     *
     * @param userId ID of the user.
     * @return Number of rows affected.
     */
    public int setDriverStatusInactiveByUserId(int userId) {
        String sql = "UPDATE Drivers SET driver_status = 'Inactive' WHERE user_id = ?";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Updates an existing driver record in the database.
     *
     * @param driver AdminDrivers object with updated values.
     * @return Number of rows affected.
     */
    public int updateDriver(AdminDrivers driver) {
        String sql = "UPDATE Drivers SET license_number = ?, license_class = ?, hire_date = ?, driver_status = ? WHERE user_id = ?";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, driver.getLicenseNumber());
            ps.setString(2, driver.getLicenseClass());
            ps.setDate(3, driver.getHireDate());
            ps.setString(4, driver.getDriverStatus());
            ps.setInt(5, driver.getUserId());

            return ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AdminUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

}
