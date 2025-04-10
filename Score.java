package dz.eduquiz.model;



import java.sql.Timestamp;

public class Score {
    private int id;
    private int userId;
    private int quizId;
    private float score;
    private int completionTime;
    private Timestamp dateTaken;
    
    public Score() {
    }
    
    public Score(int userId, int quizId, float score, int completionTime) {
        this.userId = userId;
        this.quizId = quizId;
        this.score = score;
        this.completionTime = completionTime;
    }
    
    // Getters and setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getQuizId() {
        return quizId;
    }
    
    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }
    
    public float getScore() {
        return score;
    }
    
    public void setScore(float score) {
        this.score = score;
    }
    
    public int getCompletionTime() {
        return completionTime;
    }
    
    public void setCompletionTime(int completionTime) {
        this.completionTime = completionTime;
    }
    
    public Timestamp getDateTaken() {
        return dateTaken;
    }
    
    public void setDateTaken(Timestamp dateTaken) {
        this.dateTaken = dateTaken;
    }
    
    @Override
    public String toString() {
        return "Score [id=" + id + ", userId=" + userId + ", quizId=" + quizId + ", score=" + score + 
               ", completionTime=" + completionTime + ", dateTaken=" + dateTaken + "]";
    }
}