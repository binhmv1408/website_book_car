package dao;

import model.Booking;
import model.BookingItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class BookingDAO {
    
    // Lấy danh sách ghế đã được đặt cho một chuyến xe
    // Lấy từ booking_items (mới) và bookings (cũ để tương thích)
    public Set<String> getBookedSeats(int tripId) throws SQLException {
        Set<String> bookedSeats = new HashSet<>();
        
        // Lấy từ booking_items (cấu trúc mới)
        String sql = "SELECT bi.seat_number FROM booking_items bi " +
                     "INNER JOIN bookings b ON bi.booking_id = b.id " +
                     "WHERE b.trip_id = ? AND b.status != 'cancelled'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String seatNum = rs.getString("seat_number");
                    addSeatFormats(bookedSeats, seatNum);
                }
            }
        }
        
        // Lấy từ bookings cũ (để tương thích với dữ liệu cũ)
        String sqlOld = "SELECT seat_number FROM bookings WHERE trip_id = ? AND status != 'cancelled' AND seat_number IS NOT NULL";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlOld)) {
            ps.setInt(1, tripId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String seatNum = rs.getString("seat_number");
                    addSeatFormats(bookedSeats, seatNum);
                }
            }
        }
        
        return bookedSeats;
    }
    
    private void addSeatFormats(Set<String> bookedSeats, String seatNum) {
        if (seatNum == null || seatNum.trim().isEmpty()) return;
        bookedSeats.add(seatNum);
        // Thêm format chuẩn hóa nếu là số
        try {
            int num = Integer.parseInt(seatNum);
            String normalized = String.format("%02d", num);
            bookedSeats.add(normalized);
            // Thêm format không có số 0 đứng trước
            bookedSeats.add(String.valueOf(num));
        } catch (NumberFormatException e) {
            // Không phải số, giữ nguyên
        }
    }

    // Đếm số ghế đã được đặt cho một chuyến xe
    public int getBookedSeatsCount(int tripId) throws SQLException {
        // Đếm từ booking_items (mới)
        String sql = "SELECT COUNT(*) as count FROM booking_items bi " +
                     "INNER JOIN bookings b ON bi.booking_id = b.id " +
                     "WHERE b.trip_id = ? AND b.status != 'cancelled'";
        int count = 0;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("count");
                }
            }
        }
        
        // Cộng thêm từ bookings cũ (để tương thích)
        String sqlOld = "SELECT COUNT(*) as count FROM bookings WHERE trip_id = ? AND status != 'cancelled' AND seat_number IS NOT NULL";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlOld)) {
            ps.setInt(1, tripId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count += rs.getInt("count");
                }
            }
        }
        
        return count;
    }

    // Kiểm tra ghế có còn trống không
    // Kiểm tra cả format gốc và format chuẩn hóa
    public boolean isSeatAvailable(int tripId, String seatNumber) throws SQLException {
        if (seatNumber == null || seatNumber.trim().isEmpty()) {
            return false;
        }
        
        String normalized = seatNumber.trim();
        // Thử chuẩn hóa nếu là số
        try {
            int num = Integer.parseInt(normalized);
            normalized = String.format("%02d", num);
        } catch (NumberFormatException e) {
            // Không phải số, giữ nguyên
        }
        
        // Kiểm tra từ booking_items (mới)
        String sql = "SELECT COUNT(*) as count FROM booking_items bi " +
                     "INNER JOIN bookings b ON bi.booking_id = b.id " +
                     "WHERE b.trip_id = ? AND (bi.seat_number = ? OR bi.seat_number = ?) AND b.status != 'cancelled'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            ps.setString(2, seatNumber.trim());
            ps.setString(3, normalized);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt("count") > 0) {
                    return false;
                }
            }
        }
        
        // Kiểm tra từ bookings cũ (để tương thích)
        String sqlOld = "SELECT COUNT(*) as count FROM bookings WHERE trip_id = ? AND (seat_number = ? OR seat_number = ?) AND status != 'cancelled'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlOld)) {
            ps.setInt(1, tripId);
            ps.setString(2, seatNumber.trim());
            ps.setString(3, normalized);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") == 0;
                }
            }
        }
        return true;
    }

    // Tạo booking mới và trả về ID
    public int insert(Booking booking) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            // Insert booking
            String sql = "INSERT INTO bookings(trip_id, customer_name, customer_phone, customer_email, quantity, status, total_price, seat_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            int bookingId = 0;
            try (PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, booking.getTripId());
                ps.setString(2, booking.getCustomerName());
                ps.setString(3, booking.getCustomerPhone());
                ps.setString(4, booking.getCustomerEmail());
                ps.setInt(5, booking.getQuantity() > 0 ? booking.getQuantity() : 1);
                ps.setString(6, booking.getStatus());
                ps.setDouble(7, booking.getTotalPrice());
                // Giữ seat_number để tương thích (lấy ghế đầu tiên hoặc danh sách)
                String firstSeat = booking.getItems() != null && !booking.getItems().isEmpty() 
                    ? booking.getItems().get(0).getSeatNumber() 
                    : booking.getSeatNumber();
                ps.setString(8, firstSeat);
                ps.executeUpdate();
                
                // Lấy ID vừa được tạo
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        bookingId = rs.getInt(1);
                    }
                }
            }
            
            // Insert booking_items nếu có
            if (bookingId > 0 && booking.getItems() != null && !booking.getItems().isEmpty()) {
                String itemSql = "INSERT INTO booking_items(booking_id, seat_number, seat_price) VALUES (?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(itemSql)) {
                    for (BookingItem item : booking.getItems()) {
                        ps.setInt(1, bookingId);
                        ps.setString(2, item.getSeatNumber());
                        ps.setDouble(3, item.getSeatPrice());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }
            
            conn.commit();
            return bookingId;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    // Lấy booking theo ID
    public Booking findById(int id) throws SQLException {
        String sql = "SELECT id, trip_id, customer_name, customer_phone, customer_email, quantity, seat_number, booking_date, status, total_price FROM bookings WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking booking = new Booking();
                    booking.setId(rs.getInt("id"));
                    booking.setTripId(rs.getInt("trip_id"));
                    booking.setCustomerName(rs.getString("customer_name"));
                    booking.setCustomerPhone(rs.getString("customer_phone"));
                    booking.setCustomerEmail(rs.getString("customer_email"));
                    booking.setQuantity(rs.getInt("quantity"));
                    booking.setSeatNumber(rs.getString("seat_number"));
                    booking.setBookingDate(rs.getTimestamp("booking_date") != null ? rs.getTimestamp("booking_date").toLocalDateTime() : null);
                    booking.setStatus(rs.getString("status"));
                    booking.setTotalPrice(rs.getDouble("total_price"));
                    
                    // Lấy danh sách ghế từ booking_items
                    List<BookingItem> items = getBookingItems(id);
                    booking.setItems(items);
                    
                    return booking;
                }
            }
        }
        return null;
    }

    // Lấy tất cả bookings của một chuyến xe
    public List<Booking> findByTripId(int tripId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT id, trip_id, customer_name, customer_phone, customer_email, seat_number, booking_date, status, total_price FROM bookings WHERE trip_id = ? ORDER BY booking_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(new Booking(
                            rs.getInt("id"),
                            rs.getInt("trip_id"),
                            rs.getString("customer_name"),
                            rs.getString("customer_phone"),
                            rs.getString("customer_email"),
                            rs.getString("seat_number"),
                            rs.getTimestamp("booking_date") != null ? rs.getTimestamp("booking_date").toLocalDateTime() : null,
                            rs.getString("status"),
                            rs.getDouble("total_price")
                    ));
                }
            }
        }
        return bookings;
    }

    // Cập nhật trạng thái booking
    public void updateStatus(int id, String status) throws SQLException {
        String sql = "UPDATE bookings SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    // Cập nhật thông tin khách hàng
    public void updateCustomerInfo(int id, String customerName, String customerPhone, String customerEmail) throws SQLException {
        String sql = "UPDATE bookings SET customer_name = ?, customer_phone = ?, customer_email = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerName);
            ps.setString(2, customerPhone);
            ps.setString(3, customerEmail);
            ps.setInt(4, id);
            ps.executeUpdate();
        }
    }

    // Lấy tất cả bookings
    public List<Booking> getAllBookings() throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT id, trip_id, customer_name, customer_phone, customer_email, quantity, booking_date, status, total_price, seat_number " +
                     "FROM bookings ORDER BY booking_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setTripId(rs.getInt("trip_id"));
                booking.setCustomerName(rs.getString("customer_name"));
                booking.setCustomerPhone(rs.getString("customer_phone"));
                booking.setCustomerEmail(rs.getString("customer_email"));
                booking.setQuantity(rs.getInt("quantity"));
                booking.setBookingDate(rs.getTimestamp("booking_date") != null ? rs.getTimestamp("booking_date").toLocalDateTime() : null);
                booking.setStatus(rs.getString("status"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                booking.setSeatNumber(rs.getString("seat_number"));
                
                // Lấy danh sách ghế từ booking_items
                List<BookingItem> items = getBookingItems(booking.getId());
                booking.setItems(items);
                
                bookings.add(booking);
            }
        }
        return bookings;
    }

    // Lấy danh sách ghế của một booking
    public List<BookingItem> getBookingItems(int bookingId) throws SQLException {
        List<BookingItem> items = new ArrayList<>();
        String sql = "SELECT id, booking_id, seat_number, seat_price FROM booking_items WHERE booking_id = ? ORDER BY seat_number";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(new BookingItem(
                        rs.getInt("id"),
                        rs.getInt("booking_id"),
                        rs.getString("seat_number"),
                        rs.getDouble("seat_price")
                    ));
                }
            }
        }
        return items;
    }

    // Xóa booking (sẽ tự động xóa booking_items do CASCADE)
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM bookings WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}

