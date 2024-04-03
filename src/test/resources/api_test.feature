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


  Scenario: Successful POST request to AccountV1GenerateToken
    Given I put a valid username in the body
    And I put a valid password in the body
    When I make a POST request to "/Account/v1/GenerateToken"
    Then the response status code should be 200
    And the response body should have key "token" with a value
    And the response body should have key "expires" with a value
    And the response body should have key "status" with value "Success"
    And the response body should have key "result" with value "User authorized successfully."

  Scenario: Unsuccessful POST request to AccountV1GenerateToken with incorrect user details
    Given I put a valid username in the body
    And I put an invalid password in the body
    When I make a POST request to "/Account/v1/GenerateToken"
    Then the response status code should be 200
    And the response body should have key "token" with no value
    And the response body should have key "expires" with no value
    And the response body should have key "status" with value "Failed"
    And the response body should have key "result" with value "User authorization failed."

  Scenario: Bad POST request to AccountV1GenerateToken with invalid body
    Given I put a valid username in an invalid body
    And I put a valid password in the body
    When I make a POST request to "/Account/v1/GenerateToken"
    Then the response status code should be 400
    And the response body should have key "code" with value "1200"
    And the response body should have key "message" with value "UserName and Password required."


  Scenario: Successful GET request to AccountV1UserByUserIdGet
    Given I have a valid userId
    And I have a valid authentication token
    When I make a GET request to "/Account/v1/User/{userId}"
    Then the response status code should be 200
    And the response body should have key "userId" with userId
    And the response body should have key "username" with username
    And the response body should have key "books" with 0 items

  Scenario: Unsuccessful GET request to AccountV1UserByUserIdGet with no authentication token
    Given I have a valid userId
    When I make a GET request to "/Account/v1/User/{userId}"
    Then the response status code should be 401
    And the response body should have key "code" with value "1200"
    And the response body should have key "message" with value "User not authorized!"