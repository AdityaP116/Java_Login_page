<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Explicit Objects Demo</title>
</head>
<body>
    <h2>JSP Explicit Objects Example</h2>
    <p>
        <%
            // Creating an explicit object (unlike implicit objects like request or response)
            java.util.Date date = new java.util.Date();
            out.println("The current date and time (from an explicit Date object) is: " + date.toString());
        %>
    </p>
</body>
</html>
