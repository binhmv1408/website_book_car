package model;

public class Bus {
    private int id;
    private String licensePlate;
    private String brand;
    private String model;
    private int year;
    private int totalSeats;
    private String seatType;
    private String status;

    public Bus() {
    }

    public Bus(int id, String licensePlate, String brand, String model, int year, int totalSeats, String seatType, String status) {
        this.id = id;
        this.licensePlate = licensePlate;
        this.brand = brand;
        this.model = model;
        this.year = year;
        this.totalSeats = totalSeats;
        this.seatType = seatType;
        this.status = status;
    }

    public Bus(String licensePlate, String brand, String model, int year, int totalSeats, String seatType, String status) {
        this(0, licensePlate, brand, model, year, totalSeats, seatType, status);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public int getTotalSeats() {
        return totalSeats;
    }

    public void setTotalSeats(int totalSeats) {
        this.totalSeats = totalSeats;
    }

    public String getSeatType() {
        return seatType;
    }

    public void setSeatType(String seatType) {
        this.seatType = seatType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

