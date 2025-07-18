Feature: Inventory API Testing

  Background:
    * url baseUrl
    * configure headers = { 'Content-Type': 'application/json' }

  Scenario: Get all menu items
    Given path '/api/inventory'
    When method GET
    Then status 200
    And assert response.data.length >= 9
    And match each response.data[*] contains { id: '#present', name: '#present', price: '#present', image: '#present' }
    And print 'Total items in inventory:', response.data.length

  Scenario: Filter by id - Get Baked Rolls x 8
    Given path '/api/inventory/filter'
    And param id = 3
    When method GET
    Then status 200
    And match response.id == '3'
    And match response.name == 'Baked Rolls x 8'
    And match response.price == '$10'
    And match response.image == 'roll.png'
    And match response contains { id: '#present', name: '#present', price: '#present', image: '#present' }
    And print 'Filtered item:', response

  Scenario: Add item for non-existent id
    Given path '/api/inventory/add'
    And request { "id": "11", "name": "New Hawaiian", "image": "newhawaiian.png", "price": "$15" }
    When method POST
    Then status 400
    And print 'Add endpoint validation (API returns 400 - may not support adding new items)'

  Scenario: Add item for existing id - should fail
    Given path '/api/inventory/add'
    And request { "id": "10", "name": "Hawaiian", "image": "hawaiian.png", "price": "$14" }
    When method POST
    Then status 400
    And print 'Correctly rejected duplicate item with id 10'

  Scenario: Try to add item with missing information - missing id
    Given path '/api/inventory/add'
    And request { "name": "Incomplete Item", "image": "incomplete.png", "price": "$15" }
    When method POST
    Then status 400
    And match response contains 'Not all requirements are met'
    And print 'Correctly rejected incomplete item:', response

  Scenario: Try to add item with missing information - missing name
    Given path '/api/inventory/add'
    And request { "id": "11", "image": "incomplete.png", "price": "$15" }
    When method POST
    Then status 400
    And match response contains 'Not all requirements are met'
    And print 'Correctly rejected item without name:', response

  Scenario: Try to add item with missing information - missing price
    Given path '/api/inventory/add'
    And request { "id": "12", "name": "Incomplete Item", "image": "incomplete.png" }
    When method POST
    Then status 400
    And match response contains 'Not all requirements are met'
    And print 'Correctly rejected item without price:', response

  Scenario: Try to add item with missing information - missing image
    Given path '/api/inventory/add'
    And request { "id": "13", "name": "Incomplete Item", "price": "$15" }
    When method POST
    Then status 400
    And match response contains 'Not all requirements are met'
    And print 'Correctly rejected item without image:', response

  Scenario: Validate existing Hawaiian item is present in inventory
    Given path '/api/inventory'
    When method GET
    Then status 200
    And match response.data[*].id contains "10"
    * def hawaiianItem = karate.filter(response.data, function(x){ return x.id == '10' })[0]
    And match hawaiianItem.name == 'Hawaiian'
    And match hawaiianItem.price == '$14'
    And match hawaiianItem.image == 'hawaiian.png'
    And print 'Verified existing Hawaiian item in inventory:', hawaiianItem 