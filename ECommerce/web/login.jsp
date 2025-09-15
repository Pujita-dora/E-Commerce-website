<%@ page import="java.util.*, java.sql.*, com.ecommerce.utils.DBconnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // If user already logged in, redirect to index.jsp
    if (session.getAttribute("userEmail") != null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - E-Commerce</title>
    <style>
    /* Reset default margin and padding */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #fdfbfb, #ebedee);
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        color: #333;
    }

    .login-box {
        background: #ffffff;
        padding: 40px 30px;
        border-radius: 15px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        width: 350px;
        text-align: center;
        animation: fadeIn 1s ease-in-out;
    }

    .login-box h2 {
        margin-bottom: 30px;
        color: #5a67d8; /* soft purple */
        font-size: 2em;
        font-weight: 600;
    }

    input {
        width: 100%;
        padding: 12px 15px;
        margin: 10px 0;
        border: 1px solid #ccc;
        border-radius: 10px;
        font-size: 1em;
        transition: all 0.3s ease;
    }

    input:focus {
        outline: none;
        border-color: #5a67d8;
        box-shadow: 0 0 8px rgba(90,103,216,0.3);
    }

    button {
        width: 100%;
        padding: 12px;
        margin-top: 20px;
        background: #5a67d8;
        color: white;
        font-weight: bold;
        border: none;
        border-radius: 10px;
        cursor: pointer;
        font-size: 1em;
        transition: all 0.3s ease;
    }

    button:hover {
        background: #4c51bf;
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
    }

    .error {
        color: #e53e3e;
        margin-top: 15px;
        font-weight: 500;
    }

    .register-link {
        display: block;
        margin-top: 20px;
        font-size: 0.9em;
        color: #5a67d8;
        text-decoration: none;
        transition: color 0.3s ease;
    }

    .register-link:hover {
        color: #4c51bf;
        text-decoration: underline;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-20px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @media(max-width: 400px) {
        .login-box {
            width: 90%;
            padding: 30px 20px;
        }
    }
</style>

</head>
<body>
    <div class="login-box">
        <h2>Login</h2>
        <form method="post" action="login.jsp">
            <input type="text" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        <a href="register.jsp" class="register-link">New user? Register here</a>

        <%
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (email != null && password != null) {
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    conn = DBconnection.getConnection();
                    ps = conn.prepareStatement("SELECT * FROM users WHERE email=? AND password=?");
                    ps.setString(1, email);
                    ps.setString(2, password); // plain text for simplicity
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        session.setAttribute("userEmail", email); // store session
                        response.sendRedirect("index.jsp");
                    } else {
                        out.println("<p class='error'>Invalid email or password!</p>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception ex) {}
                    try { if (ps != null) ps.close(); } catch (Exception ex) {}
                    try { if (conn != null) conn.close(); } catch (Exception ex) {}
                }
            }
        %>
    </div>
</body>
</html>
