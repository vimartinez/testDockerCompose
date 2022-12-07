package org.jpos.simulator;

import org.jpos.junit_support.simulator.JposTestRunnerHelper;
import org.jpos.simulator.TestCase;
import org.junit.AfterClass;
import org.junit.ClassRule;
import org.junit.Test;
import org.junit.jupiter.api.*;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameter;
import org.junit.runners.Parameterized.Parameters;
import org.testcontainers.containers.DockerComposeContainer;

import java.io.File;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RunWith(Parameterized.class)
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class VisaSimAtmTest {

    private static JposTestRunnerHelper helper;
    private static final List<String> TESTS_TO_FILTER = List.of(
            "0800_ATM_CASE_1_1_DEBIT_NTWK_MGMT_SIGN_ON",
            "0800_ATM_CASE_1_2_DEBIT_NTWK_MGMT_SIGN_OFF",
            "0800_ATM_CASE_1_3_DEBIT_NTWK_MGMT_ADV_RETR_ON",
            "0800_ATM_CASE_1_4_DEBIT_NTWK_MGMT_ADV_RETR_OFF");

    @Parameter
    public TestCase jposTestCase;

    @Parameters(name = "{0}")
    public static List<TestCase> data() throws Exception {

        helper = new JposTestRunnerHelper("visa-client-sim-atm");
        return helper.buildData().stream().filter(testCase -> {
                    if (TESTS_TO_FILTER.isEmpty()) {
                        return true;
                    }
                    final String testName = testCase.getFilename().replace("cfg/atm/", "");
                    return TESTS_TO_FILTER.contains(testName);
                })
                .peek(System.out::println)
                .collect(Collectors.toList());
    }
/*
    @ClassRule
    public static DockerComposeContainer environment =
            new DockerComposeContainer(new File("../../../../docker-compose.yml"));

    @BeforeAll
    public void setUp(){
        environment.start();
    }

    @Test
    @Order(1)
    public void should_initializeContainers_when_setUp() {
        Optional dbContainer = environment.getContainerByServiceName("postgres-db");
        Optional flywayContainer = environment.getContainerByServiceName("flyway");
        Optional ssVisaContainer = environment.getContainerByServiceName("ss-visa");
        Optional jptsContainer = environment.getContainerByServiceName("jpts");

        Assertions.assertTrue(dbContainer.isPresent());
        Assertions.assertTrue(flywayContainer.isPresent());
        Assertions.assertTrue(ssVisaContainer.isPresent());
        Assertions.assertTrue(jptsContainer.isPresent());
    }

    @Test
    @Order(2)
    public void dummyTest(){
        Assertions.assertEquals(1,1);
    }
    */

    @Test
    @Order(3)
    public void testVisa() throws Exception {
        helper.runTestCase(jposTestCase);
    }

    @AfterAll
    public static void close() {
        helper.closeQ2();
    //    environment.stop();
    }

}
