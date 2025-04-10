package dz.eduquiz.util;


import java.io.IOException;

import java.util.List;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;

/**
 * Utility class for JSON serialization and deserialization
 */
public class JsonUtil {
    private static final Gson gson = new GsonBuilder().create();
    
    /**
     * Convert an object to JSON string
     */
    public static String toJson(Object object) {
        return gson.toJson(object);
    }
    
    /**
     * Convert JSON string to object
     */
    public static <T> T fromJson(String json, Class<T> classOfT) {
        return gson.fromJson(json, classOfT);
    }
    
    /**
     * Convert JSON string to list of objects
     */
    public static <T> List<T> fromJson(String json, Class<T> classOfT) throws IOException {
        Type listType = TypeToken.getParameterized(List.class, classOfT).getType();
        return gson.fromJson(json, listType);
    }
}