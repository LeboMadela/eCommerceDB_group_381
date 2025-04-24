CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Table: brand
CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL
);

-- Insert 5 brands (excluding Nike, Apple, Samsung)
INSERT INTO brand (brand_name) VALUES 
('Puma'), ('Dell'), ('HP'), ('LG'), ('Reebok');

-- Table: product_category
CREATE TABLE product_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

INSERT INTO product_category (category_name) VALUES 
('Footwear'), ('Electronics'), ('Laptops'), ('Clothing'), ('Home Appliances');

-- Table: product
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    brand_id INT,
    category_id INT,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id),
    FOREIGN KEY (category_id) REFERENCES product_category(category_id)
);

-- Insert 5 products for each brand (25 total)
INSERT INTO product (name, base_price, brand_id, category_id) VALUES 
-- Puma (Footwear/Clothing)
('Puma Sneakers Blaze', 95.00, 1, 1),
('Puma Running Shoes', 110.00, 1, 1),
('Puma Slides', 45.00, 1, 1),
('Puma Track Jacket', 75.00, 1, 4),
('Puma Hoodie', 85.00, 1, 4),

-- Dell (Laptops)
('Dell XPS 13', 1200.00, 2, 3),
('Dell Inspiron 15', 900.00, 2, 3),
('Dell Latitude', 1050.00, 2, 3),
('Dell G5 Gaming', 1500.00, 2, 3),
('Dell Precision', 1700.00, 2, 3),

-- HP (Laptops)
('HP Spectre x360', 1400.00, 3, 3),
('HP Envy', 1100.00, 3, 3),
('HP Pavilion', 850.00, 3, 3),
('HP EliteBook', 1300.00, 3, 3),
('HP Omen', 1600.00, 3, 3),

-- LG (Home Appliances)
('LG Washing Machine', 600.00, 4, 5),
('LG Fridge', 850.00, 4, 5),
('LG Microwave', 300.00, 4, 5),
('LG Dishwasher', 700.00, 4, 5),
('LG Air Conditioner', 950.00, 4, 5),

-- Reebok (Footwear/Clothing)
('Reebok Classic Leather', 90.00, 5, 1),
('Reebok Nano X', 110.00, 5, 1),
('Reebok Joggers', 55.00, 5, 4),
('Reebok Sports Bra', 40.00, 5, 4),
('Reebok Hoodie', 70.00, 5, 4);

-- Table: product_image
CREATE TABLE product_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    image_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Add one image per product
INSERT INTO product_image (product_id, image_url)
SELECT product_id, CONCAT('images/product_', product_id, '.jpg') FROM product;

-- Table: color
CREATE TABLE color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(50) NOT NULL
);

INSERT INTO color (color_name) VALUES 
('Black'), ('White'), ('Grey'), ('Red'), ('Blue');

-- Table: size_category
CREATE TABLE size_category (
    size_cat_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

INSERT INTO size_category (category_name) VALUES 
('Clothing Sizes'), ('Shoe Sizes'), ('Laptop Models'), ('Appliance Volume'), ('Generic Sizes');

-- Table: size_option
CREATE TABLE size_option (
    size_id INT AUTO_INCREMENT PRIMARY KEY,
    size_cat_id INT,
    size_label VARCHAR(10) NOT NULL,
    FOREIGN KEY (size_cat_id) REFERENCES size_category(size_cat_id)
);

INSERT INTO size_option (size_cat_id, size_label) VALUES 
(1, 'S'), (1, 'M'), (1, 'L'), 
(2, '42'), (2, '44');

-- Table: product_item
CREATE TABLE product_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    sku VARCHAR(100) NOT NULL,
    stock_quantity INT NOT NULL,
    price DECIMAL(10, 2),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Insert product items for first 5 products as sample
INSERT INTO product_item (product_id, sku, stock_quantity, price) VALUES 
(1, 'PUMA-BLAZE-42', 20, 95.00),
(2, 'PUMA-RUN-44', 15, 110.00),
(3, 'PUMA-SLIDE-BLK', 30, 45.00),
(4, 'PUMA-JACKET-M', 25, 75.00),
(5, 'PUMA-HOODIE-S', 18, 85.00);

-- Table: product_variation
CREATE TABLE product_variation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    color_id INT,
    size_id INT,
    FOREIGN KEY (item_id) REFERENCES product_item(item_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id),
    FOREIGN KEY (size_id) REFERENCES size_option(size_id)
);

INSERT INTO product_variation (item_id, color_id, size_id) VALUES 
(1, 1, 4), -- Black, 42
(2, 2, 5), -- White, 44
(3, 3, NULL), -- Grey, No size
(4, 4, 2), -- Red, M
(5, 5, 1); -- Blue, S

-- Table: attribute_type
CREATE TABLE attribute_type (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL
);

INSERT INTO attribute_type (type_name) VALUES 
('Text'), ('Number'), ('Boolean'), ('Date'), ('Float');

-- Table: attribute_category
CREATE TABLE attribute_category (
    attr_cat_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

INSERT INTO attribute_category (category_name) VALUES 
('Technical'), ('Style'), ('Build'), ('Function'), ('Material');

-- Table: product_attribute
CREATE TABLE product_attribute (
    attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    attr_cat_id INT,
    type_id INT,
    attr_name VARCHAR(100),
    attr_value VARCHAR(255),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (attr_cat_id) REFERENCES attribute_category(attr_cat_id),
    FOREIGN KEY (type_id) REFERENCES attribute_type(type_id)
);

INSERT INTO product_attribute (product_id, attr_cat_id, type_id, attr_name, attr_value) VALUES 
(1, 3, 1, 'Material', 'Leather'),
(2, 1, 2, 'Weight', '0.8'),
(3, 2, 1, 'Style', 'Slide'),
(4, 4, 1, 'Function', 'Windbreaker'),
(5, 5, 1, 'Material', 'Fleece');