<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Quiz History</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body class="bg-light">
    <!-- Navigation bar -->
    <jsp:include page="../includes/navbar.jsp" />
    
    <div class="container py-5">
        <div class="row mb-4">
            <div class="col-md-8">
                <h1 class="mb-2">My Quiz History</h1>
                <p class="text-secondary">Review your past quiz attempts and track your progress over time.</p>
            </div>
            <div class="col-md-4 text-md-end">
                <a href="${pageContext.request.contextPath}/quizzes" class="btn btn-primary">
                    <i class="bi bi-journals"></i> Browse Quizzes
                </a>
            </div>
        </div>
        
        <!-- Filter controls -->
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/history" method="get" id="filterForm">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label for="categoryFilter" class="form-label">Category</label>
                            <select class="form-select" id="categoryFilter" name="category">
                                <option value="">All Categories</option>
                                <c:forEach items="${categories}" var="category">
                                    <option value="${category.id}" ${param.category == category.id ? 'selected' : ''}>
                                        ${category.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="difficultyFilter" class="form-label">Difficulty</label>
                            <select class="form-select" id="difficultyFilter" name="difficulty">
                                <option value="">All Difficulties</option>
                                <option value="easy" ${param.difficulty == 'easy' ? 'selected' : ''}>Easy</option>
                                <option value="medium" ${param.difficulty == 'medium' ? 'selected' : ''}>Medium</option>
                                <option value="hard" ${param.difficulty == 'hard' ? 'selected' : ''}>Hard</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="dateFilter" class="form-label">Date Range</label>
                            <select class="form-select" id="dateFilter" name="dateRange">
                                <option value="">All Time</option>
                                <option value="7" ${param.dateRange == '7' ? 'selected' : ''}>Last 7 Days</option>
                                <option value="30" ${param.dateRange == '30' ? 'selected' : ''}>Last 30 Days</option>
                                <option value="90" ${param.dateRange == '90' ? 'selected' : ''}>Last 3 Months</option>
                                <option value="365" ${param.dateRange == '365' ? 'selected' : ''}>Last Year</option>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary me-2">
                                <i class="bi bi-funnel"></i> Filter
                            </button>
                            <button type="button" id="resetFilters" class="btn btn-outline-secondary">
                                <i class="bi bi-x-circle"></i> Reset
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Stats summary -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-primary text-white shadow-sm h-100">
                    <div class="card-body">
                        <h6 class="text-white-50">Total Quizzes</h6>
                        <h2 class="mb-0">${totalQuizzes}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white shadow-sm h-100">
                    <div class="card-body">
                        <h6 class="text-white-50">Average Score</h6>
                        <h2 class="mb-0">${averageScore}%</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white shadow-sm h-100">
                    <div class="card-body">
                        <h6 class="text-white-50">Best Score</h6>
                        <h2 class="mb-0">${bestScore}%</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-dark shadow-sm h-100">
                    <div class="card-body">
                        <h6 class="text-dark-50">Recent Trend</h6>
                        <h2 class="mb-0">
                            <c:choose>
                                <c:when test="${scoreTrend > 0}">
                                    <i class="bi bi-arrow-up-circle-fill"></i> ${scoreTrend}%
                                </c:when>
                                <c:when test="${scoreTrend < 0}">
                                    <i class="bi bi-arrow-down-circle-fill"></i> ${Math.abs(scoreTrend)}%
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-dash-circle-fill"></i> 0%
                                </c:otherwise>
                            </c:choose>
                        </h2>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- History table -->
        <div class="card shadow-sm">
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty quizHistory}">
                        <div class="text-center py-5">
                            <i class="bi bi-journals text-secondary" style="font-size: 3rem;"></i>
                            <h3 class="mt-3">No quiz history found</h3>
                            <p class="text-secondary mb-4">You haven't taken any quizzes yet or none match your current filters.</p>
                            <a href="${pageContext.request.contextPath}/quizzes" class="btn btn-primary">
                                <i class="bi bi-play-circle me-2"></i> Take a Quiz Now
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th scope="col">Quiz</th>
                                        <th scope="col">Category</th>
                                        <th scope="col">Difficulty</th>
                                        <th scope="col">Score</th>
                                        <th scope="col">Completion Time</th>
                                        <th scope="col">Date Taken</th>
                                        <th scope="col">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${quizHistory}" var="history">
                                        <tr>
                                            <td>
                                                <div class="fw-bold">${history.quiz.title}</div>
                                                <small class="text-secondary">${history.quiz.description}</small>
                                            </td>
                                            <td>${history.quiz.category.name}</td>
                                            <td>
                                                <span class="badge rounded-pill
                                                    ${history.quiz.difficulty == 'easy' ? 'bg-success' : 
                                                     history.quiz.difficulty == 'medium' ? 'bg-warning text-dark' : 'bg-danger'}">
                                                    ${history.quiz.difficulty}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                                        <div class="progress-bar
                                                            ${history.score >= 80 ? 'bg-success' : 
                                                             history.score >= 60 ? 'bg-warning' : 'bg-danger'}" 
                                                            style="width: ${history.score}%">
                                                        </div>
                                                    </div>
                                                    <span class="fw-bold">${history.score}%</span>
                                                </div>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${history.completionTime / 60}" maxFractionDigits="0" var="minutes" />
                                                <fmt:formatNumber value="${history.completionTime % 60}" minIntegerDigits="2" var="seconds" />
                                                ${minutes}:${seconds}
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${history.dateTaken}" pattern="MMM d, yyyy h:mm a" />
                                            </td>
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <a href="${pageContext.request.contextPath}/quiz-result?id=${history.id}" 
                                                       class="btn btn-sm btn-outline-primary" title="View Results">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/take-quiz?id=${history.quiz.id}" 
                                                       class="btn btn-sm btn-outline-success" title="Retake Quiz">
                                                        <i class="bi bi-arrow-repeat"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <nav aria-label="Quiz history pagination" class="mt-4">
                                <ul class="pagination justify-content-center">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/history?page=${currentPage - 1}${filterParams}">
                                            <i class="bi bi-chevron-left"></i>
                                        </a>
                                    </li>
                                    
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <li class="page-item active">
                                                    <span class="page-link">${i}</span>
                                                </li>
                                            </c:when>
                                            <c:otherwise>
                                                <li class="page-item">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/history?page=${i}${filterParams}">${i}</a>
                                                </li>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/history?page=${currentPage + 1}${filterParams}">
                                            <i class="bi bi-chevron-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <jsp:include page="../includes/footer.jsp" />
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Chart.js for statistics (optional enhancement) -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Handle reset filters button
            document.getElementById('resetFilters').addEventListener('click', function() {
                document.getElementById('categoryFilter').value = '';
                document.getElementById('difficultyFilter').value = '';
                document.getElementById('dateFilter').value = '';
                document.getElementById('filterForm').submit();
            });
            
            // Add any additional JavaScript functionality here
            // For example, creating charts with Chart.js if needed
        });
    </script>
</body>
</html>