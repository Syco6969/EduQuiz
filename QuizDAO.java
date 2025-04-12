package dz.eduquiz.dao;




import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import dz.eduquiz.model.Category;
import dz.eduquiz.model.Quiz;



public class QuizDAO {
	
	public QuizDAO() {
	    this.categoryDAO = new CategoryDAO();
	}
	
	
	private CategoryDAO categoryDAO;
    
    // Create a new quiz
    public int createQuiz(Quiz quiz) {
        String sql = "INSERT INTO quizzes (title, description, category_id, difficulty, time_limit) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, quiz.getTitle());
            pstmt.setString(2, quiz.getDescription());
            pstmt.setInt(3, quiz.getCategoryId());
            pstmt.setString(4, quiz.getDifficulty());
            pstmt.setInt(5, quiz.getTimeLimit());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating quiz failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    quiz.setId(generatedKeys.getInt(1));
                    return quiz.getId();
                } else {
                    throw new SQLException("Creating quiz failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }
    
    // Get quiz by ID
    public Quiz getQuizById(int id) {
        Quiz quiz = null;
        String sql = "SELECT * FROM quizzes WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    quiz = new Quiz();
                    quiz.setId(rs.getInt("id"));
                    quiz.setTitle(rs.getString("title"));
                    quiz.setDescription(rs.getString("description"));
                    quiz.setCategoryId(rs.getInt("category_id"));
                    quiz.setDifficulty(rs.getString("difficulty"));
                    quiz.setTimeLimit(rs.getInt("time_limit"));
                    
                    // Populate category info
                    populateQuizWithCategory(quiz);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return quiz;
    }
    
    // Get all quizzes
    public List<Quiz> getAllQuizzes() {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM quizzes";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setTitle(rs.getString("title"));
                quiz.setDescription(rs.getString("description"));
                quiz.setCategoryId(rs.getInt("category_id"));
                quiz.setDifficulty(rs.getString("difficulty"));
                quiz.setTimeLimit(rs.getInt("time_limit"));
                
                // Populate category info
                populateQuizWithCategory(quiz);
                
                quizzes.add(quiz);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return quizzes;
    }
    
    // Get quizzes by category
    public List<Quiz> getQuizzesByCategory(int categoryId) {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM quizzes WHERE category_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, categoryId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setTitle(rs.getString("title"));
                quiz.setDescription(rs.getString("description"));
                quiz.setCategoryId(rs.getInt("category_id"));
                quiz.setDifficulty(rs.getString("difficulty"));
                quiz.setTimeLimit(rs.getInt("time_limit"));
                quizzes.add(quiz);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return quizzes;
    }
    
    // Get quizzes by difficulty
    public List<Quiz> getQuizzesByDifficulty(String difficulty) {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM quizzes WHERE difficulty = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, difficulty);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setTitle(rs.getString("title"));
                quiz.setDescription(rs.getString("description"));
                quiz.setCategoryId(rs.getInt("category_id"));
                quiz.setDifficulty(rs.getString("difficulty"));
                quiz.setTimeLimit(rs.getInt("time_limit"));
                quizzes.add(quiz);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return quizzes;
    }
    
    public List<Quiz> searchQuizzesByTitle(String searchTerm) {
        List<Quiz> result = new ArrayList<>();
        String sql = "SELECT * FROM quizzes WHERE LOWER(title) LIKE ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + searchTerm.toLowerCase() + "%");
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Quiz quiz = new Quiz();
                    quiz.setId(rs.getInt("id"));
                    quiz.setTitle(rs.getString("title"));
                    quiz.setDescription(rs.getString("description"));
                    quiz.setCategoryId(rs.getInt("category_id"));
                    quiz.setDifficulty(rs.getString("difficulty"));
                    quiz.setTimeLimit(rs.getInt("time_limit"));
                    
                    // Populate category info
                    populateQuizWithCategory(quiz);
                    
                    result.add(quiz);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return result;
    }
    
    // Update quiz
    public boolean updateQuiz(Quiz quiz) {
        String sql = "UPDATE quizzes SET title = ?, description = ?, category_id = ?, difficulty = ?, time_limit = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, quiz.getTitle());
            pstmt.setString(2, quiz.getDescription());
            pstmt.setInt(3, quiz.getCategoryId());
            pstmt.setString(4, quiz.getDifficulty());
            pstmt.setInt(5, quiz.getTimeLimit());
            pstmt.setInt(6, quiz.getId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete quiz
    public boolean deleteQuiz(int id) {
        String sql = "DELETE FROM quizzes WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private Quiz populateQuizWithCategory(Quiz quiz) {
        if (quiz != null && quiz.getCategoryId() > 0) {
            Category category = categoryDAO.getCategoryById(quiz.getCategoryId());
            quiz.setCategory(category);
        }
        return quiz;
    }

}