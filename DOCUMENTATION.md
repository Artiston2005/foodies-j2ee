# Foodies - Food Delivery Platform (Zomato Clone)

Foodies is a comprehensive, real-time, multi-tier food delivery ecosystem. It features role-based access for Customers, Restaurant Owners, Delivery Partners, and Platform Administrators.

## Tech Stack
*   **Backend:** Java 11, Java Servlets (javax), JSP, WebSockets (javax.websocket)
*   **Database:** MySQL (JDBC)
*   **Frontend:** HTML5, CSS3, Bootstrap 5, JavaScript (Vanilla), FontAwesome
*   **Server:** Apache Tomcat 9
*   **Build Tool:** Maven

## Platform Architecture & Features

### 1. Customer Experience
*   **Categorized Menus:** Browse restaurants and filter items by distinct categories (Starters, Main Course, etc.) with empty categories dynamically hiding based on live search and Veg filters.
*   **Cart & Smart Rewards:** Manage cart quantities with automatic subtotal calculation. Includes an automatic "Free Dessert Delight" injection system when the cart crosses &#8377;500.
*   **Real-Time Tracking:** Place orders and track delivery status with live WebSocket updates and a Leaflet.js interactive map route showing the path between the restaurant and user.
*   **Favorites & Vouchers:** "Heart" items to a dedicated dashboard, and apply complex promo codes.
*   **Dual-Tier Ratings:** Rate the overall Restaurant (1-5 stars) and individual food items with comments. Submitting reviews dynamically updates the global average rating for the item/restaurant.

### 2. Restaurant Owner Dashboard (/restaurant-admin)
*   **Advanced Menu Management:** Full CRUD interface ported from the global admin. Owners can assign categories, exact prep times, toggle Veg/Non-Veg, edit descriptions, and update prices via an inline form.
*   **Live Order Feed:** Real-time WebSocket dashboard that pops up new orders instantly.
*   **Review Feed:** Instantly read live customer text comments and star ratings directly on the main dashboard.
*   **Expanded Analytics:** Track Total Revenue, Total Orders, Average Rating (live), Menu Item Count, and Today's Performance.

### 3. Delivery Partner App (/rider-dashboard)
*   **Delivery Workflow:** View all "Available Deliveries" ready for pickup.
*   **Rider Analytics:** Top-row metric cards showing Total Deliveries Completed, All-Time Earnings, and Active Deliveries count.
*   **Status Management:** Accept a delivery and mark it "Delivered" once dropped off, updating the customer's map and tracking page in real-time.

### 4. Foodies HQ Admin (/admin)
*   **8-Metric God-Mode Dashboard:** Master view showing Total Users, Platform Commission (10%), Partner Restaurants, Total Orders, Total Menu Items, and Today's Gross Volume.
*   **Global Menu Override:** Master tool to edit or forcefully inject food items into any restaurant's menu across the platform.

## Database Schema Highlights
*   users: Stores all roles (CUSTOMER, RESTAURANT_OWNER, DELIVERY_PARTNER, ADMIN).
*   estaurants: Linked to users.owner_id, dynamically caches average ating.
*   ood_items: Includes is_veg, category_id, prep_time, and caches average ating.
*   orders & order_items: Includes status (PENDING, PREPARING, OUT_FOR_DELIVERY, DELIVERED).
*   estaurant_reviews & reviews: Handles the dual-tier rating system, backed by SQL AVG() triggers.