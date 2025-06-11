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
import jakarta.mail.util.*;

public class EmailUtils {

    // Cấu hình email (thay đổi thông tin này theo tài khoản email của bạn)
    private static final String FROM_EMAIL = "mailmaychu@gmail.com"; // Email gửi
    private static final String PASSWORD = "myzqvrfacskuppax"; // Mật khẩu email

    // Phương thức gửi email
    public static boolean sendEmail(String toEmail, String subject, String body) {
        Properties properties = new Properties();
    properties.put("mail.smtp.host", "smtp.gmail.com");
    properties.put("mail.smtp.port", "587");  // Use port 587 for TLS
    properties.put("mail.smtp.auth", "true");
    properties.put("mail.smtp.starttls.enable", "true");  // Enable TLS for secure connection

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
            message.setText(body);

            // Gửi email
            Transport.send(message);
            return true;  // Trả về true nếu email đã được gửi thành công
        } catch (MessagingException e) {
            e.printStackTrace();
        }
        return false;  // Trả về false nếu có lỗi
    }
}
