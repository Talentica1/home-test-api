@smoke @critical
Feature: Filter Inventory Operations
  As an API consumer
  I want to filter inventory by specific criteria
  So that I can find specific items

  Background:
    Given url baseUrl
    And def testData = read('classpath:test-data/expected-inventory.json')
    And def newItemsData = read('classpath:test-data/new-items.json')
    And def apiConfig = read('classpath:test-data/api-endpoints.json')

  @filter-by-id
  Scenario: Filter by id - Get Baked Rolls x 8
    Given path apiConfig.endpoints.filter
    And param id = apiConfig.parameters.filterId
    When method GET
    Then status 200
    And match response.id == testData.expectedItems.bakedRolls.id
    And match response.name == testData.expectedItems.bakedRolls.name
    And match response.price == testData.expectedItems.bakedRolls.price
    And match response.image == testData.expectedItems.bakedRolls.image
    And print 'Successfully filtered item:', response 