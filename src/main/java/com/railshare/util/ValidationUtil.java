package com.railshare.util;

import java.sql.Date;
import java.sql.Time;
import java.util.regex.Pattern;

public class ValidationUtil {
    
    // Pattern for 5-digit train number
    private static final Pattern TRAIN_NUMBER_PATTERN = Pattern.compile("^\\d{5}$");
    
    // Pattern for 10-digit PNR
    private static final Pattern PNR_PATTERN = Pattern.compile("^\\d{10}$");
    
    /**
     * Validate train number (exactly 5 digits)
     */
    public static boolean isValidTrainNumber(String trainNumber) {
        if (trainNumber == null || trainNumber.trim().isEmpty()) {
            return false;
        }
        return TRAIN_NUMBER_PATTERN.matcher(trainNumber.trim()).matches();
    }
    
    /**
     * Validate PNR (exactly 10 digits)
     */
    public static boolean isValidPNR(String pnr) {
        if (pnr == null || pnr.trim().isEmpty()) {
            return false;
        }
        return PNR_PATTERN.matcher(pnr.trim()).matches();
    }
    
    /**
     * Check if ticket is Tatkal
     * Tatkal PNRs typically start with specific patterns or have certain characteristics
     * For this system, we'll check if PNR starts with certain digits that indicate Tatkal
     * Common Tatkal indicators: PNRs starting with 8 or 9 in certain positions
     * This is a simplified check - adjust based on actual IRCTC PNR patterns
     */
    public static boolean isTatkalTicket(String pnr) {
        if (pnr == null || pnr.length() < 10) {
            return false;
        }
        // Simplified: Check if first digit is 8 or 9 (common Tatkal indicator)
        // In real system, this would be more sophisticated
        char firstChar = pnr.charAt(0);
        return firstChar == '8' || firstChar == '9';
    }
    
    /**
     * Validate ticket for listing
     * Returns error message if invalid, null if valid
     */
    public static String validateTicket(String trainNumber, String pnr, Date travelDate, Time travelTime) {
        // Validate train number
        if (!isValidTrainNumber(trainNumber)) {
            return "Train number must be exactly 5 digits";
        }
        
        // Validate PNR
        if (!isValidPNR(pnr)) {
            return "PNR must be exactly 10 digits";
        }
        
        // Check if Tatkal ticket
        if (isTatkalTicket(pnr)) {
            return "Tatkal tickets are not allowed. Only normal tickets can be listed.";
        }
        
        // Check if past date
        if (DateUtil.isPastDate(travelDate)) {
            return "Cannot list tickets for past dates";
        }
        
        // Check if past date and time
        if (DateUtil.isPastDateTime(travelDate, travelTime)) {
            return "Cannot list tickets for past travel times";
        }
        
        // Check 6-hour rule
        if (!DateUtil.isAtLeast6HoursBefore(travelDate, travelTime)) {
            return "Ticket must be listed at least 6 hours before travel time";
        }
        
        return null; // Valid
    }
    
    /**
     * Validate email format
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";
        return Pattern.compile(emailPattern).matcher(email).matches();
    }
    
    /**
     * Validate username (alphanumeric, 3-50 characters)
     */
    public static boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        String usernamePattern = "^[A-Za-z0-9_]{3,50}$";
        return Pattern.compile(usernamePattern).matcher(username).matches();
    }
}
