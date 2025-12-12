package controller;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet xử lý đăng nhập
 * Kiểm tra thông tin đăng nhập từ database
 */
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (isBlank(username) || isBlank(password)) {
            req.setAttribute("error", "Vui lòng nhập đủ tên đăng nhập và mật khẩu");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = null;

        try {
            // Tìm user trong database
            user = userDAO.findByUsernameAndPassword(username, password);
            
            // Nếu không tìm thấy, thử với admin hardcode (để tương thích)
            // Kiểm tra cả password plain và hash
            if (user == null && "admin".equalsIgnoreCase(username)) {
                User adminUser = userDAO.findByUsername("admin");
                boolean isAdminPassword = "admin".equals(password) || 
                    (adminUser != null && PasswordUtil.verifyPassword(password, adminUser.getPassword()));
                
                if (isAdminPassword) {
                    // Tạo session với admin (fallback)
                    HttpSession session = req.getSession(true);
                    session.setAttribute("username", username);
                    session.setAttribute("userRole", "admin");
                    session.setAttribute("fullName", "Quản trị viên");
                    
                    redirectAfterLogin(req, resp, "admin", session);
                    return;
                }
            }
            
            if (user == null) {
                req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }
            
            // Kiểm tra user có bị block không
            if (user.isBlocked()) {
                req.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            // Đăng nhập thành công
            HttpSession session = req.getSession(true);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("userId", user.getId());

            redirectAfterLogin(req, resp, user.getRole(), session);
            
        } catch (SQLException e) {
            throw new ServletException("Lỗi kết nối database", e);
        }
    }

    private void redirectAfterLogin(HttpServletRequest req, HttpServletResponse resp, String role, HttpSession session) throws IOException {
        // Kiểm tra xem có URL cần redirect sau khi đăng nhập không
        String redirectUrl = session != null ? (String) session.getAttribute("redirectAfterLogin") : null;
        if (redirectUrl != null && session != null) {
            session.removeAttribute("redirectAfterLogin");
            // Chỉ redirect về URL đã lưu nếu role phù hợp
            if ("admin".equals(role) && redirectUrl.contains("/admin")) {
                resp.sendRedirect(req.getContextPath() + redirectUrl);
            } else if ("user".equals(role) && !redirectUrl.contains("/admin")) {
                resp.sendRedirect(req.getContextPath() + redirectUrl);
            } else {
                // Role không khớp với URL, redirect về trang mặc định
                if ("admin".equals(role)) {
                    resp.sendRedirect(req.getContextPath() + "/admin");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/index.jsp");
                }
            }
        } else {
            // Không có URL redirect, điều hướng theo role
            if ("admin".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/admin");
            } else {
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
            }
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}


