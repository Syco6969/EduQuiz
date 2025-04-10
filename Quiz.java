package dz.eduquiz.model;



public class Quiz {
    private int id;
    private String title;
    private String description;
    private int categoryId;
    private String difficulty;
    private int timeLimit;
    
    public Quiz() {
    }
    
    public Quiz(String title, String description, int categoryId, String difficulty, int timeLimit) {
        this.title = title;
        this.description = description;
        this.categoryId = categoryId;
        this.difficulty = difficulty;
        this.timeLimit = timeLimit;
    }
    
    // Getters and setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public int getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public String getDifficulty() {
        return difficulty;
    }
    
    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }
    
    public int getTimeLimit() {
        return timeLimit;
    }
    
    public void setTimeLimit(int timeLimit) {
        this.timeLimit = timeLimit;
    }
    
    @Override
    public String toString() {
        return "Quiz [id=" + id + ", title=" + title + ", categoryId=" + categoryId + 
               ", difficulty=" + difficulty + ", timeLimit=" + timeLimit + "]";
    }
}
