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
public class VisaSimLocalTransactionTest {

    private static JposTestRunnerHelper helper;
    private static final List<String> TESTS_TO_FILTER = List.of();

    @Parameter
    public TestCase jposTestCase;

    @Parameters(name = "{0}")
    public static List<TestCase> data() throws Exception {

        helper = new JposTestRunnerHelper("visa-client-sim-lt");
        return helper.buildData().stream().filter(testCase -> {
                    if (TESTS_TO_FILTER.isEmpty()) {
                        return true;
                    }
                    final String testName = testCase.getFilename().replace("cfg/local_transaction/", "");
                    return TESTS_TO_FILTER.contains(testName);
                })
                .peek(System.out::println)
                .collect(Collectors.toList());
    }

    @Test
    public void testVisa() throws Exception {
        helper.runTestCase(jposTestCase);
    }

    @AfterClass
    public static void close() {
        helper.closeQ2();
    }
}
