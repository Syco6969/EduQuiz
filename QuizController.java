package dz.eduquiz.servlet;


import java.io.IOException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dz.eduquiz.model.Quiz;
import dz.eduquiz.model.Question;
import dz.eduquiz.model.Category;
import dz.eduquiz.model.User;
import dz.eduquiz.service.QuizService;
import dz.eduquiz.service.QuestionService;
import dz.eduquiz.service.CategoryService;
import dz.eduquiz.service.ScoreService;
import dz.eduquiz.util.SessionManager;

@WebServlet(urlPatterns = {"/quizzes", "/quiz/*", "/take-quiz/*", "/submit-quiz"})
public class QuizController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private QuizService quizService;
    private QuestionService questionService;
    private CategoryService categoryService;
    private ScoreService scoreService;
    
    public QuizController() {
        super();
        quizService = new QuizService();
        questionService = new QuestionService();
        categoryService = new CategoryService();
        scoreService = new ScoreService();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();
        
        if (path.equals("/quizzes")) {
            // Display list of all quizzes
            listQuizzes(request, response);
        } else if (path.equals("/quiz") && pathInfo != null) {
            // Display quiz details
            showQuizDetails(request, response, getIdFromPath(pathInfo));
        } else if (path.equals("/take-quiz") && pathInfo != null) {
            // Show quiz taking interface
            showTakeQuiz(request, response, getIdFromPath(pathInfo));
        } else {
            response.sendRedirect(request.getContextPath() + "/quizzes");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        if (path.equals("/submit-quiz")) {
            // Process quiz submission
            submitQuiz(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/quizzes");
        }
    }
    
    private void listQuizzes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get filter parameters
        String categoryParam = request.getParameter("category");
        String difficultyParam = request.getParameter("difficulty");
        String searchParam = request.getParameter("search");
        
        List<Quiz> quizzes;
        
        // Apply filters if provided
        if (categoryParam != null && !categoryParam.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryParam);
                quizzes = quizService.getQuizzesByCategory(categoryId);
            } catch (NumberFormatException e) {
                quizzes = quizService.getAllQuizzes();
            }
        } else if (difficultyParam != null && !difficultyParam.isEmpty()) {
            quizzes = quizService.getQuizzesByDifficulty(difficultyParam);
        } else if (searchParam != null && !searchParam.isEmpty()) {
            quizzes = quizService.searchQuizzesByTitle(searchParam);
        } else {
            quizzes = quizService.getAllQuizzes();
        }
        
        // Get categories for filter dropdown
        List<Category> categories = categoryService.getAllCategories();
        
        request.setAttribute("quizzes", quizzes);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", categoryParam);
        request.setAttribute("selectedDifficulty", difficultyParam);
        request.setAttribute("searchTerm", searchParam);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/quizzes.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showQuizDetails(HttpServletRequest request, HttpServletResponse response, int quizId) throws ServletException, IOException {
        Quiz quiz = quizService.getQuizById(quizId);
        
        if (quiz == null) {
            request.setAttribute("errorMessage", "Quiz not found");
            response.sendRedirect(request.getContextPath() + "/quizzes");
            return;
        }
        
        // Get quiz category
        Category category = categoryService.getCategoryById(quiz.getCategoryId());
        
        // Get question count
        int questionCount = questionService.countQuestionsByQuizId(quizId);
        
        // Get top scores if available
        List<dz.eduquiz.model.Score> topScores = scoreService.getTopScoresByQuizId(quizId, 5);
        
        // Check if logged-in user has attempted this quiz
        if (SessionManager.isLoggedIn(request)) {
            User currentUser = SessionManager.getCurrentUser(request);
            dz.eduquiz.model.Score userBestScore = scoreService.getBestScoreByUserAndQuiz(currentUser.getId(), quizId);
            request.setAttribute("userBestScore", userBestScore);
        }
        
        request.setAttribute("quiz", quiz);
        request.setAttribute("category", category);
        request.setAttribute("questionCount", questionCount);
        request.setAttribute("topScores", topScores);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/quizdetails.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showTakeQuiz(HttpServletRequest request, HttpServletResponse response, int quizId) throws ServletException, IOException {
        // Check if user is logged in
        if (!SessionManager.isLoggedIn(request)) {
            request.setAttribute("errorMessage", "You must be logged in to take a quiz");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Quiz quiz = quizService.getQuizById(quizId);
        
        if (quiz == null) {
            request.setAttribute("errorMessage", "Quiz not found");
            response.sendRedirect(request.getContextPath() + "/quizzes");
            return;
        }
        
        // Get questions for the quiz
        List<Question> questions = questionService.getQuestionsByQuizId(quizId);
        
        if (questions == null || questions.isEmpty()) {
            request.setAttribute("errorMessage", "This quiz has no questions");
            response.sendRedirect(request.getContextPath() + "/quiz/" + quizId);
            return;
        }
        
        request.setAttribute("quiz", quiz);
        request.setAttribute("questions", questions);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/takequiz.jsp");
        dispatcher.forward(request, response);
    }
    
    private void submitQuiz(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        if (!SessionManager.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = SessionManager.getCurrentUser(request);
        
        try {
            int quizId = Integer.parseInt(request.getParameter("quizId"));
            int completionTime = Integer.parseInt(request.getParameter("completionTime"));
            
            Quiz quiz = quizService.getQuizById(quizId);
            
            if (quiz == null) {
                request.setAttribute("errorMessage", "Quiz not found");
                response.sendRedirect(request.getContextPath() + "/quizzes");
                return;
            }
            
            // Get all questions for the quiz
            List<Question> questions = questionService.getQuestionsByQuizId(quizId);
            
            if (questions == null || questions.isEmpty()) {
                request.setAttribute("errorMessage", "This quiz has no questions");
                response.sendRedirect(request.getContextPath() + "/quiz/" + quizId);
                return;
            }
            
            // Calculate score
            int correctAnswers = 0;
            
            for (Question question : questions) {
                String userAnswer = request.getParameter("answer_" + question.getId());
                
                if (userAnswer != null && userAnswer.length() == 1) {
                    char answer = userAnswer.charAt(0);
                    if (question.getCorrectAnswer() == answer) {
                        correctAnswers++;
                    }
                }
            }
            
            float score = (float) correctAnswers / questions.size() * 100;
            
            // Record score
            int scoreId = scoreService.recordScore(currentUser.getId(), quizId, score, completionTime);
            
            if (scoreId > 0) {
                // Redirect to results page
                response.sendRedirect(request.getContextPath() + "/quiz-result?scoreId=" + scoreId);
            } else {
                request.setAttribute("errorMessage", "Failed to record score");
                response.sendRedirect(request.getContextPath() + "/quiz/" + quizId);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid quiz information");
            response.sendRedirect(request.getContextPath() + "/quizzes");
        }
    }
    
    // Helper method to extract ID from path
    private int getIdFromPath(String pathInfo) {
        try {
            return Integer.parseInt(pathInfo.substring(1));
        } catch (NumberFormatException | StringIndexOutOfBoundsException e) {
            return -1;
        }
    }
}