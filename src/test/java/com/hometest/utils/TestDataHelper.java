package com.hometest.utils;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

/**
 * Test Data Helper utility class for Karate BDD tests
 * Provides common operations for test data management and validation
 */
public class TestDataHelper {
    
    private static final ObjectMapper objectMapper = new ObjectMapper();
    
    /**
     * Load JSON test data from classpath
     * @param resourcePath path to JSON file
     * @return JsonNode containing the data
     */
    public static JsonNode loadTestData(String resourcePath) {
        try {
            InputStream inputStream = TestDataHelper.class
                .getClassLoader()
                .getResourceAsStream(resourcePath);
            
            if (inputStream == null) {
                throw new RuntimeException("Test data file not found: " + resourcePath);
            }
            
            return objectMapper.readTree(inputStream);
        } catch (Exception e) {
            throw new RuntimeException("Failed to load test data from: " + resourcePath, e);
        }
    }
    
    /**
     * Generate unique test item with timestamp
     * @param baseItem base item data
     * @return Map with unique item data
     */
    public static Map<String, Object> generateUniqueItem(Map<String, Object> baseItem) {
        Map<String, Object> uniqueItem = new HashMap<>(baseItem);
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        
        uniqueItem.put("id", uniqueItem.get("id") + "_" + timestamp);
        uniqueItem.put("name", uniqueItem.get("name") + " " + timestamp);
        
        return uniqueItem;
    }
    
    /**
     * Create test report metadata
     * @param testName name of the test
     * @param environment test environment
     * @return Map with metadata
     */
    public static Map<String, Object> createTestMetadata(String testName, String environment) {
        Map<String, Object> metadata = new HashMap<>();
        metadata.put("testName", testName);
        metadata.put("environment", environment);
        metadata.put("timestamp", LocalDateTime.now().toString());
        metadata.put("javaVersion", System.getProperty("java.version"));
        metadata.put("osName", System.getProperty("os.name"));
        
        return metadata;
    }
    
    /**
     * Validate required fields in response
     * @param response response data
     * @param requiredFields array of required field names
     * @return validation result
     */
    public static boolean validateRequiredFields(JsonNode response, String[] requiredFields) {
        for (String field : requiredFields) {
            if (!response.has(field) || response.get(field).isNull()) {
                throw new AssertionError("Required field missing or null: " + field);
            }
        }
        return true;
    }
    
    /**
     * Generate test summary
     * @param totalTests total number of tests
     * @param passedTests number of passed tests
     * @param failedTests number of failed tests
     * @return formatted summary string
     */
    public static String generateTestSummary(int totalTests, int passedTests, int failedTests) {
        return String.format(
            "🧪 Test Summary: %d total | ✅ %d passed | ❌ %d failed | 📊 %.1f%% success rate",
            totalTests, passedTests, failedTests, 
            totalTests > 0 ? (passedTests * 100.0 / totalTests) : 0.0
        );
    }
} 