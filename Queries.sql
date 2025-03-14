USE SAKILA;

-- which store has the highest repeat customers?
SELECT 
    store_id,
    COUNT(customer_id) AS total_customers,
    COUNT(CASE WHEN total_rentals > 5 THEN 1 END) AS repeat_customers,
    ROUND((COUNT(CASE WHEN total_rentals > 5 THEN 1 END) / COUNT(customer_id)) * 100, 2) AS repeat_customer_rate
FROM customer_rental_dw
GROUP BY store_id
ORDER BY repeat_customer_rate DESC;

-- are some months more profitable for one store vs another? (seasonality trends)
SELECT 
    rental_month,
    store_id,
    SUM(total_store_revenue) AS monthly_revenue
FROM customer_rental_dw
GROUP BY rental_month, store_id
ORDER BY rental_month, store_id;

-- most popular movie categories by revenue
SELECT 
    cat.name AS movie_category,
    COUNT(crdw.total_rentals) AS total_rentals,
    SUM(crdw.total_revenue) AS total_revenue
FROM customer_rental_dw crdw
JOIN rental r ON crdw.customer_id = r.customer_id  -- Reconnect rental data
JOIN inventory i ON r.inventory_id = i.inventory_id  -- Get film details
JOIN film_category fc ON i.film_id = fc.film_id  -- Link to movie categories
JOIN category cat ON fc.category_id = cat.category_id  -- Get category name
GROUP BY movie_category
ORDER BY total_revenue DESC;

-- top 10 revenue generating customers
SELECT 
    customer_name,
    customer_email,
    SUM(total_revenue) AS total_spent,
    COUNT(total_rentals) AS total_rentals,
    store_id AS preferred_store
FROM customer_rental_dw
GROUP BY customer_id, customer_name, customer_email, store_id
ORDER BY total_spent DESC
LIMIT 10;

