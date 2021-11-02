--=============== МОДУЛЬ 6. POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO "dvd-rental";

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Напишите SQL-запрос, который выводит всю информацию о фильмах 
--со специальным атрибутом "Behind the Scenes".

--explain analyze
-- cost=0.00..66.50 avg time=0.500
select film_id , title , special_features 
from film f 
where special_features && array ['Behind the Scenes']




--ЗАДАНИЕ №2
--Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
--используя другие функции или операторы языка SQL для поиска значения в массиве.


--explain analyze
-- cost=0.00..71.50 avg time=0.900
select film_id , title , special_features
from film f 
where special_features :: text like  '%Behind the Scenes%'


--explain analyze
-- cost=0.00..66.50 time=0.500
select film_id , title , special_features 
from film f 
where special_features @> array ['Behind the Scenes']




--ЗАДАНИЕ №3
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
--со специальным атрибутом "Behind the Scenes.

--Обязательное условие для выполнения задания: используйте запрос из задания 1, 
--помещенный в CTE. CTE необходимо использовать для решения задания.

--explain analyze
-- cost=639.35..645.34 avg time=10ms
with spec_film (film_id , title , special_features)
as
(
	select film_id , title , special_features 
	from film f 
	where special_features && array ['Behind the Scenes']		
)
select r.customer_id, count(f.film_id) film_count
from spec_film f
	join inventory i on i.film_id = f.film_id 
	join rental r on r.inventory_id =i.inventory_id 
group by r.customer_id 
order by r.customer_id 
	
--ЗАДАНИЕ №4
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".

--Обязательное условие для выполнения задания: используйте запрос из задания 1,
--помещенный в подзапрос, который необходимо использовать для решения задания.


--explain analyze
-- cost=639.35..645.34 avg time=10ms
select r.customer_id , count(f.film_id) 
from inventory i 
	join rental r on r.inventory_id = i.inventory_id 
	join (select film_id , title , special_features 
			from film f 
			where special_features && array ['Behind the Scenes']) f on f.film_id = i.film_id 
group by r.customer_id 
order by r.customer_id 




--explain analyze
-- cost=639.35..645.34 avg time=10ms
select r.customer_id, count(i.film_id)
from inventory i 
	join rental r on r.inventory_id = i.inventory_id 
where i.film_id in (select film_id 
					from film f
					where special_features && array ['Behind the Scenes'])
group by r.customer_id 
order by r.customer_id 


--ЗАДАНИЕ №5
--Создайте материализованное представление с запросом из предыдущего задания
--и напишите запрос для обновления материализованного представления

create materialized view count_film as
	with spec_film (film_id , title , special_features)
		as
		(
			select film_id , title , special_features 
			from film f 
			where special_features && array ['Behind the Scenes']		
		)
		select r.customer_id, count(f.film_id) film_count
		from spec_film f
			join inventory i on i.film_id = f.film_id 
			join rental r on r.inventory_id =i.inventory_id 
		group by r.customer_id 
		order by r.customer_id 
with  data;


refresh materialized view count_film;


--drop materialized view count_film




--ЗАДАНИЕ №6
--С помощью explain analyze проведите анализ скорости выполнения запросов
-- из предыдущих заданий и ответьте на вопросы:
	 

	
--1. Каким оператором или функцией языка SQL, используемых при выполнении домашнего задания, 
--   поиск значения в массиве происходит быстрее

-- && array  - работает быстрее чем special_features :: text like  '%Behind the Scenes%'
--  @> array = && array 
-- 

--2. какой вариант вычислений работает быстрее: 
--   с использованием CTE или с использованием подзапроса

-- 3 написанных варианта работают одинаково
	--




--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выполняйте это задание в форме ответа на сайте Нетологии

--ЗАДАНИЕ №2
--Используя оконную функцию выведите для каждого сотрудника
--сведения о самой первой продаже этого сотрудника.





--ЗАДАНИЕ №3
--Для каждого магазина определите и выведите одним SQL-запросом следующие аналитические показатели:
-- 1. день, в который арендовали больше всего фильмов (день в формате год-месяц-день)
-- 2. количество фильмов взятых в аренду в этот день
-- 3. день, в который продали фильмов на наименьшую сумму (день в формате год-месяц-день)
-- 4. сумму продажи в этот день





