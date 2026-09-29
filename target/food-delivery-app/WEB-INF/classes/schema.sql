CREATE DATABASE IF NOT EXISTS food_delivery;
USE food_delivery;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'CUSTOMER',
    address VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS food_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    is_veg BOOLEAN DEFAULT TRUE,
    category_id INT,
    rating DECIMAL(3, 2) DEFAULT 0.0,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    status VARCHAR(50) DEFAULT 'PENDING',
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    food_item_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (food_item_id) REFERENCES food_items(id)
);

-- Insert dummy data
INSERT IGNORE INTO users (username, password, role, address) VALUES 
('admin', 'admin123', 'ADMIN', 'Restaurant HQ'),
('user', 'user123', 'CUSTOMER', '123 Main St');

INSERT IGNORE INTO categories (name) VALUES ('Starters'), ('Main Course'), ('Desserts');

INSERT IGNORE INTO food_items (name, description, price, is_veg, category_id, rating) VALUES 
('Paneer Tikka', 'Spicy grilled paneer', 150.00, TRUE, 1, 4.5),
('Chicken Curry', 'Classic chicken curry', 250.00, FALSE, 2, 4.2),
('Chocolate Brownie', 'Warm chocolate brownie', 90.00, TRUE, 3, 4.8);
