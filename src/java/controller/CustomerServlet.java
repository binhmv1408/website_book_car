package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet quản lý khách hàng (users với role = 'user')
 */
public class CustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String idStr = req.getParameter("id");
        
        UserDAO userDAO = new UserDAO();
        
        try {
            if ("delete".equals(action) && idStr != null) {
                // Xóa khách hàng (chỉ qua POST)
                resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                return;
            }
            
            if ("detail".equals(action) && idStr != null) {
                // Xem chi tiết khách hàng
                int id = Integer.parseInt(idStr);
                User customer = userDAO.findById(id);
                if (customer != null) {
                    req.setAttribute("customer", customer);
                    req.getRequestDispatcher("/customerDetail.jsp").forward(req, resp);
                    return;
                } else {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
            }
            
            if ("edit".equals(action) && idStr != null) {
                // Hiển thị form sửa khách hàng
                int id = Integer.parseInt(idStr);
                User customer = userDAO.findById(id);
                if (customer != null) {
                    req.setAttribute("customer", customer);
                    req.getRequestDispatcher("/customerEdit.jsp").forward(req, resp);
                    return;
                } else {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
            }
            
            // Hiển thị danh sách khách hàng (bao gồm cả admin để admin có thể quản lý)
            List<User> customers = userDAO.getAllUsers();
            req.setAttribute("customers", customers);
            req.getRequestDispatcher("/customers.jsp").forward(req, resp);
            
        } catch (SQLException e) {
            throw new ServletException("Lỗi kết nối database", e);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String idStr = req.getParameter("id");
        
        UserDAO userDAO = new UserDAO();
        
        if ("delete".equals(action) && idStr != null) {
            // Xóa khách hàng (chỉ xóa user, không xóa admin)
            try {
                int id = Integer.parseInt(idStr);
                User user = userDAO.findById(id);
                if (user != null && "admin".equals(user.getRole())) {
                    req.getSession().setAttribute("errorMessage", "Không thể xóa tài khoản admin");
                } else {
                    boolean deleted = userDAO.delete(id);
                    if (deleted) {
                        req.getSession().setAttribute("successMessage", "Xóa khách hàng thành công");
                    } else {
                        req.getSession().setAttribute("errorMessage", "Không thể xóa khách hàng này");
                    }
                }
            } catch (NumberFormatException e) {
                req.getSession().setAttribute("errorMessage", "ID không hợp lệ");
            } catch (SQLException e) {
                req.getSession().setAttribute("errorMessage", "Lỗi khi xóa khách hàng");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/customers");
            return;
        }
        
        if ("block".equals(action) && idStr != null) {
            // Block user
            try {
                int id = Integer.parseInt(idStr);
                String currentUsername = (String) req.getSession().getAttribute("username");
                User user = userDAO.findById(id);
                
                if (user == null) {
                    req.getSession().setAttribute("errorMessage", "Không tìm thấy người dùng");
                } else if (user.getUsername().equals(currentUsername)) {
                    req.getSession().setAttribute("errorMessage", "Không thể khóa chính tài khoản của bạn");
                } else if ("admin".equals(user.getRole())) {
                    req.getSession().setAttribute("errorMessage", "Không thể khóa tài khoản admin");
                } else {
                    boolean blocked = userDAO.blockUser(id);
                    if (blocked) {
                        req.getSession().setAttribute("successMessage", "Đã khóa tài khoản thành công");
                    } else {
                        req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi khóa tài khoản");
                    }
                }
            } catch (NumberFormatException e) {
                req.getSession().setAttribute("errorMessage", "ID không hợp lệ");
            } catch (SQLException e) {
                req.getSession().setAttribute("errorMessage", "Lỗi khi khóa tài khoản");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/customers");
            return;
        }
        
        if ("unblock".equals(action) && idStr != null) {
            // Unblock user
            try {
                int id = Integer.parseInt(idStr);
                boolean unblocked = userDAO.unblockUser(id);
                if (unblocked) {
                    req.getSession().setAttribute("successMessage", "Đã mở khóa tài khoản thành công");
                } else {
                    req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi mở khóa tài khoản");
                }
            } catch (NumberFormatException e) {
                req.getSession().setAttribute("errorMessage", "ID không hợp lệ");
            } catch (SQLException e) {
                req.getSession().setAttribute("errorMessage", "Lỗi khi mở khóa tài khoản");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/customers");
            return;
        }
        
        if ("block".equals(action) && idStr != null) {
            // Block user
            try {
                int id = Integer.parseInt(idStr);
                String currentUsername = (String) req.getSession().getAttribute("username");
                User user = userDAO.findById(id);
                
                if (user == null) {
                    req.getSession().setAttribute("errorMessage", "Không tìm thấy người dùng");
                } else if (user.getUsername().equals(currentUsername)) {
                    req.getSession().setAttribute("errorMessage", "Không thể khóa chính tài khoản của bạn");
                } else if ("admin".equals(user.getRole())) {
                    req.getSession().setAttribute("errorMessage", "Không thể khóa tài khoản admin");
                } else {
                    boolean blocked = userDAO.blockUser(id);
                    if (blocked) {
                        req.getSession().setAttribute("successMessage", "Đã khóa tài khoản thành công");
                    } else {
                        req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi khóa tài khoản");
                    }
                }
            } catch (NumberFormatException e) {
                req.getSession().setAttribute("errorMessage", "ID không hợp lệ");
            } catch (SQLException e) {
                req.getSession().setAttribute("errorMessage", "Lỗi khi khóa tài khoản");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/customers");
            return;
        }
        
        if ("unblock".equals(action) && idStr != null) {
            // Unblock user
            try {
                int id = Integer.parseInt(idStr);
                boolean unblocked = userDAO.unblockUser(id);
                if (unblocked) {
                    req.getSession().setAttribute("successMessage", "Đã mở khóa tài khoản thành công");
                } else {
                    req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi mở khóa tài khoản");
                }
            } catch (NumberFormatException e) {
                req.getSession().setAttribute("errorMessage", "ID không hợp lệ");
            } catch (SQLException e) {
                req.getSession().setAttribute("errorMessage", "Lỗi khi mở khóa tài khoản");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/customers");
            return;
        }
        
        if (!"update".equals(action) || idStr == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            User customer = userDAO.findById(id);
            
            if (customer == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            // Lấy username của admin hiện tại
            String currentUsername = (String) req.getSession().getAttribute("username");
            boolean isCurrentUser = customer.getUsername().equals(currentUsername);
            
            // Cập nhật thông tin khách hàng
            String fullName = req.getParameter("fullName");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String role = req.getParameter("role");
            
            customer.setFullName(fullName);
            customer.setEmail(email);
            customer.setPhone(phone);
            
            // Chỉ cho phép sửa role nếu không phải chính admin hiện tại
            if (role != null && (role.equals("admin") || role.equals("user")) && !isCurrentUser) {
                customer.setRole(role);
            }
            
            boolean updated = userDAO.updateUser(customer);
            
            if (updated) {
                req.getSession().setAttribute("successMessage", "Cập nhật thông tin thành công");
            } else {
                req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật");
            }
            
            resp.sendRedirect(req.getContextPath() + "/admin/customers?action=detail&id=" + id);
            
        } catch (SQLException e) {
            throw new ServletException("Lỗi kết nối database", e);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
        }
    }
}

