<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Quiz Results</title>
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
                        <h3 class="mb-0">Quiz Results</h3>
                    </div>
                    <div class="card-body">
                        <h4 class="card-title">${quiz.title}</h4>
                        <p class="card-text">${quiz.description}</p>
                        
                        <div class="result-summary my-4 text-center">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="result-item p-3 rounded bg-light">
                                        <h5>Score</h5>
                                        <h2 class="${score.percentage >= 70 ? 'text-success' : score.percentage >= 50 ? 'text-warning' : 'text-danger'}">${score.score}/${score.totalQuestions}</h2>
                                        <p>${score.percentage}%</p>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="result-item p-3 rounded bg-light">
                                        <h5>Time Taken</h5>
                                        <h2><fmt:formatNumber value="${score.completionTime / 60}" pattern="#" />:<fmt:formatNumber value="${score.completionTime % 60}" pattern="00" /></h2>
                                        <p>minutes</p>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="result-item p-3 rounded bg-light">
                                        <h5>Result</h5>
                                        <h2 class="${score.percentage >= 70 ? 'text-success' : 'text-danger'}">
                                            ${score.percentage >= 70 ? 'PASSED' : 'FAILED'}
                                        </h2>
                                        <p>Pass mark: 70%</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="question-review mt-5">
                            <h4 class="mb-4">Question Review</h4>
                            
                            <c:forEach items="${reviewQuestions}" var="question" varStatus="status">
                                <div class="card mb-3 ${question.correct ? 'border-success' : 'border-danger'}">
                                    <div class="card-header ${question.correct ? 'bg-success' : 'bg-danger'} text-white">
                                        Question ${status.index + 1} - ${question.correct ? 'Correct' : 'Incorrect'}
                                    </div>
                                    <div class="card-body">
                                        <p class="card-text">${question.questionText}</p>
                                        
                                        <div class="options">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" disabled 
                                                    ${question.userAnswer eq 'A' ? 'checked' : ''}>
                                                <label class="form-check-label ${question.correctAnswer eq 'A' ? 'text-success fw-bold' : ''}">
                                                    A. ${question.optionA}
                                                    ${question.correctAnswer eq 'A' ? '(Correct Answer)' : ''}
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" disabled 
                                                    ${question.userAnswer eq 'B' ? 'checked' : ''}>
                                                <label class="form-check-label ${question.correctAnswer eq 'B' ? 'text-success fw-bold' : ''}">
                                                    B. ${question.optionB}
                                                    ${question.correctAnswer eq 'B' ? '(Correct Answer)' : ''}
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" disabled 
                                                    ${question.userAnswer eq 'C' ? 'checked' : ''}>
                                                <label class="form-check-label ${question.correctAnswer eq 'C' ? 'text-success fw-bold' : ''}">
                                                    C. ${question.optionC}
                                                    ${question.correctAnswer eq 'C' ? '(Correct Answer)' : ''}
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" disabled 
                                                    ${question.userAnswer eq 'D' ? 'checked' : ''}>
                                                <label class="form-check-label ${question.correctAnswer eq 'D' ? 'text-success fw-bold' : ''}">
                                                    D. ${question.optionD}
                                                    ${question.correctAnswer eq 'D' ? '(Correct Answer)' : ''}
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <c:if test="${not empty question.explanation}">
                                            <div class="explanation mt-3 p-2 bg-light">
                                                <strong>Explanation:</strong> ${question.explanation}
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="card-footer text-center">
                        <a href="${pageContext.request.contextPath}/quizzes" class="btn btn-primary me-2">Browse More Quizzes</a>
                        <a href="${pageContext.request.contextPath}/history" class="btn btn-secondary">View Your History</a>
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