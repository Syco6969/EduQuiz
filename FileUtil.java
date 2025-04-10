package dz.eduquiz.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import jakarta.servlet.http.Part;

public class FileUtil {
    
    private static final List<String> ALLOWED_IMAGE_EXTENSIONS = Arrays.asList(".jpg", ".jpeg", ".png", ".gif");
    
    // Check if the file has a valid image extension
    public static boolean isValidImageFile(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return false;
        }
        
        String extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        return ALLOWED_IMAGE_EXTENSIONS.contains(extension);
    }
    
    // Process and save an uploaded profile image
    public static String processProfileImage(Part filePart, String uploadDir) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        String submittedFileName = filePart.getSubmittedFileName();
        
        // Validate file type
        if (!isValidImageFile(submittedFileName)) {
            throw new IOException("Invalid file type. Only JPG, PNG, and GIF are allowed.");
        }
        
        // Generate a unique file name
        String fileExtension = submittedFileName.substring(submittedFileName.lastIndexOf(".")).toLowerCase();
        String fileName = "profile_" + UUID.randomUUID().toString() + fileExtension;
        
        // Make sure the upload directory exists
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        
        // Save the file
        Path filePath = uploadPath.resolve(fileName);
        Files.copy(filePart.getInputStream(), filePath);
        
        return fileName;
    }
    
    // Delete a file from the uploads directory
    public static boolean deleteFile(String fileName, String uploadDir) {
        if (fileName == null || fileName.isEmpty()) {
            return false;
        }
        
        try {
            Path filePath = Paths.get(uploadDir, fileName);
            return Files.deleteIfExists(filePath);
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}