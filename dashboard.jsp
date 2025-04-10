<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
</head>
<body>
    <jsp:include page="/WEB-INF/navbar.jsp" />
    
    <div class="container-fluid mt-3">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 bg-dark text-white p-0 sidebar">
                <div class="d-flex flex-column p-3">
                    <h4 class="mb-3">Admin Panel</h4>
                    <ul class="nav nav-pills flex-column mb-auto">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active" aria-current="page">
                                <i class="bi bi-speedometer2 me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-quizzes" class="nav-link text-white">
                                <i class="bi bi-journal-text me-2"></i> Manage Quizzes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-questions" class="nav-link text-white">
                                <i class="bi bi-question-circle me-2"></i> Manage Questions
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageConte<a href="${pageContext.request.contextPath}/admin/manage-categories" class="nav-link text-white">
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
                    <h1>Dashboard Overview</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
                        </div>
                        <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle">
                            <i class="bi bi-calendar3"></i> This Week
                        </button>
                    </div>
                </div>
                
                <!-- Stats Cards -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card bg-primary text-white">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title">Total Users</h6>
                                        <h2 class="mb-0">${stats.totalUsers}</h2>
                                    </div>
                                    <i class="bi bi-people fs-1"></i>
                                </div>
                                <div class="mt-3">
                                    <span class="text-white-50">
                                        <i class="bi bi-arrow-up-right"></i> ${stats.newUsers} new this month
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-success text-white">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title">Total Quizzes</h6>
                                        <h2 class="mb-0">${stats.totalQuizzes}</h2>
                                    </div>
                                    <i class="bi bi-journal-text fs-1"></i>
                                </div>
                                <div class="mt-3">
                                    <span class="text-white-50">
                                        <i class="bi bi-arrow-up-right"></i> ${stats.newQuizzes} new this month
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-warning text-dark">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title">Total Questions</h6>
                                        <h2 class="mb-0">${stats.totalQuestions}</h2>
                                    </div>
                                    <i class="bi bi-question-circle fs-1"></i>
                                </div>
                                <div class="mt-3">
                                    <span class="text-dark-50">
                                        <i class="bi bi-arrow-up-right"></i> ${stats.newQuestions} new this month
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-info text-white">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title">Quizzes Taken</h6>
                                        <h2 class="mb-0">${stats.quizzesTaken}</h2>
                                    </div>
                                    <i class="bi bi-check2-all fs-1"></i>
                                </div>
                                <div class="mt-3">
                                    <span class="text-white-50">
                                        <i class="bi bi-arrow-up-right"></i> ${stats.quizzesTakenThisMonth} this month
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row mb-4">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">Quiz Activity</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="quizActivityChart" height="300"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">Top Categories</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="categoriesChart" height="300"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Recent Users</h5>
                                <a href="${pageContext.request.contextPath}/admin/manage-users" class="btn btn-sm btn-primary">View All</a>
                            </div>
                            <div class="card-body p-0">
                                <table class="table table-striped table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>Username</th>
                                            <th>Email</th>
                                            <th>Joined</th>
                                            <th>Role</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${recentUsers}" var="user">
                                            <tr>
                                                <td>${user.username}</td>
                                                <td>${user.email}</td>
                                                <td><fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy" /></td>
                                                <td><span class="badge bg-${user.role eq 'ADMIN' ? 'danger' : 'info'}">${user.role}</span></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Recent Quizzes</h5>
                                <a href="${pageContext.request.contextPath}/admin/manage-quizzes" class="btn btn-sm btn-primary">View All</a>
                            </div>
                            <div class="card-body p-0">
                                <table class="table table-striped table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Category</th>
                                            <th>Questions</th>
                                            <th>Times Taken</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${recentQuizzes}" var="quiz">
                                            <tr>
                                                <td>${quiz.title}</td>
                                                <td>${quiz.category.name}</td>
                                                <td>${quiz.totalQuestions}</td>
                                                <td>${quiz.timesTaken}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Quiz Activity Chart
            const activityCtx = document.getElementById('quizActivityChart').getContext('2d');
            const activityChart = new Chart(activityCtx, {
                type: 'line',
                data: {
                    labels: ${activityLabels},
                    datasets: [{
                        label: 'Quizzes Taken',
                        data: ${activityData},
                        backgroundColor: 'rgba(54, 162, 235, 0.2)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1,
                        tension: 0.1
                    }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
            
            // Categories Chart
            const catCtx = document.getElementById('categoriesChart').getContext('2d');
            const catChart = new Chart(catCtx, {
                type: 'doughnut',
                data: {
                    labels: ${categoryLabels},
                    datasets: [{
                        label: 'Popular Categories',
                        data: ${categoryData},
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.5)',
                            'rgba(54, 162, 235, 0.5)',
                            'rgba(255, 206, 86, 0.5)',
                            'rgba(75, 192, 192, 0.5)',
                            'rgba(153, 102, 255, 0.5)'
                        ],
                        borderColor: [
                            'rgba(255, 99, 132, 1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(75, 192, 192, 1)',
                            'rgba(153, 102, 255, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom',
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>
                            