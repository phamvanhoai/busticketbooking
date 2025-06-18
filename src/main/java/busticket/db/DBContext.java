/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class DBContext {

private final String DB_URL = "jdbc:sqlserver://localhost\\BusTicketDatabase:1433;databaseName=BusTicket;encrypt=true;trustServerCertificate=true";
    private final String DB_USER = "sa";
    private final String DB_PWD = "123";

    public DBContext() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException ex) {
            ex.printStackTrace();
        }
    }

    
    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PWD);
    }
    // Phuong thuc cac lenh INSERT, UPDATE, DELETE
        public int execQuery(String query, Object[] params) throws SQLException {
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    ps.setObject(i + 1, params[i]);
                }
            }
            return ps.executeUpdate();
        }
    }

     public ResultSet execSelectQuery(String query, Object[] params) throws SQLException {
        Connection conn = getConnection(); // giữ conn mở để ResultSet vẫn dùng được
        PreparedStatement ps = conn.prepareStatement(query);
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
        }
        return ps.executeQuery(); // conn phải được đóng sau khi dùng ResultSet
    }
    
     public ResultSet execSelectQuery(String query) throws SQLException {
        return execSelectQuery(query, null);
    }
}