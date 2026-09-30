package net.javaguides.login.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import net.javaguides.login.bean.LoginBean;

/**
 * LoginDao - Data Access Object for login validation.
 * Uses JDBC with PreparedStatement to query the MySQL 'userdb' database.
 */
public class LoginDao {

    // ============================================================
    // DATABASE CONFIGURATION
    // ============================================================
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/userdb?useSSL=false&serverTimezone=UTC";
    private static final String JDBC_USERNAME = "root";

    // *** IMPORTANT: Replace this with your actual MySQL root password ***
    private static final String PASSWORD = "Admin@12345";
    // ============================================================

    private static final String VALIDATE_QUERY = "SELECT * FROM users WHERE username = ? AND password = ?";
    private static final String REGISTER_QUERY = "INSERT INTO users (username, password) VALUES (?, ?)";

    /**
     * Validates login credentials against the database.
     *
     * @param loginBean the LoginBean containing username and password
     * @return true if credentials match a record, false otherwise
     */
    public boolean validate(LoginBean loginBean) throws ClassNotFoundException {
        boolean isValid = false;

        // Load MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Use try-with-resources for automatic resource management
        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(VALIDATE_QUERY)) {

            preparedStatement.setString(1, loginBean.getUsername());
            preparedStatement.setString(2, loginBean.getPassword());

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    isValid = true;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return isValid;
    }

    /**
     * Registers a new user in the database.
     *
     * @param loginBean the LoginBean containing username and password
     * @return true if registration succeeded, false if username already exists
     */
    public boolean register(LoginBean loginBean) throws ClassNotFoundException {
        boolean registered = false;

        // Load MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Use try-with-resources for automatic resource management
        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(REGISTER_QUERY)) {

            preparedStatement.setString(1, loginBean.getUsername());
            preparedStatement.setString(2, loginBean.getPassword());

            int rowsInserted = preparedStatement.executeUpdate();
            if (rowsInserted > 0) {
                registered = true;
            }

        } catch (SQLException e) {
            // Duplicate username (UNIQUE constraint violation)
            if (e.getErrorCode() == 1062) {
                registered = false;
            } else {
                e.printStackTrace();
            }
        }

        return registered;
    }
}
