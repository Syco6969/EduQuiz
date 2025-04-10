package dz.eduquiz.util;



import org.mindrot.jbcrypt.BCrypt;

public class PasswordHasher {
    
    // Hash a password using BCrypt
    public static String hashPassword(String plainTextPassword) {
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt());
    }
    
    // Verify a password against a hashed password
    public static boolean checkPassword(String plainTextPassword, String hashedPassword) {
        return BCrypt.checkpw(plainTextPassword, hashedPassword);
    }
}