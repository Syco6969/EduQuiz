/**
 * Quiz functionality for EduQuiz application
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize variables
    const quizForm = document.getElementById('quizForm');
    const questionCards = document.querySelectorAll('.question-card');
    const navButtons = document.querySelectorAll('.question-nav-btn');
    const prevButtons = document.querySelectorAll('.prev-btn');
    const nextButtons = document.querySelectorAll('.next-btn');
    const submitButtons = document.querySelectorAll('.submit-btn');
    const confirmSubmitButton = document.getElementById('confirm-submit');
    const timeSpentInput = document.getElementById('timeSpent');
    const timeLimitElement = document.getElementById('timeLimit');
    
    // Get time limit from data attribute and convert to seconds
    const timeLimitMinutes = parseInt(timeLimitElement.getAttribute('data-minutes')) || 30;
    const timeLimitSeconds = timeLimitMinutes * 60;
    let timeRemaining = timeLimitSeconds;
    let timer;
    
    // Initialize the quiz UI
    initializeQuiz();
    
    /**
     * Initialize the quiz UI and timer
     */
    function initializeQuiz() {
        // Show first question
        showQuestion(0);
        
        // Setup navigation
        setupNavigation();
        
        // Start the timer
        startTimer();
        
        // Setup form submission
        setupSubmission();
    }
    
    /**
     * Setup navigation between questions
     */
    function setupNavigation() {
        // Question navigation buttons
        navButtons.forEach(btn => {
            btn.addEventListener('click', function() {
                const index = parseInt(this.getAttribute('data-index'));
                showQuestion(index);
            });
        });
        
        // Previous buttons
        prevButtons.forEach(btn => {
            btn.addEventListener('click', function() {
                const currentIndex = getCurrentQuestionIndex();
                if (currentIndex > 0) {
                    showQuestion(currentIndex - 1);
                }
            });
        });
        
        // Next buttons
        nextButtons.forEach(btn => {
            btn.addEventListener('click', function() {
                const currentIndex = getCurrentQuestionIndex();
                if (currentIndex < questionCards.length - 1) {
                    showQuestion(currentIndex + 1);
                }
            });
        });
    }
    
    /**
     * Setup quiz submission handling
     */
    function setupSubmission() {
        // Show confirmation modal on submit button click
        submitButtons.forEach(btn => {
            btn.addEventListener('click', function() {
                checkUnansweredQuestions();
                const submitModal = new bootstrap.Modal(document.getElementById('submitModal'));
                submitModal.show();
            });
        });
        
        // Handle final submission
        confirmSubmitButton.addEventListener('click', function() {
            // Calculate time spent
            const timeSpent = timeLimitSeconds - timeRemaining;
            timeSpentInput.value = timeSpent;
            
            // Submit the form
            quizForm.submit();
        });
    }
    
    /**
     * Start the quiz timer
     */
    function startTimer() {
        const timerElement = document.getElementById('timer');
        const progressBar = document.getElementById('timer-progress');
        
        // Format initial time
        timerElement.textContent = formatTime(timeRemaining);
        
        // Start countdown
        timer = setInterval(function() {
            timeRemaining--;
            
            // Update timer display
            timerElement.textContent = formatTime(timeRemaining);
            
            // Update progress bar
            const progressPercent = (timeRemaining / timeLimitSeconds) * 100;
            progressBar.style.width = progressPercent + '%';
            
            // Change color based on time remaining
            if (progressPercent < 25) {
                progressBar.classList.remove('bg-warning');
                progressBar.classList.add('bg-danger');
            } else if (progressPercent < 50) {
                progressBar.classList.remove('bg-info');
                progressBar.classList.add('bg-warning');
            }
            
            // Time's up
            if (timeRemaining <= 0) {
                clearInterval(timer);
                alert('Time is up! Your quiz will be submitted automatically.');
                submitQuiz();
            }
        }, 1000);
    }
    
    /**
     * Check for unanswered questions and update the warning message
     */
    function checkUnansweredQuestions() {
        const answerInputs = document.querySelectorAll('input[type="radio"]');
        const questionCount = questionCards.length;
        const answeredMap = new Map();
        
        // Count answered questions
        answerInputs.forEach(input => {
            if (input.checked) {
                const questionId = input.name.split('-')[1];
                answeredMap.set(questionId, true);
            }
        });
        
        const unansweredCount = questionCount - answeredMap.size;
        const warningElement = document.getElementById('unanswered-warning');
        const countElement = document.getElementById('unanswered-count');
        
        if (unansweredCount > 0) {
            countElement.textContent = unansweredCount;
            warningElement.classList.remove('d-none');
        } else {
            warningElement.classList.add('d-none');
        }
    }
    
    /**
     * Submit the quiz form
     */
    function submitQuiz() {
        const timeSpent = timeLimitSeconds - timeRemaining;
        timeSpentInput.value = timeSpent;
        quizForm.submit();
    }
    
    /**
     * Show a specific question by index
     * @param {number} index - The question index to show
     */
    function showQuestion(index) {
        // Hide all question cards
        questionCards.forEach(card => {
            card.classList.remove('active');
        });
        
        // Show the selected question
        questionCards[index].classList.add('active');
        
        // Update navigation buttons
        updateNavigationButtons(index);
    }
    
    /**
     * Update the state of navigation buttons based on current question
     * @param {number} currentIndex - The current question index
     */
    function updateNavigationButtons(currentIndex) {
        // Update the active state of navigation buttons
        navButtons.forEach((btn, index) => {
            btn.classList.remove('active');
            if (index === currentIndex) {
                btn.classList.add('active');
            }
            
            // Mark answered questions
            const questionId = document.querySelector(`#question-${index} input[type="hidden"]`).value;
            const isAnswered = document.querySelector(`input[name="answer-${questionId}"]:checked`) !== null;
            
            if (isAnswered) {
                btn.classList.add('btn-success');
                btn.classList.remove('btn-outline-primary');
            } else {
                btn.classList.remove('btn-success');
                btn.classList.add('btn-outline-primary');
            }
        });
    }
    
    /**
     * Get the index of the currently displayed question
     * @returns {number} - The current question index
     */
    function getCurrentQuestionIndex() {
        let currentIndex = 0;
        questionCards.forEach((card, index) => {
            if (card.classList.contains('active')) {
                currentIndex = index;
            }
        });
        return currentIndex;
    }
    
    /**
     * Format seconds into MM:SS format
     * @param {number} seconds - The time in seconds
     * @returns {string} - Formatted time string
     */
    function formatTime(seconds) {
        const minutes = Math.floor(seconds / 60);
        const remainingSeconds = seconds % 60;
        return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
    }
});