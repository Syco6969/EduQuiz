package dz.eduquiz.service;


import java.util.List;

import dz.eduquiz.dao.QuestionDAO;
import dz.eduquiz.model.Question;
import dz.eduquiz.util.ValidationUtil;

public class QuestionService {
    private QuestionDAO questionDAO;
    
    public QuestionService() {
        this.questionDAO = new QuestionDAO();
    }
    
    // Add a question to a quiz
    public int addQuestion(int quizId, String questionText, String optionA, String optionB, 
                           String optionC, String optionD, char correctAnswer) {
        // Validate input
        if (!ValidationUtil.isPositiveInteger(quizId)) {
            return -1;
        }
        
        if (!ValidationUtil.isNotEmpty(questionText)) {
            return -1;
        }
        
        if (!ValidationUtil.isNotEmpty(optionA) || !ValidationUtil.isNotEmpty(optionB) ||
            !ValidationUtil.isNotEmpty(optionC) || !ValidationUtil.isNotEmpty(optionD)) {
            return -1;
        }
        
        if (!isValidAnswer(correctAnswer)) {
            return -1;
        }
        
        Question question = new Question();
        question.setQuizId(quizId);
        question.setQuestionText(questionText);
        question.setOptionA(optionA);
        question.setOptionB(optionB);
        question.setOptionC(optionC);
        question.setOptionD(optionD);
        question.setCorrectAnswer(correctAnswer);
        
        return questionDAO.createQuestion(question);
    }
    
    // Get question by ID
    public Question getQuestionById(int id) {
        return questionDAO.getQuestionById(id);
    }
    
    // Get all questions for a quiz
    public List<Question> getQuestionsByQuizId(int quizId) {
        if (!ValidationUtil.isPositiveInteger(quizId)) {
            return null;
        }
        
        return questionDAO.getQuestionsByQuizId(quizId);
    }
    
    // Update a question
    public boolean updateQuestion(int id, int quizId, String questionText, String optionA, 
                                  String optionB, String optionC, String optionD, char correctAnswer) {
        // Validate input
        if (!ValidationUtil.isPositiveInteger(quizId)) {
            return false;
        }
        
        if (!ValidationUtil.isNotEmpty(questionText)) {
            return false;
        }
        
        if (!ValidationUtil.isNotEmpty(optionA) || !ValidationUtil.isNotEmpty(optionB) ||
            !ValidationUtil.isNotEmpty(optionC) || !ValidationUtil.isNotEmpty(optionD)) {
            return false;
        }
        
        if (!isValidAnswer(correctAnswer)) {
            return false;
        }
        
        Question question = questionDAO.getQuestionById(id);
        if (question == null) {
            return false;
        }
        
        question.setQuizId(quizId);
        question.setQuestionText(questionText);
        question.setOptionA(optionA);
        question.setOptionB(optionB);
        question.setOptionC(optionC);
        question.setOptionD(optionD);
        question.setCorrectAnswer(correctAnswer);
        
        return questionDAO.updateQuestion(question);
    }
    
    // Delete a question
    public boolean deleteQuestion(int id) {
        return questionDAO.deleteQuestion(id);
    }
    
    // Delete all questions for a quiz
    public boolean deleteQuestionsByQuizId(int quizId) {
        if (!ValidationUtil.isPositiveInteger(quizId)) {
            return false;
        }
        
        return questionDAO.deleteQuestionsByQuizId(quizId);
    }
    
    // Count questions in a quiz
    public int countQuestionsByQuizId(int quizId) {
        if (!ValidationUtil.isPositiveInteger(quizId)) {
            return 0;
        }
        
        return questionDAO.countQuestionsByQuizId(quizId);
    }
    
    // Helper method to validate answer
    private boolean isValidAnswer(char answer) {
        return answer == 'A' || answer == 'B' || answer == 'C' || answer == 'D';
    }
    
    // Check if an answer is correct for a specific question
    public boolean isCorrectAnswer(int questionId, char answer) {
        Question question = questionDAO.getQuestionById(questionId);
        if (question == null) {
            return false;
        }
        
        return question.getCorrectAnswer() == answer;
    }
}