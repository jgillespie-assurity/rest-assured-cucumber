Feature: Testing of DemoQA Bookstore API

  Scenario: Successful POST request to AccountV1AuthorizedPost
    Given I am authorized
    When I make a POST request to "/Account/v1/Authorized"
    Then the response status code should be 200
    And the response body should contain the expected data

  Scenario: Unsuccessful POST request to AccountV1AuthorizedPost with unauthorized user
    Given I am not authorized
    When I make a POST request to "/Account/v1/Authorized"
    Then the response status code should be 401

Scenario: Bad POST request to AccountV1AuthorizedPost with invalid body
  Given I am authorized
  And I have an invalid body for the request
  When I make a POST request to "/Account/v1/Authorized"
  Then the response status code should be 400