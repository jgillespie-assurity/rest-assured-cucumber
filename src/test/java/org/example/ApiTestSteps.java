package org.example;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class ApiTestSteps {
    private final String rootUrl = "https://demoqa.com";
    private Response response;
    private RequestSpecification request;

    @Given("I am authorized")
    public void iAmAuthorized() {
        request = RestAssured.given().auth().preemptive().basic("username", "password");
    }

    @Given("I am not authorized")
    public void iAmNotAuthorized() {
        request = RestAssured.given();
    }

    @Given("I have an invalid body for the request")
    public void iHaveAnInvalidBodyForTheRequest() {
        request.body("invalid body");
    }

    @When("I make a POST request to {string}")
    public void iMakeAPostRequestTo(String url) {
        response = request.post(rootUrl + url);
    }

    @Then("the response status code should be {int}")
    public void theResponseStatusCodeShouldBe(int statusCode) {
        assertEquals(statusCode, response.getStatusCode());
    }

    @Then("the response body should contain the expected data")
    public void theResponseBodyShouldContainTheExpectedData() {
        // This is a placeholder. You should replace this with the actual assertion
        // that checks the response body contains the expected data.
        assertTrue(response.getBody().asString().contains("expected data"));
    }
}