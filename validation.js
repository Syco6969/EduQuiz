/**
 * Form validation functions for EduQuiz application
 */

/**
 * Validates login form
 * @returns {boolean} - true if form is valid, false otherwise
 */
function validateLoginForm() {
	const usernameField = document.getElementById('username');  
		    const passwordField = document.getElementById('password');
    let isValid = true;
    
    // Reset validation state
    usernameField.classList.remove('is-invalid');
    passwordField.classList.remove('is-invalid');
    
    // Validate username
    if (usernameField.value.trim() === '') {
        usernameField.classList.add('is-invalid');
        isValid = false;
    }
    
    // Validate password
    if (passwordField.value.trim() === '') {
        passwordField.classList.add('is-invalid');
        isValid = false;
    }
    
    return isValid;
}

/**
 * Validates registration form
 * @returns {boolean} - true if form is valid, false otherwise
 */
function validateRegistrationForm() {
    const usernameField = document.getElementById('username');
    const emailField = document.getElementById('email');
    const passwordField = document.getElementById('password');
    const confirmPasswordField = document.getElementById('confirmPassword');
    let isValid = true;
    
    // Reset validation state
    usernameField.classList.remove('is-invalid');
    emailField.classList.remove('is-invalid');
    passwordField.classList.remove('is-invalid');
    confirmPasswordField.classList.remove('is-invalid');
    
    // Validate username (at least 3 characters)
    if (usernameField.value.trim().length < 3) {
        usernameField.classList.add('is-invalid');
        isValid = false;
    }
    
    // Validate email
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(emailField.value.trim())) {
        emailField.classList.add('is-invalid');
        isValid = false;
    }
    
    // Validate password (at least 8 characters, include at least one number)
    const passwordPattern = /^(?=.*\d)(?=.*[a-zA-Z]).{8,}$/;
    if (!passwordPattern.test(passwordField.value)) {
        passwordField.classList.add('is-invalid');
        isValid = false;
    }
    
    // Validate password confirmation
    if (passwordField.value !== confirmPasswordField.value) {
        confirmPasswordField.classList.add('is-invalid');
        isValid = false;
    }
    
    return isValid;
}

/**
 * Validates admin form for creating/editing quizzes
 * @returns {boolean} - true if form is valid, false otherwise
 */
function validateQuizForm() {
    const titleField = document.getElementById('quizTitle');
    const descriptionField = document.getElementById('quizDescription');
    const categoryField = document.getElementById('quizCategory');
    const timeLimitField = document.getElementById('quizTimeLimit');
    let isValid = true;
    
    // Reset validation state
    titleField.classList.remove('is-invalid');
    descriptionField.classList.remove('is-invalid');
    categoryField.classList.remove('is-invalid');
    timeLimitField.classList.remove('is-invalid');
    
    // Validate title
    if (titleField.value.trim().length < 5 || titleField.value.trim().length > 100) {
        titleField.classList.add('is-invalid');
        isValid = false;
    }
    
    // Validate description
    if (descriptionField.value.trim().length < 10) {
        descriptionField.classList.add('is-invalid');
        isValid = false;
    }
    
    // Validate category selection
    if (categoryField.value === '') {
        categoryField.classList.add('is-invalid');
        isValid = false;
    }
    
    // Validate time limit (must be a number between 1 and 120)
    const timeLimit = parseInt(timeLimitField.value);
    if (isNaN(timeLimit) || timeLimit < 1 || timeLimit > 120) {
        timeLimitField.classList.add('is-invalid');
        isValid = false;
    }
    
    return isValid;
}

/**
 * Validates question form for creating/editing quiz questions
 * @returns {boolean} - true if form is valid, false otherwise
 */
function validateQuestionForm() {
    const questionTextField = document.getElementById('questionText');
    const optionAField = document.getElementById('optionA');
    const optionBField = document.getElementById('optionB');
    const optionCField = document.getElementById('optionC');
    const optionDField = document.getElementById('optionD');
    const correctAnswerField = document.getElementById('correctAnswer');
    let isValid = true;
    
    // Reset validation state
    questionTextField.classList.remove('is-invalid');
    optionAField.classList.remove('is-invalid');
    optionBField.classList.remove('is-invalid');
    optionCField.classList.remove('is-invalid');
    optionDField.classList.remove('is-invalid');
    correctAnswerField.classList.remove('is-invalid');
    
    // Validate question text
    if (questionTextField.value.trim().length < 5) {
        questionTextField.classList.add('is-invalid');
        isValid = false;
    }
    
    // Validate options (all must have content)
    if (optionAField.value.trim() === '') {
        optionAField.classList.add('is-invalid');
        isValid = false;
    }
    
    if (optionBField.value.trim() === '') {
        optionBField.classList.add('is-invalid');
        isValid = false;
    }
    
    if (optionCField.value.trim() === '') {
        optionCField.classList.add('is-invalid');
        isValid = false;
    }
    
    if (optionDField.value.trim() === '') {
        optionDField.classList.add('is-invalid');
        isValid = false;
    }
    
    // Validate correct answer selection
    if (correctAnswerField.value === '') {
        correctAnswerField.classList.add('is-invalid');
        isValid = false;
    }
    
    return isValid;
}