package dz.eduquiz.dao;




import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import dz.eduquiz.model.Question;

public class QuestionDAO {
    
    // Create a new question
    public int createQuestion(Question question) {
        String sql = "INSERT INTO questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, question.getQuizId());
            pstmt.setString(2, question.getQuestionText());
            pstmt.setString(3, question.getOptionA());
            pstmt.setString(4, question.getOptionB());
            pstmt.setString(5, question.getOptionC());
            pstmt.setString(6, question.getOptionD());
            pstmt.setString(7, String.valueOf(question.getCorrectAnswer()));
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating question failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    question.setId(generatedKeys.getInt(1));
                    return question.getId();
                } else {
                    throw new SQLException("Creating question failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }
    
    // Get question by ID
    public Question getQuestionById(int id) {
        String sql = "SELECT * FROM questions WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Question question = new Question();
                question.setId(rs.getInt("id"));
                question.setQuizId(rs.getInt("quiz_id"));
                question.setQuestionText(rs.getString("question_text"));
                question.setOptionA(rs.getString("option_a"));
                question.setOptionB(rs.getString("option_b"));
                question.setOptionC(rs.getString("option_c"));
                question.setOptionD(rs.getString("option_d"));
                question.setCorrectAnswer(rs.getString("correct_answer").charAt(0));
                return question;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Get questions by quiz ID
    public List<Question> getQuestionsByQuizId(int quizId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM questions WHERE quiz_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, quizId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Question question = new Question();
                question.setId(rs.getInt("id"));
                question.setQuizId(rs.getInt("quiz_id"));
                question.setQuestionText(rs.getString("question_text"));
                question.setOptionA(rs.getString("option_a"));
                question.setOptionB(rs.getString("option_b"));
                question.setOptionC(rs.getString("option_c"));
                question.setOptionD(rs.getString("option_d"));
                question.setCorrectAnswer(rs.getString("correct_answer").charAt(0));
                questions.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return questions;
    }
    
    // Update question
    public boolean updateQuestion(Question question) {
        String sql = "UPDATE questions SET quiz_id = ?, question_text = ?, option_a = ?, option_b = ?, " +
                     "option_c = ?, option_d = ?, correct_answer = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, question.getQuizId());
            pstmt.setString(2, question.getQuestionText());
            pstmt.setString(3, question.getOptionA());
            pstmt.setString(4, question.getOptionB());
            pstmt.setString(5, question.getOptionC());
            pstmt.setString(6, question.getOptionD());
            pstmt.setString(7, String.valueOf(question.getCorrectAnswer()));
            pstmt.setInt(8, question.getId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete question
    public boolean deleteQuestion(int id) {
        String sql = "DELETE FROM questions WHERE id = ?";
        
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
    
    // Delete all questions for a specific quiz
    public boolean deleteQuestionsByQuizId(int quizId) {
        String sql = "DELETE FROM questions WHERE quiz_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, quizId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Count questions in a quiz
    public int countQuestionsByQuizId(int quizId) {
        String sql = "SELECT COUNT(*) FROM questions WHERE quiz_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, quizId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
}
