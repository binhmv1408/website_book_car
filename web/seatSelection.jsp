<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Trip" %>
<%@ page import="java.util.Set" %>
<%
    Trip trip = (Trip) request.getAttribute("trip");
    Set<String> bookedSeats = (Set<String>) request.getAttribute("bookedSeats");
    String error = (String) request.getAttribute("error");
    String ctx = request.getContextPath();
    
    if (trip == null) {
        response.sendRedirect(ctx + "/search-trips");
        return;
    }
    
    int totalSeats = trip.getTotalSeats();
    if (totalSeats <= 0) totalSeats = 45; // Default cho xe giường nằm
    
    // Xe giường nằm: mỗi block có 2 ghế (1 trên, 1 dưới)
    // Tổng số block = totalSeats / 2 (làm tròn lên)
    int totalBlocks = (int) Math.ceil((double) totalSeats / 2);
    
    // Giá gốc của chuyến xe
    double basePrice = trip.getPrice();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chọn ghế - <%= trip.getRouteName() != null ? trip.getRouteName() : "Chuyến xe" %></title>
    <link rel="stylesheet" href="<%= ctx %>/carbook/css/style.css?v=1">
    <style>
        * {
            box-sizing: border-box;
        }
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        body {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.9) 0%, rgba(118, 75, 162, 0.9) 100%),
                        url('<%= ctx %>/carbook/images/bg_1.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-blend-mode: overlay;
            font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
            padding: 20px 0 40px;
            min-height: 100vh;
            position: relative;
        }
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('<%= ctx %>/carbook/images/car-1.jpg') center/cover no-repeat;
            opacity: 0.15;
            z-index: 0;
            pointer-events: none;
        }
        .container {
            position: relative;
            z-index: 1;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        .card {
            background: #fff;
            border-radius: 24px;
            padding: 32px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            margin-bottom: 24px;
            animation: fadeIn 0.6s ease-out;
            transform-style: preserve-3d;
        }
        .trip-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 32px;
            box-shadow: 0 8px 24px rgba(102, 126, 234, 0.3);
        }
        .trip-header h1 {
            margin: 0 0 12px;
            font-size: 28px;
            font-weight: 800;
            color: #fff;
        }
        .trip-header .meta {
            color: rgba(255, 255, 255, 0.9);
            font-size: 15px;
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }
        .trip-header .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .legend {
            display: flex;
            gap: 24px;
            margin-bottom: 32px;
            padding: 20px;
            background: #f8fafc;
            border-radius: 12px;
            flex-wrap: wrap;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
        }
        .legend-seat {
            width: 45px;
            height: 45px;
            border-radius: 8px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 13px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: all 0.2s ease;
            position: relative;
            border: 2px solid;
        }
        .seat-vip-label {
            font-size: 8px;
            font-weight: 600;
            color: #f59e0b;
            margin-top: 2px;
            line-height: 1;
        }
        .seat-vip .seat-vip-label {
            display: block;
        }
        .legend-seat:not(.seat-vip) .seat-vip-label {
            display: none;
        }
        .seat-available {
            background: #dbeafe;
            color: #1e40af;
            border-color: #3b82f6;
            cursor: pointer;
        }
        .seat-available:hover {
            background: #bfdbfe;
            transform: scale(1.05);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            border-color: #2563eb;
        }
        .seat-selected {
            background: #86efac;
            color: #166534;
            border-color: #22c55e;
            box-shadow: 0 4px 12px rgba(34, 197, 94, 0.4);
        }
        .seat-booked {
            background: #9ca3af;
            color: #ffffff;
            border-color: #4b5563;
            cursor: not-allowed;
            opacity: 0.7;
            position: relative;
        }
        .seat-booked::after {
            content: '✕';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 20px;
            color: #dc2626;
            font-weight: 900;
        }
        .seat-map-container {
            background: #ffffff;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 32px;
            border: 2px solid #e5e7eb;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .bus-container {
            background: #ffffff;
            border-radius: 8px;
            padding: 20px;
            border: 2px solid #d1d5db;
            position: relative;
        }
        .bus-front {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 20px;
            position: relative;
            min-height: 120px;
        }
        .front-left {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .front-right {
            display: flex;
            flex-direction: column;
            gap: 10px;
            align-items: flex-end;
        }
        .driver-area {
            background: #dbeafe;
            border-radius: 8px;
            padding: 16px;
            border: 2px solid #3b82f6;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 70px;
        }
        .steering-wheel {
            font-size: 28px;
            color: #000000;
            margin-bottom: 6px;
            font-weight: 900;
        }
        .driver-label {
            font-size: 10px;
            color: #1e40af;
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        .fridge-box {
            background: #dbeafe;
            border-radius: 6px;
            padding: 10px;
            text-align: center;
            color: #1e40af;
            font-weight: 600;
            font-size: 11px;
            border: 2px solid #3b82f6;
            min-height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .bus-door-front {
            background: #dc2626;
            border-radius: 6px;
            padding: 10px 14px;
            text-align: center;
            color: #fff;
            font-weight: 700;
            font-size: 11px;
            border: 2px solid #991b1b;
            min-width: 110px;
        }
        .aux-table {
            background: #f1f5f9;
            border-radius: 6px;
            padding: 14px;
            border: 2px solid #cbd5e1;
            min-width: 70px;
            min-height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .table-dots {
            display: flex;
            gap: 10px;
        }
        .table-dots .dot {
            font-size: 14px;
            color: #64748b;
        }
        .seat-map {
            display: flex;
            flex-direction: column;
            gap: 12px;
            max-height: 600px;
            overflow-y: auto;
            padding: 15px 10px;
            background: #ffffff;
            border-radius: 8px;
            position: relative;
        }
        .seat-map::-webkit-scrollbar {
            width: 8px;
        }
        .seat-map::-webkit-scrollbar-track {
            background: #f1f5f9;
            border-radius: 4px;
        }
        .seat-map::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 4px;
        }
        .seat-map::-webkit-scrollbar-thumb:hover {
            background: #94a3b8;
        }
        .seat-row {
            display: flex;
            gap: 12px;
            align-items: center;
            padding: 6px 0;
            position: relative;
            min-height: 100px;
        }
        .row-label {
            width: 40px;
            text-align: center;
            font-weight: 600;
            color: #374151;
            font-size: 14px;
            background: #f3f4f6;
            padding: 8px 4px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #d1d5db;
        }
        .seat-group {
            display: flex;
            flex-direction: column;
            gap: 4px;
            flex: 1;
            justify-content: center;
            position: relative;
            align-items: center;
        }
        .seat-block {
            display: flex;
            flex-direction: column;
            gap: 3px;
            align-items: center;
            padding: 4px;
            min-width: 55px;
        }
        .seat-upper {
            position: relative;
        }
        .seat-lower {
            position: relative;
        }
        .aisle {
            width: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #f1f5f9;
            font-weight: 700;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            position: relative;
            background: rgba(255,255,255,0.05);
            border-radius: 8px;
            padding: 12px 8px;
            writing-mode: vertical-rl;
            text-orientation: mixed;
        }
        .aisle::before {
            content: "││";
            font-size: 32px;
            color: rgba(255,255,255,0.3);
            position: absolute;
            letter-spacing: 12px;
        }
        .aisle::after {
            content: "LỐI ĐI";
            position: relative;
            z-index: 1;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        .booking-section {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-radius: 16px;
            padding: 28px;
            border: 2px solid #e5e7eb;
        }
        .selected-seat-info {
            background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
            border: 2px solid #10b981;
            border-radius: 12px;
            padding: 16px 20px;
            margin-bottom: 24px;
            display: none;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
        }
        .selected-seat-info.show {
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideDown 0.3s ease;
        }
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .selected-seat-info strong {
            font-size: 16px;
            color: #059669;
        }
        .selected-seat-info .seat-badge {
            background: #10b981;
            color: #fff;
            padding: 6px 14px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 16px;
        }
        .booking-form h3 {
            margin: 0 0 24px;
            font-size: 20px;
            font-weight: 800;
            color: #111827;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .booking-form h3::before {
            content: "👤";
            font-size: 24px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-weight: 700;
            color: #374151;
            margin-bottom: 8px;
            font-size: 14px;
        }
        .form-group input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.2s;
            background: #fff;
        }
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            transform: translateY(-1px);
        }
        .price-info {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border: 2px solid #fcd34d;
            border-radius: 12px;
            padding: 20px;
            margin-top: 24px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(251, 191, 36, 0.2);
        }
        .price-info .label {
            font-size: 14px;
            color: #92400e;
            font-weight: 600;
            margin-bottom: 8px;
        }
        .price-info strong {
            font-size: 28px;
            color: #92400e;
            font-weight: 800;
        }
        .actions {
            display: flex;
            gap: 12px;
            margin-top: 28px;
        }
        .btn {
            border: none;
            border-radius: 12px;
            padding: 14px 28px;
            font-weight: 700;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        .btn-primary:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
        }
        .btn-primary:disabled {
            background: #9ca3af;
            cursor: not-allowed;
            box-shadow: none;
        }
        .btn-ghost {
            background: #fff;
            border: 2px solid #e5e7eb;
            color: #111827;
        }
        .btn-ghost:hover {
            background: #f9fafb;
            border-color: #cbd5e1;
        }
        .error {
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            border: 2px solid #fca5a5;
            color: #991b1b;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2);
        }
        @media (max-width: 768px) {
            .container {
                padding: 0 12px;
            }
            .card {
                padding: 20px;
                border-radius: 16px;
            }
            .trip-header {
                padding: 20px;
            }
            .trip-header h1 {
                font-size: 22px;
            }
            .legend {
                gap: 16px;
                padding: 16px;
            }
            .seat-map-container {
                padding: 20px;
            }
            .legend-seat {
                width: 40px;
                height: 40px;
                font-size: 12px;
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
    <div class="card">
        <div class="trip-header">
            <h1><%= trip.getRouteName() != null ? trip.getRouteName() : "Chuyến xe" %></h1>
            <div class="meta">
                <div class="meta-item">
                    <span>🕐</span>
                    <span>Khởi hành: <%= trip.getDepartureTime() != null ? trip.getDepartureTime().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "--" %></span>
                </div>
                <div class="meta-item">
                    <span>🚌</span>
                    <span>Xe: <%= trip.getBusLicensePlate() != null ? trip.getBusLicensePlate() : "" %></span>
                </div>
            </div>
        </div>

        <% if (error != null) { %>
            <div class="error">⚠️ <%= error %></div>
        <% } %>

        <div class="legend">
            <div class="legend-item">
                <div class="legend-seat seat-available">A1</div>
                <span>Còn trống</span>
            </div>
            <div class="legend-item">
                <div class="legend-seat seat-selected">A1</div>
                <span>Đã chọn</span>
            </div>
            <div class="legend-item">
                <div class="legend-seat seat-booked">A1</div>
                <span>Đã đặt</span>
            </div>
        </div>

        <div class="seat-map-container">
            <div class="bus-container">
                <div class="bus-front">
                    <div class="front-left">
                        <div class="driver-area">
                            <div class="steering-wheel">⭕</div>
                            <div class="driver-label">TÀI XẾ</div>
                        </div>
                        <div class="fridge-box">❄️ TỦ LẠNH</div>
                    </div>
                    <div class="front-right">
                        <div class="bus-door-front">🚪 CỬA LÊN XUỐNG</div>
                        <div class="aux-table">
                            <div class="table-dots">
                                <span class="dot">●</span>
                                <span class="dot">●</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="seat-map" id="seatMap">
                <%
                    // Tạo sơ đồ ghế theo mô hình xe giường nằm
                    // Phân bổ từ trước ra sau: 01/02 (trái), 03/04 (phải), 05/06 (trái), 07/08 (phải)...
                    // Phía sau: 40/39 (phải), 43 (đơn, trái), 45/44 (trái)
                    
                    java.util.List<java.util.List<String>> leftSeats = new java.util.ArrayList<>();
                    java.util.List<java.util.List<String>> rightSeats = new java.util.ArrayList<>();
                    
                    // Phân bổ ghế từ trước ra sau (01 -> totalSeats)
                    // Pattern: 01/02 (trái), 03/04 (phải), 05/06 (trái), 07/08 (phải)...
                    // Ghế 43 là ghế đơn ở bên trái
                    int currentSeat = 1;
                    boolean leftSide = true; // Bắt đầu bên trái
                    
                    while (currentSeat <= totalSeats) {
                        java.util.List<String> block = new java.util.ArrayList<>();
                        
                        // Xử lý ghế 43 đặc biệt (ghế đơn)
                        if (currentSeat == 43) {
                            block.add(String.format("%02d", currentSeat));
                            currentSeat++;
                            // Ghế 43 luôn ở bên trái
                            leftSeats.add(block);
                            leftSide = false; // Tiếp theo sẽ là bên phải
                            continue;
                        }
                        
                        // Thêm ghế đầu tiên của block
                        block.add(String.format("%02d", currentSeat));
                        currentSeat++;
                        
                        // Thêm ghế thứ hai nếu còn ghế
                        if (currentSeat <= totalSeats) {
                            block.add(String.format("%02d", currentSeat));
                            currentSeat++;
                        }
                        
                        // Thêm block vào bên trái hoặc phải
                        if (leftSide) {
                            leftSeats.add(block);
                        } else {
                            rightSeats.add(block);
                        }
                        
                        // Đổi bên
                        leftSide = !leftSide;
                    }
                    
                    // Sắp xếp lại để ghế trên ở trên, ghế dưới ở dưới trong mỗi block
                    for (java.util.List<String> block : leftSeats) {
                        if (block.size() == 2) {
                            int seat1 = Integer.parseInt(block.get(0));
                            int seat2 = Integer.parseInt(block.get(1));
                            // Ghế trên (số lớn hơn) ở vị trí đầu, ghế dưới (số nhỏ hơn) ở vị trí sau
                            if (seat1 > seat2) {
                                // Đã đúng thứ tự
                            } else {
                                // Đảo lại
                                String temp = block.get(0);
                                block.set(0, block.get(1));
                                block.set(1, temp);
                            }
                        }
                    }
                    for (java.util.List<String> block : rightSeats) {
                        if (block.size() == 2) {
                            int seat1 = Integer.parseInt(block.get(0));
                            int seat2 = Integer.parseInt(block.get(1));
                            // Ghế trên (số lớn hơn) ở vị trí đầu, ghế dưới (số nhỏ hơn) ở vị trí sau
                            if (seat1 > seat2) {
                                // Đã đúng thứ tự
                            } else {
                                // Đảo lại
                                String temp = block.get(0);
                                block.set(0, block.get(1));
                                block.set(1, temp);
                            }
                        }
                    }
                    
                    // Hiển thị các hàng ghế
                    int maxBlocks = Math.max(leftSeats.size(), rightSeats.size());
                    for (int i = 0; i < maxBlocks; i++) {
                %>
                <div class="seat-row">
                    <div class="row-label"><%= String.format("%02d", i + 1) %></div>
                    <div class="seat-group">
                        <%
                            if (i < leftSeats.size()) {
                                java.util.List<String> block = leftSeats.get(i);
                                if (block.size() > 0) {
                                    String upperSeat = block.get(0);
                                    // Chuẩn hóa format: "1" -> "01", "01" -> "01"
                                    String upperSeatFormatted = String.format("%02d", Integer.parseInt(upperSeat));
                                    boolean upperBooked = bookedSeats != null && (bookedSeats.contains(upperSeat) || bookedSeats.contains(upperSeatFormatted) || bookedSeats.contains(String.valueOf(Integer.parseInt(upperSeat))));
                        %>
                        <div class="seat-block">
                            <%
                                // Kiểm tra xem ghế có phải VIP không (01-15)
                                boolean isVipUpper = false;
                                try {
                                    int seatNum = Integer.parseInt(upperSeat);
                                    isVipUpper = (seatNum >= 1 && seatNum <= 15);
                                } catch (NumberFormatException e) {
                                    // Không phải số, không phải VIP
                                }
                            %>
                            <div class="legend-seat seat-available seat-upper <%= upperBooked ? "seat-booked" : "" %> <%= isVipUpper ? "seat-vip" : "" %>" 
                                 data-seat="<%= upperSeat %>" 
                                 onclick="selectSeat('<%= upperSeat %>', <%= upperBooked ? "true" : "false" %>)">
                                <%= upperSeat %>
                                <span class="seat-vip-label">(Ghế VIP)</span>
                            </div>
                            <%
                                if (block.size() > 1) {
                                    String lowerSeat = block.get(1);
                                    // Chuẩn hóa format: "1" -> "01", "01" -> "01"
                                    String lowerSeatFormatted = String.format("%02d", Integer.parseInt(lowerSeat));
                                    boolean lowerBooked = bookedSeats != null && (bookedSeats.contains(lowerSeat) || bookedSeats.contains(lowerSeatFormatted) || bookedSeats.contains(String.valueOf(Integer.parseInt(lowerSeat))));
                                    // Kiểm tra xem ghế có phải VIP không (01-15)
                                    boolean isVipLower = false;
                                    try {
                                        int seatNum = Integer.parseInt(lowerSeat);
                                        isVipLower = (seatNum >= 1 && seatNum <= 15);
                                    } catch (NumberFormatException e) {
                                        // Không phải số, không phải VIP
                                    }
                            %>
                            <div class="legend-seat seat-available seat-lower <%= lowerBooked ? "seat-booked" : "" %> <%= isVipLower ? "seat-vip" : "" %>" 
                                 data-seat="<%= lowerSeat %>" 
                                 onclick="selectSeat('<%= lowerSeat %>', <%= lowerBooked ? "true" : "false" %>)">
                                <%= lowerSeat %>
                                <span class="seat-vip-label">(Ghế VIP)</span>
                            </div>
                            <%
                                }
                            %>
                        </div>
                        <%
                                }
                            }
                        %>
                    </div>
                    <div class="aisle">Lối đi</div>
                    <div class="seat-group">
                        <%
                            if (i < rightSeats.size()) {
                                java.util.List<String> block = rightSeats.get(i);
                                if (block.size() > 0) {
                                    String upperSeat = block.get(0);
                                    // Chuẩn hóa format: "1" -> "01", "01" -> "01"
                                    String upperSeatFormatted = String.format("%02d", Integer.parseInt(upperSeat));
                                    boolean upperBooked = bookedSeats != null && (bookedSeats.contains(upperSeat) || bookedSeats.contains(upperSeatFormatted) || bookedSeats.contains(String.valueOf(Integer.parseInt(upperSeat))));
                        %>
                        <div class="seat-block">
                            <%
                                // Kiểm tra xem ghế có phải VIP không (01-15)
                                boolean isVipUpperRight = false;
                                try {
                                    int seatNum = Integer.parseInt(upperSeat);
                                    isVipUpperRight = (seatNum >= 1 && seatNum <= 15);
                                } catch (NumberFormatException e) {
                                    // Không phải số, không phải VIP
                                }
                            %>
                            <div class="legend-seat seat-available seat-upper <%= upperBooked ? "seat-booked" : "" %> <%= isVipUpperRight ? "seat-vip" : "" %>" 
                                 data-seat="<%= upperSeat %>" 
                                 onclick="selectSeat('<%= upperSeat %>', <%= upperBooked ? "true" : "false" %>)">
                                <%= upperSeat %>
                                <span class="seat-vip-label">(Ghế VIP)</span>
                            </div>
                            <%
                                if (block.size() > 1) {
                                    String lowerSeat = block.get(1);
                                    // Chuẩn hóa format: "1" -> "01", "01" -> "01"
                                    String lowerSeatFormatted = String.format("%02d", Integer.parseInt(lowerSeat));
                                    boolean lowerBooked = bookedSeats != null && (bookedSeats.contains(lowerSeat) || bookedSeats.contains(lowerSeatFormatted) || bookedSeats.contains(String.valueOf(Integer.parseInt(lowerSeat))));
                                    // Kiểm tra xem ghế có phải VIP không (01-15)
                                    boolean isVipLowerRight = false;
                                    try {
                                        int seatNum = Integer.parseInt(lowerSeat);
                                        isVipLowerRight = (seatNum >= 1 && seatNum <= 15);
                                    } catch (NumberFormatException e) {
                                        // Không phải số, không phải VIP
                                    }
                            %>
                            <div class="legend-seat seat-available seat-lower <%= lowerBooked ? "seat-booked" : "" %> <%= isVipLowerRight ? "seat-vip" : "" %>" 
                                 data-seat="<%= lowerSeat %>" 
                                 onclick="selectSeat('<%= lowerSeat %>', <%= lowerBooked ? "true" : "false" %>)">
                                <%= lowerSeat %>
                                <span class="seat-vip-label">(Ghế VIP)</span>
                            </div>
                            <%
                                }
                            %>
                        </div>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
                <%
                    }
                %>
                </div>
                
                <div class="bus-door">CỬA LÊN XUỐNG</div>
            </div>
        </div>

        <form method="post" action="<%= ctx %>/book-trip" id="bookingForm">
            <input type="hidden" name="tripId" value="<%= trip.getId() %>">
            <input type="hidden" name="seatNumbers" id="selectedSeats" value="">
            
            <div class="selected-seat-info" id="selectedSeatInfo" style="display: none;">
                <strong>Ghế đã chọn (<span id="selectedCount">0</span>):</strong>
                <div id="selectedSeatsList" style="display: flex; flex-wrap: wrap; gap: 8px; margin-top: 8px;"></div>
            </div>

            <div class="booking-section">
                <h3>Thông tin khách hàng</h3>
                
                <div class="form-group">
                    <label for="customerName">Họ và tên *</label>
                    <input type="text" id="customerName" name="customerName" required placeholder="Nhập họ và tên">
                </div>
                
                <div class="form-group">
                    <label for="customerPhone">Số điện thoại *</label>
                    <input type="tel" id="customerPhone" name="customerPhone" required placeholder="Nhập số điện thoại">
                </div>
                
                <div class="form-group">
                    <label for="customerEmail">Email (không bắt buộc)</label>
                    <input type="email" id="customerEmail" name="customerEmail" placeholder="Nhập email (nếu có)">
                </div>

                <div class="price-info" data-base-price="<%= basePrice %>">
                    <div class="label">Tổng tiền</div>
                    <strong id="totalPrice"><%= basePrice > 0 ? String.format("%,.0f đ", basePrice) : "Liên hệ" %></strong>
                    <div class="price-note" id="priceNote" style="display: none; font-size: 12px; color: #059669; margin-top: 4px;">
                        (Ghế VIP: +5%)
                    </div>
                </div>
                
                <script>
                    // Lấy giá gốc từ data attribute
                    var basePriceValue = parseFloat(document.querySelector('.price-info').getAttribute('data-base-price')) || 0;
                    
                </script>

                <div class="actions">
                    <a href="<%= ctx %>/trip-detail?id=<%= trip.getId() %>" class="btn btn-ghost">← Quay lại</a>
                    <button type="submit" class="btn btn-primary" id="submitBtn" disabled>✓ Xác nhận đặt vé</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    let selectedSeats = []; // Mảng lưu danh sách ghế đã chọn

    // Debug: Log khi trang load
    console.log('Trang chọn ghế đã load');
    
    function selectSeat(seatId, isBooked) {
        console.log('Chọn ghế:', seatId, 'Đã đặt:', isBooked);
        try {
            if (isBooked) {
                alert('Ghế ' + seatId + ' đã được đặt. Vui lòng chọn ghế khác.');
                return;
            }

            const seatElement = document.querySelector('[data-seat="' + seatId + '"]');
            if (!seatElement) {
                console.error('Không tìm thấy ghế: ' + seatId);
                return;
            }

            // Kiểm tra ghế đã được chọn chưa
            const index = selectedSeats.indexOf(seatId);
            if (index > -1) {
                // Bỏ chọn ghế
                selectedSeats.splice(index, 1);
                seatElement.classList.remove('seat-selected');
                seatElement.classList.add('seat-available');
            } else {
                // Chọn ghế mới
                selectedSeats.push(seatId);
                seatElement.classList.remove('seat-available');
                seatElement.classList.add('seat-selected');
            }
            
            // Cập nhật UI
            updateSelectedSeatsUI();
            updateTotalPrice();
        } catch (error) {
            console.error('Lỗi khi chọn ghế:', error);
            alert('Có lỗi xảy ra khi chọn ghế. Vui lòng thử lại.');
        }
    }
    
    function updateSelectedSeatsUI() {
        const selectedSeatInput = document.getElementById('selectedSeats');
        const selectedSeatInfo = document.getElementById('selectedSeatInfo');
        const selectedCount = document.getElementById('selectedCount');
        const selectedSeatsList = document.getElementById('selectedSeatsList');
        const submitBtn = document.getElementById('submitBtn');
        
        if (selectedSeatInput) {
            selectedSeatInput.value = selectedSeats.join(',');
        }
        
        if (selectedCount) {
            selectedCount.textContent = selectedSeats.length;
        }
        
        if (selectedSeatsList) {
            selectedSeatsList.innerHTML = '';
            selectedSeats.forEach(seatId => {
                const badge = document.createElement('span');
                badge.className = 'seat-badge';
                
                // Kiểm tra xem ghế có phải VIP không (01-15)
                let isVip = false;
                try {
                    const seatNum = parseInt(seatId.replace(/^0+/, '') || seatId);
                    isVip = (seatNum >= 1 && seatNum <= 15);
                } catch (e) {
                    // Không phải số, không phải VIP
                }
                
                badge.textContent = seatId + (isVip ? ' (VIP)' : '');
                badge.style.cssText = 'background: #10b981; color: #fff; padding: 4px 10px; border-radius: 6px; font-size: 13px; font-weight: 600;';
                if (isVip) {
                    badge.style.background = '#f59e0b';
                }
                selectedSeatsList.appendChild(badge);
            });
        }
        
        if (selectedSeatInfo) {
            if (selectedSeats.length > 0) {
                selectedSeatInfo.style.display = 'flex';
                selectedSeatInfo.style.flexDirection = 'column';
            } else {
                selectedSeatInfo.style.display = 'none';
            }
        }
        
        if (submitBtn) {
            submitBtn.disabled = selectedSeats.length === 0;
        }
    }
    
    function updateTotalPrice() {
        const priceElement = document.getElementById('totalPrice');
        const priceNote = document.getElementById('priceNote');
        
        if (!priceElement || basePriceValue <= 0) return;
        
        let totalPrice = 0;
        let hasVIP = false;
        
        selectedSeats.forEach(seatId => {
            try {
                const seatNum = parseInt(seatId.replace(/^0+/, '') || seatId);
                if (seatNum >= 1 && seatNum <= 15) {
                    totalPrice += basePriceValue * 1.05;
                    hasVIP = true;
                } else {
                    totalPrice += basePriceValue;
                }
            } catch (e) {
                totalPrice += basePriceValue;
            }
        });
        
        if (selectedSeats.length === 0) {
            totalPrice = basePriceValue;
        }
        
        priceElement.textContent = totalPrice.toLocaleString('vi-VN') + ' đ';
        
        if (priceNote) {
            priceNote.style.display = hasVIP ? 'block' : 'none';
        }
    }

    const bookingForm = document.getElementById('bookingForm');
    if (bookingForm) {
        bookingForm.addEventListener('submit', function(e) {
            if (!selectedSeat) {
                e.preventDefault();
                alert('Vui lòng chọn ghế trước khi đặt vé.');
                return false;
            }
        });
    }
</script>
</body>
</html>
