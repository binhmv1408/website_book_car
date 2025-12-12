package model;

public class BookingItem {
    private int id;
    private int bookingId;
    private String seatNumber;
    private double seatPrice;

    public BookingItem() {
    }

    public BookingItem(int bookingId, String seatNumber, double seatPrice) {
        this.bookingId = bookingId;
        this.seatNumber = seatNumber;
        this.seatPrice = seatPrice;
    }

    public BookingItem(int id, int bookingId, String seatNumber, double seatPrice) {
        this.id = id;
        this.bookingId = bookingId;
        this.seatNumber = seatNumber;
        this.seatPrice = seatPrice;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public String getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }

    public double getSeatPrice() {
        return seatPrice;
    }

    public void setSeatPrice(double seatPrice) {
        this.seatPrice = seatPrice;
    }
}

