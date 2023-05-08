CREATE DATABASE little_lemon;
USE little_lemon;
CREATE TABLE Customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  phone_number VARCHAR(20),
  address VARCHAR(100),
  city VARCHAR(50),
  state VARCHAR(50),
  zip_code VARCHAR(20)
);
CREATE TABLE Orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  order_date DATE,
  order_total DECIMAL(10, 2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE Products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  product_name VARCHAR(100),
  description TEXT,
  price DECIMAL(10, 2),
  image_url VARCHAR(200)
);
CREATE TABLE Order_Items (
  order_item_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT,
  product_id INT,
  quantity INT,
  price DECIMAL(10, 2),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
CREATE PROCEDURE `GetMaxQuantity` (IN `orderId` INT, IN `productId` INT, OUT `maxQuantity` INT)
BEGIN
    SELECT MAX(quantity) INTO maxQuantity 
    FROM inventory 
    WHERE product_id = productId 
    AND quantity > 0
    AND product_id IN (SELECT product_id FROM order_product WHERE order_id = orderId)
END;
CREATE PROCEDURE `ManageBooking` (IN `customerId` INT, IN `bookingId` INT, IN `addBooking` BOOLEAN)
BEGIN
    DECLARE quantity INT;
    DECLARE product_id INT;

    SELECT quantity, product_id FROM booking WHERE id = bookingId AND customer_id = customerId INTO quantity, product_id;

    IF addBooking = TRUE THEN
        IF quantity IS NULL THEN
            SET quantity = 1;
            INSERT INTO booking (customer_id, product_id, quantity) VALUES (customerId, product_id, quantity);
        ELSE
            SET quantity = quantity + 1;
            UPDATE booking SET quantity = quantity WHERE id = bookingId AND customer_id = customerId;
        END IF;
    ELSE
        IF quantity IS NOT NULL THEN
            IF quantity = 1 THEN
                DELETE FROM booking WHERE id = bookingId AND customer_id = customerId;
            ELSE
                SET quantity = quantity - 1;
                UPDATE booking SET quantity = quantity WHERE id = bookingId AND customer_id = customerId;
            END IF;
        END IF;
    END IF;
END;
CREATE PROCEDURE `UpdateBooking` (IN `bookingId` INT, IN `newQuantity` INT)
BEGIN
    IF newQuantity > 0 THEN
        UPDATE booking SET quantity = newQuantity WHERE id = bookingId
    END IF;
END;
CREATE PROCEDURE `AddBooking` (IN `customerId` INT, IN `productId` INT)
BEGIN
    INSERT INTO booking (customer_id, product_id, quantity) VALUES (customerId, productId, 1)
END;
CREATE PROCEDURE `CancelBooking` (IN `bookingId` INT)
BEGIN
    DELETE FROM booking WHERE id = bookingId
END;
