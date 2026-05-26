-- ============================================================
--  SHOPPING SYSTEM - COMPLETE SQL SCRIPT
--  Covers: DDL, Cart operations, Checkout, Order reporting
-- ============================================================


-- ============================================================
-- PART 1: DROP TABLES (in dependency order)
-- ============================================================

DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS order_header;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS products_menu;


-- ============================================================
-- PART 2: CREATE TABLES
-- ============================================================

-- Create a table to store all products available on the menu
CREATE TABLE products_menu (

    -- Unique ID for each product (auto-increments)
    id SERIAL PRIMARY KEY,

    -- Name of the product
    -- VARCHAR(100) allows text up to 100 characters
    -- NOT NULL means the field cannot be empty
    name VARCHAR(100) NOT NULL,

    -- Price of the product
    -- DECIMAL(10,2) stores numbers with 2 decimal places
    -- Example: 199.99
    -- NOT NULL means every product must have a price
    price DECIMAL(10, 2) NOT NULL
);

-- Create a table to store system users/customers
CREATE TABLE users (

    -- Unique ID for each user (auto-increments)
    user_id SERIAL PRIMARY KEY,

    -- Username of the customer/user
    -- Cannot be empty because of NOT NULL
    username VARCHAR(100) NOT NULL
);

-- Create a table to store shopping cart items
CREATE TABLE cart (

    -- ID of the product added to the cart
    -- References the id column from products_menu
    -- FOREIGN KEY relationship ensures valid products only
    product_id INT PRIMARY KEY REFERENCES products_menu(id),

    -- Quantity of the product in the cart
    -- DEFAULT 1 means if no value is provided, quantity becomes 1
    qty INT NOT NULL DEFAULT 1
);

-- Create a table to store order information
CREATE TABLE order_header (

    -- Unique ID for each order
    order_id SERIAL PRIMARY KEY,

    -- Stores which user placed the order
    -- References user_id from users table
    user_id INT NOT NULL REFERENCES users(user_id),

    -- Date and time when the order was created
    -- CURRENT_TIMESTAMP automatically inserts current date & time
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create a table to store products inside each order
CREATE TABLE order_details (

    -- Stores the order this item belongs to
    -- References order_id from order_header table
    order_header_id INT NOT NULL REFERENCES order_header(order_id),

    -- Stores the product included in the order
    -- References id from products_menu table
    product_id INT NOT NULL REFERENCES products_menu(id),

    -- Quantity of the product ordered
    qty INT NOT NULL,

    -- Composite Primary Key
    -- Prevents duplicate products in the same order
    PRIMARY KEY (order_header_id, product_id)
);


-- ============================================================
-- SEED DATA  (matches the sample data from the brief)
-- ============================================================

INSERT INTO products_menu (id, name, price) VALUES
    (1, 'Coke',  10.00),
    (2, 'Chips',  5.00);

INSERT INTO users (user_id, username) VALUES
    (1, 'Arnold'),
    (2, 'Sheryl');


-- ============================================================
-- PART 3: ADD ITEMS TO CART
-- ============================================================

-- Scenario A: Add a Coke  (product does NOT yet exist in cart → insert qty 1)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM cart WHERE product_id = 1) THEN
        UPDATE cart SET qty = qty + 1 WHERE product_id = 1;
    ELSE
        INSERT INTO cart (product_id, qty) VALUES (1, 1);
    END IF;
END $$;

SELECT * FROM cart;   -- expected: Coke qty = 1

-- Scenario B: Add a Coke again  (product EXISTS → increment qty)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM cart WHERE product_id = 1) THEN
        UPDATE cart SET qty = qty + 1 WHERE product_id = 1;
    ELSE
        INSERT INTO cart (product_id, qty) VALUES (1, 1);
    END IF;
END $$;

SELECT * FROM cart;   -- expected: Coke qty = 2

-- Scenario C: Add Chips  (product does NOT yet exist in cart → insert qty 1)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM cart WHERE product_id = 2) THEN
        UPDATE cart SET qty = qty + 1 WHERE product_id = 2;
    ELSE
        INSERT INTO cart (product_id, qty) VALUES (2, 1);
    END IF;
END $$;

SELECT * FROM cart;   -- expected: Coke qty 2, Chips qty 1


-- ============================================================
-- PART 4: REMOVE ITEMS FROM CART
-- ============================================================

-- Remove one Coke:
--   qty > 1  → subtract 1
--   qty = 1  → delete the row entirely
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM cart WHERE product_id = 1 AND qty > 1) THEN
        UPDATE cart SET qty = qty - 1 WHERE product_id = 1;
    ELSE
        DELETE FROM cart WHERE product_id = 1;
    END IF;
END $$;

SELECT * FROM cart;   -- expected: Coke qty 1, Chips qty 1

-- Remove the last Coke (qty is now 1 → full row deleted)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM cart WHERE product_id = 1 AND qty > 1) THEN
        UPDATE cart SET qty = qty - 1 WHERE product_id = 1;
    ELSE
        DELETE FROM cart WHERE product_id = 1;
    END IF;
END $$;

SELECT * FROM cart;   -- expected: only Chips qty 1

-- Re-add Coke so the cart has items for checkout demos
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM cart WHERE product_id = 1) THEN
        UPDATE cart SET qty = qty + 1 WHERE product_id = 1;
    ELSE
        INSERT INTO cart (product_id, qty) VALUES (1, 2);
    END IF;
END $$;

SELECT * FROM cart;   -- expected: Coke qty 2, Chips qty 1


-- ============================================================
-- PART 5: CHECKOUT  (user 1 = Arnold places ORDER 1)
-- ============================================================

-- Step A: insert into order_header
INSERT INTO order_header (user_id, order_date)
VALUES (1, CURRENT_TIMESTAMP);

-- Step B: copy cart rows into order_details using the new order_id
--         then clear the cart
INSERT INTO order_details (order_header_id, product_id, qty)
SELECT (SELECT MAX(order_id) FROM order_header),
       product_id,
       qty
FROM cart;

DELETE FROM cart;

SELECT * FROM order_header;   -- should show 1 row
SELECT * FROM order_details;  -- should show Coke x2 + Chips x1


-- ============================================================
-- SECOND SHOPPING SESSION  (user 2 = Sheryl places ORDER 2)
-- ============================================================

-- Sheryl adds two Chips
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM cart WHERE product_id = 2) THEN
        UPDATE cart SET qty = qty + 1 WHERE product_id = 2;
    ELSE
        INSERT INTO cart (product_id, qty) VALUES (2, 1);
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM cart WHERE product_id = 2) THEN
        UPDATE cart SET qty = qty + 1 WHERE product_id = 2;
    ELSE
        INSERT INTO cart (product_id, qty) VALUES (2, 1);
    END IF;
END $$;

-- Sheryl adds one Coke
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM cart WHERE product_id = 1) THEN
        UPDATE cart SET qty = qty + 1 WHERE product_id = 1;
    ELSE
        INSERT INTO cart (product_id, qty) VALUES (1, 1);
    END IF;
END $$;

SELECT * FROM cart;   -- expected: Chips qty 2, Coke qty 1

-- Sheryl's checkout
INSERT INTO order_header (user_id, order_date)
VALUES (2, CURRENT_TIMESTAMP);

INSERT INTO order_details (order_header_id, product_id, qty)
SELECT (SELECT MAX(order_id) FROM order_header),
       product_id,
       qty
FROM cart;

DELETE FROM cart;

SELECT * FROM order_header;   -- 2 rows: Arnold + Sheryl
SELECT * FROM order_details;  -- 4 rows total across both orders


-- ============================================================
-- REPORTING QUERIES
-- ============================================================

-- Print a single order (order 1 - Arnold)
SELECT
    oh.order_id,
    u.username,
    oh.order_date,
    pm.name        AS product_name,
    pm.price,
    od.qty,
    (pm.price * od.qty) AS line_total
FROM order_header  oh
INNER JOIN users          u  ON u.user_id          = oh.user_id
INNER JOIN order_details  od ON od.order_header_id = oh.order_id
INNER JOIN products_menu  pm ON pm.id              = od.product_id
WHERE oh.order_id = 1
ORDER BY od.product_id;

-- Print all orders placed today
SELECT
    oh.order_id,
    u.username,
    oh.order_date,
    pm.name        AS product_name,
    pm.price,
    od.qty,
    (pm.price * od.qty) AS line_total
FROM order_header  oh
INNER JOIN users          u  ON u.user_id          = oh.user_id
INNER JOIN order_details  od ON od.order_header_id = oh.order_id
INNER JOIN products_menu  pm ON pm.id              = od.product_id
WHERE DATE(oh.order_date) = CURRENT_DATE
ORDER BY oh.order_id, od.product_id;


-- ============================================================
-- BONUS: STORED FUNCTIONS
-- ============================================================

-- Function: add an item to the cart
-- Usage: SELECT add_to_cart(1);   -- adds one Coke
CREATE OR REPLACE FUNCTION add_to_cart(p_product_id INT)
RETURNS VOID AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM cart WHERE product_id = p_product_id) THEN
        UPDATE cart
        SET    qty = qty + 1
        WHERE  product_id = p_product_id;
    ELSE
        INSERT INTO cart (product_id, qty)
        VALUES (p_product_id, 1);
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Function: remove an item from the cart
-- Usage: SELECT remove_from_cart(1);   -- removes one Coke
CREATE OR REPLACE FUNCTION remove_from_cart(p_product_id INT)
RETURNS VOID AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM cart WHERE product_id = p_product_id AND qty > 1) THEN
        UPDATE cart
        SET    qty = qty - 1
        WHERE  product_id = p_product_id;
    ELSE
        DELETE FROM cart
        WHERE  product_id = p_product_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- ---- Demo using the functions ----
SELECT add_to_cart(1);      -- add Coke
SELECT add_to_cart(1);      -- add Coke again
SELECT add_to_cart(2);      -- add Chips
SELECT * FROM cart;         -- Coke qty 2, Chips qty 1

SELECT remove_from_cart(1); -- remove one Coke
SELECT * FROM cart;         -- Coke qty 1, Chips qty 1

SELECT remove_from_cart(1); -- remove last Coke (row deleted)
SELECT * FROM cart;         -- only Chips qty 1