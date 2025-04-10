<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="dz.eduquiz.util.SessionManager" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Home</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/navbar.jsp" />
    
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Welcome to EduQuiz</h4>
                    </div>
                    <div class="card-body">
                        <% if (SessionManager.isLoggedIn(request)) { %>
                            <!-- Show logged-in user content -->
                            <h5 class="card-title">Hello, <%= SessionManager.getCurrentUser(request).getUsername() %>!</h5>
                            <p class="card-text">Welcome back to EduQuiz. Take a quiz to test your knowledge or check your profile to see your past results.</p>
                            <div class="mt-4">
                                <a href="${pageContext.request.contextPath}/quizzes" class="btn btn-primary me-2">Browse Quizzes</a>
                                <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-primary">View Profile</a>
                            </div>
                        <% } else { %>
                            <!-- Show guest content -->
                            <h5 class="card-title">Welcome to EduQuiz!</h5>
                            <p class="card-text">EduQuiz is an interactive learning platform that helps you test and improve your knowledge through fun quizzes.</p>
                            <p>To get started:</p>
                            <ul>
                                <li>Create an account to save your progress</li>
                                <li>Browse our collection of quizzes across various categories</li>
                                <li>Test your knowledge and track your improvement</li>
                            </ul>
                            <div class="mt-4">
                                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary me-2">Register</a>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary">Login</a>
                            </div>
                        <% } %>
                    </div>
                </div>
                
                <!-- Featured Quizzes Section -->
                <div class="card mt-4">
                    <div class="card-header bg-light">
                        <h5 class="mb-0">Featured Quizzes</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <!-- You can use JSTL to loop through featured quizzes from your database -->
                            <!-- This is static placeholder content -->
                            <div class="col-md-4 mb-3">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <h6 class="card-title">Science Quiz</h6>
                                        <p class="card-text small">Test your knowledge of basic scientific concepts.</p>
                                    </div>
                                    <div class="card-footer bg-white border-top-0">
                                        <a href="#" class="btn btn-sm btn-primary">Take Quiz</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <h6 class="card-title">History Quiz</h6>
                                        <p class="card-text small">Explore major historical events and figures.</p>
                                    </div>
                                    <div class="card-footer bg-white border-top-0">
                                        <a href="#" class="btn btn-sm btn-primary">Take Quiz</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <h6 class="card-title">Mathematics Quiz</h6>
                                        <p class="card-text small">Challenge yourself with math problems.</p>
                                    </div>
                                    <div class="card-footer bg-white border-top-0">
                                        <a href="#" class="btn btn-sm btn-primary">Take Quiz</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
</body>
</html>