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

    public Connection conn;
    private final String DB_URL = "jdbc:sqlserver://localhost\\busticketbookingDatabase:1433;databaseName=busticketbooking;encrypt=true;trustServerCertificate=true";
    private final String DB_USER = "sa";
    private final String DB_PWD = "123";

    public DBContext() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            this.conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PWD);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Connection getConnection() {
        return conn;
    }

    // Phuong thuc cac lenh INSERT, UPDATE, DELETE
    public int execQuery(String query, Object[] params) throws SQLException {
        PreparedStatement pStatement = conn.prepareStatement(query);
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                pStatement.setObject(i + 1, params[i]);
            }
        }
        return pStatement.executeUpdate();
    }

    public ResultSet execSelectQuery(String query, Object[] params) throws SQLException {
        PreparedStatement pStatement = conn.prepareStatement(query);
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                pStatement.setObject(i + 1, params[i]);
            }
        }
        return pStatement.executeQuery();
    }
    
    public ResultSet execSelectQuery(String query) throws SQLException {
        return this.execSelectQuery(query,null);
    }
}
