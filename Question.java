package dz.eduquiz.model;



public class Question {
    private int id;
    private int quizId;
    private String questionText;
    private String optionA;
    private String optionB;
    private String optionC;
    private String optionD;
    private char correctAnswer;
    
    public Question() {
    }
    
    public Question(int quizId, String questionText, String optionA, String optionB, 
                   String optionC, String optionD, char correctAnswer) {
        this.quizId = quizId;
        this.questionText = questionText;
        this.optionA = optionA;
        this.optionB = optionB;
        this.optionC = optionC;
        this.optionD = optionD;
        this.correctAnswer = correctAnswer;
    }
    
    // Getters and setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getQuizId() {
        return quizId;
    }
    
    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }
    
    public String getQuestionText() {
        return questionText;
    }
    
    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }
    
    public String getOptionA() {
        return optionA;
    }
    
    public void setOptionA(String optionA) {
        this.optionA = optionA;
    }
    
    public String getOptionB() {
        return optionB;
    }
    
    public void setOptionB(String optionB) {
        this.optionB = optionB;
    }
    
    public String getOptionC() {
        return optionC;
    }
    
    public void setOptionC(String optionC) {
        this.optionC = optionC;
    }
    
    public String getOptionD() {
        return optionD;
    }
    
    public void setOptionD(String optionD) {
        this.optionD = optionD;
    }
    
    public char getCorrectAnswer() {
        return correctAnswer;
    }
    
    public void setCorrectAnswer(char correctAnswer) {
        this.correctAnswer = correctAnswer;
    }
    
    @Override
    public String toString() {
        return "Question [id=" + id + ", quizId=" + quizId + ", questionText=" + questionText + 
               ", correctAnswer=" + correctAnswer + "]";
    }
}
