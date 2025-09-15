<%@ page import="java.sql.*, com.ecommerce.utils.DBconnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Registration</title>
    <style>
    /* Reset and box-sizing */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    body {
        background: linear-gradient(135deg, #fdfbfb, #ebedee);
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        color: #333;
    }

    .form-container {
        background: #ffffff;
        padding: 40px 35px;
        border-radius: 15px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        width: 400px;
        animation: fadeIn 1s ease-in-out;
    }

    .form-container h2 {
        text-align: center;
        color: #5a67d8; /* soft purple */
        font-size: 2em;
        font-weight: 600;
        margin-bottom: 25px;
    }

    label {
        display: block;
        margin-top: 15px;
        font-weight: 500;
        color: #555;
    }

    input, textarea, select {
        width: 100%;
        padding: 10px 12px;
        margin-top: 5px;
        border: 1px solid #ccc;
        border-radius: 10px;
        font-size: 0.95em;
        transition: all 0.3s ease;
    }

    input:focus, textarea:focus, select:focus {
        outline: none;
        border-color: #5a67d8;
        box-shadow: 0 0 8px rgba(90,103,216,0.2);
    }

    button {
        margin-top: 25px;
        padding: 12px;
        width: 100%;
        border: none;
        background: #5a67d8;
        color: white;
        font-weight: bold;
        font-size: 1em;
        border-radius: 12px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    button:hover {
        background: #4c51bf;
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(0,0,0,0.15);
    }

    .success, .error {
        text-align: center;
        margin-top: 15px;
        font-weight: 500;
    }

    .success { color: #38a169; } /* green */
    .error { color: #e53e3e; } /* red */

    a {
        color: #5a67d8;
        text-decoration: none;
        transition: color 0.3s ease;
    }

    a:hover {
        color: #4c51bf;
        text-decoration: underline;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-20px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @media(max-width: 420px) {
        .form-container {
            width: 90%;
            padding: 30px 20px;
        }
    }
</style>

</head>
<body>
    <div class="form-container">
        <h2>User Registration</h2>
        <form method="post" action="register.jsp">
            <label>Full Name:</label>
            <input type="text" name="fullname" required>

            <label>Email:</label>
            <input type="email" name="email" required>

            <label>Password:</label>
            <input type="password" name="password" required>

            <label>Gender:</label>
            <select name="gender" required>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
            </select>

            <label>Date of Birth:</label>
            <input type="date" name="dob" required>

            <label>Phone:</label>
            <input type="text" name="phone" required>

            <label>Address:</label>
            <textarea name="address" rows="3"></textarea>

            <label>Role:</label>
            <select name="role" required>
                <option value="User" selected>User</option>
                <option value="Admin">Admin</option>
                <option value="Guest">Guest</option>
            </select>

            <button type="submit">Register</button>
        </form>

        <%
            // Process registration only if form is submitted
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String gender = request.getParameter("gender");
            String dob = request.getParameter("dob");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String role = request.getParameter("role");

            if (fullname != null && email != null && password != null) {
                Connection conn = null;
                PreparedStatement ps = null;
                try {
                    conn = DBconnection.getConnection();

                    // Check if email already exists
                    ps = conn.prepareStatement("SELECT * FROM users WHERE email=?");
                    ps.setString(1, email);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        out.println("<p class='error'>Email already exists! Try another.</p>");
                    } else {
                        // Insert new user
                        ps = conn.prepareStatement(
                            "INSERT INTO users(fullname,email,password,gender,dob,phone,address,role) VALUES (?,?,?,?,?,?,?,?)"
                        );
                        ps.setString(1, fullname);
                        ps.setString(2, email);
                        ps.setString(3, password); // For simplicity, plain text (can use hashing later)
                        ps.setString(4, gender);
                        ps.setString(5, dob);
                        ps.setString(6, phone);
                        ps.setString(7, address);
                        ps.setString(8, role);

                        int rows = ps.executeUpdate();
                        if (rows > 0) {
                            out.println("<p class='success'>Registration successful! <a href='login.jsp'>Login here</a></p>");
                        }
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                    e.printStackTrace(); // ✅ Logs to server console
                } finally {
                    try { if (ps != null) ps.close(); } catch (Exception ex) {}
                    try { if (conn != null) conn.close(); } catch (Exception ex) {}
                }
            }
        %>
    </div>
</body>
</html>
