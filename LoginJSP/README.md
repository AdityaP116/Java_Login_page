# Experiment 5 — JSP Login Validation Using JDBC and Servlet

## AIM

Design a login web page in JSP that validates username and password through a MySQL database using JDBC and calls a servlet for login operations.

The application demonstrates:
- JSP (JavaServer Pages)
- JavaBean
- JDBC (Java Database Connectivity)
- DAO (Data Access Object) Pattern
- Servlet (HttpServlet)
- MySQL Database
- HTTP POST Method
- Login Validation
- Redirect after Successful/Failed Login

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
Browser (login.jsp)
    │
    │  HTTP POST (/login)
    ▼
LoginServlet.java
    │
    │  Creates LoginBean, calls LoginDao
    ▼
LoginDao.java
    │
    │  JDBC → PreparedStatement → MySQL
    ▼
MySQL Database (userdb.users)
    │
    │  Result
    ▼
LoginServlet.java
    │
    ├── Valid   → redirect → loginsuccess.jsp
    └── Invalid → redirect → login.jsp
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
│                   └── LoginServlet.java    ← Servlet (@WebServlet("/login"))
│
├── web/
│   ├── login.jsp                            ← Login form (POST)
│   ├── loginsuccess.jsp                     ← Success page
│   └── WEB-INF/
│       ├── web.xml                          ← Deployment descriptor
│       ├── classes/                         ← Compiled .class files
│       │   └── net/javaguides/login/...
│       └── lib/
│           └── mysql-connector-j-9.3.0.jar  ← MySQL JDBC driver
│
├── setup_database.sql                       ← Database setup script
└── README.md                                ← This file
```

---

## JavaBean — `LoginBean.java`

```
Package: net.javaguides.login.bean
```

- Implements `Serializable`
- Private fields: `username`, `password`
- Public getters and setters
- No-argument constructor
- Follows JavaBean specification

---

## DAO — `LoginDao.java`

```
Package: net.javaguides.login.database
```

- Uses JDBC with `DriverManager.getConnection()`
- Loads driver: `com.mysql.cj.jdbc.Driver`
- Uses `PreparedStatement` (prevents SQL injection)
- Query: `SELECT * FROM users WHERE username = ? AND password = ?`
- Uses try-with-resources for auto-closing connections
- Returns `true` if credentials match, `false` otherwise

### ⚠️ Configuration

Open `LoginDao.java` and set your MySQL password:

```java
private static final String PASSWORD = "YOUR_MYSQL_PASSWORD";
```

Replace `YOUR_MYSQL_PASSWORD` with your actual MySQL root password.

---

## Servlet — `LoginServlet.java`

```
Package: net.javaguides.login.web
```

- Annotated with `@WebServlet("/login")`
- Overrides `doPost()` method
- Reads `username` and `password` from POST request
- Creates `LoginBean` and sets values
- Calls `LoginDao.validate(loginBean)`
- Redirects to `loginsuccess.jsp` on success
- Redirects to `login.jsp` on failure

---

## JSP Pages

### `login.jsp`
- Simple HTML form with POST method
- Action: `<%= request.getContextPath() %>/login`
- Fields: Username (text), Password (password)
- Submit button: "Login"
- UTF-8 encoding

### `loginsuccess.jsp`
- Displays: "You have logged in successfully!"
- Simple HTML page with UTF-8 encoding

---

## JDBC Flow

1. User submits login form → HTTP POST to `/login`
2. `LoginServlet.doPost()` receives request
3. Servlet creates `LoginBean` with username/password
4. Servlet calls `LoginDao.validate(loginBean)`
5. `LoginDao` loads MySQL JDBC driver (`com.mysql.cj.jdbc.Driver`)
6. Opens JDBC connection to `jdbc:mysql://localhost:3306/userdb`
7. Creates `PreparedStatement` with parameterized query
8. Executes query and checks `ResultSet`
9. Returns `true` (match found) or `false` (no match)
10. Servlet redirects based on result

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
  "$PROJECT\src\net\javaguides\login\web\LoginServlet.java"
```

### Verify Compilation

```powershell
Get-ChildItem -Path "$PROJECT\web\WEB-INF\classes" -Recurse -Filter "*.class"
```

Expected output:
```
LoginBean.class
LoginDao.class
LoginServlet.class
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

### Deployed Structure

```
<TOMCAT>/webapps/LoginJSP/
├── login.jsp
├── loginsuccess.jsp
└── WEB-INF/
    ├── web.xml
    ├── classes/
    │   └── net/javaguides/login/
    │       ├── bean/LoginBean.class
    │       ├── database/LoginDao.class
    │       └── web/LoginServlet.class
    └── lib/
        └── mysql-connector-j-9.3.0.jar
```

---

## Running

### Start Tomcat 9

```powershell
cd "C:\Users\Admin\Desktop\java_practicals\exp4\java_practicals\apache-tomcat-9.0.87\bin"
.\catalina.bat run
```

> `catalina.bat run` keeps logs visible in the console window.

### Stop Tomcat

Press `Ctrl+C` in the console, or:

```powershell
cd "C:\Users\Admin\Desktop\java_practicals\exp4\java_practicals\apache-tomcat-9.0.87\bin"
.\shutdown.bat
```

---

## Testing

### Open in Browser

```
http://localhost:8080/LoginJSP/login.jsp
```

### Test 1: Valid Login

| Field    | Value    |
|----------|----------|
| Username | admin    |
| Password | admin123 |

**Expected:** Redirected to `loginsuccess.jsp` showing:
```
You have logged in successfully!
```

### Test 2: Another Valid Login

| Field    | Value   |
|----------|---------|
| Username | swati   |
| Password | pass123 |

**Expected:** Redirected to `loginsuccess.jsp`

### Test 3: Invalid Login

| Field    | Value        |
|----------|--------------|
| Username | admin        |
| Password | wrongpassword|

**Expected:** Redirected back to `login.jsp`

---

## Expected Output

### Successful Login
![Success Page]
```
You have logged in successfully!
```

### Failed Login
```
Redirected back to the login form (login.jsp)
```

---

## Common Errors & Troubleshooting

### 1. `ClassNotFoundException: com.mysql.cj.jdbc.Driver`
**Cause:** MySQL Connector/J JAR is missing from `WEB-INF/lib/`.
**Fix:** Ensure `mysql-connector-j-9.3.0.jar` is in `WEB-INF/lib/` and redeploy.

### 2. `javax.servlet cannot be resolved`
**Cause:** Compilation classpath doesn't include `servlet-api.jar`.
**Fix:** Add Tomcat 9's `servlet-api.jar` to the `-cp` classpath during compilation.

### 3. `404 Not Found`
**Cause:** App not deployed, wrong URL, or Tomcat not running.
**Fix:**
- Verify Tomcat is running
- Verify `LoginJSP/` exists in `webapps/`
- Use correct URL: `http://localhost:8080/LoginJSP/login.jsp`

### 4. `500 Internal Server Error`
**Cause:** Java exception during processing.
**Fix:** Check Tomcat logs at `<TOMCAT>/logs/catalina.out` or console output.

### 5. `Access denied for user 'root'@'localhost'`
**Cause:** Wrong MySQL password in `LoginDao.java`.
**Fix:** Update the `PASSWORD` constant in `LoginDao.java` with your correct MySQL root password, recompile, and redeploy.

### 6. `Unknown database 'userdb'`
**Cause:** Database not created yet.
**Fix:** Run the SQL setup script to create the `userdb` database.

### 7. `Table 'userdb.users' doesn't exist`
**Cause:** Table not created yet.
**Fix:** Run the CREATE TABLE SQL statement.

### 8. Port 8080 Already in Use
**Cause:** Another Tomcat instance or application is using port 8080.
**Fix:**
```powershell
netstat -aon | findstr ":8080"
taskkill /PID <PID> /F
```

### 9. JSP Compilation Errors
**Cause:** Syntax error in JSP file.
**Fix:** Check JSP syntax. Ensure `<%= ... %>` expressions are valid.

### 10. `ClassNotFoundException` (Servlet)
**Cause:** `.class` files not in `WEB-INF/classes/` with correct package structure.
**Fix:** Recompile and verify `net/javaguides/login/web/LoginServlet.class` exists.

### 11. MySQL Connection Refused
**Cause:** MySQL service not running.
**Fix:**
```powershell
Get-Service -Name "MySQL*"
Start-Service -Name "MySQL267"
```

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

### Q9: What is try-with-resources?
**A:** A Java feature that automatically closes resources (like database connections) when the try block exits, preventing resource leaks.

### Q10: What does `request.getContextPath()` return?
**A:** It returns the context path of the web application (e.g., `/LoginJSP`), which is used to construct correct URLs.

### Q11: What is `sendRedirect()`?
**A:** `sendRedirect()` sends an HTTP 302 redirect response to the client, causing the browser to make a new request to the specified URL.

### Q12: What is the role of `WEB-INF`?
**A:** `WEB-INF` is a protected directory that cannot be accessed directly by clients. It contains `web.xml`, compiled classes, and library JARs.

### Q13: Why place the MySQL Connector JAR in `WEB-INF/lib/`?
**A:** JARs in `WEB-INF/lib/` are automatically loaded by Tomcat's classloader and made available to the web application.

### Q14: What is `Class.forName("com.mysql.cj.jdbc.Driver")`?
**A:** It dynamically loads the MySQL JDBC driver class into the JVM, making it available for establishing database connections via `DriverManager`.

### Q15: What happens if the database is down?
**A:** The `DriverManager.getConnection()` call throws a `SQLException`. In our code, this is caught and the stack trace is printed. The user would see login fail.

---

## BUILD STATUS

```
Java:                ✅ JDK 27 installed
Tomcat:              ✅ Tomcat 9.0.87 running on port 8080
MySQL:               ✅ MySQL 26.7 service running
MySQL Connector/J:   ✅ mysql-connector-j-9.3.0.jar downloaded
Compilation:         ✅ All 3 classes compiled successfully
Database Setup:      ✅ userdb created, users table with 2 records
Deployment:          ✅ Deployed to Tomcat webapps/LoginJSP
Login Page (JSP):    ✅ HTTP 200 — login.jsp loads correctly
Login Test:          ✅ PASS — admin/admin123 → "You have logged in successfully!"
Invalid Login Test:  ✅ PASS — admin/wrongpassword → Redirected to login.jsp
```
