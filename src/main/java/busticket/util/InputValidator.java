/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package busticket.util;

/**
 *
 * @author Pham Van Hoai - CE181744
 */
public class InputValidator {

    public static boolean isUsernameValid(String username) {
        return username.matches("^[a-zA-Z0-9_]{3,20}$");
        /*
            3-20 Characters
            Only allow letters, numbers, underscores (_)
         */
    }

    public static boolean isEmailValid(String email) {
        return email.matches("^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\\.[a-zA-Z]{2,})+$");
        /*
        ^                       Start of the string
        [a-zA-Z0-9]+            Username starts with a letter/number
        ([._%+-]?[a-zA-Z0-9]+)*	Allows . _ % + - in username
        @                       Required @ symbol
        [a-zA-Z0-9-]+           Domain must contain letters, numbers, or -
        (\\.[a-zA-Z]{2,})+	TLD must be at least 2 letters (.com, .org)
        $                       End of the string
         */
    }

    public static boolean isPasswordValid(String username) {
        return username.matches("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$");
        /*
        ^                   Start of the string	✅ "Password1"
        (?=.*[A-Za-z])      At least one letter (A-Z or a-z)	✅ "abc123"
        (?=.*\d)        	At least one digit (0-9)	✅ "Password1"
        [A-Za-z\d]{8,}      At least 8 characters (only letters and numbers allowed)	✅ "abc12345"
        $                   End of the string	✅ "secure123"
         */
    }
}
