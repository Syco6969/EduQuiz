package dz.eduquiz.dao;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import dz.eduquiz.model.Score;

public class ScoreDAO {
    
    // Create a new score
    public int createScore(Score score) {
        String sql = "INSERT INTO scores (user_id, quiz_id, score, completion_time) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, score.getUserId());
            pstmt.setInt(2, score.getQuizId());
            pstmt.setFloat(3, score.getScore());
            pstmt.setInt(4, score.getCompletionTime());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating score failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    score.setId(generatedKeys.getInt(1));
                    return score.getId();
                } else {
                    throw new SQLException("Creating score failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }
    
    // Get score by ID
    public Score getScoreById(int id) {
        String sql = "SELECT * FROM scores WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Score score = new Score();
                score.setId(rs.getInt("id"));
                score.setUserId(rs.getInt("user_id"));
                score.setQuizId(rs.getInt("quiz_id"));
                score.setScore(rs.getFloat("score"));
                score.setCompletionTime(rs.getInt("completion_time"));
                score.setDateTaken(rs.getTimestamp("date_taken"));
                return score;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Get scores by user ID
    public List<Score> getScoresByUserId(int userId) {
        List<Score> scores = new ArrayList<>();
        String sql = "SELECT * FROM scores WHERE user_id = ? ORDER BY date_taken DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Score score = new Score();
                score.setId(rs.getInt("id"));
                score.setUserId(rs.getInt("user_id"));
                score.setQuizId(rs.getInt("quiz_id"));
                score.setScore(rs.getFloat("score"));
                score.setCompletionTime(rs.getInt("completion_time"));
                score.setDateTaken(rs.getTimestamp("date_taken"));
                scores.add(score);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return scores;
    }
    
    // Get scores by quiz ID
    public List<Score> getScoresByQuizId(int quizId) {
        List<Score> scores = new ArrayList<>();
        String sql = "SELECT * FROM scores WHERE quiz_id = ? ORDER BY score DESC, completion_time ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, quizId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Score score = new Score();
                score.setId(rs.getInt("id"));
                score.setUserId(rs.getInt("user_id"));
                score.setQuizId(rs.getInt("quiz_id"));
                score.setScore(rs.getFloat("score"));
                score.setCompletionTime(rs.getInt("completion_time"));
                score.setDateTaken(rs.getTimestamp("date_taken"));
                scores.add(score);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return scores;
    }
    
    // Get top scores for a quiz (leaderboard)
    public List<Score> getTopScoresByQuizId(int quizId, int limit) {
        List<Score> scores = new ArrayList<>();
        String sql = "SELECT * FROM scores WHERE quiz_id = ? ORDER BY score DESC, completion_time ASC LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, quizId);
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Score score = new Score();
                score.setId(rs.getInt("id"));
                score.setUserId(rs.getInt("user_id"));
                score.setQuizId(rs.getInt("quiz_id"));
                score.setScore(rs.getFloat("score"));
                score.setCompletionTime(rs.getInt("completion_time"));
                score.setDateTaken(rs.getTimestamp("date_taken"));
                scores.add(score);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return scores;
    }
    
    // Get best score for a user on a specific quiz
    public Score getBestScoreByUserAndQuiz(int userId, int quizId) {
        String sql = "SELECT * FROM scores WHERE user_id = ? AND quiz_id = ? ORDER BY score DESC, completion_time ASC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, quizId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Score score = new Score();
                score.setId(rs.getInt("id"));
                score.setUserId(rs.getInt("user_id"));
                score.setQuizId(rs.getInt("quiz_id"));
                score.setScore(rs.getFloat("score"));
                score.setCompletionTime(rs.getInt("completion_time"));
                score.setDateTaken(rs.getTimestamp("date_taken"));
                return score;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Delete score
    public boolean deleteScore(int id) {
        String sql = "DELETE FROM scores WHERE id = ?";
        
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
    
    // Delete scores by user ID
    public boolean deleteScoresByUserId(int userId) {
        String sql = "DELETE FROM scores WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete scores by quiz ID
    public boolean deleteScoresByQuizId(int quizId) {
        String sql = "DELETE FROM scores WHERE quiz_id = ?";
        
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
}
