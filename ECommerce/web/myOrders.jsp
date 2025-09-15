<%@ page import="java.sql.*" %>
<%@ page import="com.ecommerce.utils.DBconnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Orders</title>
    <style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #fff;
        margin: 0;
        padding: 20px;
        color: #333;
    }

    h2 {
        text-align: center;
        color: #5a67d8; /* Soft purple */
        margin-bottom: 40px;
        font-size: 2em;
    }

    .container {
        width: 90%;
        max-width: 1000px;
        margin: auto;
        padding: 20px;
    }

    .order-block {
        background: #ffffff;
        border-radius: 15px;
        padding: 25px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        margin-bottom: 30px;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .order-block:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 25px rgba(0,0,0,0.15);
    }

    .order-block h3 {
        color: #ff6f61; /* Soft reddish */
        margin-bottom: 15px;
    }

    .order-block p {
        margin: 5px 0;
        font-size: 1em;
        color: #555;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 4px 10px rgba(0,0,0,0.05);
    }

    th, td {
        padding: 12px;
        text-align: center;
    }

    th {
        background: #783a59a1;
        color: white;
        font-weight: 600;
    }

    tr:nth-child(even) {
        background: #f5f5fa;
    }

    .item-row td {
        color: #444;
    }

    a {
        color: #5a67d8;
        text-decoration: none;
        font-weight: 600;
    }

    a:hover {
        text-decoration: underline;
        color: #ff6f61;
    }

    /* Responsive */
    @media(max-width: 768px) {
        .container { width: 95%; padding: 15px; }
        table, th, td { font-size: 14px; }
        .order-block { padding: 20px; }
    }
</style>

</head>
<body>
    <div class="container">
        <h2>My Orders</h2>

        <%
            String email = (String) session.getAttribute("userEmail"); // user email stored at login
            if (email == null) {
                out.println("<p style='color:red;'>⚠ Please <a href='login.jsp'>login</a> to view your orders.</p>");
            } else {
                try (Connection conn = DBconnection.getConnection()) {
                    String sql = "SELECT * FROM orders WHERE user_email=? ORDER BY order_date DESC";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, email);
                        try (ResultSet rs = ps.executeQuery()) {
                            boolean hasOrders = false;
                            while (rs.next()) {
                                hasOrders = true;
                                int orderId = rs.getInt("id");
                                String addr = rs.getString("address");
                                String payment = rs.getString("payment_method");
                                double total = rs.getDouble("total");
                                Timestamp date = rs.getTimestamp("order_date");
        %>
                                <div class="order-block">
                                    <h3>🛒 Order ID: <%= orderId %></h3>
                                    <p><b>Date:</b> <%= date %></p>
                                    <p><b>Address:</b> <%= addr %></p>
                                    <p><b>Payment:</b> <%= payment %></p>
                                    <p><b>Total:</b> ₹ <%= total %></p>

                                    <table>
                                        <tr>
                                            <th>Product</th>
                                            <th>Price (₹)</th>
                                            <th>Quantity</th>
                                            <th>Subtotal (₹)</th>
                                        </tr>
                                        <%
                                            String itemSql = "SELECT oi.*, p.name FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id=?";
                                            try (PreparedStatement ps2 = conn.prepareStatement(itemSql)) {
                                                ps2.setInt(1, orderId);
                                                try (ResultSet rs2 = ps2.executeQuery()) {
                                                    while (rs2.next()) {
                                                        String pname = rs2.getString("name");
                                                        double price = rs2.getDouble("price");
                                                        int qty = rs2.getInt("quantity");
                                                        double subtotal = price * qty;
                                        %>
                                                        <tr class="item-row">
                                                            <td><%= pname %></td>
                                                            <td><%= price %></td>
                                                            <td><%= qty %></td>
                                                            <td><%= subtotal %></td>
                                                        </tr>
                                        <%
                                                    }
                                                }
                                            }
                                        %>
                                    </table>
                                </div>
        <%
                            }
                            if (!hasOrders) {
                                out.println("<p style='color:blue;'>ℹ You have no orders yet. <a href='products.jsp'>Start Shopping</a></p>");
                            }
                        }
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>
</body>
</html>
