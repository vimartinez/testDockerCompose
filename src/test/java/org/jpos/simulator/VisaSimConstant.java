package org.jpos.simulator;

public class VisaSimConstant {

    public static final String BIMO_CARD_PAN = "4882340010082019";
    public static final String BIMO_CARD_CVV2 = "709";
    public static final String BIMO_CARD_EXP_DATE = "2505";
    public static final String BIMO_CARD_EXP_DATE_WRONG = "2005";
    public static final String BIMO_CARD_TRACK1 = "B4882340010082019^CARD 1 VISATEST     ^25052213210000321000";
    public static final String BIMO_CARD_TRACK2 = "4882340010082019=25052210460000000000";
    public static final String BIMO_CARD_TRACK2_WRONG = "4882340010082019=20052210460000000000";
    public static final String BIMO_CARD_TRACK2_FOR_MSR = "4882340010082019=25052213210000000000"; // Magnetic stripe read

    public static final String BIMO_CARD_2_PAN = "6009330000000013";
    public static final String BIMO_CARD_2_CVV2 = "517";
    public static final String BIMO_CARD_2_EXP_DATE = "2505";

    public static final String BIMO_EPINBLOCK = "D1B88E44C843B797";
    public static final String BIMO_EPINBLOCK_INVALID = "49955FE0078ADFB0";


    private VisaSimConstant() {
        throw new IllegalStateException("Aux class with constants");
    }
}
