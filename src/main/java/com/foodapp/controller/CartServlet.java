package com.foodapp.controller;

import com.foodapp.dao.FoodItemDAO;
import com.foodapp.model.Cart;
import com.foodapp.model.FoodItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private FoodItemDAO foodItemDAO;

    @Override
    public void init() {
        foodItemDAO = new FoodItemDAO();
    }

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
        
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

                if ("update".equals(action)) {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            cart.updateItemQuantity(foodId, quantity);
            
            String requestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                response.setContentType("application/json");
                response.getWriter().write("{\"status\": \"success\", \"cartCount\": " + cart.getItems().stream().mapToInt(com.foodapp.model.CartItem::getQuantity).sum() + "}");
                return;
            }
            response.sendRedirect("cart");
            return;
        }

        if ("add".equals(action)) {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            int quantity = 1;
            try {
                if (request.getParameter("quantity") != null) {
                    quantity = Integer.parseInt(request.getParameter("quantity"));
                }
            } catch (NumberFormatException ignored) {}
            
            FoodItem item = foodItemDAO.getFoodItemById(foodId);
            if (item != null) {
                cart.addItem(item, quantity);
            }
            
            // Handle AJAX request
            String requestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                response.setContentType("application/json");
                response.getWriter().write("{\"status\": \"success\", \"cartCount\": " + cart.getItems().stream().mapToInt(com.foodapp.model.CartItem::getQuantity).sum() + "}");
                return;
            }
            
            // Redirect back to menu or cart based on preference
            response.sendRedirect("menu");
        } else if ("remove".equals(action)) {
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            cart.removeItem(foodId);
            response.sendRedirect("cart");
        } else if ("apply_voucher".equals(action)) {
            String code = request.getParameter("voucherCode");
            com.foodapp.dao.VoucherDAO voucherDAO = new com.foodapp.dao.VoucherDAO();
            com.foodapp.model.Voucher voucher = voucherDAO.getVoucher(code);
            
            if (voucher != null) {
                if (voucher.getExpiryDate() != null && voucher.getExpiryDate().before(new java.util.Date())) {
                    session.setAttribute("voucherError", "This voucher has expired!");
                } else if (!voucher.isValidForAmount(cart.getSubTotal())) {
                    session.setAttribute("voucherError", "Minimum order amount of &#8377;" + voucher.getMinOrderAmount() + " required!");
                } else {
                    cart.applyVoucher(voucher.getCode(), voucher.getDiscountPercent(), voucher.getMaxDiscountCap());
                    session.setAttribute("voucherMessage", "Voucher applied successfully!");
                }
            } else {
                session.setAttribute("voucherError", "Invalid voucher code!");
            }
            response.sendRedirect("cart");
        } else if ("remove_voucher".equals(action)) {
            cart.removeVoucher();
            response.sendRedirect("cart");
        }
    }
}
