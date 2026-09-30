# Experiment 5 — JSP Login & Registration Using JDBC and Servlet

## AIM

Design a web application in JSP that validates username and password through a MySQL database using JDBC and handles user registration and login operations via Servlets.

The application demonstrates:
- JSP (JavaServer Pages) with modern HTML/CSS UI
- JavaBean
- JDBC (Java Database Connectivity)
- DAO (Data Access Object) Pattern
- Servlet (HttpServlet)
- MySQL Database
- HTTP POST Method
- User Registration (with duplicate check)
- Login Validation
- Redirect after Successful/Failed Operations

---

## Requirements

| Component         | Version / Details                                                      |
|-------------------|------------------------------------------------------------------------|
| Java JDK          | JDK 27 (`C:\Program Files\Java\jdk-27`)                               |
| Apache Tomcat     | 9.0.87 (`C:\Users\Admin\Desktop\java_practicals\exp4\java_practicals\apache-tomcat-9.0.87`) |
| Servlet API       | `javax.servlet.*` (Tomcat 9 — NOT Jakarta)                            |
| MySQL Server      | 26.7 (`C:\Program Files\MySQL\MySQL Server 26.7`)                     |
| MySQL Connector/J | 9.3.0 (`mysql-connector-j-9.3.0.jar`)                                 |
| JDBC Driver       | `com.mysql.cj.jdbc.Driver`                                            |
| IDE               | VS Code                                                               |

> **Important:** Tomcat 9 uses `javax.servlet.*`. Do NOT use `jakarta.servlet.*` (that is Tomcat 10+/11).

---

## Architecture

```
Browser (login.jsp / register.jsp)
    │
    │  HTTP POST (/login or /register)
    ▼
LoginServlet.java / RegisterServlet.java
    │
    │  Creates LoginBean, calls LoginDao
    ▼
LoginDao.java
    │
    │  JDBC → PreparedStatement (SELECT or INSERT) → MySQL
    ▼
MySQL Database (userdb.users)
    │
    │  Result
    ▼
Servlet
    │
    ├── Valid   → redirect → loginsuccess.jsp / registersuccess.jsp
    └── Invalid → redirect → login.jsp / register.jsp (with error message)
```

---

## Database Setup

### Step 1: Open MySQL Command Line

```powershell
& "C:\Program Files\MySQL\MySQL Server 26.7\bin\mysql.exe" -u root -p
```

Enter your MySQL root password when prompted.

### Step 2: Run the SQL Commands

```sql
CREATE DATABASE IF NOT EXISTS userdb;

USE userdb;

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL
);

INSERT INTO users (username, password)
VALUES
('admin', 'admin123'),
('swati', 'pass123');
```

### Step 3: Verify

```sql
SELECT * FROM users;
```

Expected output:

| id | username | password |
|----|----------|----------|
| 1  | admin    | admin123 |
| 2  | swati    | pass123  |

### Alternative: Run Script

```powershell
& "C:\Program Files\MySQL\MySQL Server 26.7\bin\mysql.exe" -u root -p < LoginJSP\setup_database.sql
```

---

## Project Structure

```
LoginJSP/
│
├── src/
│   └── net/
│       └── javaguides/
│           └── login/
│               ├── bean/
│               │   └── LoginBean.java       ← JavaBean (username, password)
│               ├── database/
│               │   └── LoginDao.java        ← DAO (JDBC + PreparedStatement)
│               └── web/
│                   ├── LoginServlet.java    ← Servlet (@WebServlet("/login"))
│                   └── RegisterServlet.java ← Servlet (@WebServlet("/register"))
│
├── web/
│   ├── login.jsp                            ← Login form (POST)
│   ├── loginsuccess.jsp                     ← Success page
│   ├── register.jsp                         ← Registration form (POST)
│   ├── registersuccess.jsp                  ← Registration success page
│   └── WEB-INF/
│       ├── web.xml                          ← Deployment descriptor
│       ├── classes/                         ← Compiled .class files
│       └── lib/
│           └── mysql-connector-j-9.3.0.jar  ← MySQL JDBC driver
│
├── setup_database.sql                       ← Database setup script
└── README.md                                ← This file
```

---

## Application Components

### JavaBean — `LoginBean.java`
- Implements `Serializable`
- Private fields: `username`, `password`
- Public getters and setters, no-argument constructor

### DAO — `LoginDao.java`
- Loads driver: `com.mysql.cj.jdbc.Driver`
- `validate()`: Uses `SELECT` query to check credentials.
- `register()`: Uses `INSERT` query to add a new user. Catches SQL Exception 1062 for duplicate usernames.
- **Note**: Ensure `PASSWORD` is set to your correct MySQL root password.

### Servlets
- `LoginServlet.java`: Handles `/login`, creates bean, calls DAO `validate()`, redirects appropriately.
- `RegisterServlet.java`: Handles `/register`, creates bean, calls DAO `register()`, redirects appropriately.

### JSP Pages
- **Modern UI**: Styled with clean CSS cards, input fields, and buttons.
- **Client-Side Validation**: Uses JavaScript to ensure fields aren't empty and passwords meet length requirements.
- **Error Handling**: Displays invalid login or duplicate username messages in red text dynamically based on URL parameters (`?error=...`).

---

## Compilation

### Prerequisites
- Tomcat 9 `servlet-api.jar`: `C:\Users\Admin\Desktop\java_practicals\exp4\java_practicals\apache-tomcat-9.0.87\lib\servlet-api.jar`
- MySQL Connector/J: `LoginJSP\web\WEB-INF\lib\mysql-connector-j-9.3.0.jar`

### Compile Command

```powershell
$TOMCAT = "C:\Users\Admin\Desktop\java_practicals\exp4\java_practicals\apache-tomcat-9.0.87"
$PROJECT = "c:\Users\Admin\Desktop\java_practicals\exp5\Java_Login_page\LoginJSP"

javac -source 11 -target 11 -d "$PROJECT\web\WEB-INF\classes" `
  -cp "$TOMCAT\lib\servlet-api.jar;$PROJECT\web\WEB-INF\lib\mysql-connector-j-9.3.0.jar" `
  "$PROJECT\src\net\javaguides\login\bean\LoginBean.java" `
  "$PROJECT\src\net\javaguides\login\database\LoginDao.java" `
  "$PROJECT\src\net\javaguides\login\web\LoginServlet.java" `
  "$PROJECT\src\net\javaguides\login\web\RegisterServlet.java"
```

---

## Deployment

### Deploy to Tomcat 9

```powershell
$TOMCAT = "C:\Users\Admin\Desktop\java_practicals\exp4\java_practicals\apache-tomcat-9.0.87"
$PROJECT = "c:\Users\Admin\Desktop\java_practicals\exp5\Java_Login_page\LoginJSP"

# Remove old deployment
Remove-Item "$TOMCAT\webapps\LoginJSP" -Recurse -Force -ErrorAction SilentlyContinue

# Deploy
Copy-Item -Path "$PROJECT\web" -Destination "$TOMCAT\webapps\LoginJSP" -Recurse -Force
```

---

## Running

### Start Tomcat 9

```powershell
cd "C:\Users\Admin\Desktop\java_practicals\exp4\java_practicals\apache-tomcat-9.0.87\bin"
.\catalina.bat run
```

### Stop Tomcat

Press `Ctrl+C` in the console, or run `.\shutdown.bat`.

---

## Testing

### Open in Browser

```
http://localhost:8080/LoginJSP/login.jsp
```

### Test Cases:

| Action | Username | Password | Expected Result |
|--------|----------|----------|-----------------|
| **Valid Login** | `admin` | `admin123` | Redirects to `loginsuccess.jsp` ("Login Successful!") |
| **Invalid Login** | `admin` | `wrongpass` | Stays on `login.jsp` with "Invalid username or password" |
| **Valid Registration** | `newuser` | `pass123` | Redirects to `registersuccess.jsp` ("Registration Successful!") |
| **Duplicate Registration**| `admin` | `anypass` | Stays on `register.jsp` with "Username already exists" |

---

## Viva Questions

### Q1: What is JSP?
**A:** JSP (JavaServer Pages) is a server-side technology that allows embedding Java code in HTML pages. It is compiled into a servlet by the web container.

### Q2: What is a JavaBean?
**A:** A JavaBean is a reusable Java class that follows specific conventions: a public no-arg constructor, private fields with public getter/setter methods, and implements `Serializable`.

### Q3: What is JDBC?
**A:** JDBC (Java Database Connectivity) is an API that provides Java programs with the ability to connect to and interact with databases using standard SQL queries.

### Q4: What is a DAO?
**A:** DAO (Data Access Object) is a design pattern that separates database operations from business logic. It provides an abstract interface to the database.

### Q5: What is a Servlet?
**A:** A Servlet is a Java class that extends the capabilities of a web server. It handles HTTP requests and generates dynamic responses.

### Q6: Why use `PreparedStatement` instead of `Statement`?
**A:** `PreparedStatement` prevents SQL injection attacks by parameterizing queries. It also offers better performance for repeated queries due to precompilation.

### Q7: What is the difference between `javax.servlet` and `jakarta.servlet`?
**A:** `javax.servlet` is used in Tomcat 9 and earlier (Java EE). `jakarta.servlet` is used in Tomcat 10+ (Jakarta EE). They are NOT interchangeable.

### Q8: What is `@WebServlet`?
**A:** `@WebServlet` is an annotation that maps a servlet to a URL pattern, replacing the need for `<servlet-mapping>` in `web.xml`.

### Q9: How is duplicate username checking handled in registration?
**A:** When inserting a user, the `username` column has a `UNIQUE` constraint. If a duplicate is inserted, MySQL throws an `SQLException` with error code `1062`. The DAO catches this and returns `false`, which the Servlet uses to show an error message.

---

## BUILD STATUS

```
Java:                ✅ JDK 27 installed
Tomcat:              ✅ Tomcat 9.0.87 running on port 8080
MySQL:               ✅ MySQL 26.7 service running
MySQL Connector/J:   ✅ mysql-connector-j-9.3.0.jar downloaded
Compilation:         ✅ All 4 classes compiled successfully
Database Setup:      ✅ userdb created, users table with records
Deployment:          ✅ Deployed to Tomcat webapps/LoginJSP
UI Redesign:         ✅ Added modern HTML/CSS/JS with validation
Login Test:          ✅ PASS — admin/admin123 → "Login Successful!"
Invalid Login Test:  ✅ PASS — admin/wrongpassword → Shows error
Registration Test:   ✅ PASS — Creates new user → "Registration Successful!"
Duplicate Username:  ✅ PASS — Prevents duplicate username → Shows error
VS Code IDE:         ✅ PASS — .vscode/settings.json created to resolve javax.servlet
```
