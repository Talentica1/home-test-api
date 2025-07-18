function fn() {
  // Environment detection and configuration
  var env = karate.env || 'local'; // Default to local if not specified
  karate.log('🔧 Karate Environment:', env);
  
  // Load configuration data
  var configData = karate.read('classpath:test-data/api-endpoints.json');
  var testData = karate.read('classpath:test-data/expected-inventory.json');
  
  // Base configuration
  var config = {
    env: env,
    baseUrl: 'http://localhost:3100',
    timeout: 30000,
    retryConfig: {
      count: 3,
      interval: 1000
    },
    reporting: {
      enabled: true,
      screenshots: true
    }
  };

  // Environment-specific configurations
  if (env === 'local') {
    config.baseUrl = 'http://localhost:3100';
    config.timeout = 30000;
    config.debug = true;
  } else if (env === 'dev') {
    config.baseUrl = 'https://dev-api.example.com';
    config.timeout = 45000;
    config.debug = true;
  } else if (env === 'staging') {
    config.baseUrl = 'https://staging-api.example.com';
    config.timeout = 60000;
    config.debug = false;
  } else if (env === 'prod') {
    config.baseUrl = 'https://api.example.com';
    config.timeout = 90000;
    config.debug = false;
    config.retryConfig.count = 5;
  }

  // Global configuration settings
  karate.configure('connectTimeout', config.timeout);
  karate.configure('readTimeout', config.timeout);
  karate.configure('retry', config.retryConfig);
  
  // Headers configuration
  karate.configure('headers', { 
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'Karate-BDD-Tests/1.0'
  });

  // SSL and proxy settings for different environments
  if (env === 'prod') {
    karate.configure('ssl', true);
  }
  
  // Logging configuration
  if (config.debug) {
    karate.configure('logPrettyRequest', true);
    karate.configure('logPrettyResponse', true);
  }
  
  // Global utility functions
  config.utils = {
    // Generate unique ID for test data
    generateUniqueId: function() {
      return 'test_' + java.lang.System.currentTimeMillis();
    },
    
    // Wait utility
    waitFor: function(seconds) {
      java.lang.Thread.sleep(seconds * 1000);
    },
    
    // Environment checker
    isEnvironment: function(envName) {
      return env === envName;
    },
    
    // Data formatter
    formatTestData: function(data, replacements) {
      var result = JSON.parse(JSON.stringify(data));
      if (replacements) {
        Object.keys(replacements).forEach(function(key) {
          if (result[key] !== undefined) {
            result[key] = replacements[key];
          }
        });
      }
      return result;
    }
  };

  // Test data injection
  config.testData = testData;
  config.endpoints = configData.endpoints;
  config.statusCodes = configData.statusCodes;

  // Feature flags for different test types
  config.features = {
    securityTests: env !== 'local',
    performanceTests: true,
    integrationTests: env !== 'local',
    mockMode: false
  };

  // Reporting configuration
  config.reporting.environment = env;
  config.reporting.timestamp = new java.util.Date().toString();
  config.reporting.baseUrl = config.baseUrl;

  karate.log('✅ Configuration loaded successfully for environment:', env);
  karate.log('📍 Base URL:', config.baseUrl);
  karate.log('⏱️  Timeout:', config.timeout + 'ms');
  karate.log('🔄 Retry count:', config.retryConfig.count);
  
  return config;
} 