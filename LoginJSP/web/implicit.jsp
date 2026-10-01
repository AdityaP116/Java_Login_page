<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html>

    <head>
        <title>Implicit Objects Demo</title>
    </head>

    <body>

        <h2>JSP Implicit Objects Example</h2>

        <p>
            <b>Request Parameter:</b>
            <%= request.getParameter("username") %>
        </p>

        <p>
            <b>Session ID:</b>
            <%= session.getId() %>
        </p>

        <p>
            <b>Application Context Path:</b>
            <%= application.getContextPath() %>
        </p>

        <p>
            <b>Server Info:</b>
            <%= config.getServletContext().getServerInfo() %>
        </p>

        <p>
            <b>Writer Output using out:</b>
            <% out.println("Hello from 'out' implicit object!"); %>
        </p>

    </body>

    </html>