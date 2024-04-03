Feature: API testing with RestAssured

  Scenario: Successful GET request
    Given I make a GET request to "https://demoqa.com/BookStore/v1/Books"
    Then the response status code should be 200