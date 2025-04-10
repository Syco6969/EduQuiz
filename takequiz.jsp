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
    <jsp:include page="/pages/components/navbar.jsp" />
    
    <div class="container mt-5">
        <div class="quiz-header">
            <h1>${quiz.title}</h1>
            <p class="lead">${quiz.description}</p>
            <div class="d-flex justify-content-between align-items-center">
                <div class="quiz-meta">
                    <span class="badge ${quiz.difficulty eq 'Easy' ? 'bg-success' : quiz.difficulty eq 'Medium' ? 'bg-warning' : 'bg-danger'}">${quiz.difficulty}</span>
                    <span class="badge bg-info">${quiz.category.name}</span>
                    <span id="timeLimit" data-minutes="${quiz.timeLimit}">Time: ${quiz.timeLimit} min</span>
                </div>
                <div class="quiz-timer">
                    <div class="progress" style="width: 200px;">
                        <div id="timer-progress" class="progress-bar" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <div id="timer" class="ms-2">--:--</div>
                </div>
            </div>
        </div>
        
        <form id="quizForm" action="${pageContext.request.contextPath}/submit-quiz" method="post">
            <input type="hidden" name="quizId" value="${quiz.id}">
            <input type="hidden" id="timeSpent" name="timeSpent" value="0">
            
            <div class="questions-container mt-4">
                <c:forEach items="${questions}" var="question" varStatus="status">
                    <div class="card mb-4 question-card ${status.index == 0 ? 'active' : ''}" id="question-${status.index}">
                        <div class="card-header">
                            <h5>Question ${status.index + 1} of ${questions.size()}</h5>
                        </div>
                        <div class="card-body">
                            <p class="question-text">${question.questionText}</p>
                            <input type="hidden" name="question-${status.index}" value="${question.id}">
                            
                            <div class="options">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="answer-${question.id}" id="option-${question.id}-A" value="A" required>
                                    <label class="form-check-label" for="option-${question.id}-A">${question.optionA}</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="answer-${question.id}" id="option-${question.id}-B" value="B">
                                    <label class="form-check-label" for="option-${question.id}-B">${question.optionB}</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="answer-${question.id}" id="option-${question.id}-C" value="C">
                                    <label class="form-check-label" for="option-${question.id}-C">${question.optionC}</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="answer-${question.id}" id="option-${question.id}-D" value="D">
                                    <label class="form-check-label" for="option-${question.id}-D">${question.optionD}</label>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer d-flex justify-content-between">
                            <button type="button" class="btn btn-secondary prev-btn" ${status.index == 0 ? 'disabled' : ''}>Previous</button>
                            <c:choose>
                                <c:when test="${status.index == questions.size() - 1}">
                                    <button type="button" class="btn btn-success submit-btn">Submit Quiz</button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="btn btn-primary next-btn">Next</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <div class="question-nav mt-4 mb-5">
                <div class="row">
                    <c:forEach begin="0" end="${questions.size() - 1}" var="i">
                        <div class="col-1 mb-2">
                            <button type="button" class="btn btn-outline-primary question-nav-btn" data-index="${i}">${i + 1}</button>
                        </div>
                    </c:forEach>
                </div>
            </div>
            
            <!-- Submit confirmation modal -->
            <div class="modal fade" id="submitModal" tabindex="-1" aria-labelledby="submitModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="submitModalLabel">Submit Quiz</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to submit your quiz?</p>
                            <div id="unanswered-warning" class="alert alert-warning d-none">
                                <span id="unanswered-count"></span> questions are still unanswered.
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="button" class="btn btn-primary" id="confirm-submit">Yes, Submit</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
    
    <jsp:include page="/pages/components/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/quiz.js"></script>
</body>
</html></html>