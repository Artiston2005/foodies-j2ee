<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Food Delivery App</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        header { background-color: #ff6b6b; color: white; padding: 1em; text-align: center; }
        nav { display: flex; justify-content: space-between; background-color: #333; padding: 10px; }
        nav a { color: white; text-decoration: none; padding: 10px; }
        .container { padding: 20px; }
    </style>
</head>
<body>

<header>
    <h1>Food Delivery App</h1>
</header>

<nav>
    <div>
        <a href="index.jsp">Home</a>
        <a href="menu.jsp">Menu (Meals)</a>
        <a href="cart.jsp">Cart</a>
    </div>
    <div>
        <% if (session.getAttribute("loggedUser") != null) { %>
            <span style="color: white; margin-right: 10px;">Welcome, <%= ((com.foodapp.model.User)session.getAttribute("loggedUser")).getUsername() %>!</span>
            <a href="logout">Logout</a>
        <% } else { %>
            <a href="login.jsp">Login</a>
        <% } %>
    </div>
</nav>

<div class="container">
    <h2>Welcome to the Food Delivery App!</h2>
    <p>Browse our delicious meals, add to cart, and enjoy fast delivery.</p>
    <ul>
        <li>Explore Categories (Veg / Non-Veg)</li>
        <li>Filter by Rating & Distance</li>
        <li>Order and Generate Bill (Payment Gateway)</li>
    </ul>
</div>

</body>
</html>
