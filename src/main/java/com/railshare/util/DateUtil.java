package com.railshare.util;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;

public class DateUtil {
    
    /**
     * Check if travel time is at least 6 hours from now
     */
    public static boolean isAtLeast6HoursBefore(Date travelDate, Time travelTime) {
        LocalDate date = travelDate.toLocalDate();
        LocalTime time = travelTime.toLocalTime();
        LocalDateTime travelDateTime = LocalDateTime.of(date, time);
        LocalDateTime now = LocalDateTime.now();
        
        long hoursDifference = ChronoUnit.HOURS.between(now, travelDateTime);
        return hoursDifference >= 6;
    }
    
    /**
     * Check if date is in the past
     */
    public static boolean isPastDate(Date date) {
        LocalDate travelDate = date.toLocalDate();
        LocalDate today = LocalDate.now();
        return travelDate.isBefore(today);
    }
    
    /**
     * Check if date and time combination is in the past
     */
    public static boolean isPastDateTime(Date date, Time time) {
        LocalDate travelDate = date.toLocalDate();
        LocalTime travelTime = time.toLocalTime();
        LocalDateTime travelDateTime = LocalDateTime.of(travelDate, travelTime);
        LocalDateTime now = LocalDateTime.now();
        return travelDateTime.isBefore(now);
    }
    
    /**
     * Get current timestamp
     */
    public static Timestamp getCurrentTimestamp() {
        return new Timestamp(System.currentTimeMillis());
    }
    
    /**
     * Convert Date and Time to Timestamp
     */
    public static Timestamp toTimestamp(Date date, Time time) {
        LocalDate localDate = date.toLocalDate();
        LocalTime localTime = time.toLocalTime();
        LocalDateTime dateTime = LocalDateTime.of(localDate, localTime);
        return Timestamp.valueOf(dateTime);
    }
}
