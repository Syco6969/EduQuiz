// UserService.java - updated with debugging

package dz.eduquiz.service;

import java.util.List;
import dz.eduquiz.dao.UserDAO;
import dz.eduquiz.model.User;
import dz.eduquiz.util.PasswordHasher;
import dz.eduquiz.util.ValidationUtil;

public class UserService {
    private UserDAO userDAO;
    
    public UserService() {
        this.userDAO = new UserDAO();
    }
    
    // Register a new user - FIXED VERSION
    public boolean registerUser(String username, String email, String password) {
        // Validate input
        if (!ValidationUtil.isValidUsername(username)) {
            System.out.println("Invalid username format");
            return false;
        }
        
        if (!ValidationUtil.isValidEmail(email)) {
            System.out.println("Invalid email format");
            return false;
        }
        
        if (!ValidationUtil.isValidPassword(password)) {
            System.out.println("Invalid password format");
            return false;
        }
        
        try {
            // Check if username already exists
            User existingUser = userDAO.getUserByUsername(username);
            if (existingUser != null) {
                System.out.println("Username already exists: " + username);
                return false;
            }
            
            // Check if email already exists
            existingUser = userDAO.getUserByEmail(email);
            if (existingUser != null) {
                System.out.println("Email already exists: " + email);
                return false;
            }
            
            // Hash password and create user
            String hashedPassword = PasswordHasher.hashPassword(password);
            User user = new User(username, email, hashedPassword);
            user.setRole("user"); // Set default role
            
            int userId = userDAO.createUser(user);
            System.out.println("User registration result: " + (userId > 0 ? "Success" : "Failed"));
            return userId > 0;
        } catch (Exception e) {
            System.out.println("Exception in registerUser: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Authenticate user
    public User authenticate(String usernameOrEmail, String password) {
        try {
            User user = null;
            
            // Try to find user by username
            user = userDAO.getUserByUsername(usernameOrEmail);
            System.out.println("Looking up by username: " + (user != null ? "Found" : "Not found"));
            
            // If not found, try by email
            if (user == null) {
                user = userDAO.getUserByEmail(usernameOrEmail);
                System.out.println("Looking up by email: " + (user != null ? "Found" : "Not found"));
            }
            
            // Check if user exists and password matches
            if (user != null) {
                boolean passwordMatch = PasswordHasher.checkPassword(password, user.getPassword());
                System.out.println("User found, password match: " + passwordMatch);
                if (passwordMatch) {
                    return user;
                }
            }
        } catch (Exception e) {
            System.out.println("Exception in authenticate: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Get user by ID
    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }
    
    // Get all users
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }
    
    // Update user profile - Enhanced with debugging

    public boolean updateUserProfile(int userId, String username, String email, 
                                   String currentPassword, String newPassword, String profileImage) {
        try {
            System.out.println("------- Profile Update Request -------");
            System.out.println("UserId: " + userId);
            System.out.println("Username: " + username);
            System.out.println("Email: " + email);
            System.out.println("Current password provided: " + (currentPassword != null && !currentPassword.isEmpty()));
            System.out.println("New password provided: " + (newPassword != null && !newPassword.isEmpty()));
            System.out.println("Profile image provided: " + (profileImage != null && !profileImage.isEmpty()));
            
            // Get current user
            User user = userDAO.getUserById(userId);
            if (user == null) {
                System.out.println("ERROR: User not found with ID: " + userId);
                return false;
            }
            System.out.println("Current user data - Username: " + user.getUsername() + ", Email: " + user.getEmail());
            
            // Verify current password
            boolean passwordMatch = PasswordHasher.checkPassword(currentPassword, user.getPassword());
            System.out.println("Current password verification: " + (passwordMatch ? "SUCCESS" : "FAILED"));
            if (!passwordMatch) {
                return false;
            }
            
            boolean hasChanges = false;
            
            // Update username if provided and different
            if (username != null && !username.trim().isEmpty() && !username.equals(user.getUsername())) {
                if (!ValidationUtil.isValidUsername(username)) {
                    System.out.println("ERROR: Invalid username format: " + username);
                    return false;
                }
                
                // Check if username is already in use
                User existingUser = userDAO.getUserByUsername(username);
                if (existingUser != null && existingUser.getId() != userId) {
                    System.out.println("ERROR: Username already in use by another user: " + username);
                    return false;
                }
                
                System.out.println("Updating username from '" + user.getUsername() + "' to '" + username + "'");
                user.setUsername(username);
                hasChanges = true;
            }
            
            // Update email if provided and different
            if (email != null && !email.trim().isEmpty() && !email.equals(user.getEmail())) {
                if (!ValidationUtil.isValidEmail(email)) {
                    System.out.println("ERROR: Invalid email format: " + email);
                    return false;
                }
                
                // Check if email is already in use
                User existingUser = userDAO.getUserByEmail(email);
                if (existingUser != null && existingUser.getId() != userId) {
                    System.out.println("ERROR: Email already in use by another user: " + email);
                    return false;
                }
                
                System.out.println("Updating email from '" + user.getEmail() + "' to '" + email + "'");
                user.setEmail(email);
                hasChanges = true;
            }
            
            // Update password if new password is provided
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                if (!ValidationUtil.isValidPassword(newPassword)) {
                    System.out.println("ERROR: Invalid new password format");
                    return false;
                }
                
                System.out.println("Updating password...");
                user.setPassword(PasswordHasher.hashPassword(newPassword));
                hasChanges = true;
            }
            
            // Update profile image if provided
            if (profileImage != null && !profileImage.trim().isEmpty()) {
                System.out.println("Updating profile image from '" + user.getProfileImage() + "' to '" + profileImage + "'");
                user.setProfileImage(profileImage);
                hasChanges = true;
            }
            
            // If no changes were made, return true (nothing to update)
            if (!hasChanges) {
                System.out.println("No changes to update");
                return true;
            }
            
            // Perform the update
            boolean updateResult = userDAO.updateUser(user);
            System.out.println("Database update result: " + (updateResult ? "SUCCESS" : "FAILED"));
            return updateResult;
        } catch (Exception e) {
            System.out.println("EXCEPTION in updateUserProfile: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete user account
    public boolean deleteUser(int userId) {
        return userDAO.deleteUser(userId);
    }
    
    // Update user role (admin function)
    public boolean updateUserRole(int userId, String role) {
        if (role == null || (!role.equals("user") && !role.equals("admin"))) {
            return false;
        }
        
        try {
            User user = userDAO.getUserById(userId);
            if (user == null) {
                return false;
            }
            
            user.setRole(role);
            return userDAO.updateUser(user);
        } catch (Exception e) {
            System.out.println("Exception in updateUserRole: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}