package dz.eduquiz.service;



import java.util.List;

import dz.eduquiz.dao.QuizDAO;
import dz.eduquiz.model.Quiz;
import dz.eduquiz.util.ValidationUtil;

public class QuizService {
    private QuizDAO quizDAO;
    
    public QuizService() {
        this.quizDAO = new QuizDAO();
    }
    
    // Create a new quiz
    public int createQuiz(String title, String description, int categoryId, String difficulty, int timeLimit) {
        // Validate input
        if (!ValidationUtil.isValidQuizTitle(title)) {
            return -1;
        }
        
        if (!ValidationUtil.isNotEmpty(description)) {
            return -1;
        }
        
        if (!ValidationUtil.isPositiveInteger(categoryId)) {
            return -1;
        }
        
        if (!isValidDifficulty(difficulty)) {
            return -1;
        }
        
        if (!ValidationUtil.isIntegerInRange(timeLimit, 1, 60)) {
            return -1;
        }
        
        Quiz quiz = new Quiz(title, description, categoryId, difficulty, timeLimit);
        return quizDAO.createQuiz(quiz);
    }
    
    // Get quiz by ID
    public Quiz getQuizById(int id) {
        return quizDAO.getQuizById(id);
    }
    
    // Get all quizzes
    public List<Quiz> getAllQuizzes() {
        return quizDAO.getAllQuizzes();
    }
    
    // Get quizzes by category
    public List<Quiz> getQuizzesByCategory(int categoryId) {
        return quizDAO.getQuizzesByCategory(categoryId);
    }
    
    // Get quizzes by difficulty
    public List<Quiz> getQuizzesByDifficulty(String difficulty) {
        if (!isValidDifficulty(difficulty)) {
            return null;
        }
        return quizDAO.getQuizzesByDifficulty(difficulty);
    }
    
    // Update quiz
    public boolean updateQuiz(int id, String title, String description, int categoryId, String difficulty, int timeLimit) {
        // Validate input
        if (!ValidationUtil.isValidQuizTitle(title)) {
            return false;
        }
        
        if (!ValidationUtil.isNotEmpty(description)) {
            return false;
        }
        
        if (!ValidationUtil.isPositiveInteger(categoryId)) {
            return false;
        }
        
        if (!isValidDifficulty(difficulty)) {
            return false;
        }
        
        if (!ValidationUtil.isIntegerInRange(timeLimit, 1, 60)) {
            return false;
        }
        
        Quiz quiz = quizDAO.getQuizById(id);
        if (quiz == null) {
            return false;
        }
        
        quiz.setTitle(title);
        quiz.setDescription(description);
        quiz.setCategoryId(categoryId);
        quiz.setDifficulty(difficulty);
        quiz.setTimeLimit(timeLimit);
        
        return quizDAO.updateQuiz(quiz);
    }
    
    // Delete quiz
    public boolean deleteQuiz(int id) {
        return quizDAO.deleteQuiz(id);
    }
    
    // Helper method to validate difficulty
    private boolean isValidDifficulty(String difficulty) {
        return difficulty != null && 
               (difficulty.equals("easy") || difficulty.equals("medium") || difficulty.equals("hard"));
    }

    public List<Quiz> searchQuizzesByTitle(String searchTerm) {
        if (!ValidationUtil.isNotEmpty(searchTerm)) {
            return getAllQuizzes();
        }
        return quizDAO.searchQuizzesByTitle(searchTerm);
    }
}