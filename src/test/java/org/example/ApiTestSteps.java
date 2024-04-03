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

    private Response response;
    private JSONObject requestBody = new JSONObject();

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
        requestBody = new JSONObject();
        requestBody.put("invalidKey", username);
    }

    @When("I make a POST request to {string}")
    public void iMakeAPostRequestTo(String url) {
        RequestSpecification request = RestAssured.given()
                .header("Content-Type", "application/json")
                .body(requestBody.toString());
        response = request.post(rootUrl + url);
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
}