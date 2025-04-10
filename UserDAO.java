// UserDAO.java - updated

package dz.eduquiz.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import dz.eduquiz.model.User;

public class UserDAO {
    
    // Create a new user
    public int createUser(User user) {
        String sql = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            if (conn == null) {
                System.out.println("Error: Database connection failed");
                return -1;
            }
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPassword());
            pstmt.setString(4, user.getRole());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setId(generatedKeys.getInt(1));
                    return user.getId();
                } else {
                    throw new SQLException("Creating user failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in createUser: " + e.getMessage());
            e.printStackTrace();
            return -1;
        }
    }
    
    // Get user by ID
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.out.println("Error: Database connection failed in getUserById");
             // In getUserByUsername and getUserByEmail methods
                
            }
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, id);
                
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        User user = new User();
                        user.setId(rs.getInt("id"));
                        user.setUsername(rs.getString("username"));
                        user.setEmail(rs.getString("email"));
                        user.setPassword(rs.getString("password"));
                        user.setRole(rs.getString("role"));
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in getUserById: " + e.getMessage());
         // In getUserByUsername and getUserByEmail methods
            
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Get user by username - FIXED VERSION
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.out.println("Error: Database connection failed in getUserByUsername");
             // In getUserByUsername and getUserByEmail methods
                System.out.println("Executing SQL: " + sql + " with parameter: " + username);
                return null;
            }
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, username);
                
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        User user = new User();
                        user.setId(rs.getInt("id"));
                        user.setUsername(rs.getString("username"));
                        user.setEmail(rs.getString("email"));
                        user.setPassword(rs.getString("password"));
                        user.setRole(rs.getString("role"));
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in getUserByUsername: " + e.getMessage());
         // In getUserByUsername and getUserByEmail methods
            System.out.println("Executing SQL: " + sql + " with parameter: " + username);
            e.printStackTrace();
            return null; // Explicitly return null on exception
        }
        
        return null;
    }
    
    // Get user by email - FIXED VERSION
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.out.println("Error: Database connection failed in getUserByEmail");
             // In getUserByUsername and getUserByEmail methods
                System.out.println("Executing SQL: " + sql + " with parameter: " + email);
                return null;
            }
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, email);
                
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        User user = new User();
                        user.setId(rs.getInt("id"));
                        user.setUsername(rs.getString("username"));
                        user.setEmail(rs.getString("email"));
                        user.setPassword(rs.getString("password"));
                        user.setRole(rs.getString("role"));
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in getUserByEmail: " + e.getMessage());
         // In getUserByUsername and getUserByEmail methods
            System.out.println("Executing SQL: " + sql + " with parameter: " + email);
            e.printStackTrace();
            return null; // Explicitly return null on exception
        }
        
        return null;
    }
    
    // Get all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.out.println("Error: Database connection failed in getAllUsers");
                return users;
            }
            
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                
                while (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    users.add(user);
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in getAllUsers: " + e.getMessage());
            e.printStackTrace();
        }
        
        return users;
    }
    
    // Update user
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET username = ?, email = ?, password = ?, role = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.out.println("Error: Database connection failed in updateUser");
                return false;
            }
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, user.getUsername());
                pstmt.setString(2, user.getEmail());
                pstmt.setString(3, user.getPassword());
                pstmt.setString(4, user.getRole());
                pstmt.setInt(5, user.getId());
                
                int affectedRows = pstmt.executeUpdate();
                return affectedRows > 0;
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in updateUser: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete user
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.out.println("Error: Database connection failed in deleteUser");
                return false;
            }
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, id);
                
                int affectedRows = pstmt.executeUpdate();
                return affectedRows > 0;
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in deleteUser: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}