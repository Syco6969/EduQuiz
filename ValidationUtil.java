package dz.eduquiz.util;


import java.util.regex.Pattern;

public class ValidationUtil {
    
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$");
    
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{4,20}$");
    
    // Validate email format
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email).matches();
    }
    
    // Validate username format (alphanumeric, underscore, 4-20 chars)
    public static boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        return USERNAME_PATTERN.matcher(username).matches();
    }
    
    // Validate password strength
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        boolean hasDigit = false;
        boolean hasLetter = false;
        
        for (char c : password.toCharArray()) {
            if (Character.isDigit(c)) {
                hasDigit = true;
            } else if (Character.isLetter(c)) {
                hasLetter = true;
            }
            
            if (hasDigit && hasLetter) {
                return true;
            }
        }
        
        return false;
    }
    
    // Validate quiz title
    public static boolean isValidQuizTitle(String title) {
        return title != null && !title.trim().isEmpty() && title.length() <= 100;
    }
    
    // Validate that a string is not empty
    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }
    
    // Validate integer is positive
    public static boolean isPositiveInteger(int value) {
        return value > 0;
    }
    
    // Validate integer is within range
    public static boolean isIntegerInRange(int value, int min, int max) {
        return value >= min && value <= max;
    }
}