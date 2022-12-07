package com.prismamp.prepaidcardtransactionsregresiontest;


import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.junit.ClassRule;
import org.junit.jupiter.api.*;
import org.springframework.boot.test.context.SpringBootTest;
import org.testcontainers.containers.DockerComposeContainer;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.io.File;
import java.io.IOException;
import java.util.Optional;

@Testcontainers
@SpringBootTest
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class PrepaidcardTransactionsRegresionTestApplicationTests {

	@ClassRule
	public static DockerComposeContainer environment =
			new DockerComposeContainer(new File("docker-compose.yml"));

	@BeforeAll
	public static void setUp(){
		environment.start();
	}

	@Test
	@Order(1)
	public void should_initializeContainers_when_composeUp() {
		Optional<GenericContainer> jptsDbContainer = environment.getContainerByServiceName("jpts-db");
		Optional<GenericContainer> jptsFlywayContainer = environment.getContainerByServiceName("jpts-flyway");
		Optional<GenericContainer> jptsContainer = environment.getContainerByServiceName("jpts");
		Optional<GenericContainer> jcardDbContainer = environment.getContainerByServiceName("jcard-db");
		Optional<GenericContainer> jcardFlywayContainer = environment.getContainerByServiceName("jcard-flyway");
		Optional<GenericContainer> jcardContainer = environment.getContainerByServiceName("jcard");
		Optional<GenericContainer> ssVisaContainer = environment.getContainerByServiceName("ss-visa");

		Assertions.assertTrue(jptsDbContainer.isPresent());
		Assertions.assertTrue(jptsFlywayContainer.isPresent());
		Assertions.assertTrue(jptsContainer.isPresent());
		Assertions.assertTrue(jcardDbContainer.isPresent());
		Assertions.assertTrue(jcardFlywayContainer.isPresent());
		Assertions.assertTrue(jcardContainer.isPresent());
		Assertions.assertTrue(ssVisaContainer.isPresent());

	}

	@Test
	@Order(2)
	public void should_verifyJcard_when_containersUp() throws IOException, JSONException, InterruptedException {

		Optional<GenericContainer> jcardContainer =  environment.getContainerByServiceName("jcard");

		HttpUriRequest jcardRequest = new HttpGet("http://localhost:15000/health/readiness");

		System.out.println("Waiting for jcard service...");
		Thread.sleep(20000);
		HttpResponse jcardHttpResponse = HttpClientBuilder.create().build().execute(jcardRequest);
		JSONObject jsonObject = new JSONObject(EntityUtils.toString(jcardHttpResponse.getEntity()));

		Assertions.assertEquals(HttpStatus.SC_OK, jcardHttpResponse.getStatusLine().getStatusCode());
		Assertions.assertEquals("UP", jsonObject.get("status"));

	}

	@Test
	@Order(3)
	public void should_verifyJpts_when_containersUp() throws IOException, JSONException, InterruptedException {

		HttpUriRequest jptsRequest = new HttpGet("http://localhost:15001/health/readiness");

		System.out.println("Waiting for jpts service...");
		Thread.sleep(5000);
		HttpResponse jptsHttpResponse = HttpClientBuilder.create().build().execute(jptsRequest);
		JSONObject jsonObject = new JSONObject(EntityUtils.toString(jptsHttpResponse.getEntity()));

		Assertions.assertEquals(HttpStatus.SC_OK, jptsHttpResponse.getStatusLine().getStatusCode());
		Assertions.assertEquals("UP", jsonObject.get("status"));

	}

	@Test
	@Order(4)
	public void should_verifySsvisa_when_containersUp() throws IOException, JSONException, InterruptedException {

		HttpUriRequest ssVisaRequest = new HttpGet("http://localhost:15000/health/readiness");

		System.out.println("Waiting for ss-Visa service...");
		Thread.sleep(5000);
		HttpResponse ssVisaHttpResponse = HttpClientBuilder.create().build().execute(ssVisaRequest);
		JSONObject jsonObject = new JSONObject(EntityUtils.toString(ssVisaHttpResponse.getEntity()));

		Assertions.assertEquals(HttpStatus.SC_OK, ssVisaHttpResponse.getStatusLine().getStatusCode());
		Assertions.assertEquals("UP", jsonObject.get("status"));

	}

	@AfterAll
	public static void shutDown(){
		environment.stop();
	}

	public class HealthCheckResponse {
		private String status;

		public HealthCheckResponse(String status) {
			this.status = status;
		}

		public String getSatus() {
			return status;
		}

		public void setSatus(String status) {
			this.status = status;
		}
	}

}
