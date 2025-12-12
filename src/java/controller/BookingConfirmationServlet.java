package controller;

import dao.BookingDAO;
import model.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "BookingConfirmationServlet", urlPatterns = {"/booking-confirmation"})
public class BookingConfirmationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search-trips");
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã đặt vé không hợp lệ");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        try {
            Booking booking = bookingDAO.findById(bookingId);
            if (booking == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy thông tin đặt vé");
                return;
            }
            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/bookingConfirmation.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải thông tin đặt vé", e);
        }
    }
}

