package dz.eduquiz.service;



import java.util.List;

import dz.eduquiz.dao.ScoreDAO;
import dz.eduquiz.dao.QuizDAO;
import dz.eduquiz.dao.UserDAO;
import dz.eduquiz.model.Score;
import dz.eduquiz.util.ValidationUtil;

public class ScoreService {
    private ScoreDAO scoreDAO;
    private QuizDAO quizDAO;
    private UserDAO userDAO;
    
    public ScoreService() {
        this.scoreDAO = new ScoreDAO();
        this.quizDAO = new QuizDAO();
        this.userDAO = new UserDAO();
    }
    
    // Record a new quiz score
    public int recordScore(int userId, int quizId, float score, int completionTime) {
        // Validate input
        if (!ValidationUtil.isPositiveInteger(userId)) {
            return -1;
        }
        
        if (!ValidationUtil.isPositiveInteger(quizId)) {
            return -1;
        }
        
        if (score < 0 || score > 100) {
            return -1;
        }
        
        if (completionTime <= 0) {
            return -1;
        }
        
        // Verify user and quiz exist
        if (userDAO.getUserById(userId) == null) {
            return -1;
        }
        
        if (quizDAO.getQuizById(quizId) == null) {
            return -1;
        }
        
        Score scoreObj = new Score();
        scoreObj.setUserId(userId);
        scoreObj.setQuizId(quizId);
        scoreObj.setScore(score);
        scoreObj.setCompletionTime(completionTime);
        
        return scoreDAO.createScore(scoreObj);
    }
    
    // Get score by ID
    public Score getScoreById(int id) {
        return scoreDAO.getScoreById(id);
    }
    
    // Get all scores for a user
    public List<Score> getScoresByUserId(int userId) {
        if (!ValidationUtil.isPositiveInteger(userId)) {
            return null;
        }
        
        return scoreDAO.getScoresByUserId(userId);
    }
    
    // Get all scores for a quiz
    public List<Score> getScoresByQuizId(int quizId) {
        if (!ValidationUtil.isPositiveInteger(quizId)) {
            return null;
        }
        
        return scoreDAO.getScoresByQuizId(quizId);
    }
    
    // Get top scores for a quiz (leaderboard)
    public List<Score> getTopScoresByQuizId(int quizId, int limit) {
        if (!ValidationUtil.isPositiveInteger(quizId) || !ValidationUtil.isPositiveInteger(limit)) {
            return null;
        }
        
        return scoreDAO.getTopScoresByQuizId(quizId, limit);
    }
    
    // Get best score for a user on a specific quiz
    public Score getBestScoreByUserAndQuiz(int userId, int quizId) {
        if (!ValidationUtil.isPositiveInteger(userId) || !ValidationUtil.isPositiveInteger(quizId)) {
            return null;
        }
        
        return scoreDAO.getBestScoreByUserAndQuiz(userId, quizId);
    }
    
    // Delete a score
    public boolean deleteScore(int id) {
        return scoreDAO.deleteScore(id);
    }
    
    // Delete all scores for a user
    public boolean deleteScoresByUserId(int userId) {
        if (!ValidationUtil.isPositiveInteger(userId)) {
            return false;
        }
        
        return scoreDAO.deleteScoresByUserId(userId);
    }
    
    // Delete all scores for a quiz
    public boolean deleteScoresByQuizId(int quizId) {
        if (!ValidationUtil.isPositiveInteger(quizId)) {
            return false;
        }
        
        return scoreDAO.deleteScoresByQuizId(quizId);
    }
    
    // Calculate average score for a quiz
    public float calculateAverageScoreForQuiz(int quizId) {
        List<Score> scores = getScoresByQuizId(quizId);
        if (scores == null || scores.isEmpty()) {
            return 0;
        }
        
        float sum = 0;
        for (Score score : scores) {
            sum += score.getScore();
        }
        
        return sum / scores.size();
    }
    
    // Calculate pass rate for a quiz (percentage of scores >= 60%)
    public float calculatePassRateForQuiz(int quizId) {
        List<Score> scores = getScoresByQuizId(quizId);
        if (scores == null || scores.isEmpty()) {
            return 0;
        }
        
        int passCount = 0;
        for (Score score : scores) {
            if (score.getScore() >= 60) {
                passCount++;
            }
        }
        
        return (float) passCount / scores.size() * 100;
    }
}