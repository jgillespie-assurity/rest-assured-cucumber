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

# TODO: Add tests for /Account/v1/User POST
# TODO: Add tests for /Account/v1/User/{userId} DELETE

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


  Scenario: Successful GET request to BookStoreV1BooksGet
    When I make a GET request to "/BookStore/v1/Books"
    Then the response status code should be 200
    And the response body should have key "books" with more than 0 items

  Scenario: Unsuccessful GET request to BookStoreV1BooksGet when no books are found
    Given the bookstore has no books
    When I make a GET request to "/BookStore/v1/Books"
    Then the response status code should be 404
    And the response body should have key "code" with value "1207"
    And the response body should have key "message" with value "Books not found!"


  Scenario: Successful POST request to BookStoreV1BooksPost
    Given I have a valid authentication token
    And I put a valid book in the body
    When I make a POST request to "/BookStore/v1/Books"
    Then the response status code should be 201
    And the response body should have key "bookId" with a value

  Scenario: Unsuccessful POST request to BookStoreV1BooksPost when book already exists
    Given I have a valid authentication token
    And I put a valid book in the body
    And the book already exists in the bookstore
    When I make a POST request to "/BookStore/v1/Books"
    Then the response status code should be 400
    And the response body should have key "code" with value "1200"
    And the response body should have key "message" with value "Book already exists!"


  Scenario: Successful DELETE request to BookStoreV1BooksDelete
    Given I have a valid authentication token
    And a book exists in the bookstore
    When I make a DELETE request to "/BookStore/v1/Books/{bookId}"
    Then the response status code should be 204

  Scenario: Unsuccessful DELETE request to BookStoreV1BooksDelete when book does not exist
    Given I have a valid authentication token
    When I make a DELETE request to "/BookStore/v1/Books/{bookId}"
    Then the response status code should be 404
    And the response body should have key "code" with value "1205"
    And the response body should have key "message" with value "Book not found!"


  Scenario: Successful GET request to BookStoreV1BookGet
    Given I have a valid authentication token
    And a book with ISBN exists in the bookstore
    When I make a GET request to "/BookStore/v1/Books/{ISBN}"
    Then the response status code should be 200
    And the response body should have key "book" with a value

  Scenario: Unsuccessful GET request to BookStoreV1BookGet when book does not exist
    Given I have a valid authentication token
    When I make a GET request to "/BookStore/v1/Books/{ISBN}"
    Then the response status code should be 404
    And the response body should have key "code" with value "1205"
    And the response body should have key "message" with value "Book not found!"


  Scenario: Successful DELETE request to BookStoreV1BookDelete
    Given I have a valid authentication token
    And a book with ISBN exists in the bookstore
    When I make a DELETE request to "/BookStore/v1/Books/{ISBN}"
    Then the response status code should be 204

  Scenario: Unsuccessful DELETE request to BookStoreV1BookDelete when book does not exist
    Given I have a valid authentication token
    When I make a DELETE request to "/BookStore/v1/Books/{ISBN}"
    Then the response status code should be 404
    And the response body should have key "code" with value "1205"
    And the response body should have key "message" with value "Book not found!"


  Scenario: Successful PUT request to BookStoreV1BooksByISBNPut
    Given I have a valid authentication token
    And a book with ISBN exists in the bookstore
    And I put a valid book in the body
    When I make a PUT request to "/BookStore/v1/Books/{ISBN}"
    Then the response status code should be 200
    And the response body should have key "book" with a value

  Scenario: Unsuccessful PUT request to BookStoreV1BooksByISBNPut when book does not exist
    Given I have a valid authentication token
    And I put a valid book in the body
    When I make a PUT request to "/BookStore/v1/Books/{ISBN}"
    Then the response status code should be 404
    And the response body should have key "code" with value "1205"
    And the response body should have key "message" with value "Book not found!"