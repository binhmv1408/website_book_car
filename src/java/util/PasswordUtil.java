package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utility class để mã hóa mật khẩu bằng SHA-256
 */
public class PasswordUtil {
    
    /**
     * Hash password bằng SHA-256
     * @param password Mật khẩu gốc
     * @return Mật khẩu đã hash (hex string)
     */
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) {
            return null;
        }
        
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(password.getBytes());
            
            // Chuyển đổi byte array thành hex string
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }
    
    /**
     * Kiểm tra mật khẩu có khớp không
     * @param plainPassword Mật khẩu gốc
     * @param hashedPassword Mật khẩu đã hash
     * @return true nếu khớp, false nếu không khớp
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        
        String hashedInput = hashPassword(plainPassword);
        return hashedInput != null && hashedInput.equals(hashedPassword);
    }
}

