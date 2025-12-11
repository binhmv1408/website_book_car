package dao;

import model.Trip;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Date;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class TripDAO {
    public List<Trip> getAllTripsWithRouteName() throws SQLException {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT t.id, t.route_id, t.bus_id, t.departure_time, r.name AS route_name, b.license_plate AS bus_license_plate, " +
                "r.origin AS origin, r.destination AS destination, r.distance_km AS distance_km, r.price AS price, b.total_seats AS total_seats " +
                "FROM trips t " +
                "INNER JOIN routes r ON t.route_id = r.id " +
                "INNER JOIN buses b ON t.bus_id = b.id " +
                "ORDER BY t.departure_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                LocalDateTime departure = rs.getTimestamp("departure_time").toLocalDateTime();
                Trip trip = new Trip(
                        rs.getInt("id"),
                        rs.getInt("route_id"),
                        rs.getInt("bus_id"),
                        departure,
                        rs.getString("route_name"),
                        rs.getString("bus_license_plate"),
                        rs.getString("origin"),
                        rs.getString("destination"),
                        rs.getDouble("distance_km"),
                        rs.getDouble("price"),
                        rs.getInt("total_seats")
                );
                trips.add(trip);
            }
        }
        return trips;
    }

    public List<Trip> searchTrips(String origin, String destination, LocalDate departureDate) throws SQLException {
        List<Trip> trips = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT t.id, t.route_id, t.bus_id, t.departure_time, r.name AS route_name, " +
                        "r.origin AS origin, r.destination AS destination, r.distance_km AS distance_km, r.price AS price, b.total_seats AS total_seats, b.license_plate AS bus_license_plate " +
                        "FROM trips t " +
                        "INNER JOIN routes r ON t.route_id = r.id " +
                        "INNER JOIN buses b ON t.bus_id = b.id " +
                        "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (origin != null && !origin.trim().isEmpty()) {
            sql.append("AND (LOWER(r.origin) = LOWER(?) OR LOWER(r.name) LIKE LOWER(?)) ");
            params.add(origin.trim());
            params.add("%" + origin.trim() + "%");
        }

        if (destination != null && !destination.trim().isEmpty()) {
            sql.append("AND (LOWER(r.destination) = LOWER(?) OR LOWER(r.name) LIKE LOWER(?)) ");
            params.add(destination.trim());
            params.add("%" + destination.trim() + "%");
        }

        if (departureDate != null) {
            sql.append("AND DATE(t.departure_time) = ? ");
            params.add(Date.valueOf(departureDate));
        }

        sql.append("ORDER BY t.departure_time ASC");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LocalDateTime departure = rs.getTimestamp("departure_time").toLocalDateTime();
                    Trip trip = new Trip(
                            rs.getInt("id"),
                            rs.getInt("route_id"),
                            rs.getInt("bus_id"),
                            departure,
                            rs.getString("route_name"),
                            rs.getString("bus_license_plate"),
                            rs.getString("origin"),
                            rs.getString("destination"),
                            rs.getDouble("distance_km"),
                            rs.getDouble("price"),
                            rs.getInt("total_seats")
                    );
                    trips.add(trip);
                }
            }
        }

        return trips;
    }

    public Trip findById(int id) throws SQLException {
        String sql = "SELECT t.id, t.route_id, t.bus_id, t.departure_time, " +
                "r.name AS route_name, r.origin, r.destination, r.distance_km, r.price, " +
                "b.license_plate, b.total_seats " +
                "FROM trips t " +
                "INNER JOIN routes r ON t.route_id = r.id " +
                "INNER JOIN buses b ON t.bus_id = b.id " +
                "WHERE t.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LocalDateTime departure = rs.getTimestamp("departure_time").toLocalDateTime();
                    return new Trip(
                            rs.getInt("id"),
                            rs.getInt("route_id"),
                            rs.getInt("bus_id"),
                            departure,
                            rs.getString("route_name"),
                            rs.getString("license_plate"),
                            rs.getString("origin"),
                            rs.getString("destination"),
                            rs.getDouble("distance_km"),
                            rs.getDouble("price"),
                            rs.getInt("total_seats")
                    );
                }
            }
        }
        return null;
    }

    public void insert(Trip trip) throws SQLException {
        String sql = "INSERT INTO trips(route_id, bus_id, departure_time) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trip.getRouteId());
            ps.setInt(2, trip.getBusId());
            ps.setTimestamp(3, Timestamp.valueOf(trip.getDepartureTime()));
            ps.executeUpdate();
        }
    }

    public void update(Trip trip) throws SQLException {
        String sql = "UPDATE trips SET route_id = ?, bus_id = ?, departure_time = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trip.getRouteId());
            ps.setInt(2, trip.getBusId());
            ps.setTimestamp(3, Timestamp.valueOf(trip.getDepartureTime()));
            ps.setInt(4, trip.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM trips WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}

