/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.AdminBusTypes;
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
 * @author Pham Van Hoai - CE181744
 */
public class AdminBusTypesDAO extends DBContext {
   private static final Logger LOGGER = Logger.getLogger(AdminBusTypesDAO.class.getName());

    // Get all bus types
    public List<AdminBusTypes> getAllBusTypes() {
        List<AdminBusTypes> busTypes = new ArrayList<>();
        String query = "SELECT bus_type_id, bus_type_name, bus_type_description FROM Bus_Types";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                AdminBusTypes busType = new AdminBusTypes(
                        rs.getInt("bus_type_id"),
                        rs.getString("bus_type_name"),
                        rs.getString("bus_type_description")
                );
                busTypes.add(busType);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all bus types", e);
        }

        return busTypes;
    }

    // Get a specific bus type by ID
    public AdminBusTypes getBusTypeById(int busTypeId) {
        AdminBusTypes busType = null;
        String query = "SELECT bus_type_id, bus_type_name, bus_type_description FROM Bus_Types WHERE bus_type_id = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, busTypeId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                busType = new AdminBusTypes(
                        rs.getInt("bus_type_id"),
                        rs.getString("bus_type_name"),
                        rs.getString("bus_type_description")
                );
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving bus type by ID", e);
        }

        return busType;
    }

    // Add a new bus type
    public boolean addBusType(AdminBusTypes busType) {
        String query = "INSERT INTO Bus_Types (bus_type_name, bus_type_description) VALUES (?, ?)";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, busType.getBusTypeName());
            stmt.setString(2, busType.getBusTypeDescription());
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.log(Level.INFO, "Successfully added new bus type: " + busType.getBusTypeName());
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding new bus type", e);
        }

        return false;
    }

    // Update an existing bus type
    public boolean updateBusType(AdminBusTypes busType) {
        String query = "UPDATE Bus_Types SET bus_type_name = ?, bus_type_description = ? WHERE bus_type_id = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, busType.getBusTypeName());
            stmt.setString(2, busType.getBusTypeDescription());
            stmt.setInt(3, busType.getBusTypeId());
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.log(Level.INFO, "Successfully updated bus type with ID: " + busType.getBusTypeId());
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating bus type", e);
        }

        return false;
    }

    // Delete a bus type by ID
    public boolean deleteBusType(int busTypeId) {
        String query = "DELETE FROM Bus_Types WHERE bus_type_id = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, busTypeId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.log(Level.INFO, "Successfully deleted bus type with ID: " + busTypeId);
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting bus type", e);
        }

        return false;
    }
}
