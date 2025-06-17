/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.DAO;

import busticket.db.DBContext;
import busticket.model.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class ProfileManangementDAO extends DBContext{
    /**
     * Lấy thông tin User theo user_id
     */
    public Users getUserById(int userId) {
        String sql = "SELECT "
                   + "user_id, user_name, user_email, password, user_phone, "
                   + "role, user_status, birthdate, gender, user_address, user_created_at "
                   + "FROM Users WHERE user_id = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Users u = new Users();
                    u.setUser_id(      rs.getInt       ("user_id")             );
                    u.setName(         rs.getString    ("user_name")           );
                    u.setEmail(        rs.getString    ("user_email")          );
                    u.setPassword(     rs.getString    ("password")            );
                    u.setPhone(        rs.getString    ("user_phone")          );
                    u.setRole(         rs.getString    ("role")                );
                    u.setStatus(       rs.getString    ("user_status")         );
                    u.setBirthdate(    rs.getTimestamp ("birthdate")           );
                    u.setGender(       rs.getString    ("gender")              );
                    u.setAddress(      rs.getString    ("user_address")        );
                    u.setCreated_at(   rs.getTimestamp ("user_created_at")     );
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Có thể throw new RuntimeException(e) hoặc log chi tiết hơn tuỳ yêu cầu
        }
        return null;
    }
}
