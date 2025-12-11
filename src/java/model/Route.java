package model;

public class Route {
    private int id;
    private String name;
    private String origin;
    private String destination;
    private double distanceKm;
    private double price;

    public Route() {
    }

    public Route(int id, String name, String origin, String destination, double distanceKm, double price) {
        this.id = id;
        this.name = name;
        this.origin = origin;
        this.destination = destination;
        this.distanceKm = distanceKm;
        this.price = price;
    }

    public Route(String name, String origin, String destination, double distanceKm, double price) {
        this(0, name, origin, destination, distanceKm, price);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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
}

