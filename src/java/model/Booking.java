package model;

import java.time.LocalDateTime;
import java.util.List;

public class Booking {
    private int id;
    private int tripId;
    private Integer userId; // ID của user đã đặt vé (có thể null nếu đặt không đăng nhập)
    private String customerName;
    private String customerPhone;
    private String customerEmail;
    private String seatNumber; // Giữ lại để tương thích với code cũ
    private int quantity; // Số lượng ghế
    private LocalDateTime bookingDate;
    private String status;
    private double totalPrice;
    private List<BookingItem> items; // Danh sách ghế

    public Booking() {
    }

    public Booking(int id, int tripId, String customerName, String customerPhone, String customerEmail,
                   String seatNumber, LocalDateTime bookingDate, String status, double totalPrice) {
        this.id = id;
        this.tripId = tripId;
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.customerEmail = customerEmail; 
        this.seatNumber = seatNumber;
        this.bookingDate = bookingDate;
        this.status = status;
        this.totalPrice = totalPrice;
    }

    public Booking(int tripId, String customerName, String customerPhone, String customerEmail,
                   String seatNumber, String status, double totalPrice) {
        this(0, tripId, customerName, customerPhone, customerEmail, seatNumber, null, status, totalPrice);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }

    public LocalDateTime getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(LocalDateTime bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public List<BookingItem> getItems() {
        return items;
    }

    public void setItems(List<BookingItem> items) {
        this.items = items;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }
}

