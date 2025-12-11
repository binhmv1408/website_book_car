package controller;

import dao.BusDAO;
import model.Bus;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "BusServlet", urlPatterns = {"/BusServlet"})
public class BusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            loadBusData(request);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/buses.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải dữ liệu xe", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("/doAnTu/admin/xe-va-ghe");
            return;
        }

        BusDAO busDAO = new BusDAO();
        try {
            switch (action) {
                case "add":
                    handleAdd(request, busDAO);
                    break;
                case "update":
                    handleUpdate(request, busDAO);
                    break;
                case "delete":
                    handleDelete(request, busDAO);
                    break;
                default:
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Lỗi thao tác xe", e);
        }
        response.sendRedirect("/doAnTu/admin/xe-va-ghe");
    }

    private void loadBusData(HttpServletRequest request) throws SQLException {
        BusDAO busDAO = new BusDAO();
        List<Bus> buses = busDAO.getAllBuses();
        int totalBuses = busDAO.getTotalBuses();
        request.setAttribute("buses", buses);
        request.setAttribute("totalBuses", totalBuses);
    }

    private void handleAdd(HttpServletRequest request, BusDAO busDAO) throws SQLException {
        String licensePlate = request.getParameter("licensePlate");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        int year = parseInt(request.getParameter("year"));
        int totalSeats = parseInt(request.getParameter("totalSeats"));
        String seatType = request.getParameter("seatType");
        String status = request.getParameter("status");
        
        if (status == null || status.trim().isEmpty()) {
            status = "active";
        }
        
        Bus bus = new Bus(licensePlate, brand, model, year, totalSeats, seatType, status);
        busDAO.insert(bus);
    }

    private void handleUpdate(HttpServletRequest request, BusDAO busDAO) throws SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        String licensePlate = request.getParameter("licensePlate");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        int year = parseInt(request.getParameter("year"));
        int totalSeats = parseInt(request.getParameter("totalSeats"));
        String seatType = request.getParameter("seatType");
        String status = request.getParameter("status");
        
        if (status == null || status.trim().isEmpty()) {
            status = "active";
        }
        
        Bus bus = new Bus(id, licensePlate, brand, model, year, totalSeats, seatType, status);
        busDAO.update(bus);
    }

    private void handleDelete(HttpServletRequest request, BusDAO busDAO) throws SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        busDAO.delete(id);
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return 0;
        }
    }
}

