package net.javaguides.login.web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.javaguides.login.bean.LoginBean;
import net.javaguides.login.database.LoginDao;

/**
 * LoginServlet - Handles POST login requests.
 * Reads username/password, validates via LoginDao, and redirects accordingly.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Read username and password from request
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 2. Create LoginBean and set values
        LoginBean loginBean = new LoginBean();
        loginBean.setUsername(username);
        loginBean.setPassword(password);

        // 3. Validate using LoginDao
        LoginDao loginDao = new LoginDao();

        try {
            if (loginDao.validate(loginBean)) {
                // 4. Valid credentials - forward to success page
                response.sendRedirect("loginsuccess.jsp");
            } else {
                // 5. Invalid credentials - redirect back to login page
                response.sendRedirect("login.jsp?error=invalid");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new ServletException("MySQL JDBC Driver not found", e);
        }
    }
}
