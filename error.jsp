<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduQuiz - Error</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center mt-5 pt-5">
            <div class="col-md-8 col-lg-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center p-5">
                        <div class="mb-4">
                            <i class="bi bi-exclamation-triangle text-danger" style="font-size: 5rem;"></i>
                        </div>
                        
                        <h1 class="display-5 fw-bold mb-3">Oops!</h1>
                        
                        <c:choose>
                            <c:when test="${not empty errorCode}">
                                <h2 class="h3 text-secondary mb-4">Error ${errorCode}</h2>
                            </c:when>
                            <c:otherwise>
                                <h2 class="h3 text-secondary mb-4">Something went wrong</h2>
                            </c:otherwise>
                        </c:choose>
                        
                        <div class="mb-4">
                            <c:choose>
                                <c:when test="${not empty errorMessage}">
                                    <p class="lead">${errorMessage}</p>
                                </c:when>
                                <c:when test="${not empty pageContext.exception}">
                                    <p class="lead">${pageContext.exception.message}</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="lead">We encountered an unexpected error while processing your request.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <c:if test="${not empty errorDetails}">
                            <div class="alert alert-light text-start mb-4">
                                <strong>Details:</strong>
                                <p class="mb-0 text-break">${errorDetails}</p>
                            </div>
                        </c:if>
                        
                        <c:if test="${debug && not empty pageContext.exception}">
                            <div class="accordion mb-4" id="errorAccordion">
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="errorStackTraceHeader">
                                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" 
                                                data-bs-target="#errorStackTrace" aria-expanded="false" aria-controls="errorStackTrace">
                                            Stack Trace (Debug Mode)
                                        </button>
                                    </h2>
                                    <div id="errorStackTrace" class="accordion-collapse collapse" aria-labelledby="errorStackTraceHeader">
                                        <div class="accordion-body">
                                            <pre class="text-start small overflow-auto" style="max-height: 300px;">
                                                <c:forEach items="${pageContext.exception.stackTrace}" var="element">
                                                    ${element}
                                                </c:forEach>
                                            </pre>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <div class="d-grid gap-2">
                            <button class="btn btn-outline-secondary" onclick="history.back()">
                                <i class="bi bi-arrow-left me-2"></i> Go Back
                            </button>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                                <i class="bi bi-house-door me-2"></i> Return to Home Page
                            </a>
                        </div>
                    </div>
                </div>
                
                <div class="text-center mt-4 text-secondary">
                    <p class="small mb-0">
                        If you continue to experience issues, please contact support at:
                        <a href="mailto:support@eduquiz.com">support@eduquiz.com</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Session timeout check -->
    <c:if test="${errorCode == 'SESSION_EXPIRED' || errorCode == 'SESSION_TIMEOUT'}">
        <script>
            // Redirect to login page after 5 seconds
            setTimeout(function() {
                window.location.href = "${pageContext.request.contextPath}/login?timeout=true";
            }, 5000);
        </script>
    </c:if>
</body>
</html>