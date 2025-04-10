package dz.eduquiz.servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import dz.eduquiz.util.FileUtil;

@WebServlet("/fileUpload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 5,   // 5 MB
    maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class FileUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private static final String UPLOAD_DIRECTORY = "uploads";
    
    public FileUploadServlet() {
        super();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get the upload directory path
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIRECTORY;
        
        // Create the upload directory if it doesn't exist
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        String fileName = null;
        
        // Process the uploaded file
        try {
            Part filePart = request.getPart("file"); // "file" is the name of the form field
            
            // Extract file name
            String submittedFileName = filePart.getSubmittedFileName();
            
            // Validate file type
            if (!FileUtil.isValidImageFile(submittedFileName)) {
                response.setContentType("application/json");
                response.getWriter().write("{\"error\": \"Invalid file type. Only JPG, PNG, and GIF are allowed.\"}");
                return;
            }
            
            // Generate a unique file name to prevent overwriting
            String fileExtension = submittedFileName.substring(submittedFileName.lastIndexOf("."));
            fileName = UUID.randomUUID().toString() + fileExtension;
            
            // Save the file
            Path filePath = Paths.get(uploadPath + File.separator + fileName);
            Files.copy(filePart.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
            
            // Return the file name to the client
            response.setContentType("application/json");
            response.getWriter().write("{\"fileName\": \"" + fileName + "\"}");
        } catch (Exception e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}