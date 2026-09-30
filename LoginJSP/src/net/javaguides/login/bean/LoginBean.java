package net.javaguides.login.bean;

import java.io.Serializable;

/**
 * LoginBean - A Serializable JavaBean for holding login credentials.
 * Follows the JavaBean specification with private fields and public getters/setters.
 */
public class LoginBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private String username;
    private String password;

    // Default no-arg constructor (required by JavaBean spec)
    public LoginBean() {
    }

    // Getter for username
    public String getUsername() {
        return username;
    }

    // Setter for username
    public void setUsername(String username) {
        this.username = username;
    }

    // Getter for password
    public String getPassword() {
        return password;
    }

    // Setter for password
    public void setPassword(String password) {
        this.password = password;
    }
}
