function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  
  if (!env) {
    env = 'dev';
  }
  
  var config = {
    env: env,
    baseUrl: 'http://localhost:3100/',
    timeout: 30000
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