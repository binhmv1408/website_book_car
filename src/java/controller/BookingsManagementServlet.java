package controller;

import dao.BookingDAO;
import dao.TripDAO;
import dao.UserDAO;
import model.Booking;
import model.Trip;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "BookingsManagementServlet", urlPatterns = {"/admin/bookings", "/admin/booking-detail", "/admin/booking-edit", "/admin/booking-delete", "/admin/booking-update-status"})
public class BookingsManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/admin/bookings".equals(path)) {
            handleListBookings(request, response);
        } else if ("/admin/booking-detail".equals(path)) {
            handleViewDetail(request, response);
        } else if ("/admin/booking-edit".equals(path)) {
            handleEditForm(request, response);
        } else if ("/admin/booking-delete".equals(path)) {
            handleDelete(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/admin/booking-update-status".equals(path)) {
            handleUpdateStatus(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleListBookings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BookingDAO bookingDAO = new BookingDAO();
        TripDAO tripDAO = new TripDAO();
        UserDAO userDAO = new UserDAO();
        
        try {
            // Lấy tất cả bookings
            List<Booking> bookings = bookingDAO.getAllBookings();
            
            // Lấy thông tin route name, origin, destination cho mỗi booking
            Map<Integer, String> routeNames = new HashMap<>();
            Map<Integer, String> origins = new HashMap<>();
            Map<Integer, String> destinations = new HashMap<>();
            Map<Integer, User> users = new HashMap<>();
            
            for (Booking booking : bookings) {
                if (!routeNames.containsKey(booking.getTripId())) {
                    Trip trip = tripDAO.findById(booking.getTripId());
                    if (trip != null) {
                        routeNames.put(booking.getTripId(), trip.getRouteName() != null ? trip.getRouteName() : "Chuyến #" + booking.getTripId());
                        origins.put(booking.getTripId(), trip.getOrigin() != null ? trip.getOrigin() : "N/A");
                        destinations.put(booking.getTripId(), trip.getDestination() != null ? trip.getDestination() : "N/A");
                    }
                }
                
                // Lấy thông tin user nếu có userId
                if (booking.getUserId() != null && !users.containsKey(booking.getUserId())) {
                    User user = userDAO.findById(booking.getUserId());
                    if (user != null) {
                        users.put(booking.getUserId(), user);
                    }
                }
            }
            
            // Set route names, origins, destinations vào request
            for (Map.Entry<Integer, String> entry : routeNames.entrySet()) {
                request.setAttribute("routeName_" + entry.getKey(), entry.getValue());
            }
            for (Map.Entry<Integer, String> entry : origins.entrySet()) {
                request.setAttribute("origin_" + entry.getKey(), entry.getValue());
            }
            for (Map.Entry<Integer, String> entry : destinations.entrySet()) {
                request.setAttribute("destination_" + entry.getKey(), entry.getValue());
            }
            
            // Set user info vào request
            for (Map.Entry<Integer, User> entry : users.entrySet()) {
                request.setAttribute("user_" + entry.getKey(), entry.getValue());
            }
            
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/bookings.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải danh sách vé đã đặt", e);
        }
    }

    private void handleViewDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã vé");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã vé không hợp lệ");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        TripDAO tripDAO = new TripDAO();
        UserDAO userDAO = new UserDAO();
        
        try {
            Booking booking = bookingDAO.findById(id);
            if (booking == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy vé");
                return;
            }
            
            // Lấy thông tin chuyến xe
            Trip trip = tripDAO.findById(booking.getTripId());
            
            // Lấy thông tin user nếu có userId
            User user = null;
            if (booking.getUserId() != null) {
                user = userDAO.findById(booking.getUserId());
            }
            
            // Lấy danh sách ghế từ booking_items
            List<model.BookingItem> items = bookingDAO.getBookingItems(booking.getId());
            booking.setItems(items);
            
            request.setAttribute("booking", booking);
            request.setAttribute("trip", trip);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/bookingDetail.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải chi tiết vé", e);
        }
    }

    private void handleEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã vé");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã vé không hợp lệ");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        TripDAO tripDAO = new TripDAO();
        
        try {
            Booking booking = bookingDAO.findById(id);
            if (booking == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy vé");
                return;
            }
            
            Trip trip = tripDAO.findById(booking.getTripId());
            List<model.BookingItem> items = bookingDAO.getBookingItems(booking.getId());
            booking.setItems(items);
            
            request.setAttribute("booking", booking);
            request.setAttribute("trip", trip);
            request.getRequestDispatcher("/bookingEdit.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải thông tin vé", e);
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã vé");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã vé không hợp lệ");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        
        try {
            bookingDAO.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/bookings?deleted=true");
        } catch (SQLException e) {
            throw new ServletException("Không thể xóa vé", e);
        }
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String status = request.getParameter("status");
        String customerName = request.getParameter("customer_name");
        String customerPhone = request.getParameter("customer_phone");
        String customerEmail = request.getParameter("customer_email");
        
        if (idStr == null || status == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu thông tin");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã vé không hợp lệ");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        
        try {
            // Cập nhật trạng thái
            bookingDAO.updateStatus(id, status);
            
            // Cập nhật thông tin khách hàng nếu có
            if (customerName != null && customerPhone != null) {
                bookingDAO.updateCustomerInfo(id, customerName, customerPhone, customerEmail);
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/booking-detail?id=" + id + "&updated=true");
        } catch (SQLException e) {
            throw new ServletException("Không thể cập nhật thông tin", e);
        }
    }
}

