package com.railshare.util;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class PriceCalculator {
    // Service fee percentage (5%)
    private static final double SERVICE_FEE_PERCENTAGE = 0.05;
    
    /**
     * Calculate service fee from base fare
     */
    public static BigDecimal calculateServiceFee(BigDecimal baseFare) {
        if (baseFare == null) {
            return BigDecimal.ZERO;
        }
        return baseFare.multiply(BigDecimal.valueOf(SERVICE_FEE_PERCENTAGE))
                .setScale(2, RoundingMode.HALF_UP);
    }
    
    /**
     * Calculate total amount (base fare + service fee)
     */
    public static BigDecimal calculateTotal(BigDecimal baseFare) {
        if (baseFare == null) {
            return BigDecimal.ZERO;
        }
        BigDecimal serviceFee = calculateServiceFee(baseFare);
        return baseFare.add(serviceFee).setScale(2, RoundingMode.HALF_UP);
    }
    
    /**
     * Get service fee percentage
     */
    public static double getServiceFeePercentage() {
        return SERVICE_FEE_PERCENTAGE * 100; // Return as percentage (5.0)
    }
}
