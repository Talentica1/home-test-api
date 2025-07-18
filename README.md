# Home Test API - Karate BDD Testing Framework

This project implements BDD (Behavior Driven Development) testing for an Inventory API using Karate framework with Java and Maven.

## Project Structure

```
home-test-api/
├── pom.xml                                    # Maven configuration with Karate dependencies
├── src/
│   └── test/
│       ├── java/
│       │   └── com/hometest/api/
│       │       └── InventoryApiTest.java      # JUnit 5 test runner
│       └── resources/
│           ├── features/
│           │   └── inventory-api.feature      # Gherkin test scenarios
│           └── karate-config.js               # Karate configuration
└── README.md                                  # This file
```

## Prerequisites

- **Java 11 or higher** - Download from [OpenJDK](https://openjdk.org/install/) or [Oracle](https://www.oracle.com/java/technologies/downloads/)
- **Maven 3.6+** - Download from [Apache Maven](https://maven.apache.org/download.cgi)
- **Git** (optional) - For version control

Verify installations:
```bash
java -version
mvn -version
```

## API Configuration

Before running the tests, update the base URL in `src/test/resources/karate-config.js`:

```javascript
// Update these URLs to point to your actual API endpoints
if (env == 'dev') {
  config.baseUrl = 'http://localhost:3100/';  // Replace with your API URL
}
```

## Test Scenarios Covered

The test suite validates the following API endpoints and scenarios:

### 1. **Get All Menu Items**
- **Endpoint**: `GET /api/inventory`
- **Validations**:
  - Response contains at least 9 items
  - Each item has required fields: `id`, `name`, `price`, `image`

### 2. **Filter by ID**
- **Endpoint**: `GET /api/inventory/filter?id=3`
- **Validations**:
  - Returns correct item data for "Baked Rolls x 8"
  - Validates all required fields are present

### 3. **Add New Item (Success)**
- **Endpoint**: `POST /api/inventory/add`
- **Body**: `{"id": "10", "name": "Hawaiian", "image": "hawaiian.png", "price": "$14"}`
- **Validation**: Status code 200

### 4. **Add Existing Item (Failure)**
- **Endpoint**: `POST /api/inventory/add`
- **Body**: Same as above (duplicate ID)
- **Validation**: Status code 400

### 5. **Add Item with Missing Data**
- **Endpoint**: `POST /api/inventory/add`
- **Scenarios**: Missing `id`, `name`, `price`, or `image`
- **Validations**:
  - Status code 400
  - Response contains "Not all requirements are met"

### 6. **Verify Added Item in Inventory**
- **Endpoint**: `GET /api/inventory`
- **Validation**: Confirms the Hawaiian item was successfully added with correct data

## Building the Project

1. **Clone or navigate to the project directory**:
```bash
cd home-test-api
```

2. **Download dependencies**:
```bash
mvn clean compile
```

3. **Compile test classes**:
```bash
mvn test-compile
```

## Running the Tests

### Run All Tests
```bash
mvn test
```

### Run Tests with Specific Environment
```bash
# For development environment
mvn test -Dkarate.env=dev

# For QA environment
mvn test -Dkarate.env=qa

# For production environment
mvn test -Dkarate.env=prod
```

### Run Tests with Custom Base URL
```bash
mvn test -DbaseUrl=https://your-custom-api-url.com
```

### Run with Detailed Output
```bash
mvn test -Dkarate.options="--tags ~@ignore" -X
```

### Generate HTML Test Report
```bash
mvn test
```
The HTML report will be generated in `target/karate-reports/karate-summary.html`

## Karate Options

### Running Specific Scenarios
Add tags to scenarios in the feature file and run:
```bash
mvn test -Dkarate.options="--tags @smoke"
```

### Parallel Execution
For faster execution with multiple threads:
```bash
mvn test -Dkarate.options="--threads 5"
```

## Configuration Options

### Environment Variables
Set these in your environment or pass as system properties:

- `karate.env` - Environment (dev/qa/prod)
- `baseUrl` - API base URL override
- `karate.options` - Additional Karate options

### karate-config.js Settings
- **Timeouts**: Connection and read timeouts (default: 30 seconds)
- **Headers**: Default Content-Type and other headers
- **Environment URLs**: Different base URLs per environment

## Troubleshooting

### Common Issues

1. **Connection Timeout**:
   - Increase timeout in `karate-config.js`
   - Check if API URL is accessible

2. **SSL Certificate Issues**:
   ```bash
   mvn test -Dkarate.options="--ssl false"
   ```

3. **Maven Dependencies**:
   ```bash
   mvn dependency:resolve
   mvn clean install
   ```

4. **Java Version Issues**:
   - Ensure Java 11+ is installed and JAVA_HOME is set correctly

### Debug Mode
Run with debug information:
```bash
mvn test -Dkarate.options="--debug" -X
```

## Continuous Integration

For CI/CD pipelines, use:
```bash
mvn clean test -Dkarate.env=qa -Dmaven.test.failure.ignore=false
```

## Test Reports

After running tests, check:
- **Console Output**: Real-time test execution logs
- **HTML Report**: `target/karate-reports/karate-summary.html`
- **JSON Report**: `target/karate-reports/karate-summary.json`
- **JUnit XML**: `target/surefire-reports/`

## Contributing

1. Add new test scenarios to `src/test/resources/features/inventory-api.feature`
2. Update base URLs in `karate-config.js` as needed
3. Run tests locally before committing
4. Ensure all tests pass in the target environment

## Dependencies

- **Karate**: 1.4.1 - BDD testing framework
- **JUnit 5**: 5.9.2 - Test runner
- **Maven Surefire**: 3.0.0-M9 - Test execution plugin

## Support

For issues or questions:
1. Check the console output for detailed error messages
2. Verify API endpoints are accessible
3. Review Karate documentation: [https://github.com/karatelabs/karate](https://github.com/karatelabs/karate)