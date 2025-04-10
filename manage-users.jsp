<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Manage Users</title>
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
                            <a href="${pageContext.request.contextPath}/admin/manage-questions" class="nav-link text-white">
                                <i class="bi bi-question-circle me-2"></i> Manage Questions
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/manage-users" class="nav-link active" aria-current="page">
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
                    <h1>Manage Users</h1>
                    <div>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                            <i class="bi bi-person-plus me-2"></i> Add New User
                        </button>
                    </div>
                </div>
                
                <!-- Filter and Search -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <select class="form-select" id="roleFilter">
                            <option value="">All Roles</option>
                            <option value="ADMIN" ${param.role eq 'ADMIN' ? 'selected' : ''}>Administrators</option>
                            <option value="USER" ${param.role eq 'USER' ? 'selected' : ''}>Regular Users</option>
                        </select>
                    </div>
                    <div class="col-md-8">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Search users..." id="searchUser" value="${param.search}">
                            <button class="btn btn-outline-secondary" type="button" id="searchButton">
                                <i class="bi bi-search"></i> Search
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Users Table -->
                <div class="card mb-4">
                    <div class="card-body p-0">
                        <table class="table table-striped table-hover align-middle mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Registration Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${users}" var="user">
                                    <tr>
                                        <td>${user.id}</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="avatar-sm bg-${user.role eq 'ADMIN' ? 'danger' : 'primary'} rounded-circle text-white text-center me-2" style="width: 32px; height: 32px; line-height: 32px;">
                                                    ${fn:substring(user.username, 0, 1).toUpperCase()}
                                                </div>
                                                ${user.username}
                                                <c:if test="${user.id eq sessionScope.user.id}">
                                                    <span class="badge bg-info ms-2">You</span>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td>${user.email}</td>
                                        <td>
                                            <span class="badge ${user.role eq 'ADMIN' ? 'bg-danger' : 'bg-primary'}">${user.role}</span>
                                        </td>
                                        <td><fmt:formatDate value="${user.registrationDate}" pattern="MMM dd, yyyy" /></td>
                                        <td>
                                            <span class="badge ${user.active ? 'bg-success' : 'bg-secondary'}">${user.active ? 'Active' : 'Inactive'}</span>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <button type="button" class="btn btn-sm btn-info view-user" 
                                                        data-id="${user.id}" 
                                                        data-username="${user.username}"
                                                        data-email="${user.email}">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button type="button" class="btn btn-sm btn-primary edit-user" 
                                                        data-id="${user.id}" 
                                                        data-username="${user.username}"
                                                        data-email="${user.email}"
                                                        data-role="${user.role}"
                                                        data-active="${user.active}">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <c:if test="${user.id ne sessionScope.user.id}">
                                                    <button type="button" class="btn btn-sm ${user.active ? 'btn-warning' : 'btn-success'} toggle-status"
                                                            data-id="${user.id}"
                                                            data-username="${user.username}"
                                                            data-active="${user.active}">
                                                        <i class="bi ${user.active ? 'bi-person-x' : 'bi-person-check'}"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-danger delete-user" 
                                                            data-id="${user.id}" 
                                                            data-username="${user.username}">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${empty users}">
                                    <tr>
                                        <td colspan="7" class="text-center">No users found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Pagination -->
                <c:if test="${not empty users}">
                    <nav aria-label="User pagination">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-users?page=${currentPage - 1}${not empty param.role ? '&role=' + param.role : ''}${not empty param.search ? '&search=' + param.search : ''}">Previous</a>
                            </li>
                            
                            <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                                <li class="page-item ${pageNumber == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-users?page=${pageNumber}${not empty param.role ? '&role=' + param.role : ''}${not empty param.search ? '&search=' + param.search : ''}">${pageNumber}</a>
                                </li>
                            </c:forEach>
                            
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/manage-users?page=${currentPage + 1}${not empty param.role ? '&role=' + param.role : ''}${not empty param.search ? '&search=' + param.search : ''}">Next</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
                
                <!-- User Statistics -->
                <div class="row mt-4">
                    <div class="col-md-4">
                        <div class="card bg-primary text-white mb-4">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h5 class="mb-0">Total Users</h5>
                                        <p class="mb-0">${userStats.totalUsers}</p>
                                    </div>
                                    <div>
                                        <i class="bi bi-people-fill fs-1"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-success text-white mb-4">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h5 class="mb-0">Active Users</h5>
                                        <p class="mb-0">${userStats.activeUsers}</p>
                                    </div>
                                    <div>
                                        <i class="bi bi-person-check-fill fs-1"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-danger text-white mb-4">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h5 class="mb-0">Administrators</h5>
                                        <p class="mb-0">${userStats.adminUsers}</p>
                                    </div>
                                    <div>
                                        <i class="bi bi-shield-fill-check fs-1"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="addUserModalLabel">Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/add-user" method="post" id="addUserForm">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Confirm Password</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                        </div>
                        <div class="mb-3">
                            <label for="role" class="form-label">Role</label>
                            <select class="form-select" id="role" name="role" required>
                                <option value="USER">Regular User</option>
                                <option value="ADMIN">Administrator</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="active" name="active" checked>
                                <label class="form-check-label" for="active">
                                    Active Account
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="editUserModalLabel">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/update-user" method="post" id="editUserForm">
                    <input type="hidden" id="editUserId" name="id">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="editUsername" class="form-label">Username</label>
                            <input type="text" class="form-control" id="editUsername" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="editEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="editEmail" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="editPassword" class="form-label">New Password (leave blank to keep current)</label>
                            <input type="password" class="form-control" id="editPassword" name="password">
                        </div>
                        <div class="mb-3">
                            <label for="editRole" class="form-label">Role</label>
                            <select class="form-select" id="editRole" name="role" required>
                                <option value="USER">Regular User</option>
                                <option value="ADMIN">Administrator</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="editActive" name="active">
                                <label class="form-check-label" for="editActive">
                                    Active Account
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- View User Modal -->
    <div class="modal fade" id="viewUserModal" tabindex="-1" aria-labelledby="viewUserModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title" id="viewUserModalLabel">User Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-4">
                        <div class="avatar-lg mx-auto bg-primary rounded-circle text-white d-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px; font-size: 32px;">
                            <span id="userInitial"></span>
                        </div>
                        <h4 id="viewUsername" class="mb-1"></h4>
                        <p id="viewEmail" class="text-muted mb-2"></p>
                        <div id="viewUserBadges"></div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card mb-3">
                                <div class="card-header bg-light">
                                    <h6 class="mb-0">Quiz Performance</h6>
                                </div>
                                <div class="card-body">
                                    <div id="userStatsLoading" class="text-center">
                                        <div class="spinner-border text-primary" role="status">
                                            <span class="visually-hidden">Loading...</span>
                                        </div>
                                        <p class="mt-2">Loading user statistics...</p>
                                    </div>
                                    <div id="userStats" class="d-none">
                                        <div class="row text-center">
                                            <div class="col-4">
                                                <h3 id="quizzesTaken">-</h3>
                                                <p class="text-muted mb-0">Quizzes Taken</p>
                                            </div>
                                            <div class="col-4">
                                                <h3 id="avgScore">-</h3>
                                                <p class="text-muted mb-0">Avg. Score</p>
                                            </div>
                                            <div class="col-4">
                                                <h3 id="totalPoints">-</h3>
                                                <p class="text-muted mb-0">Total Points</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card mb-3">
                                <div class="card-header bg-light">
                                    <h6 class="mb-0">Account Info</h6>
                                </div>
                                <div class="card-body">
                                    <ul class="list-group list-group-flush">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            <span>User ID</span>
                                            <span id="viewUserId" class="text-muted"></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            <span>Registration Date</span>
                                            <span id="viewRegDate" class="text-muted"></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            <span>Last Login</span>
                                            <span id="viewLastLogin" class="text-muted"></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            <span>Status</span>
                                            <span id="viewStatus"></span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <a id="viewQuizzesBtn" href="#" class="btn btn-primary">View Quizzes</a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete User Modal -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteUserModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this user?</p>
                    <p>Username: <strong id="deleteUsername"></strong></p>
                    <div class="alert alert-warning">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        This action cannot be undone. All user data, including quiz results and history will be permanently removed.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteUserForm" action="${pageContext.request.contextPath}/admin/delete-user" method="post">
                        <input type="hidden" id="deleteUserId" name="id">
                        <button type="submit" class="btn btn-danger">Delete Permanently</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Toggle Status Modal -->
    <div class="modal fade" id="toggleStatusModal" tabindex="-1" aria-labelledby="toggleStatusModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header" id="toggleStatusHeader">
                    <h5 class="modal-title" id="toggleStatusModalLabel">Confirm Status Change</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p id="toggleStatusMessage"></p>
                    <p>Username: <strong id="toggleStatusUsername"></strong></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="toggleStatusForm" action="${pageContext.request.contextPath}/admin/toggle-user-status" method="post">
                        <input type="hidden" id="toggleStatusUserId" name="id">
                        <input type="hidden" id="toggleStatusAction" name="active">
                        <button type="submit" class="btn" id="toggleStatusButton">Confirm</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/pages/components/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Role filter
            const roleFilter = document.getElementById('roleFilter');
            roleFilter.addEventListener('change', function() {
                const role = this.value;
                let url = '${pageContext.request.contextPath}/admin/manage-users';
                
                if (role) {
                    url += '?role=' + role;
                }
                
                window.location.href = url;
            });
            
            // User search
            const searchButton = document.getElementById('searchButton');
            const searchInput = document.getElementById('searchUser');
            
            searchButton.addEventListener('click', function() {
                const searchTerm = searchInput.value.trim();
                let url = '${pageContext.request.contextPath}/admin/manage-users';
                const params = new URLSearchParams();
                
                if (searchTerm) {
                    params.append('search', searchTerm);
                }
                
                const role = roleFilter.value;
                if (role) {
                    params.append('role', role);
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
            
            // View user
            const viewButtons = document.querySelectorAll('.view-user');
            viewButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const userId = this.getAttribute('data-id');
                    const username = this.getAttribute('data-username');
                    const email = this.getAttribute('data-email');
                    
                    document.getElementById('viewUsername').textContent = username;
                    document.getElementById('viewEmail').textContent = email;
                    document.getElementById('userInitial').textContent = username.charAt(0).toUpperCase();
                    document.getElementById('viewUserId').textContent = userId;
                    document.getElementById('viewQuizzesBtn').href = '${pageContext.request.contextPath}/admin/user-quizzes?userId=' + userId;
                    
                    // Show loading state
                    document.getElementById('userStatsLoading').classList.remove('d-none');
                    document.getElementById('userStats').classList.add('d-none');
                    
                    // Fetch user details via AJAX
                    fetch('${pageContext.request.contextPath}/admin/get-user-details?id=' + userId)
                        .then(response => response.json())
                        .then(data => {
                            // Update user stats
                            document.getElementById('quizzesTaken').textContent = data.quizzesTaken;
                            document.getElementById('avgScore').textContent = data.averageScore + '%';
                            document.getElementById('totalPoints').textContent = data.totalPoints;
                            
                            // Update account info
                            document.getElementById('viewRegDate').textContent = data.registrationDate;
                            document.getElementById('viewLastLogin').textContent = data.lastLogin || 'Never';
                            
                            // Set status badge
                            const statusElement = document.getElementById('viewStatus');
                            statusElement.textContent = data.active ? 'Active' : 'Inactive';
                            statusElement.className = `badge ${data.active ? 'bg-success' : 'bg-secondary'}`;
                            
                            // Set role badges
                            const badgesContainer = document.getElementById('viewUserBadges');
                            badgesContainer.innerHTML = '';
                            const roleBadge = document.createElement('span');
                            roleBadge.className = `badge ${data.role === 'ADMIN' ? 'bg-danger' : 'bg-primary'} me-2`;
                            roleBadge.textContent = data.role;
                            badgesContainer.appendChild(roleBadge);
                            
                            // Show stats after loading
                            document.getElementById('userStatsLoading').classList.add('d-none');
                            document.getElementById('userStats').classList.remove('d-none');
                        })
                        .catch(error => {
                            console.error('Error fetching user details:', error);
                            document.getElementById('userStatsLoading').innerHTML = 
                                '<div class="alert alert-danger">Error loading user data</div>';
                        });
                    
                    const viewModal = new bootstrap.Modal(document.getElementById('viewUserModal'));
                    viewModal.show();
                });
            });
            
            // Edit user
            const editButtons = document.querySelectorAll('.edit-user');
            editButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const userId = this.getAttribute('data-id');
                    const username = this.getAttribute('data-username');
                    const email = this.getAttribute('data-email');
                    const role = this.getAttribute('data-role');
                    const active = this.getAttribute('data-active') === 'true';
                    
                    document.getElementById('editUserId').value = userId;
                    document.getElementById('editUsername').value = username;
                    document.getElementById('editEmail').value = email;
                    document.getElementById('editRole').value = role;
                    document.getElementById('editActive').checked = active;
                    
                    const editModal = new bootstrap.Modal(document.getElementById('editUserModal'));
                    editModal.show();
                });
            });
            
            // Delete user
            const deleteButtons = document.querySelectorAll('.delete-user');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const userId = this.getAttribute('data-id');
                    const username = this.getAttribute('data-username');
                    
                    document.getElementById('deleteUserId').value = userId;
                    document.getElementById('deleteUsername').textContent = username;
                    
                    const deleteModal = new bootstrap.Modal(document.getElementById('deleteUserModal'));
                    deleteModal.show();
                });
            });
            
            // Toggle user status
            const toggleButtons = document.querySelectorAll('.toggle-status');
            toggleButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const userId = this.getAttribute('data-id');
                    const username = this.getAttribute('data-username');
                    const currentlyActive = this.getAttribute('data-active') === 'true';
                    const newStatus = !currentlyActive;
                    
                    document.getElementById('toggleStatusUserId').value = userId;
                    document.getElementById('toggleStatusUsername').textContent = username;
                    document.getElementById('toggleStatusAction').value = newStatus;
                    
                    const messageElement = document.getElementById('toggleStatusMessage');
                    const headerElement = document.getElementById('toggleStatusHeader');
                    const buttonElement = document.getElementById('toggleStatusButton');
                    
                    if (newStatus) {
                        // Activating account
                        messageElement.textContent = 'Are you sure you want to activate this user account?';
                        headerElement.className = 'modal-header bg-success text-white';
                        buttonElement.className = 'btn btn-success';
                        buttonElement.textContent = 'Activate Account';
                    } else {
                        // Deactivating account
                        messageElement.textContent = 'Are you sure you want to deactivate this user account?';
                        headerElement.className = 'modal-header bg-warning text-dark';
                        buttonElement.className = 'btn btn-warning';
                        buttonElement.textContent = 'Deactivate Account';
                    }
                    
                    const toggleModal = new bootstrap.Modal(document.getElementById('toggleStatusModal'));
                    toggleModal.show();
                });
            });
            
            // Form validation for add user
            const addUserForm = document.getElementById('addUserForm');
            if (addUserForm) {
                addUserForm.addEventListener('submit', function(event) {
                    const password = document.getElementById('password').value;
                    const confirmPassword = document.getElementById('confirmPassword').value;
                    
                    if (password !== confirmPassword) {
                        event.preventDefault();
                        alert('Password and confirmation password do not match');
                    }
                });
            }
        });
    </script>
</body>
</html>