<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - CarBook</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.85) 0%, rgba(118, 75, 162, 0.85) 100%),
                        url('<%= ctx %>/carbook/images/car-1.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-repeat: no-repeat;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }
        
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.3);
            pointer-events: none;
            z-index: 0;
        }
        
        .register-container {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 700px;
            margin: auto;
        }
        
        .register-card {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 48px 40px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: slideUpFade 0.8s ease-out;
            border: 2px solid rgba(255, 255, 255, 0.2);
            width: 100%;
            box-sizing: border-box;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .register-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 70px rgba(0, 0, 0, 0.4);
        }
        
        @keyframes slideUpFade {
            from {
                opacity: 0;
                transform: translateY(40px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }
        
        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }
        
        .logo-section {
            text-align: center;
            margin-bottom: 32px;
        }
        
        .logo-icon {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            font-size: 32px;
            color: white;
            box-shadow: 0 8px 24px rgba(102, 126, 234, 0.4);
            animation: pulse 2s ease-in-out infinite;
            transition: transform 0.3s ease;
        }
        
        .logo-icon:hover {
            transform: rotate(5deg) scale(1.1);
        }
        
        .logo-section h1 {
            font-size: 28px;
            font-weight: 800;
            color: #1a202c;
            margin-bottom: 8px;
        }
        
        .logo-section p {
            color: #6b7280;
            font-size: 15px;
        }
        
        .alert {
            padding: 14px 16px;
            border-radius: 10px;
            margin-bottom: 24px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: shake 0.5s ease-out, fadeIn 0.5s ease-out;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }
        
        .alert-error {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }
        
        .alert-icon {
            font-size: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .form-group label .required {
            color: #dc2626;
        }
        
        .input-wrapper {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
            font-size: 18px;
        }
        
        .form-group input {
            width: 100%;
            padding: 14px 16px 14px 48px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f9fafb;
            animation: fadeIn 0.6s ease-out both;
        }
        
        .form-group:nth-child(1) input {
            animation-delay: 0.1s;
        }
        
        .form-group:nth-child(2) input {
            animation-delay: 0.2s;
        }
        
        .form-group:nth-child(3) input {
            animation-delay: 0.3s;
        }
        
        .form-group:nth-child(4) input {
            animation-delay: 0.4s;
        }
        
        .form-group:nth-child(5) input {
            animation-delay: 0.5s;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }
        
        .form-group input:hover {
            border-color: #cbd5e1;
            background: #fff;
        }
        
        .btn-primary {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            margin-top: 8px;
            position: relative;
            overflow: hidden;
            animation: fadeIn 0.6s ease-out 0.6s both;
        }
        
        .btn-primary::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }
        
        .btn-primary:hover::before {
            width: 300px;
            height: 300px;
        }
        
        .btn-primary:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.6);
        }
        
        .btn-primary:active {
            transform: translateY(-1px) scale(0.98);
        }
        
        .btn-primary span {
            position: relative;
            z-index: 1;
        }
        
        .divider {
            display: flex;
            align-items: center;
            margin: 24px 0;
            color: #9ca3af;
            font-size: 14px;
        }
        
        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #e5e7eb;
        }
        
        .divider span {
            padding: 0 16px;
        }
        
        .login-link {
            text-align: center;
            margin-top: 24px;
            padding-top: 24px;
            border-top: 1px solid #e5e7eb;
        }
        
        .login-link p {
            color: #6b7280;
            font-size: 14px;
            margin-bottom: 12px;
        }
        
        .btn-secondary {
            width: 100%;
            padding: 12px;
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: block;
            position: relative;
            overflow: hidden;
            animation: fadeIn 0.6s ease-out 0.7s both;
        }
        
        .btn-secondary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(102, 126, 234, 0.1), transparent);
            transition: left 0.5s;
        }
        
        .btn-secondary:hover::before {
            left: 100%;
        }
        
        .btn-secondary:hover {
            background: #f3f4f6;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
        }
        
        .btn-secondary span {
            position: relative;
            z-index: 1;
        }
        
        @media (max-width: 768px) {
            .register-container {
                max-width: 100%;
            }
            
            .register-card {
                padding: 40px 30px;
            }
        }
        
        @media (max-width: 480px) {
            .register-card {
                padding: 32px 24px;
            }
            
            .logo-section h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-card">
            <div class="logo-section">
                <div class="logo-icon">🚌</div>
                <h1>Tạo tài khoản mới</h1>
                <p>Đăng ký để bắt đầu đặt vé</p>
            </div>
            
            <% if (error != null) { %>
                <div class="alert alert-error">
                    <span class="alert-icon">⚠️</span>
                    <span><%= error %></span>
                </div>
            <% } %>
            
            <form method="post" action="<%= ctx %>/register">
                <div class="form-group">
                    <label for="username">Tên đăng nhập <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <span class="input-icon">👤</span>
                        <input 
                            type="text" 
                            id="username" 
                            name="username" 
                            required 
                            placeholder="Nhập tên đăng nhập"
                            autocomplete="username"
                        >
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Mật khẩu <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <span class="input-icon">🔒</span>
                        <input 
                            type="password" 
                            id="password" 
                            name="password" 
                            required 
                            placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)"
                            autocomplete="new-password"
                            minlength="6"
                        >
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="fullName">Họ và tên <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <span class="input-icon">📝</span>
                        <input 
                            type="text" 
                            id="fullName" 
                            name="fullName" 
                            required 
                            placeholder="Nhập họ và tên"
                            autocomplete="name"
                        >
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="email">Email</label>
                    <div class="input-wrapper">
                        <span class="input-icon">📧</span>
                        <input 
                            type="email" 
                            id="email" 
                            name="email" 
                            placeholder="Nhập email (không bắt buộc)"
                            autocomplete="email"
                        >
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <div class="input-wrapper">
                        <span class="input-icon">📱</span>
                        <input 
                            type="tel" 
                            id="phone" 
                            name="phone" 
                            placeholder="Nhập số điện thoại (không bắt buộc)"
                            autocomplete="tel"
                        >
                    </div>
                </div>
                
                <button type="submit" class="btn-primary"><span>Đăng ký</span></button>
            </form>
            
            <div class="divider">
                <span>hoặc</span>
            </div>
            
            <div class="login-link">
                <p>Đã có tài khoản?</p>
                <a href="<%= ctx %>/login" class="btn-secondary"><span>Đăng nhập ngay</span></a>
            </div>
        </div>
    </div>
</body>
</html>

