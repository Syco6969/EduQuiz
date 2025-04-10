<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Manage Quizzes</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
</head>
<body>
    <jsp:include page="/WEB-INF/navbar.jsp" />
    
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
                            <a href="${pageContext.request.contextPath}/admin/manage-quizzes" class="nav-link active" aria-current="page">
                                <i class="bi bi-journal-text me-2"></i> Manage Quizzes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-questions" class="nav-link text-white">
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
                    <h1>Manage Quizzes</h1>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addQuizModal">
                        <i class="bi bi-plus-circle me-2"></i> Add New Quiz
                    </button>
                </div>
                
                <!-- Search and Filter -->
                <div class="row mb-4">
                    <div class="col-md-8">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Search quizzes..." id="searchQuiz">
                            <button class="btn btn-outline-secondary" type="button" id="searchButton">
                                <i class="bi bi-search"></i> Search
                            </button>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <select class="form-select" id="categoryFilter">
                            <option value="">All Categories</option>
                            <c:forEach items="${categories}" var="category">
                                <option value="${category.id}" ${param.category eq category.id ? 'selected' : ''}>${category.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                
                <!-- Quizzes Table -->
                <div class="card mb-4">
                    <div class="card-body p-0">
                        <table class="table table-striped table-hover align-middle mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Title</th>
                                    <th>Category</th>
                                    <th>Difficulty</th>
                                    <th>Questions</th>
                                    <th>Time Limit</th>
                                    <th>Times Taken</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${quizzes}" var="quiz">
                                    <tr>
                                        <td>${quiz.id}</td>
                                        <td>${quiz.title}</td>
                                        <td>${quiz.category.name}</td>
                                        <td>
                                            <span class="badge bg-${quiz.difficulty eq 'EASY' ? 'success' : quiz.difficulty eq 'MEDIUM' ? 'warning' : 'danger'}">
                                                ${quiz.difficulty}
                                            </span>
                                        </td>
                                        <td>${quiz.totalQuestions}</td>
                                        <td>${quiz.timeLimit} min</td>
                                        <td>${quiz.timesTaken}</td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/admin/edit-quiz?id=${quiz.id}" class="btn btn-sm btn-primary">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/view-questions?quizId=${quiz.id}" class="btn btn-sm btn-info">
                                                    <i class="bi bi-list-check"></i>
                                                </a>
                                                <button type="button" class="btn btn-sm btn-danger delete-quiz" data-id="${quiz.id}" data-title="${quiz.title}">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${empty quizzes}">
                                    <tr>
                                        <td colspan="8" class="text-center">No quizzes found. Create your first quiz!</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Pagination -->
                <c:if test="${not empty quizzes}">
                    <nav aria-label="Quiz pagination">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-quizzes?page=${currentPage - 1}${not empty param.category ? '&category=' + param.category : ''}">Previous</a>
                            </li>
                            
                            <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                                <li class="page-item ${pageNumber == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-quizzes?page=${pageNumber}${not empty param.category ? '&category=' + param.category : ''}">${pageNumber}</a>
                                </li>
                            </c:forEach>
                            
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-quizzes?page=${currentPage + 1}${not empty param.category ? '&category=' + param.category : ''}">Next</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>
    
    <!-- Add Quiz Modal -->
    <div class="modal fade" id="addQuizModal" tabindex="-1" aria-labelledby="addQuizModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="addQuizModalLabel">Add New Quiz</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/add-quiz" method="post" id="addQuizForm">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="title" class="form-label">Quiz Title</label>
                            <input type="text" class="form-control" id="title" name="title" required>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="category" class="form-label">Category</label>
                                <select class="form-select" id="category" name="categoryId" required>
                                    <option value="">Select Category</option>
                                    <c:forEach items="${categories}" var="category">
                                        <option value="${category.id}">${category.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="difficulty" class="form-label">Difficulty</label>
                                <select class="form-select" id="difficulty" name="difficulty" required>
                                    <option value="EASY">Easy</option>
                                    <option value="MEDIUM">Medium</option>
                                    <option value="HARD">Hard</option>
                                </select>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="timeLimit" class="form-label">Time Limit (minutes)</label>
                                <input type="number" class="form-control" id="timeLimit" name="timeLimit" min="1" value="10" required>
                            </div>
                            <div class="col-md-6">
                                <label for="passingScore" class="form-label">Passing Score (%)</label>
                                <input type="number" class="form-control" id="passingScore" name="passingScore" min="1" max="100" value="70" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="isPublished" name="isPublished" checked>
                                <label class="form-check-label" for="isPublished">
                                    Publish immediately
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Quiz</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteQuizModal" tabindex="-1" aria-labelledby="deleteQuizModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteQuizModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the quiz "<span id="quizTitle"></span>"?</p>
                    <p class="text-danger"><strong>Warning:</strong> This action cannot be undone and will delete all associated questions and scores.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteQuizForm" action="${pageContext.request.contextPath}/admin/delete-quiz" method="post">
                        <input type="hidden" id="deleteQuizId" name="id">
                        <button type="submit" class="btn btn-danger">Delete Quiz</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Delete quiz confirmation
            const deleteButtons = document.querySelectorAll('.delete-quiz');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const quizId = this.getAttribute('data-id');
                    const quizTitle = this.getAttribute('data-title');
                    
                    document.getElementById('quizTitle').textContent = quizTitle;
                    document.getElementById('deleteQuizId').value = quizId;
                    
                    const deleteModal = new bootstrap.Modal(document.getElementById('deleteQuizModal'));
                    deleteModal.show();
                });
            });
            
            // Category filter
            const categoryFilter = document.getElementById('categoryFilter');
            categoryFilter.addEventListener('change', function() {
                const category = this.value;
                let url = '${pageContext.request.contextPath}/admin/manage-quizzes';
                
                if (category) {
                    url += '?category=' + category;
                }
                
                window.location.href = url;
            });
            
            // Quiz search
            const searchButton = document.getElementById('searchButton');
            const searchInput = document.getElementById('searchQuiz');
            
            searchButton.addEventListener('click', function() {
                const searchTerm = searchInput.value.trim();
                let url = '${pageContext.request.contextPath}/admin/manage-quizzes';
                
                if (searchTerm) {
                    url += '?search=' + encodeURIComponent(searchTerm);
                    
                    const category = categoryFilter.value;
                    if (category) {
                        url += '&category=' + category;
                    }
                } else if (categoryFilter.value) {
                    url += '?category=' + categoryFilter.value;
                }
                
                window.location.href = url;
            });
            
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchButton.click();
                }
            });
        });
    </script>
</body>
</html>