--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO "dvd-rental";


--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.

SELECT last_name||' '||first_name "Фамилия Имя", a.address "Адрес"
	, c2.city "Город", c3.country "Страна"
FROM customer c LEFT JOIN address a ON c.address_id = a.address_id 
	LEFT JOIN city c2 ON a.city_id = c2.city_id 
	LEFT JOIN country c3 ON c3.country_id =c2.country_id;
 
--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.
SELECT store_id "ID магазина", COUNT(customer_id) "Количество покупателей"
FROM customer c
GROUP BY store_id 



--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.
SELECT store_id "ID магазина", COUNT(customer_id) "Количество покупателей"
FROM customer c
GROUP BY store_id
HAVING COUNT(customer_id) > 300




-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.

SELECT c.store_id "ID магазина", COUNT(c.customer_id) "Количество покупателей"
	, c2.city "Город маназина", s2.first_name||' '||s2.last_name "Фамилия и Имя продавца"
FROM customer c LEFT JOIN store s ON s.store_id = c.store_id 
	LEFT JOIN address a ON a.address_id =s.address_id 
	LEFT JOIN city c2 ON c2.city_id =a.city_id 
	LEFT JOIN staff s2 ON s2.staff_id = s.manager_staff_id 
GROUP BY c.store_id, c2.city, s2.first_name||' '||s2.last_name 
HAVING COUNT(customer_id) > 300


--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

SELECT  c.last_name||' '||c.first_name "Фамилия и Имя покупателя"
	, COUNT(inventory_id) "Количество фильмов"
FROM rental r LEFT JOIN customer c ON r.customer_id = c.customer_id 
GROUP BY c.last_name||' '||c.first_name
ORDER BY COUNT(inventory_id) DESC 
LIMIT 5;


--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма
SELECT last_name || ' ' || first_name "Фамилия и Имя покупателя"
	, c2.count_rent "Количество фильмов"
	, c3.sum_rent "Общая стоимость фильмов"
	, c3.min_rent "Минимальная стоимость платежа"
	, c3.max_rent "Максимальная стоимость платежа"
FROM customer c LEFT JOIN (SELECT customer_id, COUNT(inventory_id) "count_rent"
							FROM rental r  
							GROUP BY customer_id) AS c2 ON c2.customer_id = c.customer_id
				LEFT JOIN (SELECT customer_id , ROUND(SUM(amount), 0) "sum_rent", MIN(amount) "min_rent" , MAX(amount) "max_rent"
							FROM payment p 
							GROUP BY customer_id) AS c3  ON c3.customer_id = c.customer_id;



--ЗАДАНИЕ №5
--Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
 --чтобы в результате не было пар с одинаковыми названиями городов. 
 --Для решения необходимо использовать декартово произведение.
SELECT c1.city "Город 1", c2.city "Город 2" 
FROM 
	(SELECT city 
		FROM city c) "c1",
	(SELECT city 
		FROM city c) "c2"
WHERE c1.city <> c2.city;


--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
--и дате возврата фильма (поле return_date), 
--вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.
 
SELECT customer_id , DATE_PART('day', AVG(return_date - rental_date))+ ROUND((DATE_PART('hour', AVG(return_date - rental_date)) / 24) :: NUMERIC , 1)
FROM rental r 
GROUP BY customer_id 
ORDER BY customer_id 
;





--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.





--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания и выведите с помощью запроса фильмы, которые ни разу не брали в аренду.





--ЗАДАНИЕ №3
--Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".







