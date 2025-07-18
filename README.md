# Home Test API - Karate BDD Tests

A simple BDD testing framework for Inventory API using Karate with Java and Maven. 

**Architecture**: Separate feature files organized by functionality with a single test runner generating one unified report.

## Test Scenarios

This project implements the following test scenarios across 3 focused feature files:

1. **Get all menu items** - Validates response contains ≥9 items with required fields
2. **Filter by ID** - Gets "Baked Rolls x 8" item by ID=3  
3. **Add unique test item** - Tests API behavior for new item (API returns 400)
4. **Add existing item** - Validates rejection of duplicate ID (400 status)
5. **Add missing data** - Validates rejection when required fields are missing
6. **Verify existing item** - Confirms "Hawaiian" item exists in inventory

## Prerequisites

- **Java 22+** - [Download OpenJDK](https://openjdk.org/)
- **Maven 3.9+** - [Download Maven](https://maven.apache.org/download.cgi)
- **IDE** - IntelliJ IDEA (recommended) or Eclipse with Maven support

## IDE Setup

### IntelliJ IDEA

1. **Import Project**:
   - Open IntelliJ IDEA
   - Select "Open or Import" → Choose `pom.xml`
   - Select "Open as Project"
   - IntelliJ will auto-detect Maven and import dependencies

2. **Karate Plugin**:
   - Go to `File` → `Settings` → `Plugins`
   - Search for "Karate" and install the official plugin
   - Restart IntelliJ

3. **Run Configuration**:
   - Right-click on `InventoryApiTest.java` → "Run"
   - Or use Maven tool window: `Lifecycle` → `test`

4. **Features**:
   - Syntax highlighting for `.feature` files
   - Debug support with breakpoints
   - Built-in test runner integration

### Eclipse IDE

1. **Import Project**:
   - Open Eclipse
   - `File` → `Import` → `Maven` → `Existing Maven Projects`
   - Browse to project root and select `pom.xml`
   - Click "Finish"

2. **Karate Support**:
   - Install "Eclipse Wild Web Developer" from Eclipse Marketplace
   - Provides syntax highlighting for `.feature` files
   - Alternative: Use generic text editor for `.feature` files

3. **Run Configuration**:
   - Right-click project → `Run As` → `Maven test`
   - Or create JUnit run configuration for `InventoryApiTest.java`

4. **Maven Integration**:
   - Use Maven view: `Window` → `Show View` → `Other` → `Maven`
   - Run goals: clean, compile, test

### Test Reports Location

After running tests, the HTML reports are available in:
- `target/karate-reports/karate-summary.html`

## Project Structure

```
home-test-api/
├── pom.xml                                    # Maven configuration
├── README.md                                  # This file
└── src/test/
    ├── java/com/hometest/api/
    │   └── InventoryApiTest.java              # Single test runner for all features
    └── resources/
        ├── test-data/                         # External JSON test data
        │   ├── expected-inventory.json        # Expected response data
        │   ├── new-items.json                 # Test items for POST operations
        │   └── api-endpoints.json             # API endpoints configuration
        ├── features/                          # Separate feature files by functionality
        │   ├── get-inventory.feature          # GET operations (scenarios 1, 6)
        │   ├── filter-inventory.feature       # Filter operations (scenario 2)
        │   └── add-inventory.feature          # POST operations (scenarios 3, 4, 5)
        └── karate-config.js                   # Configuration
```

## Configuration

The API base URL is configured in `karate-config.js`:
- **Local**: `http://localhost:3100` (default)
- **Dev**: Override with `-Dkarate.env=dev`
- **Staging**: Override with `-Dkarate.env=staging` 
- **Production**: Override with `-Dkarate.env=prod`

## Running Tests

### Basic Execution

```bash
# Run all tests
mvn clean test

# Run with specific environment
mvn test -Dkarate.env=dev
```

### Environment Profiles

```bash
mvn test -Pdev          # Development environment
mvn test -Pstaging      # Staging environment  
mvn test -Prod          # Production environment
```

## Feature File Organization

### Benefits
- **Focused Feature Files**: Each file contains related scenarios (GET, Filter, Add operations)
- **Single Test Runner**: `InventoryApiTest.java` executes all features automatically
- **Unified Report**: All results combined into one comprehensive report
- **Maintainability**: Easy to locate and modify specific test scenarios
- **Parallel Execution**: Karate can run feature files in parallel when needed

### Running Specific Features

```bash
# Run all features (default)
mvn clean test

# Run specific feature file
mvn test -Dkarate.options="classpath:features/get-inventory.feature"
mvn test -Dkarate.options="classpath:features/filter-inventory.feature" 
mvn test -Dkarate.options="classpath:features/add-inventory.feature"

# Run by scenario tags
mvn test -Dkarate.options="--tags @get-all"
mvn test -Dkarate.options="--tags @filter-by-id"
mvn test -Dkarate.options="--tags @add-new"
```

## Test Reports

After execution, view the HTML report:
```
target/karate-reports/karate-summary.html
```

## API Endpoints Tested

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/inventory` | Get all menu items |
| GET | `/api/inventory/filter?id=3` | Filter item by ID |
| POST | `/api/inventory/add` | Add new item |

## Expected API Behavior

- **GET /api/inventory** returns JSON with `data` array containing items
- Each item has: `id`, `name`, `price`, `image` fields
- **GET /api/inventory/filter?id=3** returns item: "Baked Rolls x 8", price "$10"
- **POST /api/inventory/add** returns 400 status for all POST requests (current API behavior)

## Test Tags & Organization

All scenarios are tagged with `@smoke` and `@critical`, plus specific scenario tags:

### Feature Files & Tags
| Feature File | Scenarios | Tags |
|--------------|-----------|------|
| `get-inventory.feature` | Get all items, Verify existing item | `@get-all`, `@verify-added-item` |
| `filter-inventory.feature` | Filter by ID | `@filter-by-id` |
| `add-inventory.feature` | Add new (400), Add existing (400), Add missing data (400) | `@add-new`, `@add-existing`, `@add-missing-data` |

### Tag-based Execution

```bash
# Run all tests (all feature files)
mvn test

# Run specific scenarios by tag
mvn test -Dkarate.options="--tags @get-all"
mvn test -Dkarate.options="--tags @filter-by-id" 
mvn test -Dkarate.options="--tags @add-new"

# Run by priority (across all features)
mvn test -Dkarate.options="--tags @smoke"
mvn test -Dkarate.options="--tags @critical"
```

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Connection refused | Ensure API is running on `http://localhost:3100` |
| Java version | Verify Java 22+ with `java -version` |
| Maven errors | Run `mvn clean install` |

### Debug Mode

```bash
mvn test -Dkarate.options="--tags @debug" -X
```

## Sample Test Output

```
✅ Get all menu items - PASSED
✅ Filter by id - Get Baked Rolls x 8 - PASSED  
✅ Add item for non-existent id - PASSED
✅ Add item for existing id - should fail - PASSED
✅ Try to add item with missing information - PASSED
✅ Validate recently added item is present - PASSED

Tests run: 6, Failures: 0, Errors: 0, Skipped: 0
```

---

**Framework**: Karate BDD + Java 22 + Maven  
**Focus**: Core inventory API validation scenarios