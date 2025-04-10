package dz.eduquiz.service;



import java.util.List;

import dz.eduquiz.dao.CategoryDAO;
import dz.eduquiz.model.Category;
import dz.eduquiz.util.ValidationUtil;

public class CategoryService {
    private CategoryDAO categoryDAO;
    
    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }
    
    // Create a new category
    public int createCategory(String name, String description) {
        // Validate input
        if (!ValidationUtil.isNotEmpty(name)) {
            return -1;
        }
        
        Category category = new Category();
        category.setName(name);
        category.setDescription(description);
        
        return categoryDAO.createCategory(category);
    }
    
    // Get category by ID
    public Category getCategoryById(int id) {
        if (!ValidationUtil.isPositiveInteger(id)) {
            return null;
        }
        
        return categoryDAO.getCategoryById(id);
    }
    
    // Get all categories
    public List<Category> getAllCategories() {
        return categoryDAO.getAllCategories();
    }
    
    // Update a category
    public boolean updateCategory(int id, String name, String description) {
        // Validate input
        if (!ValidationUtil.isPositiveInteger(id) || !ValidationUtil.isNotEmpty(name)) {
            return false;
        }
        
        Category category = categoryDAO.getCategoryById(id);
        if (category == null) {
            return false;
        }
        
        category.setName(name);
        category.setDescription(description);
        
        return categoryDAO.updateCategory(category);
    }
    
    // Delete a category
    public boolean deleteCategory(int id) {
        if (!ValidationUtil.isPositiveInteger(id)) {
            return false;
        }
        
        return categoryDAO.deleteCategory(id);
    }
    
    // Check if a category exists by name (for avoiding duplicates)
    public boolean categoryExistsByName(String name) {
        if (!ValidationUtil.isNotEmpty(name)) {
            return false;
        }
        
        List<Category> categories = categoryDAO.getAllCategories();
        for (Category category : categories) {
            if (category.getName().equalsIgnoreCase(name)) {
                return true;
            }
        }
        
        return false;
    }
}