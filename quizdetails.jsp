<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - ${quiz.title}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/quiz.css">
</head>
<body>
    <jsp:include page="/WEB-INF/navbar.jsp" />
    
    <div class="container mt-5">
        <div class="row">
            <div class="col-lg-8">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h1 class="h3 mb-0">${quiz.title}</h1>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <span class="badge ${quiz.difficulty eq 'Easy' ? 'bg-success' : quiz.difficulty eq 'Medium' ? 'bg-warning' : 'bg-danger'}">${quiz.difficulty}</span>
                            <span class="badge bg-info">${category.name}</span>
                            <span class="ms-2"><i class="bi bi-clock"></i> ${quiz.timeLimit} minutes</span>
                            <span class="ms-2"><i class="bi bi-question-circle"></i> ${questionCount} questions</span>
                        </div>
                        
                        <p class="lead">${quiz.description}</p>
                        
                        <div class="d-flex justify-content-between align-items-center mt-4">
                            <c:choose>
                                <c:when test="${sessionScope.user != null}">
                                    <a href="${pageContext.request.contextPath}/take-quiz/${quiz.id}" class="btn btn-primary">
                                        <i class="bi bi-play-fill"></i> Take Quiz
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                                        <i class="bi bi-box-arrow-in-right"></i> Login to Take Quiz
                                    </a>
                                </c:otherwise>
                            </c:choose>
                            
                            <a href="${pageContext.request.contextPath}/quizzes" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left"></i> Back to Quizzes
                            </a>
                        </div>
                    </div>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header">
                        <h2 class="h5 mb-0">About This Quiz</h2>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Quiz Features:</h6>
                                <ul>
                                    <li>Multiple choice questions</li>
                                    <li>Time limit: ${quiz.timeLimit} minutes</li>
                                    <li>Difficulty: ${quiz.difficulty}</li>
                                    <li>Category: ${category.name}</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h6>Completion Reward:</h6>
                                <ul>
                                    <li>Performance score</li>
                                    <li>Instant feedback</li>
                                    <li>Compare with others</li>
                                    <li>Track your progress</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                
                <c:if test="${userBestScore != null}">
                    <div class="card mb-4 border-primary">
                        <div class="card-header bg-primary text-white">
                            <h2 class="h5 mb-0">Your Best Performance</h2>
                        </div>
                        <div class="card-body">
                            <div class="row text-center">
                                <div class="col-md-4">
                                    <h3 class="h2 mb-0">${userBestScore.score}%</h3>
                                    <p class="text-muted">Score</p>
                                </div>
                                <div class="col-md-4">
                                    <h3 class="h2 mb-0">${userBestScore.completionTime} sec</h3>
                                    <p class="text-muted">Time</p>
                                </div>
                                <div class="col-md-4">
                                    <h3 class="h2 mb-0">${userBestScore.attemptDate}</h3>
                                    <p class="text-muted">Date</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
            
            <div class="col-lg-4">
                <div class="card mb-4">
                    <div class="card-header">
                        <h2 class="h5 mb-0">Top Scores</h2>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${topScores != null && !topScores.isEmpty()}">
                                <ul class="list-group list-group-flush">
                                    <c:forEach items="${topScores}" var="score" varStatus="status">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            <div>
                                                <span class="badge rounded-pill bg-primary me-2">${status.index + 1}</span>
                                                <span>${score.userName}</span>
                                            </div>
                                            <div>
                                                <span class="badge bg-success rounded-pill">${score.score}%</span>
                                                <small class="text-muted ms-2">${score.completionTime} sec</small>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <div class="p-4 text-center">
                                    <p class="text-muted">No scores recorded yet. Be the first to complete this quiz!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header">
                        <h2 class="h5 mb-0">Related Quizzes</h2>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${relatedQuizzes != null && !relatedQuizzes.isEmpty()}">
                                <div class="list-group list-group-flush">
                                    <c:forEach items="${relatedQuizzes}" var="relatedQuiz">
                                        <a href="${pageContext.request.contextPath}/quiz/${relatedQuiz.id}" 
                                           class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                            <div>
                                                ${relatedQuiz.title}
                                                <small class="d-block text-muted">${relatedQuiz.difficulty}</small>
                                            </div>
                                            <span class="badge bg-info rounded-pill">${relatedQuiz.questionCount} Qs</span>
                                        </a>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="p-4 text-center">
                                    <p class="text-muted">No related quizzes found.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h2 class="h5 mb-0">Share This Quiz</h2>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <button class="btn btn-outline-primary" onclick="copyQuizLink()">
                                <i class="bi bi-link-45deg"></i> Copy Quiz Link
                            </button>
                            <div class="d-flex justify-content-between">
                                <a href="#" class="btn btn-outline-primary flex-grow-1 me-2">
                                    <i class="bi bi-facebook"></i>
                                </a>
                                <a href="#" class="btn btn-outline-info flex-grow-1 me-2">
                                    <i class="bi bi-twitter"></i>
                                </a>
                                <a href="#" class="btn btn-outline-success flex-grow-1">
                                    <i class="bi bi-whatsapp"></i>
                                </a>
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
    <script>
        function copyQuizLink() {
            const url = window.location.href;
            navigator.clipboard.writeText(url)
                .then(() => {
                    alert('Quiz link copied to clipboard!');
                })
                .catch(err => {
                    console.error('Failed to copy: ', err);
                });
        }
    </script>
</body>
</html>