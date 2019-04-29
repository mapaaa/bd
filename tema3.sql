-- ex 1 o singura cerere?
select s_id "Cod", s_last "Student sau curs", 'Student' "Tip"
from student
join faculty using(f_id)
where lower(f_last) = 'brown'
union
select course_no "Cod", course_name "Student sau curs", 'Curs' "Tip"
from course
join course_section using(course_no)
join faculty using(f_id)
where lower(f_last) = 'brown';

-- ex 2 (nimeni nu e enrolled in Progamming in C++ :((
select s_id, s_last
from student
join enrollment using(s_id)
join course_section using(c_sec_id)
join course using(course_no)
where lower(course_name) = 'database management'
and s_id not in (
    select s_id
    from student
    join enrollment using(s_id)
    join course_section using(c_sec_id)
    join course using(course_no)
    where lower(course_name) = 'programming in c++');

-- ex 3
select distinct s_id, s_last
from student 
join enrollment using(s_id)
where grade is null or lower(grade) = 'c';

-- ex 4
select loc_id, bldg_code, capacity
from location
where capacity = (
    select max(capacity)
    from location);
    
-- ex 5
drop table t;
CREATE TABLE t (id NUMBER PRIMARY KEY);
INSERT INTO t VALUES(1);
INSERT INTO t VALUES(2);
INSERT INTO t VALUES(4);
INSERT INTO t VALUES(6);
INSERT INTO t VALUES(8);
INSERT INTO t VALUES(9);
select min(id) + 1 "Minim si maxim disponibil", 'minim' "Tip"
from t
where id + 1 not in (
    select id from t)
union
select max(id) - 1 "Minim si maxim disponibil", 'maxim' "Tip"
from t
where id - 1 not in (
    select id from t);

-- ex 6 (count de mai putine ori?)
select
    f_id "Cod profesor",
    f_last "Nume profesor",
    decode(count(distinct s_id), 0, 'Nu', 'Da ('||count(distinct s_id)||')') "Student",
    decode(count(distinct course_no), 0, 'Nu', 'Da ('||count(distinct course_no)||')') "Curs"
from faculty
left join course_section using(f_id)
join course course using(course_no)
left join student using(f_id)
group by f_id, f_last; 

-- ex 7
select f1.term_id, f1.term_desc, f2.term_id, f2.term_desc
from term f1, term f2
where substr(f1.term_desc, length(f1.term_desc)) != substr(f2.term_desc, length(f2.term_desc))
and substr(f1.term_desc, 1, length(f1.term_desc) - 1) = substr(f2.term_desc, 1, length(f2.term_desc) - 1);

-- ex 8 toti???
select distinct s.s_id, s.s_last
from student s
join enrollment a on(s.s_id = a.s_id)
join enrollment b on(s.s_id = b.s_id and a.c_sec_id != b.c_sec_id)
join course_section ca on(a.c_sec_id = ca.c_sec_id)
join course_section cb on(b.c_sec_id = cb.c_sec_id)
and substr(ca.course_no, 5, 1) != substr(cb.course_no, 5, 1);

-- ex 9
select distinct c1.course_no, c2.course_no
from course c1
join course c2 on(c1.course_no > c2.course_no)
join course_section cs1 on(cs1.course_no = c1.course_no)
join course_section cs2 on(cs2.course_no = c2.course_no and cs2.term_id = cs1.term_id)
order by c1.course_no;

-- ex 10
select distinct course_no, course_name, term_desc, max_enrl
from course_section
join term using(term_id)
join course using(course_no)
where max_enrl < (
  select min(max_enrl)
  from course_section
  where loc_id = 1
);

-- ex 11
select distinct course_name, max_enrl
from course_section
join course using(course_no)
where max_enrl = (
  select min(max_enrl)
  from course_section
);

-- ex 12
select f_last, avg(max_enrl)
from faculty
join course_section using(f_id)
group by f_last;

-- ex 13
select f_last, count(s_id)
from faculty
join student using(f_id)
group by f_last
having count(s_id) >= 3;

-- ex 14
select distinct c.course_name, capacity, cs1.loc_id
from course_section cs1
join location l on(l.loc_id = cs1.loc_id)
join course c on(cs1.course_no = c.course_no)
where capacity = (
  select max(capacity)
  from course_section cs2 
  join location using(loc_id)
  where(cs2.course_no = cs1.course_no)
);

-- ex 15
select term_id, term_desc, avg(max_enrl)
from course_section
join term using(term_id)
where substr(term_desc, -4) = '2007'
group by term_id, term_desc;