package org.example;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.json.JSONObject;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class ApiTestSteps {
    private final String rootUrl = "https://demoqa.com";

    private final DotEnv dotEnv = new DotEnv();
    private final String username = dotEnv.get("USERNAME");
    private final String password = dotEnv.get("PASSWORD");
    private final String userId = dotEnv.get("USER_ID");

    private Response response;
    private final JSONObject requestHeader = new JSONObject();
    private final JSONObject requestBody = new JSONObject();

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

    @Given("I have a valid authentication token")
    public void iHaveAValidAuthenticationToken() {
        Response response = RestAssured.given()
                .header("Content-Type", "application/json")
                .body(new JSONObject()
                        .put("userName", username)
                        .put("password", password).toString())
                .post(rootUrl + "/Account/v1/GenerateToken");

        requestHeader.put("token", response.jsonPath().getString("token"));
    }

    @When("I make a POST request to {string}")
    public void iMakeAPostRequestTo(String url) {
        RequestSpecification request = RestAssured.given()
                .header("Content-Type", "application/json")
                .body(requestBody.toString());
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
        response = request.get(rootUrl + url);
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

    @Then("the response body should have key {string} with {int} items")
    public void theResponseBodyShouldHaveKeyWithItems(String key, int itemCount) {
        assertThat(response.jsonPath().getList(key).size(), is(itemCount));
    }
}