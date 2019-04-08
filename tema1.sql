-- ex 1
select cust_id Cod, cust_name Nume
from customer_tbl
where cust_state in ('IN', 'OH', 'MI', 'IL')
and lower(cust_name) like 'a%' or lower(cust_name) like 'b%'
order by cust_name;

-- ex 2
-- a)
select prod_id Cod, prod_desc Descrierea, cost "Cost produs"
from products_tbl
where 1 <= cost and cost <= 12.5;

-- b)
select prod_id Cod, prod_desc Descrierea, cost "Cost produs"
from products_tbl
where cost < 1 or 12.5 < cost;

-- ex 3
select concat(first_name, concat('.', concat(last_name,'@iitech.com')))
from employee_tbl;

select * from employee_tbl;

-- ex 4
select 
   concat(last_name, concat(', ', first_name)) "NAME", 
   to_char(emp_id, '%%%-%%-%%%') "EMP_ID",
   phone "PHONE"
from employee_tbl;

-- ex 5
select emp_id Cod, to_char(date_hire, 'YYYY') "ANUL ANGAJARII"
from employee_pay_tbl;

-- ex 6
select emp_id, last_name, first_name, salary, bonus
from employee_tbl
join employee_pay_tbl using(emp_id);

-- ex 7
select cust_name, ord_num, ord_date
from customer_tbl
join orders_tbl using(cust_id)
where upper(cust_state) like 'I%';

-- ex 8
select 
    ord_num "NUMAR COMANDA", 
    qty "CANTIATE",
    last_name "NUME ANGAJAT",
    first_name "PRENUME ANGAJAT",
    city "ORAS"
from orders_tbl
join employee_tbl on (emp_id = sales_rep);

-- ex 9
select 
    ord_num "NUMAR COMANDA", 
    qty "CANTIATE",
    last_name "NUME ANGAJAT",
    first_name "PRENUME ANGAJAT",
    city "ORAS"
from orders_tbl
right outer join employee_tbl on (emp_id = sales_rep);

-- ex 10
select last_name, first_name, middle_name
from employee_tbl
where middle_name is null;

-- ex 11
select 
    last_name "Nume",
    first_name "Prenume",
    nvl(salary, 0) * nvl(pay_rate, 1) + nvl(bonus, 0) "Salariu anual"
from employee_tbl
join employee_pay_tbl using(emp_id);

-- ex 12
-- metoda 1
select 
    last_name,
    salary,
    position,
    decode(lower(position), 'marketing', salary * 110/100, 'salesman', salary * 150/100, salary) "Salariu modificat"
from employee_tbl
join employee_pay_tbl using(emp_id);
-- metoda 2
select
    last_name,
    salary,
    position,
    case lower(position)
        when 'marketing' then
            salary * 110/100
        when 'salesman' then
            salary * 150/100
        else salary
    end  "Salariu modificat"
from employee_tbl
join employee_pay_tbl using(emp_id);




select * from employee_tbl;
select * from employee_pay_tbl;