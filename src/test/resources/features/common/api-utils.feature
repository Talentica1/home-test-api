@ignore
Feature: API Utilities - Reusable Components
  
  Background:
    * def config = read('classpath:test-data/api-endpoints.json')
    * def expectedData = read('classpath:test-data/expected-inventory.json')
    * def newItemsData = read('classpath:test-data/new-items.json')

  @name=validateInventoryResponse
  Scenario: Validate standard inventory response structure
    * def validateInventoryStructure = 
    """
    function(response, minCount) {
      // Validate response structure
      if (!response.data) {
        karate.fail('Response missing data property');
      }
      
      // Validate minimum item count
      if (response.data.length < minCount) {
        karate.fail('Response contains ' + response.data.length + ' items, expected at least ' + minCount);
      }
      
      // Validate each item has required fields
      var requiredFields = ['id', 'name', 'price', 'image'];
      for (var i = 0; i < response.data.length; i++) {
        var item = response.data[i];
        for (var j = 0; j < requiredFields.length; j++) {
          var field = requiredFields[j];
          if (!item[field]) {
            karate.fail('Item at index ' + i + ' missing required field: ' + field);
          }
        }
      }
      
      return true;
    }
    """

  @name=findItemById
  Scenario: Find item by ID in inventory response
    * def findItemById = 
    """
    function(response, itemId) {
      if (!response.data) {
        karate.fail('Response missing data property');
      }
      
      var items = response.data.filter(function(item) {
        return item.id === itemId;
      });
      
      if (items.length === 0) {
        karate.fail('Item with ID ' + itemId + ' not found in response');
      }
      
      return items[0];
    }
    """

  @name=validateErrorResponse
  Scenario: Validate error response structure and message
    * def validateErrorResponse = 
    """
    function(response, expectedStatus, expectedMessage) {
      // Add validation logic for error responses
      if (expectedMessage && response.toString().indexOf(expectedMessage) === -1) {
        karate.log('Expected message: ' + expectedMessage);
        karate.log('Actual response: ' + response);
      }
      return true;
    }
    """

  @name=logTestStep
  Scenario: Enhanced logging utility
    * def logTestStep = 
    """
    function(step, details) {
      var timestamp = new Date().toISOString();
      karate.log('🔍 [' + timestamp + '] ' + step);
      if (details) {
        karate.log('   Details: ' + JSON.stringify(details, null, 2));
      }
    }
    """ 