@inventory @get @smoke
Feature: Get Inventory Operations
  As an API consumer
  I want to retrieve inventory information
  So that I can display available menu items

  Background:
    Given url baseUrl
    And def utils = call read('classpath:features/common/api-utils.feature')
    And def config = read('classpath:test-data/api-endpoints.json')
    And def expectedData = read('classpath:test-data/expected-inventory.json')
    And call utils.logTestStep('Starting Get Inventory test suite')

  @get-all @critical
  Scenario: Get all menu items - Validate response structure and minimum count
    Given call utils.logTestStep('Testing GET all inventory items')
    And path config.endpoints.inventory.getAll
    When method GET
    Then status config.statusCodes.success
    And call utils.validateInventoryStructure(response, expectedData.minItemCount)
    And match response.data.length >= expectedData.minItemCount
    And call utils.logTestStep('Validated inventory contains minimum required items', { count: response.data.length, minimum: expectedData.minItemCount })
    
    # Validate each item has required fields
    And match each response.data[*] contains { id: '#present', name: '#present', price: '#present', image: '#present' }
    And call utils.logTestStep('All items contain required fields', { fields: expectedData.requiredFields })

  @get-all @data-validation
  Scenario: Get all menu items - Validate specific item data integrity
    Given call utils.logTestStep('Testing data integrity of specific items')
    And path config.endpoints.inventory.getAll
    When method GET
    Then status config.statusCodes.success
    
    # Validate specific expected items exist with correct data
    And def hawaiianItem = call utils.findItemById(response, expectedData.expectedItems['10'].id)
    And match hawaiianItem == expectedData.expectedItems['10']
    And call utils.logTestStep('Validated Hawaiian item data', hawaiianItem)

  @get-all @performance
  Scenario: Get all menu items - Response time validation
    Given call utils.logTestStep('Testing response time performance')
    And path config.endpoints.inventory.getAll
    When method GET
    Then status config.statusCodes.success
    And assert responseTime < config.timeouts.read
    And call utils.logTestStep('Response time within acceptable limits', { responseTime: responseTime, limit: config.timeouts.read })

  @get-all @response-headers
  Scenario: Get all menu items - Validate response headers
    Given call utils.logTestStep('Testing response headers')
    And path config.endpoints.inventory.getAll
    When method GET
    Then status config.statusCodes.success
    And match header Content-Type == config.headers.contentType + '; charset=utf-8'
    And call utils.logTestStep('Response headers validated successfully') 