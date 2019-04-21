/*
Nume: Pandele Maria-Smaranda
Grupa: 331
Tema 2
*/

-- I. Exercitii pe diagrama HR 
-- ex 1
select count(*)
from employees
where upper(last_name) like 'K%';

-- ex 2
select employee_id, last_name, first_name
from employees
where salary = (select min(salary) from employees);

-- ex 3
select distinct m.employee_id, m.last_name
from employees m
join employees e on(e.manager_id = m.employee_id)
where e.department_id = 30
order by last_name;

-- ex 4
select e.employee_id, e.last_name, e.first_name, count(s.employee_id) "Nr de subalterni"
from employees e
join employees s on(s.manager_id = e.employee_id)
group by e.employee_id, e.last_name, e.first_name;

-- ex 5
select e.employee_id, e.last_name, e.first_name
from employees e
join employees l on(e.last_name = l.last_name and e.employee_id != l.employee_id)
order by e.last_name;

-- ex 6
select d.department_id, d.department_name, count(distinct e.job_id) "Nr de joburi din departament"
from departments d
join employees e on(d.department_id = e.department_id)
join jobs j on(j.job_id = e.job_id)
group by d.department_id, d.department_name
having count(distinct e.job_id) >= 2;


-- Exercitii pe diagrama ORDERS
-- ex 7
select p.prod_id, p.prod_desc, count(o.ord_num) "Cantitate comandata"
from products_tbl p
join orders_tbl o on(o.prod_id = p.prod_id)
where lower(p.prod_desc) like '%plastic%'
group by p.prod_id, p.prod_desc;

-- ex 8
select last_name||' '||first_name "Nume", 'angajat' "Tip"
from employee_tbl
union
select cust_name "Nume", 'client' "Tip"
from customer_tbl
order by "Tip";

-- ex 9
select distinct p.prod_desc
from products_tbl p
join orders_tbl o on(p.prod_id = o.prod_id)
where o.sales_rep in
   (select sales_rep 
    from orders_tbl
    join products_tbl using(prod_id)
    where length(prod_desc) - length(replace(prod_desc, ' ', '')) + 1 >= 2 and regexp_like(prod_desc, '\w+\sP.+'));

-- ex 10
select distinct cust_name
from customer_tbl
join orders_tbl using(cust_id)
where to_char(ord_date, 'dd') = 17;

-- ex 11
select last_name, first_name, salary, bonus
from employee_tbl e
join employee_pay_tbl using(emp_id)
where greatest(nvl(salary, 0), 17*nvl(bonus, 0)) < 32000;

-- ex 12
select last_name, sum(qty)
from employee_tbl
left outer join orders_tbl on(emp_id = sales_rep)
group by last_name
having sum(qty) is null or sum(qty)>50;

-- ex 13
select last_name, first_name, salary, max(ord_date)
from employee_tbl e
join employee_pay_tbl using(emp_id)
join orders_tbl on(emp_id = sales_rep)
group by last_name, first_name, salary
having count(ord_num) >= 2;

-- ex 14
select prod_desc, cost
from products_tbl
where cost >
    (select avg(cost)
     from products_tbl);
   
-- ex 15
select 
    last_name, 
    first_name, 
    salary, 
    bonus,
    (select sum(salary) 
     from employee_pay_tbl) "Salariu total",
    (select sum(bonus) 
     from employee_pay_tbl) "Bonus total"
from employee_tbl
join employee_pay_tbl using(emp_id);

-- ex 16
select city
from employee_tbl
join orders_tbl on(emp_id = sales_rep)
group by city, emp_id
having count(ord_num) = 
    (select max(count(ord_num))
     from orders_tbl
     group by sales_rep);
     
-- ex 17
select 
    emp_id, 
    last_name, 
    count(decode(to_char(ord_date, 'MON'), 'SEP', ord_num)) "Nr comenzi sept", 
    count(decode(to_char(ord_date, 'MON'), 'OCT', ord_num)) "Nr comenzi oct"
from employee_tbl
join orders_tbl on(emp_id = sales_rep)
group by emp_id, last_name;

-- ex 18 ?
select cust_name, cust_city
from customer_tbl
left outer join orders_tbl using(cust_id)
where regexp_like(cust_zip,'[0-9].+')
group by cust_name, cust_city
having count(ord_num) = 0;

-- ex 19
select distinct emp_id, last_name, city, cust_id, cust_name, cust_city
from employee_tbl
join orders_tbl on(sales_rep = emp_id)
join customer_tbl using(cust_id);

-- ex 20
select avg(nvl(salary, 0))
from employee_pay_tbl;

-- ex 21 
-- a. corect (este un singur ord_num='16C17')
SELECT CUST_ID, CUST_NAME
FROM CUSTOMER_TBL
WHERE CUST_ID =
                (SELECT CUST_ID
                 FROM ORDERS_TBL
                 WHERE ORD_NUM = '16C17');
 
 -- b. incorect, nu exista tabelul employee_id
 SELECT EMP_ID, SALARY
 FROM EMPLOYEE_PAY_TBL
 WHERE SALARY BETWEEN '20000'
 AND (SELECT SALARY
 FROM EMPLOYEE_ID
WHERE SALARY = '40000');

 SELECT EMP_ID, SALARY
 FROM EMPLOYEE_PAY_TBL
 WHERE SALARY BETWEEN '20000'
     AND (SELECT SALARY
          FROM EMPLOYEE_PAY_TBL 
          WHERE SALARY = '40000');
          
select emp_id, salary
from employee_pay_tbl
where salary between 20000 and 40000;

-- ex 22
select last_name, pay_rate
from employee_tbl
join employee_pay_tbl using(emp_id)
where pay_rate > all    
    (select pay_rate
     from employee_pay_tbl
     join employee_tbl using(emp_id)
     where upper(last_name) like '%LL%');