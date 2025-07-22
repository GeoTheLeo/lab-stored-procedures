USE sakila;
DELIMITER $$

CREATE PROCEDURE Get_Customers_By_Category(IN category_name VARCHAR(50))
BEGIN
    SELECT 
        c.first_name, 
        c.last_name, 
        c.email
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON f.film_id = i.film_id
    JOIN film_category fc ON fc.film_id = f.film_id
    JOIN category cat ON cat.category_id = fc.category_id
    WHERE cat.name = category_name
    GROUP BY c.first_name, c.last_name, c.email;
END$$

DELIMITER ;
-- action movies
CALL Get_Customers_By_Category('Action');

-- animation movies
CALL Get_Customers_By_Category('Animation');

-- IN category_name VARCHAR(50) → Accepts the category name as an input.

-- The procedure joins all necessary tables (customer → rental → inventory → film → category).

-- GROUP BY avoids duplicates per customer.

-- Query to count movies for each category
SELECT 
    c.name AS category,
    COUNT(f.film_id) AS film_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON f.film_id = fc.film_id
GROUP BY c.name;

-- conversion to a stored procedure - threshold
DELIMITER $$

CREATE PROCEDURE Get_Categories_By_Min_Film_Count(IN min_film_count INT)
BEGIN
    SELECT 
        c.name AS category,
        COUNT(f.film_id) AS film_count
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON f.film_id = fc.film_id
    GROUP BY c.name
    HAVING COUNT(f.film_id) > min_film_count;
END$$

DELIMITER ;

-- call the procedure!
CALL Get_Categories_By_Min_Film_Count(70);
