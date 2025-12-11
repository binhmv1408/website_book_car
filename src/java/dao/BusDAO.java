package dao;

import model.Bus;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BusDAO {
    public List<Bus> getAllBuses() throws SQLException {
        List<Bus> buses = new ArrayList<>();
        String sql = "SELECT id, license_plate, brand, model, year, total_seats, seat_type, status FROM buses ORDER BY id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Bus bus = new Bus(
                        rs.getInt("id"),
                        rs.getString("license_plate"),
                        rs.getString("brand"),
                        rs.getString("model"),
                        rs.getInt("year"),
                        rs.getInt("total_seats"),
                        rs.getString("seat_type"),
                        rs.getString("status")
                );
                buses.add(bus);
            }
        }
        return buses;
    }

    public Bus findById(int id) throws SQLException {
        String sql = "SELECT id, license_plate, brand, model, year, total_seats, seat_type, status FROM buses WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Bus(
                            rs.getInt("id"),
                            rs.getString("license_plate"),
                            rs.getString("brand"),
                            rs.getString("model"),
                            rs.getInt("year"),
                            rs.getInt("total_seats"),
                            rs.getString("seat_type"),
                            rs.getString("status")
                    );
                }
            }
        }
        return null;
    }

    public Bus findByLicensePlate(String licensePlate) throws SQLException {
        String sql = "SELECT id, license_plate, brand, model, year, total_seats, seat_type, status FROM buses WHERE license_plate = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, licensePlate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Bus(
                            rs.getInt("id"),
                            rs.getString("license_plate"),
                            rs.getString("brand"),
                            rs.getString("model"),
                            rs.getInt("year"),
                            rs.getInt("total_seats"),
                            rs.getString("seat_type"),
                            rs.getString("status")
                    );
                }
            }
        }
        return null;
    }

    public void insert(Bus bus) throws SQLException {
        String sql = "INSERT INTO buses(license_plate, brand, model, year, total_seats, seat_type, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bus.getLicensePlate());
            ps.setString(2, bus.getBrand());
            ps.setString(3, bus.getModel());
            ps.setInt(4, bus.getYear());
            ps.setInt(5, bus.getTotalSeats());
            ps.setString(6, bus.getSeatType());
            ps.setString(7, bus.getStatus());
            ps.executeUpdate();
        }
    }

    public void update(Bus bus) throws SQLException {
        String sql = "UPDATE buses SET license_plate = ?, brand = ?, model = ?, year = ?, total_seats = ?, seat_type = ?, status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bus.getLicensePlate());
            ps.setString(2, bus.getBrand());
            ps.setString(3, bus.getModel());
            ps.setInt(4, bus.getYear());
            ps.setInt(5, bus.getTotalSeats());
            ps.setString(6, bus.getSeatType());
            ps.setString(7, bus.getStatus());
            ps.setInt(8, bus.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM buses WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public int getTotalBuses() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM buses";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
}

