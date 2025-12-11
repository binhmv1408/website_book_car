package controller;

import dao.RouteDAO;
import dao.TripDAO;
import model.Route;
import model.Trip;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "RouteServlet", urlPatterns = {"/RouteServlet"})
public class RouteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            loadDashboardData(request);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải dữ liệu", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("/doAnTu/admin/tuyen-xe");
            return;
        }

        RouteDAO routeDAO = new RouteDAO();
        try {
            switch (action) {
                case "add":
                    handleAdd(request, routeDAO);
                    break;
                case "update":
                    handleUpdate(request, routeDAO);
                    break;
                case "delete":
                    handleDelete(request, routeDAO);
                    break;
                default:
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Lỗi thao tác tuyến xe", e);
        }
        response.sendRedirect("/doAnTu/admin/tuyen-xe");
    }

    private void loadDashboardData(HttpServletRequest request) throws SQLException {
        RouteDAO routeDAO = new RouteDAO();
        TripDAO tripDAO = new TripDAO();
        List<Route> routes = routeDAO.getAllRoutes();
        List<Trip> trips = tripDAO.getAllTripsWithRouteName();
        request.setAttribute("routes", routes);
        request.setAttribute("trips", trips);
    }

    private void handleAdd(HttpServletRequest request, RouteDAO routeDAO) throws SQLException {
        String origin = ensureValue(request.getParameter("origin"),
                request.getParameter("nameFromValue"), request.getParameter("nameToValue"));
        String destination = ensureValue(request.getParameter("destination"),
                request.getParameter("nameToValue"), request.getParameter("nameFromValue"));
        String fromProvince = ensureProvince(request.getParameter("nameFromValue"), origin);
        String toProvince = ensureProvince(request.getParameter("nameToValue"), destination);
        String name = buildRouteName(fromProvince, toProvince);
        double distanceKm = parseDouble(request.getParameter("distanceKm"));
        double price = parseDouble(request.getParameter("price"));
        Route route = new Route(name, origin, destination, distanceKm, price);
        routeDAO.insert(route);
    }

    private void handleUpdate(HttpServletRequest request, RouteDAO routeDAO) throws SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        String origin = ensureValue(request.getParameter("origin"),
                request.getParameter("nameFromValue"), request.getParameter("nameToValue"));
        String destination = ensureValue(request.getParameter("destination"),
                request.getParameter("nameToValue"), request.getParameter("nameFromValue"));
        String fromProvince = ensureProvince(request.getParameter("nameFromValue"), origin);
        String toProvince = ensureProvince(request.getParameter("nameToValue"), destination);
        String name = buildRouteName(fromProvince, toProvince);
        double distanceKm = parseDouble(request.getParameter("distanceKm"));
        double price = parseDouble(request.getParameter("price"));
        Route route = new Route(id, name, origin, destination, distanceKm, price);
        routeDAO.update(route);
    }

    private void handleDelete(HttpServletRequest request, RouteDAO routeDAO) throws SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        routeDAO.delete(id);
    }

    private double parseDouble(String value) {
        try {
            return Double.parseDouble(value);
        } catch (Exception e) {
            return 0;
        }
    }

    /**
     * Đảm bảo tên tuyến luôn có giá trị (fallback khi phía client không gửi về).
     */
    private String buildRouteName(String originProvince, String destinationProvince) {
        String o = originProvince == null ? "" : originProvince.trim();
        String d = destinationProvince == null ? "" : destinationProvince.trim();
        if (!o.isEmpty() && !d.isEmpty()) {
            return "Tuyến " + o + " - " + d;
        }
        return "Tuyến mới";
    }

    /**
     * Lấy giá trị chính, nếu trống thì dùng fallback1 rồi fallback2.
     */
    private String ensureValue(String primary, String fallback1, String fallback2) {
        // Ưu tiên giá trị huyện/quận (primary), sau đó tới tỉnh (fallback1/fallback2)
        if (primary != null && !primary.trim().isEmpty()) return primary.trim();
        if (fallback1 != null && !fallback1.trim().isEmpty()) return fallback1.trim();
        if (fallback2 != null && !fallback2.trim().isEmpty()) return fallback2.trim();
        return "";
    }

    /**
     * Ưu tiên tỉnh (hidden nameFromValue/nameToValue); nếu trống thì fallback sang origin/destination.
     */
    private String ensureProvince(String provinceVal, String fallbackDistrict) {
        if (provinceVal != null && !provinceVal.trim().isEmpty()) return provinceVal.trim();
        if (fallbackDistrict != null && !fallbackDistrict.trim().isEmpty()) return fallbackDistrict.trim();
        return "";
    }
}

