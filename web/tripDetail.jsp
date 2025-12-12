<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Trip" %>
<%
    Trip trip = (Trip) request.getAttribute("trip");
    String ctx = request.getContextPath();
    java.time.format.DateTimeFormatter dtFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    Integer availableSeats = (Integer) request.getAttribute("availableSeats");
    Integer totalSeats = (Integer) request.getAttribute("totalSeats");
    if (availableSeats == null && trip != null) {
        availableSeats = trip.getTotalSeats();
    }
    if (totalSeats == null && trip != null) {
        totalSeats = trip.getTotalSeats();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết chuyến xe</title>
    <link rel="stylesheet" href="<%= ctx %>/carbook/css/style.css?v=1">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            background: 
                linear-gradient(135deg, rgba(102, 126, 234, 0.85) 0%, rgba(118, 75, 162, 0.85) 100%),
                url('<%= ctx %>/carbook/images/car-1.jpg') center/cover no-repeat fixed;
            font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
            min-height: 100vh;
            padding: 20px;
            position: relative;
        }
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                linear-gradient(135deg, rgba(102, 126, 234, 0.75) 0%, rgba(118, 75, 162, 0.75) 100%),
                url('<%= ctx %>/carbook/images/bg_1.jpg') center/cover no-repeat;
            z-index: -1;
            filter: blur(1px);
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }
        .header {
            text-align: center;
            color: #fff;
            margin-bottom: 30px;
        }
        .header h1 {
            font-size: 32px;
            font-weight: 800;
            margin-bottom: 8px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
        .header .subtitle {
            font-size: 16px;
            opacity: 0.9;
        }
        .card {
            background: #ffffff;
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            position: relative;
            overflow: hidden;
        }
        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
        }
        .route-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f3f4f6;
        }
        .route-title {
            flex: 1;
        }
        .route-title h2 {
            font-size: 28px;
            font-weight: 800;
            color: #111827;
            margin-bottom: 6px;
        }
        .route-title .trip-id {
            color: #6b7280;
            font-size: 14px;
            font-weight: 600;
        }
        .route-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .info-card {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-radius: 16px;
            padding: 20px;
            border: 2px solid #e5e7eb;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .info-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
        }
        .info-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.1);
            border-color: #667eea;
        }
        .info-card .icon {
            font-size: 24px;
            margin-bottom: 12px;
            display: block;
        }
        .info-card label {
            display: block;
            font-weight: 700;
            color: #6b7280;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        .info-card .value {
            font-size: 18px;
            font-weight: 700;
            color: #111827;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .highlight-card {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border: 2px solid #fcd34d;
            grid-column: 1 / -1;
        }
        .highlight-card::before {
            background: linear-gradient(180deg, #f59e0b 0%, #d97706 100%);
        }
        .highlight-card .value {
            color: #92400e;
            font-size: 24px;
        }
        .seats-info {
            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
            border: 2px solid #3b82f6;
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .seats-info .seats-text {
            flex: 1;
        }
        .seats-info .seats-text label {
            display: block;
            font-weight: 700;
            color: #1e40af;
            font-size: 14px;
            margin-bottom: 6px;
        }
        .seats-info .seats-text .seats-count {
            font-size: 32px;
            font-weight: 800;
            color: #1e40af;
        }
        .seats-info .seats-icon {
            font-size: 64px;
            opacity: 0.3;
        }
        .actions {
            display: flex;
            gap: 16px;
            margin-top: 30px;
        }
        .btn {
            flex: 1;
            border: none;
            border-radius: 12px;
            padding: 16px 24px;
            font-weight: 700;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 28px rgba(102, 126, 234, 0.5);
        }
        .btn-ghost {
            background: #fff;
            border: 2px solid #e5e7eb;
            color: #374151;
        }
        .btn-ghost:hover {
            background: #f9fafb;
            border-color: #cbd5e1;
        }
        .price-badge {
            display: inline-block;
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: #fff;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 700;
            margin-left: 8px;
        }
        @media (max-width: 768px) {
            .container {
                padding: 0;
            }
            .card {
                padding: 24px;
                border-radius: 20px;
            }
            .route-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }
            .route-icon {
                width: 60px;
                height: 60px;
                font-size: 30px;
            }
            .info-grid {
                grid-template-columns: 1fr;
            }
            .actions {
                flex-direction: column;
            }
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>🚌 Chi tiết chuyến xe</h1>
        <div class="subtitle">Thông tin đầy đủ về chuyến đi của bạn</div>
    </div>
    
    <div class="card">
        <div class="route-header">
            <div class="route-title">
                <h2><%= trip != null && trip.getRouteName() != null ? trip.getRouteName() : "Chuyến xe" %></h2>
                <div class="trip-id">Mã chuyến: #<%= trip != null ? trip.getId() : "" %></div>
            </div>
            <div class="route-icon">🚌</div>
        </div>

        <div class="info-grid">
            <div class="info-card">
                <span class="icon">🕐</span>
                <label>Khởi hành</label>
                <div class="value">
                    <%= trip != null && trip.getDepartureTime() != null ? trip.getDepartureTime().format(dtFmt) : "--" %>
                </div>
            </div>
            
            <div class="info-card">
                <span class="icon">📍</span>
                <label>Điểm đi</label>
                <div class="value">
                    <%= trip != null ? trip.getOrigin() : "" %>
                </div>
            </div>
            
            <div class="info-card">
                <span class="icon">🎯</span>
                <label>Điểm đến</label>
                <div class="value">
                    <%= trip != null ? trip.getDestination() : "" %>
                </div>
            </div>
            
            <div class="info-card">
                <span class="icon">📏</span>
                <label>Quãng đường</label>
                <div class="value">
                    <%= trip != null ? String.format("%,.1f", trip.getDistanceKm()) + " km" : "" %>
                </div>
            </div>
            
            <div class="info-card highlight-card">
                <span class="icon">💰</span>
                <label>Giá vé</label>
                <div class="value">
                    <%= trip != null && trip.getPrice() > 0 ? String.format("%,.0f đ", trip.getPrice()) : "Liên hệ" %>
                    <% if (trip != null && trip.getPrice() > 0) { %>
                    <span class="price-badge">Từ</span>
                    <% } %>
                </div>
            </div>
            
            <div class="info-card">
                <span class="icon">🚗</span>
                <label>Biển số xe</label>
                <div class="value">
                    <%= trip != null ? trip.getBusLicensePlate() : "" %>
                </div>
            </div>
        </div>

        <div class="seats-info">
            <div class="seats-text">
                <label>Số chỗ còn lại</label>
                <div class="seats-count">
                    <%= availableSeats != null ? availableSeats : 0 %>
                    <% if (totalSeats != null) { %>
                    <span style="font-size: 18px; color: #3b82f6; font-weight: 600;">/ <%= totalSeats %></span>
                    <% } %>
                </div>
            </div>
            <div class="seats-icon">🪑</div>
        </div>

        <div class="actions">
            <a class="btn btn-ghost" href="<%= ctx %>/search-trips">
                ← Quay lại
            </a>
            <a class="btn btn-primary" href="<%= ctx %>/select-seats?tripId=<%= trip != null ? trip.getId() : "" %>">
                🎫 Chọn ghế và đặt vé
            </a>
        </div>
    </div>
</div>
</body>
</html>

