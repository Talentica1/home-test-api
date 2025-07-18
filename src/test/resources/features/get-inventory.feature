@smoke @critical
Feature: Get Inventory Operations
  As an API consumer
  I want to retrieve inventory data
  So that I can view available items

  Background:
    Given url baseUrl
    And def testData = read('classpath:test-data/expected-inventory.json')
    And def newItemsData = read('classpath:test-data/new-items.json')
    And def apiConfig = read('classpath:test-data/api-endpoints.json')

  @get-all
  Scenario: Get all menu items
    Given path apiConfig.endpoints.getAll
    When method GET
    Then status 200
    And assert response.data.length >= testData.minItemCount
    And match each response.data[*] contains { id: '#present', name: '#present', price: '#present', image: '#present' }
    And print 'Validated inventory contains', response.data.length, 'items (minimum required:', testData.minItemCount, ')'

  @verify-added-item
  Scenario: Validate recently added item is present in inventory
    Given path apiConfig.endpoints.getAll
    When method GET
    Then status 200
    And match response.data[*].id contains testData.expectedItems.hawaiian.id
    * def addedItem = karate.filter(response.data, function(x){ return x.id == testData.expectedItems.hawaiian.id })[0]
    And match addedItem.name == testData.expectedItems.hawaiian.name
    And match addedItem.price == testData.expectedItems.hawaiian.price
    And match addedItem.image == testData.expectedItems.hawaiian.image
    And print 'Verified recently added item exists in inventory:'
    And print 'ID:', addedItem.id, '| Name:', addedItem.name, '| Price:', addedItem.price
    And print 'Expected data matches actual response - item successfully verified in inventory!' 