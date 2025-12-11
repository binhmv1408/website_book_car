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

@WebServlet(name = "TripDetailServlet", urlPatterns = {"/trip-detail"})
public class TripDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã chuyến xe");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã chuyến xe không hợp lệ");
            return;
        }

        TripDAO tripDAO = new TripDAO();
        try {
            Trip trip = tripDAO.findById(id);
            if (trip == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy chuyến xe");
                return;
            }
            request.setAttribute("trip", trip);
            request.getRequestDispatcher("/tripDetail.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải chi tiết chuyến xe", e);
        }
    }
}


