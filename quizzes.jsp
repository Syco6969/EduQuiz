<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Browse Quizzes</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/navbar.jsp" />
    
    <div class="container mt-5">
        <h1 class="mb-4">Browse Quizzes</h1>
        
        <div class="row mb-4">
            <div class="col-md-8">
                <div class="input-group">
                    <input type="text" class="form-control" id="searchQuiz" placeholder="Search quizzes..." value="${param.search}">
                    <button class="btn btn-primary" type="button" id="searchButton">Search</button>
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
        
        <div class="row mb-4">
            <div class="col-md-4">
                <select class="form-select" id="difficultyFilter">
                    <option value="">All Difficulties</option>
                    <option value="easy" ${param.difficulty eq 'easy' ? 'selected' : ''}>Easy</option>
                    <option value="medium" ${param.difficulty eq 'medium' ? 'selected' : ''}>Medium</option>
                    <option value="hard" ${param.difficulty eq 'hard' ? 'selected' : ''}>Hard</option>
                </select>
            </div>
            <div class="col-md-4">
                <select class="form-select" id="sortBy">
                    <option value="newest" ${param.sort eq 'newest' ? 'selected' : ''}>Newest First</option>
                    <option value="popular" ${param.sort eq 'popular' ? 'selected' : ''}>Most Popular</option>
                    <option value="difficulty" ${param.sort eq 'difficulty' ? 'selected' : ''}>By Difficulty</option>
                </select>
            </div>
        </div>
        
        <div class="row" id="quizList">
            <c:forEach items="${quizzes}" var="quiz">
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <div class="card-header ${quiz.difficulty eq 'Easy' ? 'bg-success' : quiz.difficulty eq 'Medium' ? 'bg-warning' : 'bg-danger'} text-white">
                            ${quiz.difficulty}
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">${quiz.title}</h5>
                            <p class="card-text">${quiz.description}</p>
                            <p class="small">Category: ${quiz.category.name} | Time: ${quiz.timeLimit} min</p>
                        </div>
                        <div class="card-footer d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/quiz/${quiz.id}" class="btn btn-primary">View Details</a>
                            <a href="${pageContext.request.contextPath}/take-quiz/${quiz.id}" class="btn btn-outline-success">
                                <i class="bi bi-play-fill"></i> Take Quiz
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty quizzes}">
                <div class="col-12">
                    <div class="alert alert-info">No quizzes found matching your criteria.</div>
                </div>
            </c:if>
        </div>
        
        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Quiz pagination">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/quizzes?page=${currentPage - 1}&category=${param.category}&difficulty=${param.difficulty}&search=${param.search}&sort=${param.sort}" tabindex="-1">Previous</a>
                    </li>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/quizzes?page=${i}&category=${param.category}&difficulty=${param.difficulty}&search=${param.search}&sort=${param.sort}">${i}</a>
                        </li>
                    </c:forEach>
                    
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/quizzes?page=${currentPage + 1}&category=${param.category}&difficulty=${param.difficulty}&search=${param.search}&sort=${param.sort}">Next</a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
    
    <jsp:include page="/WEB-INF/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Make entire card clickable for quiz details
            const quizCards = document.querySelectorAll('.card-body');
            quizCards.forEach(card => {
                card.addEventListener('click', function() {
                    const detailsLink = this.closest('.card').querySelector('a.btn-primary').href;
                    window.location.href = detailsLink;
                });
                card.style.cursor = 'pointer';
            });
            
            // Filter functionality
            const categoryFilter = document.getElementById('categoryFilter');
            const difficultyFilter = document.getElementById('difficultyFilter');
            const sortBy = document.getElementById('sortBy');
            const searchButton = document.getElementById('searchButton');
            const searchQuiz = document.getElementById('searchQuiz');
            
            categoryFilter.addEventListener('change', applyFilters);
            difficultyFilter.addEventListener('change', applyFilters);
            sortBy.addEventListener('change', applyFilters);
            searchButton.addEventListener('click', applyFilters);
            searchQuiz.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    applyFilters();
                }
            });
            
            function applyFilters() {
                const category = categoryFilter.value;
                const difficulty = difficultyFilter.value;
                const sort = sortBy.value;
                const search = searchQuiz.value;
                
                let url = '${pageContext.request.contextPath}/quizzes?page=1';
                if (category) url += '&category=' + category;
                if (difficulty) url += '&difficulty=' + difficulty;
                if (sort) url += '&sort=' + sort;
                if (search) url += '&search=' + encodeURIComponent(search);
                
                window.location.href = url;
            }
        });
    </script>
</body>
</html>