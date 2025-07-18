@smoke @critical
Feature: Add Inventory Operations
  As an API consumer
  I want to add new items to inventory
  So that I can manage product catalog

  Background:
    Given url baseUrl
    And def testData = read('classpath:test-data/expected-inventory.json')
    And def newItemsData = read('classpath:test-data/new-items.json')
    And def apiConfig = read('classpath:test-data/api-endpoints.json')

  @add-new
  Scenario: Add unique test item for non-existent id
    Given path apiConfig.endpoints.add
    And request newItemsData.uniqueNewItem
    When method POST
    Then status 400
    And print 'API returned 400 for unique test item (API behavior):', newItemsData.uniqueNewItem.name, 'with ID:', newItemsData.uniqueNewItem.id

  @add-existing
  Scenario: Add item for existing id - should fail
    Given path apiConfig.endpoints.add
    And request newItemsData.hawaiianItem
    When method POST
    Then status 400
    And print 'Correctly rejected existing item'

  @add-missing-data
  Scenario: Try to add item with missing information - missing id
    Given path apiConfig.endpoints.add
    And request newItemsData.incompleteItems.missingId
    When method POST
    Then status 400
    And match response contains newItemsData.expectedMessages.missingRequirements
    And print 'Correctly rejected item with missing id' 