/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.util;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
import java.util.*;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtils {

    // Cấu hình email (thay đổi thông tin này theo tài khoản email của bạn)
    private static final String FROM_EMAIL = "mailmaychu@gmail.com"; // Email gửi
    private static final String PASSWORD = "qijimmuyjzdofbyp"; // Mật khẩu email (hoặc App Password nếu bạn dùng 2FA)

    // Phương thức gửi email HTML
    public static boolean sendEmail(String toEmail, String subject, String body) {
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");  // Port 587 cho TLS
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");  // Enable TLS cho kết nối bảo mật

        // Tạo session và xác thực tài khoản email
        Session session = Session.getInstance(properties, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            // Tạo thông điệp email
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(body, "text/html");  // Đảm bảo nội dung là HTML

            // Gửi email
            Transport.send(message);
            return true;  // Trả về true nếu email đã được gửi thành công
        } catch (MessagingException e) {
            e.printStackTrace();
        }
        return false;  // Trả về false nếu có lỗi
    }

    // Phương thức gửi email reset mật khẩu với nội dung HTML
    public static void sendResetPasswordEmail(String userEmail, String userName, String resetLink) throws Exception {
        // Nội dung email HTML
        String htmlContent = "<!DOCTYPE html>"
                + "<html lang=\"en\">"
                + "<head>"
                + "<meta charset=\"UTF-8\">"
                + "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
                + "<title>Reset Password</title>"
                + "<style>"
                + "body {font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; color: #333;}"
                + ".container { width: 100%; max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); }"
                + ".header { text-align: center; background-color: #ef5222; color: white; padding: 20px; border-radius: 8px 8px 0 0; }"
                + ".header h1 { margin: 0; font-size: 24px; }"
                + ".content { padding: 20px; line-height: 1.6; }"
                + ".button { display: inline-block; padding: 12px 24px; background-color: #ef5222; color: white; text-decoration: none; font-weight: bold; border-radius: 4px; text-align: center; }"
                + ".footer { text-align: center; font-size: 12px; color: #777; margin-top: 20px; }"
                + ".footer a { color: #ef5222; text-decoration: none; }"
                + "</style>"
                + "</head>"
                + "<body>"
                + "<div class=\"container\">"
                + "<div class=\"header\">"
                + "<h1>Reset Your Password</h1>"
                + "</div>"
                + "<div class=\"content\">"
                + "<p>Hello " + userName + ",</p>"
                + "<p>We received a request to reset your password. Please click the link below to create a new password:</p>"
                + "<p style='text-align: center;'>"
                + "<a href='" + resetLink + "' style='color: white;' class='button'>Reset Your Password</a>"
                + "</p>"
                + "<p>If you didn’t request a password reset, you can ignore this email. Your password will remain the same.</p>"
                + "<p>Thank you for being with us!</p>"
                + "<p>Best regards, <br>The BusTicketBooking Team</p>"
                + "</div>"
                + "<div class=\"footer\">"
                + "<p>If you have any questions, feel free to <a href=\"mailto:support@yourcompany.com\">contact us</a>.</p>"
                + "<p>© [Year] [Your Company Name]. All rights reserved.</p>"
                + "</div>"
                + "</div>"
                + "</body>"
                + "</html>";

        // Gửi email
        sendEmail(userEmail, "Reset Your Password", htmlContent);
    }
}
