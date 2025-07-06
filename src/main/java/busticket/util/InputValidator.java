/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.util;

/**
 *
 * @author Nguyen Thanh Truong - CE180140
 */
public class InputValidator {

    /**
     * Validates if a username is between 3 and 20 characters and contains only
     * letters, numbers, and underscores.
     *
     * Examples: "user_name123" → valid "us" → too short "invalid-user!" →
     * invalid characters
     *
     * @param username the input string to validate
     * @return true if valid, false otherwise
     */
    public static boolean isUsernameValid(String username) {
        return username.matches("^[a-zA-Z0-9_]{3,20}$");
    }

    /**
     * Validates an email address format using a regular expression that
     * supports common email standards including subdomains.
     *
     * Examples: "user@example.com" → valid "user.name123@gmail.co.uk" → valid
     * "user@.com" → invalid domain
     *
     * @param email the input string to validate
     * @return true if valid, false otherwise
     */
    public static boolean isEmailValid(String email) {
        return email.matches("^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\\.[a-zA-Z]{2,})+$");
    }

    /**
     * Validates if a password contains at least 8 characters, including: - At
     * least one uppercase letter - At least one lowercase letter - At least one
     * digit - At least one special character
     *
     * Examples: "Password1!" → valid "password" → missing uppercase, digit,
     * special character "PASSWORD123" → missing lowercase, special character
     *
     * @param password the input string to validate
     * @return true if valid, false otherwise
     */
    public static boolean isPasswordValid(String password) {
        return password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$");
    }

    /**
     * Validates a Vietnamese phone number based on standard prefixes and
     * 10-digit format (e.g., 0987654321, 039xxxxxxx, 089xxxxxxx).
     *
     * Allowed prefixes include: - 03[2-9] - 05[6,8,9] - 07[0,6-9] - 08[1-9] -
     * 09[0-9]
     *
     * Examples: "0912345678" → valid "0123456789" → invalid prefix
     *
     * @param phone the input string to validate
     * @return true if valid, false otherwise
     */
    public static boolean isVietnamesePhoneValid(String phone) {
        return phone != null && phone.matches("^0(3[2-9]|5[6|8|9]|7[0|6-9]|8[1-9]|9[0-9])\\d{7}$");
    }

    /**
     * Validates if a driver license number is 6 to 12 characters, alphanumeric
     * only.
     *
     * Examples: "B12345" → valid, "123456789012" → valid, "AB#12!" → invalid
     *
     * @param licenseNumber the input license number
     * @return true if valid, false otherwise
     */
    public static boolean isLicenseNumberValid(String licenseNumber) {
        return licenseNumber != null && licenseNumber.matches("^\\d{12}$");
    }

    /**
     * Validates if license class is one of allowed values: D, D2.
     *
     * @param licenseClass the input license class
     * @return true if valid, false otherwise
     */
    public static boolean isLicenseClassValid(String licenseClass) {
        return "D".equalsIgnoreCase(licenseClass) || "D2".equalsIgnoreCase(licenseClass);
    }

    /**
     * Validates if driver status is Active or Inactive (case-insensitive).
     *
     * @param status the input status
     * @return true if valid, false otherwise
     */
    public static boolean isDriverStatusValid(String status) {
        return "Active".equalsIgnoreCase(status) || "Inactive".equalsIgnoreCase(status);
    }

    /**
     * Validates if hire date is in the format yyyy-MM-dd (strict).
     *
     * @param date the input string date
     * @return true if valid date, false otherwise
     */
    public static boolean isDateValid(String date) {
        if (date == null || date.trim().isEmpty()) {
            return false;
        }
        try {
            java.time.LocalDate.parse(date); // will throw exception if invalid
            return true;
        } catch (Exception e) {
            return false;
        }
    }

}
