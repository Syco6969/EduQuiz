// DBConnection.java

package dz.eduquiz.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Update these with your actual database info
    private static final String URL = "jdbc:mysql://localhost:3306/eduquiz_db?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    
    static {
        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.out.println("Error loading JDBC driver: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to load JDBC driver", e);
        }
    }
    
    public static Connection getConnection() {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            if (conn != null) {
                System.out.println("Database connection established successfully");
            }
            return conn;
        } catch (SQLException e) {
            System.out.println("Database connection error: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    // Test database connection
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return (conn != null);
        } catch (SQLException e) {
            System.out.println("Test connection error: " + e.getMessage());
            return false;
        }
    }
}