package dz.eduquiz.util;



import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import dz.eduquiz.model.User;

public class SessionManager {
    
    private static final String USER_SESSION_KEY = "currentUser";
    private static final int SESSION_TIMEOUT = 30 * 60; // 30 minutes in seconds
    
    // Create a new session for a user
    public static void login(HttpServletRequest request, User user) {
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setMaxInactiveInterval(SESSION_TIMEOUT);
    }
    
    // Get the current logged-in user from session
    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");  // Use "user" instead of USER_SESSION_KEY
        }
        return null;
    }
    
    // Check if a user is logged in
    public static boolean isLoggedIn(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }
    
    // Check if current user is an admin
    public static boolean isAdmin(HttpServletRequest request) {
        User user = getCurrentUser(request);
        return user != null && "admin".equals(user.getRole());
    }
    
    // Logout (invalidate session)
    public static void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
    
 // Add this to SessionManager.java
    public static void updateSessionUser(HttpServletRequest request, User user) {
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
    }
}