package com.foodapp.controller;

import com.foodapp.model.Cart;
import com.foodapp.model.User;
import com.foodapp.dao.OrderDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        
        if (cart != null && !cart.getItems().isEmpty()) {
            int restaurantId = cart.getItems().get(0).getFoodItem().getRestaurantId();
            com.foodapp.dao.RestaurantDAO restaurantDAO = new com.foodapp.dao.RestaurantDAO();
            com.foodapp.model.Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);
            request.setAttribute("restaurant", restaurant);
        }
        
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart != null && !cart.getItems().isEmpty()) {

            // Item Total + Delivery (45) + Platform (5) + AI Existence Fee (10) + Bad Humour Tax (15) + GST (5%)
            double finalAmount = cart.getTotalAmount() + 45.0 + 5.0 + 10.0 + 15.0 + (cart.getTotalAmount() * 0.05);
            String paymentMethod = request.getParameter("paymentMethod");
            if (paymentMethod == null || paymentMethod.isEmpty()) paymentMethod = "COD";

            OrderDAO orderDAO = new OrderDAO();
            boolean success = orderDAO.createOrder(user.getId(), cart, finalAmount, paymentMethod);

                        if (success) {
                int latestOrderId = orderDAO.getLatestOrderIdForUser(user.getId());
                
                // Real-time broadcast to Restaurant Owner(s)
                java.util.Set<Integer> notified = new java.util.HashSet<>();
                for (com.foodapp.model.CartItem item : cart.getItems()) {
                    int rId = item.getFoodItem().getRestaurantId();
                    if (notified.add(rId)) {
                        com.foodapp.websocket.LiveUpdateServer.broadcast("restaurant", String.valueOf(rId), "{\"type\":\"NEW_ORDER\", \"orderId\":" + latestOrderId + "}");
                    }
                }

                cart.clear();
                session.setAttribute("successMessage", "Order placed successfully!");
                response.sendRedirect("track?orderId=" + latestOrderId);
            } else {
                response.sendRedirect("checkout.jsp?error=true");
            }
        } else {
            response.sendRedirect("cart");
        }
    }
}

