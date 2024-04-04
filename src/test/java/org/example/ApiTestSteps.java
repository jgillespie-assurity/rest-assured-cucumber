package org.example;

import io.cucumber.java.After;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class ApiTestSteps {
    private static final String rootUrl = "https://demoqa.com";

    private static final DotEnv dotEnv = new DotEnv();
    private final String username = dotEnv.get("USERNAME");
    private static final String password = dotEnv.get("PASSWORD");
    private final String userId = dotEnv.get("USER_ID");

    private Response response;
    private final JSONObject requestHeader = new JSONObject();
    private final JSONObject requestBody = new JSONObject();

    private final String tempUserName = dotEnv.get("TEMP_USERNAME");
    private String tempUserId;
    private String addedBookISBN;

    @After
    public void cleanup() {
        // If a book was added during the test, remove all books
        if (addedBookISBN != null) {
            RestAssured.given()
                    .header("Content-Type", "application/json")
                    .auth().oauth2(getToken(username, password))
                    .pathParam("userId", userId)
                    .delete(rootUrl + "/BookStore/v1/Books?UserId={userId}");

            addedBookISBN = null;
        }

        // If temp user was created during the test, delete it
        if (tempUserId != null) {
            RestAssured.given()
                    .header("Content-Type", "application/json")
                    .auth().oauth2(getToken(tempUserName, password))
                    .pathParam("userId", tempUserId)
                    .delete(rootUrl + "/Account/v1/User/{userId}");

            tempUserId = null;
        }
    }

    public static String getToken(String username, String password) {
        Response response = RestAssured.given()
                .header("Content-Type", "application/json")
                .body(new JSONObject()
                        .put("userName", username)
                        .put("password", password).toString())
                .post(rootUrl + "/Account/v1/GenerateToken");

        return response.jsonPath().getString("token");
    }

    @Given("I put a valid username in the body")
    public void iPutAValidUsernameInTheBody() {
        requestBody.put("userName", username);
    }

    @Given("I put a valid password in the body")
    public void iPutAValidPasswordInTheBody() {
        requestBody.put("password", password);
    }

    @Given("I put an invalid password in the body")
    public void iPutAnInvalidPasswordInTheBody() {
        requestBody.put("password", "invalidPassword");
    }

    @Given("I put a valid username in an invalid body")
    public void iPutAValidUsernameInAnInvalidBody() {
        requestBody.put("invalidKey", username);
    }

    @Given("I have a valid userId")
    public void iHaveAValidUserId() {
        requestHeader.put("userId", userId);
    }

    @Given("I have a temp userId")
    public void iHaveAUserId() {
        requestHeader.put("userId", tempUserId);
    }

    @Given("I have a valid authentication token")
    public void iHaveAValidAuthenticationToken() {
        requestHeader.put("token", getToken(username, password));
    }

    @Given("I have a temp authentication token")
    public void iHaveATempAuthenticationToken() {
        requestHeader.put("token", getToken(tempUserName, password));
    }

    @Given("I put a valid userId in the body")
    public void iPutAValidUserIdInTheBody() {
        requestBody.put("userId", userId);
    }

    @Given("I put a temp username in the body")
    public void iPutATempUsernameInTheBody() {
        requestBody.put("userName", tempUserName);
    }

    @Given("I put the key {string} with value {string} in the body")
    public void iPutTheKeyWithValueInTheBody(String key, String value) {
        requestBody.put(key, value);
    }

    @Given("the temp account exists")
    public void theTestAccountExists() {
        Response response = RestAssured.given()
                .header("Content-Type", "application/json")
                .body(new JSONObject()
                        .put("userName", tempUserName)
                        .put("password", password).toString())
                .post(rootUrl + "/Account/v1/User/");

        tempUserId = response.jsonPath().getString("userID");
    }

    @Given("I put a book collection in the body with ISBN {string}")
    public void iPutABookCollectionInTheBodyWithIsbn(String isbn) {
        List<JSONObject> collectionOfIsbns = new ArrayList<>();
        JSONObject book = new JSONObject();
        book.put("isbn", isbn);
        collectionOfIsbns.add(book);
        requestBody.put("collectionOfIsbns", collectionOfIsbns);

        // Store the ISBN of the added book for cleanup
        addedBookISBN = isbn;
    }

    @Given("a book with ISBN {string}")
    public void aBookWithISBN(String isbn) {
        requestHeader.put("ISBN", isbn);
    }

    @Given("the book with ISBN {string} exists on my account")
    public void theBookWithISBNExistsOnMyAccount(String isbn) {
        String token;
        if (requestHeader.has("token")) {
            token = requestHeader.getString("token");
        } else {
            token = getToken(username, password);
        }

        List<JSONObject> collectionOfIsbns = new ArrayList<>();
        JSONObject book = new JSONObject();
        book.put("isbn", isbn);
        collectionOfIsbns.add(book);

        RestAssured.given()
                .header("Content-Type", "application/json")
                .auth().oauth2(token)
                .body(new JSONObject()
                        .put("userId", userId)
                        .put("collectionOfIsbns", collectionOfIsbns).toString())
                .post(rootUrl + "/BookStore/v1/Books/");

        // Store the ISBN of the added book for cleanup
        addedBookISBN = isbn;
    }

    @Given("I put a book in the body with ISBN {string}")
    public void iPutABookInTheBodyWithIsbn(String isbn) {
        requestBody.put("isbn", isbn);

        // Store the ISBN of the added book for cleanup
        addedBookISBN = isbn;
    }

    @When("I make a POST request to {string}")
    public void iMakeAPOSTRequestTo(String url) {
        RequestSpecification request = RestAssured.given()
                .header("Content-Type", "application/json")
                .body(requestBody.toString());
        if (requestHeader.has("token")) {
            request.auth().oauth2(requestHeader.getString("token"));
        }
        response = request.post(rootUrl + url);
    }

    @When("I make a GET request to {string}")
    public void iMakeAGETRequestTo(String url) {
        RequestSpecification request = RestAssured.given()
                .header("Content-Type", "application/json");
        if (requestHeader.has("token")) {
            request.auth().oauth2(requestHeader.getString("token"));
        }
        if (requestHeader.has("userId")) {
            request.pathParam("userId", requestHeader.getString("userId"));
        }
        if (requestHeader.has("ISBN")) {
            request.pathParam("ISBN", requestHeader.getString("ISBN"));
        }
        response = request.get(rootUrl + url);
    }

    @When("I make a PUT request to {string}")
    public void iMakeAPUTRequestTo(String url) {
        RequestSpecification request = RestAssured.given()
                .header("Content-Type", "application/json")
                .body(requestBody.toString());
        if (requestHeader.has("token")) {
            request.auth().oauth2(requestHeader.getString("token"));
        }
        if (requestHeader.has("ISBN")) {
            request.pathParam("ISBN", requestHeader.getString("ISBN"));
        }
        response = request.put(rootUrl + url);
    }

    @When("I make a DELETE request to {string}")
    public void iMakeADELETERequestTo(String url) {
        RequestSpecification request = RestAssured.given()
                .header("Content-Type", "application/json")
                .body(requestBody.toString());
        if (requestHeader.has("token")) {
            request.auth().oauth2(requestHeader.getString("token"));
        }
        if (requestHeader.has("userId")) {
            request.pathParam("userId", requestHeader.getString("userId"));
        }
        response = request.delete(rootUrl + url);
    }

    @Then("the response status code should be {int}")
    public void theResponseStatusCodeShouldBe(int statusCode) {
        assertThat(response.getStatusCode(), is(statusCode));
    }

    @Then("the response body should be {string}")
    public void theResponseBodyShouldBe(String expectedBody) {
        assertThat(response.getBody().asString(), is(expectedBody));
    }

    @Then("the response body should have key {string} with value {string}")
    public void theResponseBodyShouldHaveKeyWithValue(String key, String value) {
        assertThat(response.jsonPath().getString(key), is(value));
    }

    @Then("the response body should have key {string} with a value")
    public void theResponseBodyShouldHaveKeyWithAValue(String key) {
        assertThat(response.jsonPath().getString(key), notNullValue());
    }

    @Then("the response body should have key {string} with no value")
    public void theResponseBodyShouldHaveKeyWithNoValue(String key) {
        assertThat(response.jsonPath().getString(key), nullValue());
    }

    @Then("the response body should have key {string} with userId")
    public void theResponseBodyShouldHaveKeyWithUserId(String key) {
        theResponseBodyShouldHaveKeyWithValue(key, userId);
    }

    @Then("the response body should have key {string} with username")
    public void theResponseBodyShouldHaveKeyWithUsername(String key) {
        theResponseBodyShouldHaveKeyWithValue(key, username);
    }

    @Then("the response body should have key {string} with temp username")
    public void theResponseBodyShouldHaveKeyWithTempUsername(String key) {
        theResponseBodyShouldHaveKeyWithValue(key, tempUserName);
    }

    @Then("the response body should have key {string} with {int} items")
    public void theResponseBodyShouldHaveKeyWithItems(String key, int itemCount) {
        assertThat(response.jsonPath().getList(key).size(), is(itemCount));
    }

    @Then("the response body should have key {string} with more than {int} items")
    public void theResponseBodyShouldHaveKeyWithMoreThanItems(String key, int itemCount) {
        assertThat(response.jsonPath().getList(key).size(), greaterThan(itemCount));
    }

    @Then("the account is created")
    public void theAccountIsCreated() {
        tempUserId = response.jsonPath().getString("userID");
    }

    @Then("the account is deleted")
    public void theAccountIsDeleted() {
        tempUserId = null;
    }

}