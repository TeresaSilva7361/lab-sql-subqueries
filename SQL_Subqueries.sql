USE SAKILA;
SELECT
  COUNT(*) AS num_copies
FROM inventory AS i
JOIN film AS f ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

SELECT
  title,
  length
FROM film
WHERE length > (
  SELECT AVG(length) FROM film
)
ORDER BY length DESC, title;

SELECT
  actor_id,
  first_name,
  last_name
FROM actor
WHERE actor_id IN (
  SELECT fa.actor_id
  FROM film_actor AS fa
  JOIN film AS f ON f.film_id = fa.film_id
  WHERE f.title = 'Alone Trip'
)
ORDER BY last_name, first_name;

SELECT
  f.film_id,
  f.title
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c       ON c.category_id = fc.category_id
WHERE c.name = 'Family'
ORDER BY f.title;

SELECT
  first_name,
  last_name,
  email
FROM customer
WHERE address_id IN (
  SELECT address_id
  FROM address
  WHERE city_id IN (
    SELECT city_id
    FROM city
    WHERE country_id = (
      SELECT country_id
      FROM country
      WHERE country = 'Canada'
    )
  )
)
ORDER BY last_name, first_name;

SELECT
  cu.first_name,
  cu.last_name,
  cu.email
FROM customer AS cu
JOIN address AS a   ON a.address_id = cu.address_id
JOIN city AS ci     ON ci.city_id = a.city_id
JOIN country AS co  ON co.country_id = ci.country_id
WHERE co.country = 'Canada'
ORDER BY cu.last_name, cu.first_name;

SELECT actor_id
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(*) DESC
LIMIT 1;
SELECT
  f.film_id,
  f.title
FROM film AS f
JOIN film_actor AS fa ON fa.film_id = f.film_id
WHERE fa.actor_id = (
  SELECT actor_id
  FROM film_actor
  GROUP BY actor_id
  ORDER BY COUNT(*) DESC
  LIMIT 1
)
ORDER BY f.title;

SELECT customer_id
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1;
SELECT DISTINCT
  f.film_id,
  f.title
FROM film AS f
JOIN inventory AS i ON i.film_id = f.film_id
JOIN rental AS r    ON r.inventory_id = i.inventory_id
WHERE r.customer_id = (
  SELECT customer_id
  FROM payment
  GROUP BY customer_id
  ORDER BY SUM(amount) DESC
  LIMIT 1
)
ORDER BY f.title;

SELECT
  customer_id,
  total_amount_spent
FROM (
  SELECT
    customer_id,
    SUM(amount) AS total_amount_spent
  FROM payment
  GROUP BY customer_id
) AS totals
WHERE total_amount_spent > (
  SELECT AVG(total_amount)
  FROM (
    SELECT SUM(amount) AS total_amount
    FROM payment
    GROUP BY customer_id
  ) AS sub
)
ORDER BY total_amount_spent DESC;