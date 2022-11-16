package com.prismamp.prepaid.simvisa;

import org.junit.ClassRule;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.testcontainers.containers.DockerComposeContainer;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.io.File;
import java.util.Optional;

@Testcontainers
@SpringBootTest
class SimVisa2ApplicationTests {

	@ClassRule
	public static DockerComposeContainer environment =
			new DockerComposeContainer(new File("docker-compose.yml"));

	@BeforeEach
	public void setUp(){
		environment.start();
		Optional db = environment.getContainerByServiceName("postgres-db");
		Optional ssVisa = environment.getContainerByServiceName("ss-visa");
		Optional jpts = environment.getContainerByServiceName("jpts");
		String dbContainer = String.valueOf(environment.getContainerByServiceName("postgres-db"));
		//Flyway flyway = Flyway.configure().dataSource(postgreSQLContainer.getJdbcUrl(), postgreSQLContainer.getUsername(), postgreSQLContainer.getPassword()).load();
		//MigrateResult migrateResult = flyway.migrate();
		//Assertions.assertTrue(migrateResult.success);
		Assertions.assertNotNull(dbContainer);
	}

	@Test
	void contextLoads() {
	}

	@AfterEach
	public void shutDown(){
		environment.stop();
	}

}
