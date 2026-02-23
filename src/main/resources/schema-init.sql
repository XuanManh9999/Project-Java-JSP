CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'CUSTOMER',
    active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(15,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    image_url LONGTEXT,
    category_id INT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    shipping_address VARCHAR(500) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_order_items_product FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Admin account: email: admin@example.com, password: admin
INSERT IGNORE INTO users (id, email, password_hash, full_name, role, active) VALUES
(1, 'admin@example.com', '$2a$10$3i0lHh72S.91Cki.9CAwgOiHivOTHVbhs4cl6tn0eC/19cUNnA4nm', 'Quản trị viên', 'ADMIN', 1);

INSERT IGNORE INTO categories (name, description) VALUES
('Quà lưu niệm du lịch', 'Các món quà lưu niệm mang đậm dấu ấn địa phương'),
('Đồ trang trí', 'Các sản phẩm trang trí nhà cửa, bàn làm việc'),
('Đồ thủ công mỹ nghệ', 'Sản phẩm làm thủ công độc đáo');

INSERT INTO products (name, description, price, stock, image_url, category_id) VALUES
('Tượng Rùa Vàng', 'Tượng rùa vàng phong thủy mang lại may mắn', 250000, 50, 'https://via.placeholder.com/300x300?text=Tuong+Rua', 1),
('Bình Hoa Gốm', 'Bình hoa gốm sứ Bát Tràng cao cấp', 380000, 30, 'https://via.placeholder.com/300x300?text=Binh+Hoa', 2),
('Tranh Thêu Tay', 'Tranh thêu tay truyền thống Việt Nam', 450000, 20, 'https://via.placeholder.com/300x300?text=Tranh+Theu', 3),
('Móc Khóa Địa Danh', 'Bộ móc khóa các địa danh nổi tiếng', 85000, 100, 'https://via.placeholder.com/300x300?text=Moc+Khoa', 1),
('Đèn Lồng Tre', 'Đèn lồng tre trang trí phong cách Á Đông', 120000, 40, 'https://via.placeholder.com/300x300?text=Den+Long', 2);

