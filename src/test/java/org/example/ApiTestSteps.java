package org.example;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.restassured.RestAssured;
import io.restassured.response.Response;

import static org.junit.Assert.assertEquals;

public class ApiTestSteps {
    private Response response;

    @Given("I make a GET request to {string}")
    public void iMakeAGETRequestTo(String url) {
        response = RestAssured.get(url);
    }

    @Then("the response status code should be {int}")
    public void theResponseStatusCodeShouldBe(int statusCode) {
        assertEquals(statusCode, response.getStatusCode());
    }
}