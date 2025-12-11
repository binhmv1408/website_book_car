package controller;

import dao.TripDAO;
import model.Trip;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "SearchTripServlet", urlPatterns = {"/search-trips"})
public class SearchTripServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String origin = trimParam(request.getParameter("from"));
        String destination = trimParam(request.getParameter("to"));
        String dateStr = trimParam(request.getParameter("date"));

        List<Trip> trips = Collections.emptyList();

        // Nếu không nhập tiêu chí nào, trả về tất cả chuyến xe
        TripDAO tripDAO = new TripDAO();
        LocalDate date = null;
        if (dateStr != null && !dateStr.isEmpty()) {
            try {
                String dateOnly = dateStr.contains("T") ? dateStr.substring(0, 10) : dateStr;
                date = LocalDate.parse(dateOnly);
            } catch (Exception e) {
                request.setAttribute("error", "Ngày đi không hợp lệ (định dạng yyyy-MM-dd hoặc yyyy-MM-ddTHH:mm)");
            }
        }

        if (request.getAttribute("error") == null) {
            try {
                if (origin == null && destination == null && date == null) {
                    trips = tripDAO.getAllTripsWithRouteName();
                } else {
                    trips = tripDAO.searchTrips(origin, destination, date);
                }
            } catch (SQLException e) {
                throw new ServletException("Không thể tìm chuyến xe", e);
            }
        }

        request.setAttribute("trips", trips);
        request.setAttribute("from", origin == null ? "" : origin);
        request.setAttribute("to", destination == null ? "" : destination);
        request.setAttribute("date", dateStr == null ? "" : dateStr);
        request.getRequestDispatcher("/searchTrips.jsp").forward(request, response);
    }

    private String trimParam(String value) {
        if (value == null) return null;
        String v = value.trim();
        return v.isEmpty() ? null : v;
    }
}

