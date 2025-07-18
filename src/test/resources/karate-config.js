function fn() {
  var env = karate.env || 'local';
  karate.log('karate.env system property was:', env);
  
  var config = {
    env: env,
    baseUrl: 'http://localhost:3100',
    timeout: 30000
  }
  
  // Environment-specific base URLs
  if (env == 'dev') {
    config.baseUrl = 'https://dev-api.example.com';
  } else if (env == 'staging') {
    config.baseUrl = 'https://staging-api.example.com';
  } else if (env == 'prod') {
    config.baseUrl = 'https://api.example.com';
  }
  
  // Configure common headers
  karate.configure('headers', { 'Content-Type': 'application/json' });
  
  // Set timeouts
  karate.configure('connectTimeout', config.timeout);
  karate.configure('readTimeout', config.timeout);
  
  karate.log('Configuration loaded for environment:', env);
  karate.log('Base URL:', config.baseUrl);
  
  return config;
} 