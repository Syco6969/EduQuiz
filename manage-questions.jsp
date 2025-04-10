<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Manage Questions</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
</head>
<body>
    <jsp:include page="/pages/components/navbar.jsp" />
    
    <div class="container-fluid mt-3">
        <div class="row">
            <!-- Sidebar (Same as dashboard) -->
            <div class="col-md-2 bg-dark text-white p-0 sidebar">
                <div class="d-flex flex-column p-3">
                    <h4 class="mb-3">Admin Panel</h4>
                    <ul class="nav nav-pills flex-column mb-auto">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link text-white">
                                <i class="bi bi-speedometer2 me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-quizzes" class="nav-link text-white">
                                <i class="bi bi-journal-text me-2"></i> Manage Quizzes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-questions" class="nav-link active" aria-current="page">
                                <i class="bi bi-question-circle me-2"></i> Manage Questions
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-users" class="nav-link text-white">
                                <i class="bi bi-people me-2"></i> Manage Users
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-categories" class="nav-link text-white">
                                <i class="bi bi-tags me-2"></i> Manage Categories
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/reports" class="nav-link text-white">
                                <i class="bi bi-graph-up me-2"></i> Reports
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 ms-auto px-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1>Manage Questions</h1>
                    <div>
                        <button class="btn btn-success me-2" data-bs-toggle="modal" data-bs-target="#importQuestionsModal">
                            <i class="bi bi-file-earmark-arrow-up me-2"></i> Import Questions
                        </button>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addQuestionModal">
                            <i class="bi bi-plus-circle me-2"></i> Add New Question
                        </button>
                    </div>
                </div>
                
                <!-- Filter and Search -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <select class="form-select" id="quizFilter">
                            <option value="">All Quizzes</option>
                            <c:forEach items="${quizzes}" var="quiz">
                                <option value="${quiz.id}" ${param.quizId eq quiz.id ? 'selected' : ''}>${quiz.title}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-8">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Search questions..." id="searchQuestion" value="${param.search}">
                            <button class="btn btn-outline-secondary" type="button" id="searchButton">
                                <i class="bi bi-search"></i> Search
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Questions Table -->
                <div class="card mb-4">
                    <div class="card-body p-0">
                        <table class="table table-striped table-hover align-middle mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Question</th>
                                    <th>Quiz</th>
                                    <th>Correct Answer</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${questions}" var="question">
                                    <tr>
                                        <td>${question.id}</td>
                                        <td>
                                            <div class="question-text">${question.questionText}</div>
                                        </td>
                                        <td>${question.quiz.title}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${question.correctAnswer eq 'A'}">A</c:when>
                                                <c:when test="${question.correctAnswer eq 'B'}">B</c:when>
                                                <c:when test="${question.correctAnswer eq 'C'}">C</c:when>
                                                <c:when test="${question.correctAnswer eq 'D'}">D</c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <button type="button" class="btn btn-sm btn-info view-question" 
                                                        data-id="${question.id}" 
                                                        data-text="${question.questionText}"
                                                        data-option-a="${question.optionA}"
                                                        data-option-b="${question.optionB}"
                                                        data-option-c="${question.optionC}"
                                                        data-option-d="${question.optionD}"
                                                        data-correct="${question.correctAnswer}">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button type="button" class="btn btn-sm btn-primary edit-question" 
                                                        data-id="${question.id}" 
                                                        data-quiz-id="${question.quiz.id}"
                                                        data-text="${question.questionText}"
                                                        data-option-a="${question.optionA}"
                                                        data-option-b="${question.optionB}"
                                                        data-option-c="${question.optionC}"
                                                        data-option-d="${question.optionD}"
                                                        data-correct="${question.correctAnswer}">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button type="button" class="btn btn-sm btn-danger delete-question" 
                                                        data-id="${question.id}" 
                                                        data-text="${question.questionText}">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${empty questions}">
                                    <tr>
                                        <td colspan="5" class="text-center">No questions found. Add your first question!</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Pagination -->
                <c:if test="${not empty questions}">
                    <nav aria-label="Question pagination">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-questions?page=${currentPage - 1}${not empty param.quizId ? '&quizId=' + param.quizId : ''}${not empty param.search ? '&search=' + param.search : ''}">Previous</a>
                            </li>
                            
                            <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                                <li class="page-item ${pageNumber == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-questions?page=${pageNumber}${not empty param.quizId ? '&quizId=' + param.quizId : ''}${not empty param.search ? '&search=' + param.search : ''}">${pageNumber}</a>
                                </li>
                            </c:forEach>
                            
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-questions?page=${currentPage + 1}${not empty param.quizId ? '&quizId=' + param.quizId : ''}${not empty param.search ? '&search=' + param.search : ''}">Next</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>
    
    <!-- Add Question Modal -->
    <div class="modal fade" id="addQuestionModal" tabindex="-1" aria-labelledby="addQuestionModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="addQuestionModalLabel">Add New Question</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/add-question" method="post" id="addQuestionForm">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="quizId" class="form-label">Select Quiz</label>
                            <select class="form-select" id="quizId" name="quizId" required>
                                <option value="">Select a Quiz</option>
                                <c:forEach items="${quizzes}" var="quiz">
                                    <option value="${quiz.id}" ${param.quizId eq quiz.id ? 'selected' : ''}>${quiz.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="questionText" class="form-label">Question</label>
                            <textarea class="form-control" id="questionText" name="questionText" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="optionA" class="form-label">Option A</label>
                            <input type="text" class="form-control" id="optionA" name="optionA" required>
                        </div>
                        <div class="mb-3">
                            <label for="optionB" class="form-label">Option B</label>
                            <input type="text" class="form-control" id="optionB" name="optionB" required>
                        </div>
                        <div class="mb-3">
                            <label for="optionC" class="form-label">Option C</label>
                            <input type="text" class="form-control" id="optionC" name="optionC" required>
                        </div>
                        <div class="mb-3">
                            <label for="optionD" class="form-label">Option D</label>
                            <input type="text" class="form-control" id="optionD" name="optionD" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Correct Answer</label>
                            <div class="d-flex">
                                <div class="form-check me-4">
                                    <input class="form-check-input" type="radio" name="correctAnswer" id="answerA" value="A" required>
                                    <label class="form-check-label" for="answerA">A</label>
                                </div>
                                <div class="form-check me-4">
                                    <input class="form-check-input" type="radio" name="correctAnswer" id="answerB" value="B">
                                    <label class="form-check-label" for="answerB">B</label>
                                </div>
                                <div class="form-check me-4">
                                    <input class="form-check-input" type="radio" name="correctAnswer" id="answerC" value="C">
                                    <label class="form-check-label" for="answerC">C</label>
                                </div>
                                <div class="form-check me-4">
                                    <input class="form-check-input" type="radio" name="correctAnswer" id="answerD" value="D">
                                    <label class="form-check-label" for="answerD">D</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Question</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit Question Modal -->
    <div class="modal fade" id="editQuestionModal" tabindex="-1" aria-labelledby="editQuestionModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="editQuestionModalLabel">Edit Question</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/update-question" method="post" id="editQuestionForm">
                    <input type="hidden" id="editQuestionId" name="id">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="editQuizId" class="form-label">Select Quiz</label>
                            <select class="form-select" id="editQuizId" name="quizId" required>
                                <option value="">Select a Quiz</option>
                                <c:forEach items="${quizzes}" var="quiz">
                                    <option value="${quiz.id}">${quiz.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="editQuestionText" class="form-label">Question</label>
                            <textarea class="form-control" id="editQuestionText" name="questionText" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="editOptionA" class="form-label">Option A</label>
                            <input type="text" class="form-control" id="editOptionA" name="optionA" required>
                        </div>
                        <div class="mb-3">
                            <label for="editOptionB" class="form-label">Option B</label>
                            <input type="text" class="form-control" id="editOptionB" name="optionB" required>
                        </div>
                        <div class="mb-3">
                            <label for="editOptionC" class="form-label">Option C</label>
                            <input type="text" class="form-control" id="editOptionC" name="optionC" required>
                        </div>
                        <div class="mb-3">
                            <label for="editOptionD" class="form-label">Option D</label>
                            <input type="text" class="form-control" id="editOptionD" name="optionD" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Correct Answer</label>
                            <div class="d-flex">
                                <div class="form-check me-4">
                                    <input class="form-check-input" type="radio" name="editCorrectAnswer" id="editAnswerA" value="A" required>
                                    <label class="form-check-label" for="editAnswerA">A</label>
                                </div>
                                <div class="form-check me-4">
                                    <input class="form-check-input" type="radio" name="editCorrectAnswer" id="editAnswerB" value="B">
                                    <label class="form-check-label" for="editAnswerB">B</label>
                                </div>
                                <div class="form-check me-4">
                                    <input class="form-check-input" type="radio" name="editCorrectAnswer" id="editAnswerC" value="C">
                                    <label class="form-check-label" for="editAnswerC">C</label>
                                </div>
                                <div class="form-check me-4">
                                    <input class="form-check-input" type="radio" name="editCorrectAnswer" id="editAnswerD" value="D">
                                    <label class="form-check-label" for="editAnswerD">D</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Question</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- View Question Modal -->
    <div class="modal fade" id="viewQuestionModal" tabindex="-1" aria-labelledby="viewQuestionModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title" id="viewQuestionModalLabel">Question Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <h5 id="viewQuestionText" class="mb-4"></h5>
                    <div class="mb-3">
                        <div class="card mb-2" id="viewOptionACard">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="me-3 fw-bold">A.</div>
                                    <div id="viewOptionA"></div>
                                </div>
                            </div>
                        </div>
                        <div class="card mb-2" id="viewOptionBCard">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="me-3 fw-bold">B.</div>
                                    <div id="viewOptionB"></div>
                                </div>
                            </div>
                        </div>
                        <div class="card mb-2" id="viewOptionCCard">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="me-3 fw-bold">C.</div>
                                    <div id="viewOptionC"></div>
                                </div>
                            </div>
                        </div>
                        <div class="card mb-2" id="viewOptionDCard">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="me-3 fw-bold">D.</div>
                                    <div id="viewOptionD"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Question Modal -->
    <div class="modal fade" id="deleteQuestionModal" tabindex="-1" aria-labelledby="deleteQuestionModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteQuestionModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this question?</p>
                    <p id="deleteQuestionPreview" class="border-start border-danger border-4 ps-3 text-muted"></p>
                    <p class="text-danger mt-3"><strong>Warning:</strong> This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteQuestionForm" action="${pageContext.request.contextPath}/admin/delete-question" method="post">
                        <input type="hidden" id="deleteQuestionId" name="id">
                        <button type="submit" class="btn btn-danger">Delete Question</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Import Questions Modal -->
    <div class="modal fade" id="importQuestionsModal" tabindex="-1" aria-labelledby="importQuestionsModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="importQuestionsModalLabel">Import Questions</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/import-questions" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="importQuizId" class="form-label">Select Quiz</label>
                            <select class="form-select" id="importQuizId" name="quizId" required>
                                <option value="">Select a Quiz</option>
                                <c:forEach items="${quizzes}" var="quiz">
                                    <option value="${quiz.id}">${quiz.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="importFile" class="form-label">CSV File</label>
                            <input type="file" class="form-control" id="importFile" name="importFile" accept=".csv" required>
                            <div class="form-text">Upload a CSV file with columns: question,optionA,optionB,optionC,optionD,correctAnswer</div>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="hasHeader" name="hasHeader" checked>
                                <label class="form-check-label" for="hasHeader">
                                    File has header row
                                </label>
                            </div>
                        </div>
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle-fill me-2"></i> 
                            You can download a <a href="${pageContext.request.contextPath}/resources/templates/questions_template.csv" class="alert-link">sample template</a> to see the required format.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Import Questions</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <jsp:include page="/pages/components/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Quiz filter
            const quizFilter = document.getElementById('quizFilter');
            quizFilter.addEventListener('change', function() {
                const quizId = this.value;
                let url = '${pageContext.request.contextPath}/admin/manage-questions';
                
                if (quizId) {
                    url += '?quizId=' + quizId;
                }
                
                window.location.href = url;
            });
            
            // Question search
            const searchButton = document.getElementById('searchButton');
            const searchInput = document.getElementById('searchQuestion');
            
            searchButton.addEventListener('click', function() {
                const searchTerm = searchInput.value.trim();
                let url = '${pageContext.request.contextPath}/admin/manage-questions';
                const params = new URLSearchParams();
                
                if (searchTerm) {
                    params.append('search', searchTerm);
                }
                
                const quizId = quizFilter.value;
                if (quizId) {
                    params.append('quizId', quizId);
                }
                
                if (params.toString()) {
                    url += '?' + params.toString();
                }
                
                window.location.href = url;
            });
            
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchButton.click();
                }
            });
            
            // View question
            const viewButtons = document.querySelectorAll('.view-question');
            viewButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const questionText = this.getAttribute('data-text');
                    const optionA = this.getAttribute('data-option-a');
                    const optionB = this.getAttribute('data-option-b');
                    const optionC = this.getAttribute('data-option-c');
                    const optionD = this.getAttribute('data-option-d');
                    const correctAnswer = this.getAttribute('data-correct');
                    
                    document.getElementById('viewQuestionText').textContent = questionText;
                    document.getElementById('viewOptionA').textContent = optionA;
                    document.getElementById('viewOptionB').textContent = optionB;
                    document.getElementById('viewOptionC').textContent = optionC;
                    document.getElementById('viewOptionD').textContent = optionD;
                    
                    // Reset all card styles
                    document.getElementById('viewOptionACard').className = 'card mb-2';
                    document.getElementById('viewOptionBCard').className = 'card mb-2';
                    document.getElementById('viewOptionCCard').className = 'card mb-2';
                    document.getElementById('viewOptionDCard').className = 'card mb-2';
                    
                    // Highlight correct answer
                    if (correctAnswer === 'A') {
                        document.getElementById('viewOptionACard').className = 'card mb-2 border-success bg-success bg-opacity-10';
                    } else if (correctAnswer === 'B') {
                        document.getElementById('viewOptionBCard').className = 'card mb-2 border-success bg-success bg-opacity-10';
                    } else if (correctAnswer === 'C') {
                        document.getElementById('viewOptionCCard').className = 'card mb-2 border-success bg-success bg-opacity-10';
                    } else if (correctAnswer === 'D') {
                        document.getElementById('viewOptionDCard').className = 'card mb-2 border-success bg-success bg-opacity-10';
                    }
                    
                    const viewModal = new bootstrap.Modal(document.getElementById('viewQuestionModal'));
                    viewModal.show();
                });
            });
            
            // Edit question
            const editButtons = document.querySelectorAll('.edit-question');
            editButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const questionId = this.getAttribute('data-id');
                    const quizId = this.getAttribute('data-quiz-id');
                    const questionText = this.getAttribute('data-text');
                    const optionA = this.getAttribute('data-option-a');
                    const optionB = this.getAttribute('data-option-b');
                    const optionC = this.getAttribute('data-option-c');
                    const optionD = this.getAttribute('data-option-d');
                    const correctAnswer = this.getAttribute('data-correct');
                    
                    document.getElementById('editQuestionId').value = questionId;
                    document.getElementById('editQuizId').value = quizId;
                    document.getElementById('editQuestionText').value = questionText;
                    document.getElementById('editOptionA').value = optionA;
                    document.getElementById('editOptionB').value = optionB;
                    document.getElementById('editOptionC').value = optionC;
                    document.getElementById('editOptionD').value = optionD;
                    
                 // Set the correct answer radio button
                    document.querySelector(`#editAnswer${correctAnswer}`).checked = true;
                    
                    const editModal = new bootstrap.Modal(document.getElementById('editQuestionModal'));
                    editModal.show();
                });
            });
            
            // Delete question
            const deleteButtons = document.querySelectorAll('.delete-question');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const questionId = this.getAttribute('data-id');
                    const questionText = this.getAttribute('data-text');
                    
                    document.getElementById('deleteQuestionId').value = questionId;
                    document.getElementById('deleteQuestionPreview').textContent = questionText;
                    
                    const deleteModal = new bootstrap.Modal(document.getElementById('deleteQuestionModal'));
                    deleteModal.show();
                });
            });
            
            // Form validations
            document.getElementById('addQuestionForm').addEventListener('submit', function(e) {
                validateQuestionForm(e, this);
            });
            
            document.getElementById('editQuestionForm').addEventListener('submit', function(e) {
                validateQuestionForm(e, this);
            });
            
            function validateQuestionForm(e, form) {
                const questionText = form.querySelector('[name="questionText"]').value.trim();
                const optionA = form.querySelector('[name="optionA"]').value.trim();
                const optionB = form.querySelector('[name="optionB"]').value.trim();
                const optionC = form.querySelector('[name="optionC"]').value.trim();
                const optionD = form.querySelector('[name="optionD"]').value.trim();
                
                if (questionText.length < 5) {
                    e.preventDefault();
                    alert('Question text must be at least 5 characters long.');
                    return false;
                }
                
                if (optionA.length < 1 || optionB.length < 1 || optionC.length < 1 || optionD.length < 1) {
                    e.preventDefault();
                    alert('All options must be filled out.');
                    return false;
                }
                
                // Check for duplicate options
                const options = [optionA, optionB, optionC, optionD];
                const uniqueOptions = [...new Set(options)];
                if (uniqueOptions.length !== options.length) {
                    e.preventDefault();
                    alert('All options must be unique.');
                    return false;
                }
                
                return true;
            }
            
            // Show notification if there is a message
            const urlParams = new URLSearchParams(window.location.search);
            const message = urlParams.get('message');
            const status = urlParams.get('status');
            
            if (message) {
                const alertDiv = document.createElement('div');
                alertDiv.className = `alert alert-${status || 'info'} alert-dismissible fade show`;
                alertDiv.role = 'alert';
                alertDiv.innerHTML = `
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                `;
                
                document.querySelector('.col-md-10').insertAdjacentElement('afterbegin', alertDiv);
                
                // Auto dismiss after 5 seconds
                setTimeout(() => {
                    const bsAlert = new bootstrap.Alert(alertDiv);
                    bsAlert.close();
                }, 5000);
            }
        });
    </script>
</body>
</html>