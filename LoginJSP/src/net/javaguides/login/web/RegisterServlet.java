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
 * RegisterServlet - Handles POST registration requests.
 * Reads username/password, inserts via LoginDao, and redirects accordingly.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

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

        // 3. Register using LoginDao
        LoginDao loginDao = new LoginDao();

        try {
            boolean registered = loginDao.register(loginBean);

            if (registered) {
                // 4. Registration successful
                response.sendRedirect("registersuccess.jsp");
            } else {
                // 5. Username already exists
                response.sendRedirect("register.jsp?error=duplicate");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new ServletException("MySQL JDBC Driver not found", e);
        }
    }
}
