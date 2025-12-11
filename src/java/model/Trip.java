package model;

import java.time.LocalDateTime;

public class Trip {
    private int id;
    private int routeId;
    private int busId;
    private LocalDateTime departureTime;
    private String routeName;
    private String busLicensePlate;
    private String origin;
    private String destination;
    private double distanceKm;
    private double price;
    private int totalSeats;

    public Trip() {
    }

    public Trip(int id, int routeId, int busId, LocalDateTime departureTime) {
        this.id = id;
        this.routeId = routeId;
        this.busId = busId;
        this.departureTime = departureTime;
    }

    public Trip(int id, int routeId, int busId, LocalDateTime departureTime, String routeName) {
        this(id, routeId, busId, departureTime);
        this.routeName = routeName;
    }

    public Trip(int id, int routeId, int busId, LocalDateTime departureTime, String routeName, String busLicensePlate) {
        this(id, routeId, busId, departureTime, routeName);
        this.busLicensePlate = busLicensePlate;
    }

    public Trip(int id, int routeId, int busId, LocalDateTime departureTime, String routeName, String busLicensePlate,
                String origin, String destination, double distanceKm, double price, int totalSeats) {
        this(id, routeId, busId, departureTime, routeName, busLicensePlate);
        this.origin = origin;
        this.destination = destination;
        this.distanceKm = distanceKm;
        this.price = price;
        this.totalSeats = totalSeats;
    }

    public Trip(int routeId, int busId, LocalDateTime departureTime) {
        this(0, routeId, busId, departureTime);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRouteId() {
        return routeId;
    }

    public void setRouteId(int routeId) {
        this.routeId = routeId;
    }

    public LocalDateTime getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(LocalDateTime departureTime) {
        this.departureTime = departureTime;
    }

    public String getRouteName() {
        return routeName;
    }

    public void setRouteName(String routeName) {
        this.routeName = routeName;
    }

    public int getBusId() {
        return busId;
    }

    public void setBusId(int busId) {
        this.busId = busId;
    }

    public String getBusLicensePlate() {
        return busLicensePlate;
    }

    public void setBusLicensePlate(String busLicensePlate) {
        this.busLicensePlate = busLicensePlate;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public double getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(double distanceKm) {
        this.distanceKm = distanceKm;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getTotalSeats() {
        return totalSeats;
    }

    public void setTotalSeats(int totalSeats) {
        this.totalSeats = totalSeats;
    }
}

