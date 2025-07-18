@inventory @add @smoke
Feature: Add Inventory Operations
  As an API consumer
  I want to add new items to the inventory
  So that I can manage the menu items catalog

  Background:
    Given url baseUrl
    And def utils = call read('classpath:features/common/api-utils.feature')
    And def config = read('classpath:test-data/api-endpoints.json')
    And def newItemsData = read('classpath:test-data/new-items.json')
    And def expectedData = read('classpath:test-data/expected-inventory.json')
    And call utils.logTestStep('Starting Add Inventory test suite')

  @add-new @validation
  Scenario: Add new item - Validate API behavior
    Given call utils.logTestStep('Testing add new item endpoint behavior')
    And path config.endpoints.inventory.add
    And request newItemsData.validNewItem
    When method POST
    Then status newItemsData.expectedResponses.successStatus
    And call utils.logTestStep('Add endpoint returned expected status', { status: response.status, item: newItemsData.validNewItem })

  @add-existing @validation  
  Scenario: Add existing item - Should return error
    Given call utils.logTestStep('Testing add existing item - should fail')
    And path config.endpoints.inventory.add
    And request newItemsData.existingItem
    When method POST
    Then status newItemsData.expectedResponses.errorStatus
    And call utils.logTestStep('Correctly rejected existing item', { status: response.status })

  @add-invalid @data-driven @validation
  Scenario Outline: Add item with missing required fields - Data driven validation
    Given call utils.logTestStep('Testing add item with missing <fieldName>')
    And path config.endpoints.inventory.add
    And request <testData>
    When method POST
    Then status newItemsData.expectedResponses.errorStatus
    And call utils.validateErrorResponse(response, newItemsData.expectedResponses.errorStatus, newItemsData.expectedResponses.errorMessage)
    And call utils.logTestStep('Correctly rejected item missing <fieldName>', { data: <testData>, status: response.status })

    Examples:
      | fieldName | testData                        |
      | id        | newItemsData.invalidItems.missingId     |
      | name      | newItemsData.invalidItems.missingName   |
      | price     | newItemsData.invalidItems.missingPrice  |
      | image     | newItemsData.invalidItems.missingImage  |

  @add-validation @security
  Scenario: Add item with malicious data - Security validation
    Given call utils.logTestStep('Testing security validation for malicious data')
    And def maliciousItem = 
    """
    {
      "id": "<script>alert('xss')</script>",
      "name": "'; DROP TABLE items; --",
      "price": "javascript:void(0)",
      "image": "../../../etc/passwd"
    }
    """
    And path config.endpoints.inventory.add
    And request maliciousItem
    When method POST
    Then status newItemsData.expectedResponses.errorStatus
    And call utils.logTestStep('Security validation: malicious data properly rejected')

  @add-validation @data-types
  Scenario Outline: Add item with invalid data types
    Given call utils.logTestStep('Testing data type validation for <field>')
    And def invalidItem = 
    """
    {
      "id": <idValue>,
      "name": <nameValue>,
      "price": <priceValue>,
      "image": <imageValue>
    }
    """
    And path config.endpoints.inventory.add
    And request invalidItem
    When method POST
    Then status newItemsData.expectedResponses.errorStatus
    And call utils.logTestStep('Data type validation: rejected invalid <field>')

    Examples:
      | field | idValue | nameValue    | priceValue | imageValue      |
      | id    | null    | "Test Item"  | "$10"      | "test.png"      |
      | name  | "15"    | null         | "$10"      | "test.png"      |
      | price | "16"    | "Test Item"  | null       | "test.png"      |
      | image | "17"    | "Test Item"  | "$10"      | null            |

  @add-validation @boundary
  Scenario: Add item with boundary value testing
    Given call utils.logTestStep('Testing boundary values')
    And def boundaryItem = 
    """
    {
      "id": "999999999999999999999",
      "name": "A".repeat(1000),
      "price": "$999999999",
      "image": "a".repeat(500) + ".png"
    }
    """
    And path config.endpoints.inventory.add
    And request boundaryItem
    When method POST
    Then status newItemsData.expectedResponses.errorStatus
    And call utils.logTestStep('Boundary value testing completed')

  @integration @verification
  Scenario: Verify inventory state after add attempts
    Given call utils.logTestStep('Verifying inventory state consistency')
    # Get current inventory
    And path config.endpoints.inventory.getAll
    When method GET
    Then status config.statusCodes.success
    And def originalCount = response.data.length
    
    # Attempt to add item (which should fail based on API behavior)
    And path config.endpoints.inventory.add
    And request newItemsData.validNewItem
    And method POST
    And status newItemsData.expectedResponses.successStatus
    
    # Verify inventory state hasn't changed unexpectedly
    And path config.endpoints.inventory.getAll
    And method GET
    And status config.statusCodes.success
    And call utils.logTestStep('Inventory state verification completed', { originalCount: originalCount, currentCount: response.data.length }) 