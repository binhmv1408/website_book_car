package controller;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet xử lý đăng ký tài khoản mới
 */
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        // Validate input
        if (isBlank(username) || isBlank(password) || isBlank(fullName)) {
            req.setAttribute("error", "Vui lòng điền đầy đủ các trường bắt buộc");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (username.length() < 3) {
            req.setAttribute("error", "Tên đăng nhập phải có ít nhất 3 ký tự");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        UserDAO userDAO = new UserDAO();

        try {
            // Kiểm tra username đã tồn tại chưa
            if (userDAO.usernameExists(username)) {
                req.setAttribute("error", "Tên đăng nhập đã được sử dụng. Vui lòng chọn tên khác");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            // Kiểm tra email đã tồn tại chưa (nếu có)
            if (!isBlank(email) && userDAO.emailExists(email)) {
                req.setAttribute("error", "Email đã được sử dụng. Vui lòng sử dụng email khác");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            // Tạo user mới với role "user"
            User newUser = new User();
            newUser.setUsername(username.trim());
            // Mã hóa mật khẩu bằng SHA-256
            newUser.setPassword(PasswordUtil.hashPassword(password));
            newUser.setFullName(fullName.trim());
            newUser.setEmail(isBlank(email) ? null : email.trim());
            newUser.setPhone(isBlank(phone) ? null : phone.trim());
            newUser.setRole("user");

            int userId = userDAO.insert(newUser);

            if (userId > 0) {
                // Đăng ký thành công, chuyển về trang login với thông báo
                resp.sendRedirect(req.getContextPath() + "/login?message=" + 
                    java.net.URLEncoder.encode("Đăng ký thành công! Vui lòng đăng nhập.", "UTF-8"));
            } else {
                req.setAttribute("error", "Có lỗi xảy ra khi đăng ký. Vui lòng thử lại");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException("Lỗi kết nối database", e);
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}

