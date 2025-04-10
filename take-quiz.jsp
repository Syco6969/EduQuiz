<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Take Quiz - EduQuiz</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/quiz.css">
</head>
<body>
    <jsp:include page="../includes/navbar.jsp" />
    
    <div class="main-content py-4">
        <div class="container">
            <div class="quiz-container fade-in">
                <!-- Quiz Header -->
                <div class="quiz-header">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h2 class="quiz-title">${quiz.title}</h2>
                            <div class="quiz-meta">
                                <span><i class="bi bi-bookmark-fill me-1"></i> ${quiz.category}</span>
                                <span class="ms-3"><i class="bi bi-bar-chart-fill me-1"></i> ${quiz.difficulty}</span>
                                <span class="ms-3"><i class="bi bi-question-circle-fill me-1"></i> ${quiz.questions.size()} Questions</span>
                            </div>
                        </div>
                        <div class="col-md-4 text-md-end mt-3 mt-md-0">
                            <div class="quiz-timer" id="quiz-timer">
                                <i class="bi bi-clock"></i>
                                <span id="timer-display">00:00</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Quiz Progress Bar -->
                    <div class="quiz-progress mt-3">
                        <div class="progress-label">
                            <span>Progress</span>
                            <span id="progress-text">0/${quiz.questions.size()}</span>
                        </div>
                        <div class="progress">
                            <div class="progress-bar" id="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                    </div>
                </div>
                
                <form id="quiz-form" action="${pageContext.request.contextPath}/quiz/submit" method="post">
                    <input type="hidden" name="quizId" value="${quiz.id}">
                    <input type="hidden" name="startTime" id="start-time" value="${startTime}">
                    <input type="hidden" name="timeSpent" id="time-spent" value="0">
                    
                    <!-- Question Navigator -->
                    <div class="question-navigator mb-4" id="question-navigator">
                        <c:forEach items="${quiz.questions}" var="question" varStatus="status">
                            <div class="question-nav-item" data-question="${status.index + 1}">${status.index + 1}</div>
                        </c:forEach>
                    </div>
                    
                    <!-- Questions Container -->
                    <div id="questions-container">
                        <c:forEach items="${quiz.questions}" var="question" varStatus="status">
                            <div class="question-card card shadow-sm" id="question-${status.index + 1}" style="display: ${status.index == 0 ? 'block' : 'none'};">
                                <div class="question-header">
                                    <div class="question-number">Question ${status.index + 1} of ${quiz.questions.size()}</div>
                                    <div>
                                        <button type="button" class="btn btn-sm btn-outline-primary mark-question" data-question="${status.index + 1}">
                                            <i class="bi bi-flag"></i> Mark for Review
                                        </button>
                                    </div>
                                </div>
                                <div class="question-body">
                                    <div class="question-text">${question.questionText}</div>
                                    <ul class="options-list">
                                        <li class="option-item">
                                            <label class="option-label" for="q${status.index + 1}_a">
                                                <input type="radio" id="q${status.index + 1}_a" name="answer_${question.id}" value="A" class="option-radio">
                                                <div class="option-text">${question.optionA}</div>
                                            </label>
                                        </li>
                                        <li class="option-item">
                                            <label class="option-label" for="q${status.index + 1}_b">
                                                <input type="radio" id="q${status.index + 1}_b" name="answer_${question.id}" value="B" class="option-radio">
                                                <div class="option-text">${question.optionB}</div>
                                            </label>
                                        </li>
                                        <li class="option-item">
                                            <label class="option-label" for="q${status.index + 1}_c">
                                                <input type="radio" id="q${status.index + 1}_c" name="answer_${question.id}" value="C" class="option-radio">
                                                <div class="option-text">${question.optionC}</div>
                                            </label>
                                        </li>
                                        <li class="option-item">
                                            <label class="option-label" for="q${status.index + 1}_d">
                                                <input type="radio" id="q${status.index + 1}_d" name="answer_${question.id}" value="D" class="option-radio">
                                                <div class="option-text">${question.optionD}</div>
                                            </label>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Quiz Navigation -->
                    <div class="quiz-navigation">
                        <button type="button" id="prev-btn" class="btn btn-outline-primary" disabled>
                            <i class="bi bi-arrow-left"></i> Previous
                        </button>
                        
                        <div>
                            <button type="button" id="next-btn" class="btn btn-primary">
                                Next <i class="bi bi-arrow-right"></i>
                            </button>
                            
                            <button type="button" id="submit-btn" class="btn btn-accent" style="display: none;">
                                Submit Quiz
                            </button>
                        </div>
                    </div>
                </form>
                
                <!-- Confirmation Modal -->
                <div class="modal fade" id="submission-modal" tabindex="-1" aria-labelledby="submission-modal-label" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="submission-modal-label">Submit Quiz</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div id="quiz-summary">
                                    <p><strong>Total Questions:</strong> <span id="total-questions">${quiz.questions.size()}</span></p>
                                    <p><strong>Answered:</strong> <span id="answered-questions">0</span></p>
                                    <p><strong>Marked for Review:</strong> <span id="marked-questions">0</span></p>
                                    <p><strong>Unanswered:</strong> <span id="unanswered-questions">${quiz.questions.size()}</span></p>
                                </div>
                                <div class="alert alert-warning mt-3">
                                    <i class="bi bi-exclamation-triangle"></i> Are you sure you want to submit? You cannot return to the quiz after submission.
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Return to Quiz</button>
                                <button type="button" class="btn btn-primary" id="confirm-submit">Confirm Submission</button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Time's Up Modal -->
                <div class="modal fade" id="times-up-modal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="times-up-modal-label" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="times-up-modal-label">Time's Up!</h5>
                            </div>
                            <div class="modal-body">
                                <div class="text-center mb-3">
                                    <i class="bi bi-clock text-danger" style="font-size: 3rem;"></i>
                                </div>
                                <p>Your time for this quiz has expired. Your answers will be automatically submitted.</p>
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle"></i> Please wait while we process your submission...
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-primary" id="time-up-submit" disabled>
                                    <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                                    Submitting...
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Initialize quiz state
        let currentQuestion = 1;
        const totalQuestions = ${quiz.questions.size()};
        let answeredQuestions = 0;
        let markedQuestions = [];
        let startTime = new Date().getTime();
        let timeLimit = ${quiz.timeLimit} * 60 * 1000; // Convert minutes to milliseconds
        
        // Initialize timer
        document.getElementById('start-time').value = startTime;
        const timerDisplay = document.getElementById('timer-display');
        const quizTimer = document.getElementById('quiz-timer');
        let timerInterval;
        
        // DOM elements
        const questionCards = document.querySelectorAll('.question-card');
        const navItems = document.querySelectorAll('.question-nav-item');
        const prevBtn = document.getElementById('prev-btn');
        const nextBtn = document.getElementById('next-btn');
        const submitBtn = document.getElementById('submit-btn');
        const quizForm = document.getElementById('quiz-form');
        const timeSpentInput = document.getElementById('time-spent');
        
        // Modals
        const submissionModal = new bootstrap.Modal(document.getElementById('submission-modal'));
        const timesUpModal = new bootstrap.Modal(document.getElementById('times-up-modal'));
        
        // Start quiz timer
        startTimer();
        
        // Show first question
        showQuestion(1);
        updateNavigation();
        
        // Update navigation when options are selected
        document.querySelectorAll('.option-radio').forEach(radio => {
            radio.addEventListener('change', function() {
                const questionLabel = this.closest('.question-card').id;
                const questionNumber = parseInt(questionLabel.split('-')[1]);
                
                // Update question navigator
                const navItem = document.querySelector(`.question-nav-item[data-question="${questionNumber}"]`);
                if (!navItem.classList.contains('answered')) {
                    answeredQuestions++;
                    navItem.classList.add('answered');
                }
                
                // Update progress
                updateProgress();
                
                // Mark the selected option
                const optionLabels = this.closest('.options-list').querySelectorAll('.option-label');
                optionLabels.forEach(label => {
                    label.classList.remove('selected');
                });
                this.closest('.option-label').classList.add('selected');
            });
        });
        
        // Handle navigation buttons
        prevBtn.addEventListener('click', function() {
            if (currentQuestion > 1) {
                showQuestion(currentQuestion - 1);
                updateNavigation();
            }
        });
        
        nextBtn.addEventListener('click', function() {
            if (currentQuestion < totalQuestions) {
                showQuestion(currentQuestion + 1);
                updateNavigation();
            }
        });
        
        // Handle question navigator
        navItems.forEach(item => {
            item.addEventListener('click', function() {
                const questionNumber = parseInt(this.getAttribute('data-question'));
                showQuestion(questionNumber);
                updateNavigation();
            });
        });
        
        // Mark question for review
        document.querySelectorAll('.mark-question').forEach(button => {
            button.addEventListener('click', function() {
                const questionNumber = parseInt(this.getAttribute('data-question'));
                const navItem = document.querySelector(`.question-nav-item[data-question="${questionNumber}"]`);
                
                if (!markedQuestions.includes(questionNumber)) {
                    markedQuestions.push(questionNumber);
                    navItem.classList.add('marked');
                    this.innerHTML = '<i class="bi bi-flag-fill"></i> Marked';
                    this.classList.remove('btn-outline-primary');
                    this.classList.add('btn-warning');
                } else {
                    markedQuestions = markedQuestions.filter(q => q !== questionNumber);
                    navItem.classList.remove('marked');
                    this.innerHTML = '<i class="bi bi-flag"></i> Mark for Review';
                    this.classList.remove('btn-warning');
                    this.classList.add('btn-outline-primary');
                }
                
                updateSubmissionModal();
            });
        });
        
        // Open submission modal
        submitBtn.addEventListener('click', function() {
            updateSubmissionModal();
            submissionModal.show();
        });
        
        // Confirm submission
        document.getElementById('confirm-submit').addEventListener('click', function() {
            timeSpentInput.value = Math.floor((new Date().getTime() - startTime) / 1000);
            quizForm.submit();
        });
        
        // Submit when time's up
        document.getElementById('time-up-submit').addEventListener('click', function() {
            timeSpentInput.value = Math.floor(timeLimit / 1000);
            quizForm.submit();
        });
        
        // Helper functions
        function showQuestion(number) {
            questionCards.forEach(card => {
                card.style.display = 'none';
            });
            
            const questionToShow = document.getElementById(`question-${number}`);
            if (questionToShow) {
                questionToShow.style.display = 'block';
            }
            
            currentQuestion = number;
            
            // Update mark button status
            const markButton = questionToShow.querySelector('.mark-question');
            if (markedQuestions.includes(number)) {
                markButton.innerHTML = '<i class="bi bi-flag-fill"></i> Marked';
                markButton.classList.remove('btn-outline-primary');
                markButton.classList.add('btn-warning');
            } else {
                markButton.innerHTML = '<i class="bi bi-flag"></i> Mark for Review';
                markButton.classList.remove('btn-warning');
                markButton.classList.add('btn-outline-primary');
            }
        }
        
        function updateNavigation() {
            // Update Previous button
            prevBtn.disabled = currentQuestion === 1;
            
            // Update Next/Submit button
            if (currentQuestion === totalQuestions) {
                nextBtn.style.display = 'none';
                submitBtn.style.display = 'inline-block';
            } else {
                nextBtn.style.display = 'inline-block';
                submitBtn.style.display = 'none';
            }
            
            // Update active navigation item
            navItems.forEach(item => {
                item.classList.remove('current');
                if (parseInt(item.getAttribute('data-question')) === currentQuestion) {
                    item.classList.add('current');
                }
            });
        }
        
        function updateProgress() {
            const progressText = document.getElementById('progress-text');
            const progressBar = document.getElementById('progress-bar');
            const progress = Math.floor((answeredQuestions / totalQuestions) * 100);
            
            progressText.textContent = `${answeredQuestions}/${totalQuestions}`;
            progressBar.style.width = `${progress}%`;
            progressBar.setAttribute('aria-valuenow', progress);
        }
        
        function updateSubmissionModal() {
            const totalQuestionsElem = document.getElementById('total-questions');
            const answeredQuestionsElem = document.getElementById('answered-questions');
            const markedQuestionsElem = document.getElementById('marked-questions');
            const unansweredQuestionsElem = document.getElementById('unanswered-questions');
            
            totalQuestionsElem.textContent = totalQuestions;
            answeredQuestionsElem.textContent = answeredQuestions;
            markedQuestionsElem.textContent = markedQuestions.length;
            unansweredQuestionsElem.textContent = totalQuestions - answeredQuestions;
        }
        
        function startTimer() {
            const endTime = startTime + timeLimit;
            
            timerInterval = setInterval(function() {
                const currentTime = new Date().getTime();
                const remainingTime = endTime - currentTime;
                
                if (remainingTime <= 0) {
                    clearInterval(timerInterval);
                    handleTimesUp();
                } else {
                    updateTimerDisplay(remainingTime);
                    
                    // Warning states
                    const minutesLeft = Math.floor(remainingTime / (60 * 1000));
                    if (minutesLeft <= 5) {
                        quizTimer.classList.add('warning');
                    }
                    if (minutesLeft <= 1) {
                        quizTimer.classList.remove('warning');
                        quizTimer.classList.add('danger');
                    }
                }
            }, 1000);
        }
        
        function updateTimerDisplay(milliseconds) {
            const minutes = Math.floor(milliseconds / (60 * 1000));
            const seconds = Math.floor((milliseconds % (60 * 1000)) / 1000);
            
            timerDisplay.textContent = `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
        }
        
        function handleTimesUp() {
            timerDisplay.textContent = "00:00";
            timeSpentInput.value = Math.floor(timeLimit / 1000);
            timesUpModal.show();
            
            // Auto-submit after 3 seconds
            setTimeout(function() {
                document.getElementById('time-up-submit').disabled = false;
                document.getElementById('time-up-submit').innerHTML = 'View Results';
                document.getElementById('time-up-submit').click();
            }, 3000);
        }
    </script>
    <script src="${pageContext.request.contextPath}/resources/js/quiz.js"></script>
</body>
</html>