package controller;

import dao.BookingDAO;
import dao.TripDAO;
import model.Booking;
import model.BookingItem;
import model.Trip;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Set;

@WebServlet(name = "BookingServlet", urlPatterns = {"/select-seats", "/book-trip"})
public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Kiểm tra đăng nhập
        if (!checkLogin(request, response)) {
            return;
        }
        
        String path = request.getServletPath();
        
        if ("/select-seats".equals(path)) {
            handleSelectSeats(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Kiểm tra đăng nhập
        if (!checkLogin(request, response)) {
            return;
        }
        
        String path = request.getServletPath();
        
        if ("/book-trip".equals(path)) {
            handleBookTrip(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Kiểm tra người dùng đã đăng nhập chưa.
     * Nếu chưa đăng nhập, lưu URL hiện tại và redirect về trang login.
     * @return true nếu đã đăng nhập, false nếu chưa đăng nhập và đã redirect
     */
    private boolean checkLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        String role = session != null ? (String) session.getAttribute("userRole") : null;
        
        // Chỉ cho phép user (khách hàng) đặt vé, không cho admin
        if (session == null || role == null || !"user".equals(role)) {
            // Lưu URL hiện tại để quay lại sau khi đăng nhập
            // Sử dụng getServletPath() thay vì getRequestURI() để tránh duplicate context path
            String currentUrl = request.getServletPath();
            String queryString = request.getQueryString();
            if (queryString != null && !queryString.isEmpty()) {
                currentUrl += "?" + queryString;
            }
            
            if (session != null) {
                session.setAttribute("redirectAfterLogin", currentUrl);
            } else {
                HttpSession newSession = request.getSession(true);
                newSession.setAttribute("redirectAfterLogin", currentUrl);
            }
            
            String ctx = request.getContextPath();
            response.sendRedirect(ctx + "/login");
            return false;
        }
        
        return true;
    }

    private void handleSelectSeats(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tripIdStr = request.getParameter("tripId");
        if (tripIdStr == null || tripIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã chuyến xe");
            return;
        }

        int tripId;
        try {
            tripId = Integer.parseInt(tripIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã chuyến xe không hợp lệ");
            return;
        }

        TripDAO tripDAO = new TripDAO();
        BookingDAO bookingDAO = new BookingDAO();
        
        try {
            Trip trip = tripDAO.findById(tripId);
            if (trip == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy chuyến xe");
                return;
            }

            // Lấy danh sách ghế đã được đặt
            Set<String> bookedSeats = bookingDAO.getBookedSeats(tripId);
            
            request.setAttribute("trip", trip);
            request.setAttribute("bookedSeats", bookedSeats);
            request.getRequestDispatcher("/seatSelection.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải thông tin chuyến xe", e);
        }
    }

    private void handleBookTrip(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tripIdStr = request.getParameter("tripId");
        String seatNumbersStr = request.getParameter("seatNumbers"); // Nhận danh sách ghế (comma-separated)
        String customerName = request.getParameter("customerName");
        String customerPhone = request.getParameter("customerPhone");
        String customerEmail = request.getParameter("customerEmail");

        if (tripIdStr == null || seatNumbersStr == null || seatNumbersStr.trim().isEmpty() || 
            customerName == null || customerPhone == null) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin và chọn ít nhất 1 ghế");
            try {
                int tripId = Integer.parseInt(tripIdStr != null ? tripIdStr : "0");
                response.sendRedirect(request.getContextPath() + "/select-seats?tripId=" + tripId);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/search-trips");
            }
            return;
        }
        
        // Parse danh sách ghế
        String[] seatNumbers = seatNumbersStr.split(",");
        java.util.List<String> seatList = new java.util.ArrayList<>();
        for (String seat : seatNumbers) {
            String trimmed = seat.trim();
            if (!trimmed.isEmpty()) {
                seatList.add(trimmed);
            }
        }
        
        if (seatList.isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn ít nhất 1 ghế");
            try {
                int tripId = Integer.parseInt(tripIdStr);
                response.sendRedirect(request.getContextPath() + "/select-seats?tripId=" + tripId);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/search-trips");
            }
            return;
        }

        int tripId;
        try {
            tripId = Integer.parseInt(tripIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã chuyến xe không hợp lệ");
            return;
        }

        TripDAO tripDAO = new TripDAO();
        BookingDAO bookingDAO = new BookingDAO();

        try {
            Trip trip = tripDAO.findById(tripId);
            if (trip == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy chuyến xe");
                return;
            }

            // Chuẩn hóa và kiểm tra từng ghế
            java.util.List<String> normalizedSeats = new java.util.ArrayList<>();
            java.util.List<model.BookingItem> bookingItems = new java.util.ArrayList<>();
            double totalPrice = 0;
            
            for (String seatNumber : seatList) {
                String normalized = seatNumber.trim();
                try {
                    int seatNum = Integer.parseInt(normalized);
                    normalized = String.format("%02d", seatNum);
                } catch (NumberFormatException e) {
                    // Giữ nguyên nếu không phải số
                }
                
                // Kiểm tra ghế có còn trống không
                if (!bookingDAO.isSeatAvailable(tripId, normalized)) {
                    request.setAttribute("error", "Ghế " + normalized + " đã được đặt. Vui lòng chọn ghế khác.");
                    Set<String> bookedSeats = bookingDAO.getBookedSeats(tripId);
                    request.setAttribute("trip", trip);
                    request.setAttribute("bookedSeats", bookedSeats);
                    request.getRequestDispatcher("/seatSelection.jsp").forward(request, response);
                    return;
                }
                
                normalizedSeats.add(normalized);
                
                // Tính giá cho từng ghế (ghế 01-15: +5%)
                double seatPrice = trip.getPrice();
                try {
                    int seatNum = Integer.parseInt(normalized);
                    if (seatNum >= 1 && seatNum <= 15) {
                        seatPrice = trip.getPrice() * 1.05;
                    }
                } catch (NumberFormatException e) {
                    // Giữ nguyên giá gốc
                }
                
                totalPrice += seatPrice;
                bookingItems.add(new model.BookingItem(0, normalized, seatPrice));
            }

            // Tạo booking với nhiều ghế
            Booking booking = new Booking();
            booking.setTripId(tripId);
            booking.setCustomerName(customerName.trim());
            booking.setCustomerPhone(customerPhone.trim());
            booking.setCustomerEmail(customerEmail != null ? customerEmail.trim() : null);
            booking.setQuantity(seatList.size());
            booking.setStatus("confirmed");
            booking.setTotalPrice(totalPrice);
            booking.setItems(bookingItems);
            // Giữ seatNumber để tương thích (ghế đầu tiên)
            booking.setSeatNumber(normalizedSeats.get(0));

            int bookingId = bookingDAO.insert(booking);
            
            if (bookingId > 0) {
                // Đặt thông báo thành công vào session
                request.getSession().setAttribute("bookingSuccess", "Bạn đã đặt vé thành công! Mã đặt vé: #" + bookingId);
                // Chuyển về trang chủ
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi đặt vé. Vui lòng thử lại.");
                Set<String> bookedSeats = bookingDAO.getBookedSeats(tripId);
                request.setAttribute("trip", trip);
                request.setAttribute("bookedSeats", bookedSeats);
                request.getRequestDispatcher("/seatSelection.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Không thể đặt vé", e);
        }
    }
}

