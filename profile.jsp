<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - My Profile</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
    <jsp:include page="/WEB-INF/navbar.jsp" />
    
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Profile Information</h4>
                    </div>
                    <div class="card-body">
                        <!-- In Profile.jsp, update the profile image display in the card -->
<div class="text-center mb-4">
    <div class="profile-image mx-auto mb-3" style="width: 100px; height: 100px; overflow: hidden; border-radius: 50%;">
        <c:choose>
            <c:when test="${not empty sessionScope.user.profileImage}">
                <img src="${pageContext.request.contextPath}/uploads/${sessionScope.user.profileImage}" alt="Profile" class="img-fluid" style="width: 100%; height: 100%; object-fit: cover;">
            </c:when>
            <c:otherwise>
                <div class="profile-image bg-light rounded-circle mx-auto d-flex justify-content-center align-items-center" style="width: 100px; height: 100px;">
                    <span class="display-4">${fn:toUpperCase(fn:substring(sessionScope.user.username, 0, 1))}</span>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <h3 class="mt-3">${sessionScope.user.username}</h3>
    <p class="text-muted">${sessionScope.user.email}</p>
    <p>
        <span class="badge bg-info">${sessionScope.user.role}</span>
        <span class="badge bg-success">Member since: <fmt:formatDate value="${sessionScope.user.createdAt}" pattern="MMM yyyy" /></span>
    </p>
</div>
                        
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                Total Quizzes Taken
                                <span class="badge bg-primary rounded-pill">${userStats.quizzesTaken}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                Average Score
                                <span class="badge bg-success rounded-pill">${userStats.averageScore}%</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                Highest Score
                                <span class="badge bg-warning rounded-pill">${userStats.highestScore}%</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                Favorite Category
                                <span class="badge bg-info rounded-pill">${userStats.favoriteCategory}</span>
                            </li>
                        </ul>
                    </div>
                    <div class="card-footer text-center">
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#editProfileModal">Edit Profile</button>
                    </div>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Achievements</h4>
                    </div>
                    <div class="card-body">
                        <c:if test="${empty achievements}">
                            <p class="text-center">No achievements yet. Start taking quizzes to earn badges!</p>
                        </c:if>
                        
                        <c:forEach items="${achievements}" var="achievement">
                            <div class="achievement-item d-flex align-items-center mb-3">
                                <div class="badge-icon me-3 ${achievement.unlocked ? '' : 'opacity-50'}">
                                    <i class="${achievement.icon} fs-1"></i>
                                </div>
                                <div>
                                    <h5 class="mb-1 ${achievement.unlocked ? '' : 'text-muted'}">${achievement.name}</h5>
                                    <p class="small mb-0 ${achievement.unlocked ? '' : 'text-muted'}">${achievement.description}</p>
                                    <c:if test="${not achievement.unlocked}">
                                        <p class="small text-info mb-0">Progress: ${achievement.progress}%</p>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
            
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Performance Overview</h4>
                    </div>
                    <div class="card-body">
                        <canvas id="performanceChart" height="250"></canvas>
                    </div>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">Recent Quiz Results</h4>
                        <a href="${pageContext.request.contextPath}/history" class="btn btn-light btn-sm">View All</a>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-striped table-hover mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th>Quiz</th>
                                    <th>Score</th>
                                    <th>Time</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentResults}" var="result">
                                    <tr>
                                        <td>${result.quiz.title}</td>
                                        <td>
                                            <span class="${result.percentage >= 70 ? 'text-success' : result.percentage >= 50 ? 'text-warning' : 'text-danger'}">
                                                ${result.score}/${result.quiz.totalQuestions} (${result.percentage}%)
                                            </span>
                                        </td>
                                        <td><fmt:formatNumber value="${result.completionTime / 60}" pattern="#" />:<fmt:formatNumber value="${result.completionTime % 60}" pattern="00" /></td>
                                        <td><fmt:formatDate value="${result.dateTaken}" pattern="MMM dd, yyyy HH:mm" /></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/quiz-result?id=${result.id}" class="btn btn-sm btn-info">Review</a>
                                            <a href="${pageContext.request.contextPath}/quiz?id=${result.quiz.id}" class="btn btn-sm btn-primary">Retake</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${empty recentResults}">
                                    <tr>
                                        <td colspan="5" class="text-center">No quiz results found. Start taking quizzes!</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Category Performance</h4>
                    </div>
                    <div class="card-body">
                        <canvas id="categoryChart" height="250"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- In Profile.jsp, update the Edit Profile Modal -->
<div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="editProfileModalLabel">Edit Profile</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/updateProfile" method="post" id="editProfileForm" enctype="multipart/form-data">
                <div class="modal-body">
                    <div class="mb-3 text-center">
                        <div class="profile-image-preview mb-3 mx-auto" style="width: 100px; height: 100px; overflow: hidden; border-radius: 50%;">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.profileImage}">
                                    <img src="${pageContext.request.contextPath}/uploads/${sessionScope.user.profileImage}" alt="Profile" class="img-fluid" style="width: 100%; height: 100%; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <div class="bg-light rounded-circle d-flex justify-content-center align-items-center" style="width: 100%; height: 100%;">
                                        <span class="display-4">${fn:toUpperCase(fn:substring(sessionScope.user.username, 0, 1))}</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="mb-3">
                            <label for="profileImage" class="form-label">Profile Picture</label>
                            <input type="file" class="form-control" id="profileImage" name="profileImage" accept="image/*">
                            <div class="form-text">Max file size: 2MB. Supported formats: JPG, PNG, GIF</div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" class="form-control" id="username" name="username" value="${sessionScope.user.username}" >
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" value="${sessionScope.user.email}" >
                    </div>
                    <div class="mb-3">
                        <label for="currentPassword" class="form-label">Current Password</label>
                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                    </div>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">New Password (leave blank to keep current)</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword">
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirm New Password</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>
    
    <jsp:include page="/WEB-INF/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/chart.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Performance Chart
            const perfCtx = document.getElementById('performanceChart').getContext('2d');
            const performanceChart = new Chart(perfCtx, {
                type: 'line',
                data: {
                    labels: ${performanceLabels},
                    datasets: [{
                        label: 'Quiz Scores (%)',
                        data: ${performanceData},
                        backgroundColor: 'rgba(54, 162, 235, 0.2)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 2,
                        tension: 0.1
                    }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100
                        }
                    }
                }
            });
            
            // Category Chart
            const catCtx = document.getElementById('categoryChart').getContext('2d');
            const categoryChart = new Chart(catCtx, {
                type: 'bar',
                data: {
                    labels: ${categoryLabels},
                    datasets: [{
                        label: 'Average Score (%)',
                        data: ${categoryData},
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.5)',
                            'rgba(54, 162, 235, 0.5)',
                            'rgba(255, 206, 86, 0.5)',
                            'rgba(75, 192, 192, 0.5)',
                            'rgba(153, 102, 255, 0.5)',
                            'rgba(255, 159, 64, 0.5)'
                        ],
                        borderColor: [
                            'rgba(255, 99, 132, 1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(75, 192, 192, 1)',
                            'rgba(153, 102, 255, 1)',
                            'rgba(255, 159, 64, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100
                        }
                    }
                }
            });
            
            // Form validation
            const editProfileForm = document.getElementById('editProfileForm');
            editProfileForm.addEventListener('submit', function(event) {
                const newPassword = document.getElementById('newPassword').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                
                if (newPassword && newPassword !== confirmPassword) {
                    alert("New passwords don't match!");
                    event.preventDefault();
                }
            });
        });
    </script>
</body>
</html>