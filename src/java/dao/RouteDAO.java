package dao;

import model.Route;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RouteDAO {
    public List<Route> getAllRoutes() throws SQLException {
        List<Route> routes = new ArrayList<>();
        String sql = "SELECT id, name, origin, destination, distance_km, price FROM routes ORDER BY id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Route route = new Route(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("origin"),
                        rs.getString("destination"),
                        rs.getDouble("distance_km"),
                        rs.getDouble("price")
                );
                routes.add(route);
            }
        }
        return routes;
    }

    public Route findById(int id) throws SQLException {
        String sql = "SELECT id, name, origin, destination, distance_km, price FROM routes WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Route(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("origin"),
                            rs.getString("destination"),
                            rs.getDouble("distance_km"),
                            rs.getDouble("price")
                    );
                }
            }
        }
        return null;
    }

    public void insert(Route route) throws SQLException {
        String sql = "INSERT INTO routes(name, origin, destination, distance_km, price) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, route.getName());
            ps.setString(2, route.getOrigin());
            ps.setString(3, route.getDestination());
            ps.setDouble(4, route.getDistanceKm());
            ps.setDouble(5, route.getPrice());
            ps.executeUpdate();
        }
    }

    public void update(Route route) throws SQLException {
        String sql = "UPDATE routes SET name = ?, origin = ?, destination = ?, distance_km = ?, price = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, route.getName());
            ps.setString(2, route.getOrigin());
            ps.setString(3, route.getDestination());
            ps.setDouble(4, route.getDistanceKm());
            ps.setDouble(5, route.getPrice());
            ps.setInt(6, route.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM routes WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}

