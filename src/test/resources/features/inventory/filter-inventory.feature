@inventory @filter @smoke
Feature: Filter Inventory Operations
  As an API consumer
  I want to filter inventory by specific criteria
  So that I can find specific menu items

  Background:
    Given url baseUrl
    And def utils = call read('classpath:features/common/api-utils.feature')
    And def config = read('classpath:test-data/api-endpoints.json')
    And def expectedData = read('classpath:test-data/expected-inventory.json')
    And call utils.logTestStep('Starting Filter Inventory test suite')

  @filter-by-id @critical
  Scenario: Filter inventory by valid ID - Baked Rolls x 8
    Given call utils.logTestStep('Testing filter by ID for Baked Rolls')
    And path config.endpoints.inventory.filter
    And param id = expectedData.expectedItems['3'].id
    When method GET
    Then status config.statusCodes.success
    And match response == expectedData.expectedItems['3']
    And call utils.logTestStep('Successfully filtered and validated Baked Rolls item', response)

  @filter-by-id @data-driven
  Scenario Outline: Filter inventory by ID - Data driven validation
    Given call utils.logTestStep('Testing filter by ID: <itemId>')
    And path config.endpoints.inventory.filter
    And param id = '<itemId>'
    When method GET
    Then status config.statusCodes.success
    And match response.id == '<itemId>'
    And match response.name == '<expectedName>'
    And match response.price == '<expectedPrice>'
    And match response.image == '<expectedImage>'
    And call utils.logTestStep('Validated filtered item', response)

    Examples:
      | itemId | expectedName     | expectedPrice | expectedImage |
      | 3      | Baked Rolls x 8  | $10          | roll.png      |
      | 10     | Hawaiian         | $14          | hawaiian.png  |

  @filter-by-id @negative
  Scenario: Filter inventory by non-existent ID
    Given call utils.logTestStep('Testing filter with non-existent ID')
    And path config.endpoints.inventory.filter
    And param id = '99999'
    When method GET
    Then status 404
    And call utils.logTestStep('Correctly returned 404 for non-existent ID')

  @filter-by-id @edge-cases
  Scenario Outline: Filter inventory with invalid ID formats
    Given call utils.logTestStep('Testing filter with invalid ID format: <invalidId>')
    And path config.endpoints.inventory.filter
    And param id = '<invalidId>'
    When method GET
    Then status <expectedStatus>
    And call utils.logTestStep('Handled invalid ID format correctly', { id: '<invalidId>', status: <expectedStatus> })

    Examples:
      | invalidId | expectedStatus |
      |           | 400           |
      | abc       | 400           |
      | -1        | 400           |
      | 0         | 400           |

  @filter-by-id @performance
  Scenario: Filter inventory performance validation
    Given call utils.logTestStep('Testing filter performance')
    And path config.endpoints.inventory.filter
    And param id = expectedData.expectedItems['3'].id
    When method GET
    Then status config.statusCodes.success
    And assert responseTime < 2000
    And call utils.logTestStep('Filter operation completed within performance threshold', { responseTime: responseTime }) 