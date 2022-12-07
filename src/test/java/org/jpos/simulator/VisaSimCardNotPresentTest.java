package org.jpos.simulator;

import org.jpos.junit_support.simulator.JposTestRunnerHelper;
import org.jpos.simulator.TestCase;
import org.junit.AfterClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameter;
import org.junit.runners.Parameterized.Parameters;

import java.util.List;
import java.util.stream.Collectors;

@RunWith(Parameterized.class)
public class VisaSimCardNotPresentTest {

    private static JposTestRunnerHelper HELPER;
    private static final List<String> TESTS_TO_FILTER = List.of();
    //private static final List<String> TESTS_TO_FILTER = List.of("0100_AUTHORIZATION_MOTO_41");
    @Parameter
    public TestCase jposTestCase;

    @Parameters(name = "{0}")
    public static List<TestCase> data() throws Exception {
        System.out.println("INITIALIZING TEST SUITE");
        HELPER = new JposTestRunnerHelper("visa-client-sim");
        return HELPER.buildData().stream()
                .peek(System.out::println)
                .filter(testCase -> {
                    if (TESTS_TO_FILTER.isEmpty()) {
                        return true;
                    }
                    final String testName = testCase.getFilename().replace("cfg/card_no_present/", "");
                    return TESTS_TO_FILTER.stream().anyMatch(t -> testName.contains(t) || testCase.getName().contains(t));
                })
                .peek(System.out::println)
                .collect(Collectors.toList());
    }

    @Test
    public void testVisa() throws Exception {
        HELPER.runTestCase(jposTestCase);
    }

    @AfterClass
    public static void close() {
        HELPER.closeQ2();
    }
}
