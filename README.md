# 🧪 Enterprise-Grade Karate BDD Testing Framework

[![Java](https://img.shields.io/badge/Java-22-orange.svg)](https://www.oracle.com/java/)
[![Karate](https://img.shields.io/badge/Karate-1.5.1-green.svg)](https://github.com/karatelabs/karate)
[![Maven](https://img.shields.io/badge/Maven-3.9+-blue.svg)](https://maven.apache.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A comprehensive, industry-standard BDD testing framework for Inventory API using Karate with modular architecture, external test data management, and enterprise-grade best practices.

## 📋 Table of Contents

- [🏗️ Architecture Overview](#-architecture-overview)
- [🚀 Quick Start](#-quick-start)
- [📁 Project Structure](#-project-structure)
- [⚙️ Configuration](#-configuration)
- [🧪 Test Execution](#-test-execution)
- [📊 Test Categories](#-test-categories)
- [🔧 Advanced Usage](#-advanced-usage)
- [📈 Reporting](#-reporting)
- [🔐 Security](#-security)
- [🚀 CI/CD Integration](#-cicd-integration)

## 🏗️ Architecture Overview

This framework implements industry best practices with:

- **Modular Feature Files**: Separated by functionality (GET, POST, Filter operations)
- **External Test Data**: JSON-based test data management
- **Reusable Components**: Common utilities and validation functions
- **Environment Management**: Multi-environment configuration support
- **Tag-based Execution**: Organized test execution by categories
- **Comprehensive Reporting**: Enhanced HTML reports with detailed insights

### 🎯 Key Features

- ✅ **Data-Driven Testing** with external JSON files
- ✅ **Modular Architecture** for maintainability
- ✅ **Multi-Environment Support** (local, dev, staging, prod)
- ✅ **Parallel Test Execution** capabilities
- ✅ **Comprehensive Validation** (functional, security, performance)
- ✅ **Industry-Standard Patterns** and conventions

## 🚀 Quick Start

### Prerequisites

- **Java 22+** - [Download OpenJDK](https://openjdk.org/)
- **Maven 3.9+** - [Download Maven](https://maven.apache.org/download.cgi)
- **Git** - [Download Git](https://git-scm.com/)

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/home-test-api.git
cd home-test-api

# Verify Java and Maven installation
java -version
mvn -version

# Run all tests
mvn clean test

# Run specific test categories
mvn test -Psmoke          # Smoke tests only
mvn test -Pcritical       # Critical tests only
mvn test -Pperformance    # Performance tests only
```

## 📁 Project Structure

```
home-test-api/
├── 📄 pom.xml                                    # Maven configuration with profiles
├── 📄 README.md                                  # This comprehensive guide
├── 📄 .gitignore                                # Git ignore patterns
└── 📁 src/test/
    ├── 📁 java/com/hometest/
    │   ├── 📁 api/
    │   │   └── 📄 InventoryTestSuite.java        # Main test suite runner
    │   └── 📁 utils/
    │       └── 📄 TestDataHelper.java            # Java utility functions
    └── 📁 resources/
        ├── 📄 karate-config.js                   # Enhanced environment configuration
        ├── 📄 application.properties             # Application settings
        ├── 📁 test-data/                        # 🎯 External JSON test data
        │   ├── 📄 expected-inventory.json        # Expected response data
        │   ├── 📄 new-items.json                # Test items for POST operations
        │   └── 📄 api-endpoints.json            # API endpoints configuration
        └── 📁 features/
            ├── 📁 common/
            │   └── 📄 api-utils.feature          # Reusable utility functions
            └── 📁 inventory/                     # 🎯 Modular feature files
                ├── 📄 get-inventory.feature      # GET operations & validation
                ├── 📄 filter-inventory.feature   # Filter & search operations
                └── 📄 add-inventory.feature      # POST operations & validation
```

## ⚙️ Configuration

### Environment Management

The framework supports multiple environments with different configurations:

```javascript
// karate-config.js - Environment-specific settings
{
  "local":   { baseUrl: "http://localhost:3100",     timeout: 30000 },
  "dev":     { baseUrl: "https://dev-api.example.com", timeout: 45000 },
  "staging": { baseUrl: "https://staging-api.example.com", timeout: 60000 },
  "prod":    { baseUrl: "https://api.example.com",   timeout: 90000 }
}
```

### Test Data Management

External JSON files manage all test data:

```json
// test-data/expected-inventory.json
{
  "minItemCount": 9,
  "requiredFields": ["id", "name", "price", "image"],
  "expectedItems": {
    "3": {
      "id": "3",
      "name": "Baked Rolls x 8",
      "price": "$10",
      "image": "roll.png"
    }
  }
}
```

## 🧪 Test Execution

### Basic Execution

```bash
# Run all tests
mvn clean test

# Run with specific environment
mvn test -Dkarate.env=dev

# Run with Maven profiles
mvn test -Psmoke                    # Smoke tests
mvn test -Pcritical                 # Critical path tests
mvn test -Pperformance              # Performance tests
mvn test -Psecurity                 # Security validation tests
```

### Advanced Execution

```bash
# Parallel execution for faster results
mvn test -Pparallel

# Combine environment and test type
mvn test -Pdev,smoke

# Run specific feature file
mvn test -Dtest=InventoryTestSuite#getInventoryTests

# Debug mode with detailed logging
mvn test -Dkarate.env=local -Dkarate.options="--tags @debug"
```

### Tag-Based Execution

```bash
# Execute by functionality
mvn test -Dkarate.options="--tags @get"         # GET operations only
mvn test -Dkarate.options="--tags @add"         # POST operations only
mvn test -Dkarate.options="--tags @filter"      # Filter operations only

# Execute by priority
mvn test -Dkarate.options="--tags @critical"    # Critical tests
mvn test -Dkarate.options="--tags @smoke"       # Smoke tests

# Execute by test type
mvn test -Dkarate.options="--tags @validation"  # Validation tests
mvn test -Dkarate.options="--tags @security"    # Security tests
mvn test -Dkarate.options="--tags @performance" # Performance tests
```

## 📊 Test Categories

### 🎯 Test Tags Organization

| Tag | Purpose | Features |
|-----|---------|----------|
| `@smoke` | Quick validation | Core functionality verification |
| `@critical` | Essential flows | Business-critical path testing |
| `@get` | GET operations | Inventory retrieval and validation |
| `@filter` | Search/Filter | Item filtering and search functionality |
| `@add` | POST operations | Item creation and validation |
| `@validation` | Data validation | Field validation and error handling |
| `@security` | Security testing | Input sanitization and security checks |
| `@performance` | Performance | Response time and load validation |
| `@data-driven` | Data variations | Multiple data sets and edge cases |
| `@negative` | Error scenarios | Invalid inputs and error conditions |

### 📋 Test Scenarios Coverage

#### GET Inventory Operations
- ✅ Retrieve all menu items (minimum 9 items)
- ✅ Validate response structure and required fields
- ✅ Data integrity verification for specific items
- ✅ Response time performance validation
- ✅ Response headers validation

#### Filter Operations
- ✅ Filter by valid item ID
- ✅ Data-driven validation with multiple items
- ✅ Non-existent ID handling (404 scenarios)
- ✅ Invalid ID format validation
- ✅ Performance benchmarking

#### Add Operations
- ✅ Add new item validation
- ✅ Duplicate item rejection (400 status)
- ✅ Missing required fields validation
- ✅ Security validation (XSS, SQL injection)
- ✅ Data type validation
- ✅ Boundary value testing
- ✅ Integration state verification

## 🔧 Advanced Usage

### Custom Test Data

Create environment-specific test data:

```bash
# Create custom test data
mkdir src/test/resources/test-data/environments
echo '{"customItem": {"id": "999", "name": "Custom Item"}}' > src/test/resources/test-data/environments/dev-data.json
```

### Extending Utilities

Add custom utility functions:

```java
// src/test/java/com/hometest/utils/CustomHelper.java
public class CustomHelper {
    public static String generateTestData() {
        // Custom logic here
        return "custom-data";
    }
}
```

### Custom Validation

Add custom validation in feature files:

```gherkin
# Custom validation scenario
@custom @validation
Scenario: Custom business rule validation
  * def customValidator = 
  """
  function(response) {
    // Custom validation logic
    return response.someField === 'expectedValue';
  }
  """
  * assert customValidator(response)
```

## 📈 Reporting

### HTML Reports

After test execution, comprehensive reports are generated:

```bash
# Main report location
target/karate-reports/karate-summary.html

# Individual feature reports
target/karate-reports/[feature-name].html
```

### Report Features

- 📊 **Test Summary**: Pass/fail statistics with visual indicators
- 🕒 **Execution Timeline**: Detailed timing information
- 📝 **Request/Response**: Complete HTTP transaction details
- 🖼️ **Screenshots**: Visual evidence for failed tests
- 📋 **Tags Summary**: Results organized by test categories
- 🌍 **Environment Info**: Configuration and environment details

### CI/CD Integration Reports

```bash
# Generate JUnit XML for CI/CD
mvn test -Dkarate.options="--format junit:target/karate-reports"

# Generate custom JSON reports
mvn test -Dkarate.options="--format json:target/karate-reports"
```

## 🔐 Security

### Security Testing Features

- **Input Validation**: XSS and injection attack prevention
- **Data Sanitization**: Malicious input handling
- **Authentication**: Token-based security testing
- **Authorization**: Role-based access validation
- **SSL/TLS**: Secure communication verification

### Security Test Examples

```gherkin
@security
Scenario: XSS Prevention Validation
  * def maliciousPayload = '<script>alert("xss")</script>'
  * request { id: maliciousPayload, name: 'Test Item' }
  * method POST
  * status 400
```

## 🚀 CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/api-tests.yml
name: API Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          java-version: '22'
      - name: Run Smoke Tests
        run: mvn test -Psmoke
      - name: Run Critical Tests
        run: mvn test -Pcritical
```

### Jenkins Pipeline

```groovy
pipeline {
    agent any
    stages {
        stage('Test') {
            parallel {
                stage('Smoke Tests') {
                    steps {
                        sh 'mvn test -Psmoke'
                    }
                }
                stage('Critical Tests') {
                    steps {
                        sh 'mvn test -Pcritical'
                    }
                }
            }
        }
    }
    post {
        always {
            publishHTML([
                allowMissing: false,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'target/karate-reports',
                reportFiles: 'karate-summary.html',
                reportName: 'Karate Test Report'
            ])
        }
    }
}
```

### Docker Integration

```dockerfile
# Dockerfile
FROM openjdk:22-jdk-slim
COPY . /app
WORKDIR /app
RUN ./mvnw test -Psmoke
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the established patterns and conventions
4. Add appropriate tests and documentation
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 📝 Best Practices

### ✅ Do's
- Use meaningful scenario names and descriptions
- Implement data-driven testing for comprehensive coverage
- Add appropriate tags for test organization
- Use external test data files for maintainability
- Include performance and security validations
- Write reusable utility functions

### ❌ Don'ts
- Don't hardcode test data in feature files
- Don't create monolithic feature files
- Don't skip error scenario testing
- Don't ignore performance implications
- Don't mix test environments in the same execution

## 🔧 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Java version conflicts | Ensure Java 22+ is installed and JAVA_HOME is set |
| Maven dependency errors | Run `mvn clean install -U` to update dependencies |
| Test data not found | Verify JSON files exist in `test-data/` directory |
| Environment config issues | Check `karate-config.js` environment settings |
| Network timeouts | Adjust timeout values in configuration |

### Debug Mode

```bash
# Enable detailed logging
mvn test -Dkarate.env=local -Dkarate.options="--tags @debug" -X
```

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/your-username/home-test-api/issues)
- **Documentation**: [Karate Documentation](https://github.com/karatelabs/karate)
- **Community**: [Karate Discussions](https://github.com/karatelabs/karate/discussions)

---

**Made with ❤️ using Karate BDD Framework**

*This framework demonstrates enterprise-grade testing practices with comprehensive validation, modular architecture, and industry-standard patterns.*