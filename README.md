# Foodies - J2EE Food Delivery Application (Zomato Clone)

A comprehensive, full-stack 3-sided marketplace food delivery application built using the classic Java J2EE Web Stack (JSP, Servlets, JDBC, MySQL).

## 🚀 Technologies Used
*   **Backend:** Java 8+, Servlets (HttpServlet), JDBC
*   **Frontend:** HTML5, CSS3, JavaScript, Bootstrap 5, JSP (JavaServer Pages), JSTL, Expression Language (EL)
*   **Database:** MySQL
*   **Web Container:** Apache Tomcat (9.0+)
*   **Real-time Communication:** Java WebSockets API (javax.websocket)

## 🏗️ Architecture
The application strictly follows a **3-Tier MVC (Model-View-Controller)** Architecture:
*   **Models (Data Objects):** User.java, Cart.java, Order.java, FoodItem.java, Restaurant.java
*   **Views (UI):** JSP files (menu.jsp, cart.jsp, 	racking.jsp, dmin.jsp, etc.)
*   **Controllers (Business Logic):** Servlets (CartServlet, OrderServlet, AdminServlet, etc.)
*   **Data Access Object (DAO) Pattern:** Extensively used to decouple business logic from SQL queries (OrderDAO.java, UserDAO.java).

## ✨ Features

### 👤 1. Customer Portal
*   **User Authentication:** Secure registration and login.
*   **Restaurant Browsing & Search:** View all restaurants, live search, and 'Veg Only' filters.
*   **Categorized Menus:** Beautifully categorized menu items (Starters, Main Course, etc.).
*   **Smart Cart System:** Session-based cart with subtotal, tax, and automated freebie injections (e.g., Free Dessert on orders > ₹500).
*   **Checkout & Vouchers:** Apply promo codes and multi-address management (Home, Work, Other).
*   **Live Order Tracking:** Real-time WebSocket-powered status updates (Pending -> Preparing -> Out for Delivery -> Delivered) with a Leaflet.js interactive map route.
*   **Review System:** Rate restaurants and individual food items out of 5 stars with detailed comments.

### 🏪 2. Restaurant Admin Dashboard
*   **Analytics:** Live metrics showing Total Revenue, Total Orders, Average Customer Rating, and Menu Item counts.
*   **Live Order Management:** Real-time dashboard to accept orders (PREPARING) or reject them.
*   **Advanced Menu Management:** Add, edit, delete, and categorize menu items. Control prices, prep times, and veg/non-veg status.
*   **Customer Feedback:** View a live feed of recent customer reviews and comments.

### 🛵 3. Delivery Partner (Rider) Dashboard
*   **Rider Analytics:** Track all-time completed deliveries and total earnings.
*   **Order Dispatching:** View a pool of available orders ready for pickup.
*   **Active Delivery Mode:** Claim an order, view pickup/dropoff details, map routing, and update status to DELIVERED.

### 👑 4. Global Admin Panel
*   **Master Analytics:** 8-card metric dashboard tracking total users, platform commission (10% cut), gross volume, and daily stats.
*   **Global Menu Override:** A master Add/Edit form to forcefully manage items across any restaurant.
*   **Order Monitoring:** Live tracking of all orders across the platform.

## 🛠️ Setup Instructions
1.  **Database:** Import the provided MySQL schema/dump into your local MySQL server (Database name: ood_delivery).
2.  **Configuration:** Update the DBConnection.java file with your MySQL root username and password.
3.  **Deployment:** Open the project in IntelliJ IDEA, configure an Apache Tomcat Server, and add the project artifacts to be deployed.
4.  **Run:** Start the Tomcat server. The app will launch at http://localhost:8080/food-delivery-app.