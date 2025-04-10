package dz.eduquiz.servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dz.eduquiz.model.User;
import dz.eduquiz.service.UserService;
import dz.eduquiz.service.ScoreService;
import dz.eduquiz.util.SessionManager;
import dz.eduquiz.util.ValidationUtil;

@WebServlet(urlPatterns = {"/register", "/login", "/logout", "/profile", "/updateProfile", "/home"})
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserService userService;
    private ScoreService scoreService;
    
    public UserServlet() {
        super();
        userService = new UserService();
        scoreService = new ScoreService();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        
        switch (action) {
            case "/register":
                showRegisterForm(request, response);
                break;
            case "/login":
                showLoginForm(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            case "/profile":
                showProfile(request, response);
                break;
            case "/home":
                showHomePage(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
                break;
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        
        switch (action) {
            case "/register":
                registerUser(request, response);
                break;
            case "/login":
                loginUser(request, response);
                break;
            case "/updateProfile":
                updateProfile(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
                break;
        }
    }
    
    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // If user is already logged in, redirect to home
        if (SessionManager.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/register.jsp");
        dispatcher.forward(request, response);
    }
    
    private void registerUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // If user is already logged in, redirect to home
        if (SessionManager.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate inputs
        boolean hasError = false;
        
        if (!ValidationUtil.isValidUsername(username)) {
            request.setAttribute("usernameError", "Username must be 4-20 characters and contain only letters, numbers, or underscores");
            hasError = true;
        }
        
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("emailError", "Please enter a valid email address");
            hasError = true;
        }
        
        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("passwordError", "Password must be at least 8 characters and contain at least one letter and one number");
            hasError = true;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("confirmPasswordError", "Passwords do not match");
            hasError = true;
        }
        
        if (hasError) {
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/register.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Try to register the user
        boolean success = userService.registerUser(username, email, password);
        
        if (success) {
            request.setAttribute("successMessage", "Registration successful! Please log in.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/login.jsp");
            dispatcher.forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Username or email already exists");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/register.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void showLoginForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // If user is already logged in, redirect to home
        if (SessionManager.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/login.jsp");
        dispatcher.forward(request, response);
    }
    
    private void loginUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // If user is already logged in, redirect to home
        if (SessionManager.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        String usernameOrEmail = request.getParameter("usernameOrEmail");
        String password = request.getParameter("password");
        
        User user = userService.authenticate(usernameOrEmail, password);
        
        if (user != null) {
            // Create session for user
            SessionManager.login(request, user);
            
            // Redirect based on role
            if ("admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home"); // Changed from "/profile"
            }
        } else {
            request.setAttribute("usernameOrEmail", usernameOrEmail);
            request.setAttribute("errorMessage", "Invalid username/email or password");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/login.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        SessionManager.logout(request);
        response.sendRedirect(request.getContextPath() + "/login");
    }
    
    private void showProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        if (!SessionManager.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = SessionManager.getCurrentUser(request);
        
        // Get user's quiz history
        request.setAttribute("quizHistory", scoreService.getScoresByUserId(currentUser.getId()));
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/profile.jsp");
        dispatcher.forward(request, response);
    }
    
    // Updated profile method with enhanced logging
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("------ Update Profile Request Received ------");
        
        // Check if user is logged in
        if (!SessionManager.isLoggedIn(request)) {
            System.out.println("User not logged in - redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = SessionManager.getCurrentUser(request);
        System.out.println("Current user: " + currentUser.getUsername() + " (ID: " + currentUser.getId() + ")");
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        System.out.println("Form data received:");
        System.out.println("- Username: " + username);
        System.out.println("- Email: " + email);
        System.out.println("- Current password provided: " + (currentPassword != null && !currentPassword.isEmpty()));
        System.out.println("- New password provided: " + (newPassword != null && !newPassword.isEmpty()));
        
        // Validate inputs
        boolean hasError = false;
        
        if (username != null && !username.trim().isEmpty() && !username.equals(currentUser.getUsername())) {
            if (!ValidationUtil.isValidUsername(username)) {
                request.setAttribute("usernameError", "Username must be 4-20 characters and contain only letters, numbers, or underscores");
                hasError = true;
                System.out.println("Username validation failed");
            }
        }
        
        if (email != null && !email.trim().isEmpty() && !email.equals(currentUser.getEmail())) {
            if (!ValidationUtil.isValidEmail(email)) {
                request.setAttribute("emailError", "Please enter a valid email address");
                hasError = true;
                System.out.println("Email validation failed");
            }
        }
        
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (!ValidationUtil.isValidPassword(newPassword)) {
                request.setAttribute("newPasswordError", "Password must be at least 8 characters and contain at least one letter and one number");
                hasError = true;
                System.out.println("New password validation failed");
            }
            
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("confirmPasswordError", "Passwords do not match");
                hasError = true;
                System.out.println("Confirm password validation failed");
            }
        }
        
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            request.setAttribute("currentPasswordError", "Current password is required to make changes");
            hasError = true;
            System.out.println("Current password not provided");
        }
        
        if (hasError) {
            System.out.println("Validation errors found - returning to profile page");
            // Keep the submitted values to refill the form
            request.setAttribute("formUsername", username);
            request.setAttribute("formEmail", email);
            
            // Forward back to profile page with error messages
            request.setAttribute("showProfileModal", true); // Flag to show modal
            request.setAttribute("quizHistory", scoreService.getScoresByUserId(currentUser.getId()));
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/profile.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Update profile using the new combined method
        System.out.println("Calling userService.updateUserProfile");
        boolean success = userService.updateUserProfile(
            currentUser.getId(), 
            username, 
            email, 
            currentPassword, 
            newPassword
        );
        System.out.println("Update result: " + (success ? "SUCCESS" : "FAILED"));
        
        if (success) {
            System.out.println("Update successful - updating session data");
            // Update session user with new information
            if (username != null && !username.trim().isEmpty()) {
                currentUser.setUsername(username);
            }
            if (email != null && !email.trim().isEmpty()) {
                currentUser.setEmail(email);
            }
            
            request.getSession().setAttribute("user", currentUser); // Update session
            request.setAttribute("successMessage", "Profile updated successfully");
        } else {
            System.out.println("Update failed - setting error message");
            request.setAttribute("errorMessage", "Failed to update profile. Please check your current password.");
            request.setAttribute("showProfileModal", true); // Flag to show modal
            
            // Keep the submitted values to refill the form
            request.setAttribute("formUsername", username);
            request.setAttribute("formEmail", email);
        }
        
        // Redirect to the profile page
        request.setAttribute("quizHistory", scoreService.getScoresByUserId(currentUser.getId()));
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/profile.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showHomePage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/index.jsp");
        dispatcher.forward(request, response);
    }
}