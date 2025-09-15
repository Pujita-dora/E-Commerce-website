<%@ page import="java.sql.*, com.ecommerce.utils.DBconnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products - E-Commerce</title>
      <style>
        /* Reset */
        * { margin:0; padding:0; box-sizing:border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #fef9f9; /* soft pastel background */
            padding: 20px;
            color: #333;
        }

        /* Navbar */
        .navbar {
            text-align: center;
            background: #a8edea; /* light aqua */
            padding: 15px 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 10px;
            margin-bottom: 30px;
        }

        .navbar a {
            color: #333;
            margin: 0 20px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: 0.3s;
        }

        .navbar a:hover {
            color: #ff7e5f; /* soft coral on hover */
        }

        /* Page title */
        h2 {
            text-align: center;
            color: #ff7e5f; /* soft coral */
            margin-bottom: 20px;
            font-size: 2em;
        }

        /* Table styles */
        table {
            width: 85%;
            margin: auto;
            border-collapse: collapse;
            background: #ffffff; /* white table */
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            border-radius: 12px;
            overflow: hidden;
        }

        th, td {
            padding: 12px 15px;
            text-align: center;
        }

        th {
            background: #ffe1e0; /* soft pink header */
            color: #ff7e5f;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background: #f9f9f9;
        }

        tr:hover {
            background: #fff2f0; /* hover highlight */
        }

        input[type="number"] {
            width: 50px;
            padding: 5px;
            border-radius: 5px;
            border: 1px solid #ccc;
            text-align: center;
        }

        .btn {
            padding: 6px 12px;
            background: #ff7e5f;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn:hover {
            background: #ff4c3b;
        }

        /* Responsive */
        @media(max-width:768px){
            table { width: 100%; }
            .navbar a { margin: 0 10px; font-size: 14px; }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">Home</a>
        <a href="products.jsp">Products</a>
        <a href="cart.jsp">Cart</a>
        <a href="myOrders.jsp">My Orders</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <h2>Available Products</h2>

    <table>
        <tr><th>Name</th><th>Description</th><th>Price (₹)</th><th>Stock</th><th>Quantity</th><th>Action</th></tr>
        <%
            try(Connection conn = DBconnection.getConnection()) {
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM products");
                while(rs.next()){
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String desc = rs.getString("description");
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("stock");
        %>
                    <tr>
                        <td><%=name%></td>
                        <td><%=desc%></td>
                        <td>₹<%=price%></td>
                        <td><%=stock%></td>
                        <form action="cart.jsp" method="get">
                        <td><input type="number" name="quantity" value="1" min="1" max="<%=stock%>" required></td>
                        <td>
                            <input type="hidden" name="productId" value="<%=id%>">
                            <button type="submit" class="btn">Add to Cart</button>
                        </td>
                        </form>
                    </tr>
        <%
                }
                rs.close();
                st.close();
            } catch(Exception e){
                out.println("<tr><td colspan='6' style='color:red;'>Error: "+e.getMessage()+"</td></tr>");
            }
        %>
    </table>
</body>
</html>