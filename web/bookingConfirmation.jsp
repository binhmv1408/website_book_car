<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Booking" %>
<%
    Booking booking = (Booking) request.getAttribute("booking");
    String ctx = request.getContextPath();
    
    if (booking == null) {
        response.sendRedirect(ctx + "/search-trips");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận đặt vé</title>
    <link rel="stylesheet" href="<%= ctx %>/carbook/css/style.css?v=1">
    <style>
        body {
            background: #f3f4f6;
            font-family: "Inter", Arial, sans-serif;
            padding: 40px 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
        }
        .card {
            background: #fff;
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 10px 32px rgba(0,0,0,0.08);
            text-align: center;
        }
        .success-icon {
            width: 80px;
            height: 80px;
            background: #10b981;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px;
            font-size: 40px;
        }
        h1 {
            margin: 0 0 8px;
            font-size: 28px;
            font-weight: 800;
            color: #111827;
        }
        .subtitle {
            color: #6b7280;
            margin-bottom: 32px;
        }
        .booking-info {
            background: #f9fafb;
            border-radius: 12px;
            padding: 24px;
            margin: 24px 0;
            text-align: left;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #e5e7eb;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            color: #6b7280;
            font-weight: 600;
        }
        .info-value {
            color: #111827;
            font-weight: 700;
        }
        .booking-id {
            background: #dbeafe;
            color: #1e40af;
            padding: 8px 16px;
            border-radius: 8px;
            display: inline-block;
            font-weight: 700;
            margin-top: 16px;
        }
        .actions {
            margin-top: 32px;
            display: flex;
            gap: 12px;
            justify-content: center;
        }
        .btn {
            border: none;
            border-radius: 10px;
            padding: 12px 24px;
            font-weight: 700;
            cursor: pointer;
            font-size: 15px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s;
        }
        .btn-primary {
            background: #2563eb;
            color: #fff;
        }
        .btn-primary:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }
        .btn-ghost {
            background: #fff;
            border: 1px solid #e5e7eb;
            color: #111827;
        }
        .btn-ghost:hover {
            background: #f9fafb;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="card">
        <div class="success-icon">✓</div>
        <h1>Đặt vé thành công!</h1>
        <p class="subtitle">Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi</p>
        
        <div class="booking-info">
            <div class="info-row">
                <span class="info-label">Mã đặt vé:</span>
                <span class="info-value">#<%= booking.getId() %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Họ và tên:</span>
                <span class="info-value"><%= booking.getCustomerName() %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Số điện thoại:</span>
                <span class="info-value"><%= booking.getCustomerPhone() %></span>
            </div>
            <% if (booking.getCustomerEmail() != null && !booking.getCustomerEmail().isEmpty()) { %>
            <div class="info-row">
                <span class="info-label">Email:</span>
                <span class="info-value"><%= booking.getCustomerEmail() %></span>
            </div>
            <% } %>
            <div class="info-row">
                <span class="info-label">Ghế đã chọn:</span>
                <span class="info-value"><%= booking.getSeatNumber() %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Tổng tiền:</span>
                <span class="info-value"><%= booking.getTotalPrice() > 0 ? String.format("%,.0f đ", booking.getTotalPrice()) : "Liên hệ" %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Trạng thái:</span>
                <span class="info-value" style="color: #10b981;">Đã xác nhận</span>
            </div>
        </div>

        <div class="actions">
            <a href="<%= ctx %>/search-trips" class="btn btn-primary">Tìm chuyến khác</a>
            <a href="<%= ctx %>/index.jsp" class="btn btn-ghost">Về trang chủ</a>
        </div>
    </div>
</div>
</body>
</html>

