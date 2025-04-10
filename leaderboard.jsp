<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Leaderboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/navbar.jsp" />
    
    <div class="container mt-5">
        <h1 class="mb-4">Leaderboard</h1>
        
        <div class="row mb-4">
            <div class="col-md-6">
                <select class="form-select" id="categoryFilter">
                    <option value="">All Categories</option>
                    <c:forEach items="${categories}" var="category">
                        <option value="${category.id}" ${param.category eq category.id ? 'selected' : ''}>${category.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-6">
                <select class="form-select" id="timeFilter">
                    <option value="all">All Time</option>
                    <option value="month" ${param.time eq 'month' ? 'selected' : ''}>This Month</option>
                    <option value="week" ${param.time eq 'week' ? 'selected' : ''}>This Week</option>
                    <option value="day" ${param.time eq 'day' ? 'selected' : ''}>Today</option>
                </select>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Top Performers</h3>
            </div>
            <div class="card-body p-0">
                <table class="table table-striped table-hover mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>Rank</th>
                            <th>User</th>
                            <th>Quiz</th>
                            <th>Score</th>
                            <th>Percentage</th>
                            <th>Time</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${topScores}" var="score" varStatus="status">
                            <tr class="${score.user.username eq sessionScope.user.username ? 'table-primary' : ''}">
                                <td>${status.index + 1}</td>
                                <td>
                                    ${score.user.username}
                                    <c:if test="${score.user.username eq sessionScope.user.username}">
                                        <span class="badge bg-info">You</span>
                                    </c:if>
                                </td>
                                <td>${score.quiz.title}</td>
                                <td>${score.score}/${score.quiz.totalQuestions}</td>
                                <td>${score.percentage}%</td>
                                <td><fmt:formatNumber value="${score.completionTime / 60}" pattern="#" />:<fmt:formatNumber value="${score.completionTime % 60}" pattern="00" /></td>
                                <td><fmt:formatDate value="${score.dateTaken}" pattern="MMM dd, yyyy" /></td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty topScores}">
                            <tr>
                                <td colspan="7" class="text-center">No records found for the selected filters.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        
        <c:if test="${not empty userRank}">
            <div class="card mt-4">
                <div class="card-header bg-info text-white">
                    <h3 class="mb-0">Your Rank</h3>
                </div>
                <div class="card-body p-0">
                    <table class="table mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th>Rank</th>
                                <th>User</th>
                                <th>Total Score</th>
                                <th>Quizzes Taken</th>
                                <th>Average Score</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>#${userRank.rank}</td>
                                <td>${sessionScope.user.username}</td>
                                <td>${userRank.totalScore}</td>
                                <td>${userRank.quizzesTaken}</td>
                                <td>${userRank.averageScore}%</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
    </div>
    
    <jsp:include page="/WEB-INF/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Filter functionality
            const categoryFilter = document.getElementById('categoryFilter');
            const timeFilter = document.getElementById('timeFilter');
            
            categoryFilter.addEventListener('change', applyFilters);
            timeFilter.addEventListener('change', applyFilters);
            
            function applyFilters() {
                const category = categoryFilter.value;
                const time = timeFilter.value;
                
                let url = '${pageContext.request.contextPath}/leaderboard?';
                if (category) url += 'category=' + category + '&';
                if (time && time !== 'all') url += 'time=' + time;
                
                window.location.href = url;
            }
        });
    </script>
</body>
</html>