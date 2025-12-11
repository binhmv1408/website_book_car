package controller;

import dao.TripDAO;
import dao.RouteDAO;
import dao.BusDAO;
import model.Route;
import model.Trip;
import model.Bus;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "TripServlet", urlPatterns = {"/TripServlet"})
public class TripServlet extends HttpServlet {

    private static final DateTimeFormatter INPUT_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            RouteDAO routeDAO = new RouteDAO();
            BusDAO busDAO = new BusDAO();
            TripDAO tripDAO = new TripDAO();
            List<Route> routes = routeDAO.getAllRoutes();
            List<Bus> buses = busDAO.getAllBuses();
            List<Trip> trips = tripDAO.getAllTripsWithRouteName();
            request.setAttribute("routes", routes);
            request.setAttribute("buses", buses);
            request.setAttribute("trips", trips);
            request.getRequestDispatcher("/trips.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải dữ liệu chuyến xe", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("/doAnTu/admin/chuyen-xe");
            return;
        }

        TripDAO tripDAO = new TripDAO();
        try {
            switch (action) {
                case "add":
                    handleAdd(request, tripDAO);
                    break;
                case "update":
                    handleUpdate(request, tripDAO);
                    break;
                case "delete":
                    handleDelete(request, tripDAO);
                    break;
                default:
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Lỗi thao tác chuyến xe", e);
        }
        response.sendRedirect("/doAnTu/admin/chuyen-xe");
    }

    private void handleAdd(HttpServletRequest request, TripDAO tripDAO) throws SQLException {
        String routeIdStr = request.getParameter("routeId");
        String busIdStr = request.getParameter("busId");
        String departureTimeStr = request.getParameter("departureTime");
        
        if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Tuyến xe không được để trống");
        }
        if (busIdStr == null || busIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Xe không được để trống");
        }
        if (departureTimeStr == null || departureTimeStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Giờ khởi hành không được để trống");
        }
        
        int routeId = Integer.parseInt(routeIdStr);
        int busId = Integer.parseInt(busIdStr);
        LocalDateTime departure = parseDateTime(departureTimeStr);
        tripDAO.insert(new Trip(routeId, busId, departure));
    }

    private void handleUpdate(HttpServletRequest request, TripDAO tripDAO) throws SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        int routeId = Integer.parseInt(request.getParameter("routeId"));
        int busId = Integer.parseInt(request.getParameter("busId"));
        LocalDateTime departure = parseDateTime(request.getParameter("departureTime"));
        tripDAO.update(new Trip(id, routeId, busId, departure));
    }

    private void handleDelete(HttpServletRequest request, TripDAO tripDAO) throws SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        tripDAO.delete(id);
    }

    private LocalDateTime parseDateTime(String value) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("Giờ khởi hành không hợp lệ");
        }
        try {
            return LocalDateTime.parse(value, INPUT_FORMATTER);
        } catch (Exception e) {
            throw new IllegalArgumentException("Định dạng giờ khởi hành không đúng: " + value, e);
        }
    }
}

