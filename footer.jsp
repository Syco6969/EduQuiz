<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<footer class="py-4 bg-dark text-white mt-5">
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-4">
                <h5><i class="bi bi-mortarboard-fill me-2"></i>EduQuiz</h5>
                <p>Enhance your knowledge with interactive quizzes on various subjects. Challenge yourself, learn new things, and track your progress.</p>
            </div>
            <div class="col-md-4">
                <h5>Quick Links</h5>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/" class="text-decoration-none text-white-50">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/quizzes" class="text-decoration-none text-white-50">Quizzes</a></li>
                    <li><a href="${pageContext.request.contextPath}/leaderboard" class="text-decoration-none text-white-50">Leaderboard</a></li>
                    <c:if test="${not empty sessionScope.user}">
                        <li><a href="${pageContext.request.contextPath}/history" class="text-decoration-none text-white-50">My History</a></li>
                    </c:if>
                </ul>
            </div>
            <div class="col-md-4">
                <h5>Contact Us</h5>
                <address class="text-white-50">
                    <i class="bi bi-envelope me-2"></i>support@eduquiz.com<br>
                    <i class="bi bi-telephone me-2"></i>(123) 456-7890<br>
                    <div class="mt-3">
                        <a href="#" class="text-white me-2"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="text-white me-2"><i class="bi bi-twitter"></i></a>
                        <a href="#" class="text-white me-2"><i class="bi bi-instagram"></i></a>
                        <a href="#" class="text-white"><i class="bi bi-linkedin"></i></a>
                    </div>
                </address>
            </div>
        </div>
        <hr class="mt-2 mb-3">
        <div class="row">
            <div class="col-md-6">
                <p class="mb-0">&copy; <%= java.time.Year.now().getValue() %> EduQuiz. All rights reserved.</p>
            </div>
            <div class="col-md-6 text-md-end">
                <a href="#" class="text-decoration-none text-white-50 me-3">Privacy Policy</a>
                <a href="#" class="text-decoration-none text-white-50 me-3">Terms of Service</a>
                <a href="#" class="text-decoration-none text-white-50">Help</a>
            </div>
        </div>
    </div>
</footer>