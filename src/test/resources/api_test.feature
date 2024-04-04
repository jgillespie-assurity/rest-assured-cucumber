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


  Scenario: Successful POST request to BookStoreV1BooksPost
    Given I have a valid authentication token
    And I put a valid userId in the body
    And I put a book collection in the body with ISBN "9781449325862"
    When I make a POST request to "/BookStore/v1/Books"
    Then the response status code should be 201
    And the response body should have key "books[0].isbn" with value "9781449325862"

  Scenario: Unsuccessful POST request to BookStoreV1BooksPost when book does not exist
    Given I have a valid authentication token
    And I put a valid userId in the body
    And I put a book collection in the body with ISBN "9781449325863"
    When I make a POST request to "/BookStore/v1/Books"
    Then the response status code should be 400
    And the response body should have key "code" with value "1205"
    And the response body should have key "message" with value "ISBN supplied is not available in Books Collection!"

  Scenario: Unsuccessful POST request to BookStoreV1BooksPost when user not authorized
    Given I put a valid userId in the body
    And I put a book collection in the body with ISBN "9781449325862"
    When I make a POST request to "/BookStore/v1/Books"
    Then the response status code should be 401
    And the response body should have key "code" with value "1200"
    And the response body should have key "message" with value "User not authorized!"


  Scenario: Successful DELETE request to BookStoreV1BooksDelete
    Given I have a valid authentication token
    And I have a valid userId
    When I make a DELETE request to "/BookStore/v1/Books?UserId={userId}"
    Then the response status code should be 204

  Scenario: Unsuccessful DELETE request to BookStoreV1BooksDelete when user not authorized
    Given I have a valid userId
    When I make a DELETE request to "/BookStore/v1/Books?UserId={userId}"
    Then the response status code should be 401
    And the response body should have key "code" with value "1200"
    And the response body should have key "message" with value "User not authorized!"


  Scenario: Successful GET request to BookStoreV1BookGet
    Given a book with ISBN "9781449325862"
    When I make a GET request to "/BookStore/v1/Book?ISBN={ISBN}"
    Then the response status code should be 200
    And the response body should have key "isbn" with value "9781449325862"
    And the response body should have key "title" with value "Git Pocket Guide"
    And the response body should have key "subTitle" with value "A Working Introduction"
    And the response body should have key "author" with value "Richard E. Silverman"
    And the response body should have key "publish_date" with value "2020-06-04T08:48:39.000Z"
    And the response body should have key "publisher" with value "O'Reilly Media"
    And the response body should have key "pages" with value "234"
    And the response body should have key "description" with value "This pocket guide is the perfect on-the-job companion to Git, the distributed version control system. It provides a compact, readable introduction to Git for new users, as well as a reference to common commands and procedures for those of you with Git exp"
    And the response body should have key "website" with value "http://chimera.labs.oreilly.com/books/1230000000561/index.html"

  Scenario: Unsuccessful GET request to BookStoreV1BookGet when book does not exist
    Given a book with ISBN "9781449325863"
    When I make a GET request to "/BookStore/v1/Book?ISBN={ISBN}"
    Then the response status code should be 400
    And the response body should have key "code" with value "1205"
    And the response body should have key "message" with value "ISBN supplied is not available in Books Collection!"


  Scenario: Successful DELETE request to BookStoreV1BookDelete
    Given I have a valid authentication token
    And the book with ISBN "9781449325862" exists on my account
    And I put a valid userId in the body
    And I put a book in the body with ISBN "9781449325862"
    When I make a DELETE request to "/BookStore/v1/Book"
    Then the response status code should be 204

  Scenario: Unsuccessful DELETE request to BookStoreV1BookDelete when book does not exist
    Given I have a valid authentication token
    And I put a valid userId in the body
    And I put a book in the body with ISBN "9781449325863"
    When I make a DELETE request to "/BookStore/v1/Book"
    Then the response status code should be 400
    And the response body should have key "code" with value "1206"
    And the response body should have key "message" with value "ISBN supplied is not available in User's Collection!"

  Scenario: Unsuccessful DELETE request to BookStoreV1BookDelete when user not authorized
    Given I put a valid userId in the body
    And I put a book in the body with ISBN "9781449325862"
    When I make a DELETE request to "/BookStore/v1/Book"
    Then the response status code should be 401
    And the response body should have key "code" with value "1200"
    And the response body should have key "message" with value "User not authorized!"


  Scenario: Successful PUT request to BookStoreV1BooksByISBNPut
    Given I have a valid authentication token
    And the book with ISBN "9781449325862" exists on my account
    And a book with ISBN "9781449325862"
    And I put a valid userId in the body
    And I put a book in the body with ISBN "9781449331818"
    When I make a PUT request to "/BookStore/v1/Books/{ISBN}"
    Then the response status code should be 200
    And the response body should have key "userId" with userId
    And the response body should have key "username" with username
    And the response body should have key "books" with 1 items
    And the response body should have key "books[0].isbn" with value "9781449331818"
    And the response body should have key "books[0].title" with value "Learning JavaScript Design Patterns"
    And the response body should have key "books[0].subTitle" with value "A JavaScript and jQuery Developer's Guide"
    And the response body should have key "books[0].author" with value "Addy Osmani"
    And the response body should have key "books[0].publish_date" with value "2020-06-04T09:11:40.000Z"
    And the response body should have key "books[0].publisher" with value "O'Reilly Media"
    And the response body should have key "books[0].pages" with value "254"
    And the response body should have key "books[0].description" with value "With Learning JavaScript Design Patterns, you'll learn how to write beautiful, structured, and maintainable JavaScript by applying classical and modern design patterns to the language. If you want to keep your code efficient, more manageable, and up-to-da"
    And the response body should have key "books[0].website" with value "http://www.addyosmani.com/resources/essentialjsdesignpatterns/book/"

  Scenario: Unsuccessful PUT request to BookStoreV1BooksByISBNPut when book does not exist
    Given I have a valid authentication token
    And the book with ISBN "9781449325862" exists on my account
    And a book with ISBN "9781449325862"
    And I put a valid userId in the body
    And I put a book in the body with ISBN "9781449325863"
    When I make a PUT request to "/BookStore/v1/Books/{ISBN}"
    Then the response status code should be 400
    And the response body should have key "code" with value "1205"
    And the response body should have key "message" with value "ISBN supplied is not available in Books Collection!"

  Scenario: Unsuccessful PUT request to BookStoreV1BooksByISBNPut when book not in users collection
    Given I have a valid authentication token
    And a book with ISBN "9781449325862"
    And I put a valid userId in the body
    And I put a book in the body with ISBN "9781449331818"
    When I make a PUT request to "/BookStore/v1/Books/{ISBN}"
    Then the response status code should be 400
    And the response body should have key "code" with value "1206"
    And the response body should have key "message" with value "ISBN supplied is not available in User's Collection!"

  Scenario: Successful PUT request to BookStoreV1BooksByISBNPut when user not authorized
    Given the book with ISBN "9781449325862" exists on my account
    And a book with ISBN "9781449325862"
    And I put a valid userId in the body
    And I put a book in the body with ISBN "9781449331818"
    When I make a PUT request to "/BookStore/v1/Books/{ISBN}"
    Then the response status code should be 401
    And the response body should have key "code" with value "1200"
    And the response body should have key "message" with value "User not authorized!"