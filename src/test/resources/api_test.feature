Feature: Testing of DemoQA Bookstore API

  Scenario: Successful POST request to AccountV1AuthorizedPost
    Given I put a valid username in the body
    And I put a valid password in the body
    When I make a POST request to "/Account/v1/Authorized"
    Then the response status code should be 200
    And the response body should be "true"

  Scenario: Unsuccessful POST request to AccountV1AuthorizedPost with incorrect user details
    Given I put a valid username in the body
    And I put an invalid password in the body
    When I make a POST request to "/Account/v1/Authorized"
    Then the response status code should be 404
    And the response body should have key "code" with value "1207"
    And the response body should have key "message" with value "User not found!"

  Scenario: Bad POST request to AccountV1AuthorizedPost with invalid body
    Given I put a valid username in an invalid body
    And I put a valid password in the body
    When I make a POST request to "/Account/v1/Authorized"
    Then the response status code should be 400
    And the response body should have key "code" with value "1200"
    And the response body should have key "message" with value "UserName and Password required."


  Scenario: Successful POST request to GenerateToken
    Given I put a valid username in the body
    And I put a valid password in the body
    When I make a POST request to "/Account/v1/GenerateToken"
    Then the response status code should be 200
    And the response body should have key "token"

  Scenario: Unsuccessful POST request to GenerateToken with incorrect user details
    Given I put a valid username in the body
    And I put an invalid password in the body
    When I make a POST request to "/Account/v1/GenerateToken"
    Then the response status code should be 404
    And the response body should have key "code" with value "1207"
    And the response body should have key "message" with value "User not found!"

  Scenario: Bad POST request to GenerateToken with invalid body
    Given I put a valid username in an invalid body
    And I put a valid password in the body
    When I make a POST request to "/Account/v1/GenerateToken"
    Then the response status code should be 400
    And the response body should have key "code" with value "1200"
    And the response body should have key "message" with value "UserName and Password required."