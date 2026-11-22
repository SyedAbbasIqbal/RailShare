package com.railshare.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Transfer {

    private int id;
    private int ticketId;
    private int sellerId;
    private int buyerId;

    private BigDecimal price;
    private BigDecimal serviceFee;
    private BigDecimal totalAmount;

    private Timestamp transferDate;

    private String paymentStatus;

    // NEW FIELDS
    private String passengerName;
    private int age;
    private String gender;

    public Transfer() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public int getSellerId() {
        return sellerId;
    }

    public void setSellerId(int sellerId) {
        this.sellerId = sellerId;
    }

    public int getBuyerId() {
        return buyerId;
    }

    public void setBuyerId(int buyerId) {
        this.buyerId = buyerId;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getServiceFee() {
        return serviceFee;
    }

    public void setServiceFee(BigDecimal serviceFee) {
        this.serviceFee = serviceFee;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Timestamp getTransferDate() {
        return transferDate;
    }

    public void setTransferDate(
            Timestamp transferDate) {

        this.transferDate =
                transferDate;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(
            String paymentStatus) {

        this.paymentStatus =
                paymentStatus;
    }

    // Passenger Name

    public String getPassengerName() {
        return passengerName;
    }

    public void setPassengerName(
            String passengerName) {

        this.passengerName =
                passengerName;
    }

    // Age

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    // Gender

    public String getGender() {
        return gender;
    }

    public void setGender(
            String gender) {

        this.gender =
                gender;
    }
}