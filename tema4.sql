-- ex 1
select s.s_last
from student s
where s.s_id not in (
    select s_id
    from enrollment
    where grade is null);

-- ex 2
select bldg_code
from location
where bldg_code not in (
    select bldg_code
    from location
    where loc_id not in (
        select loc_id
        from course_section));
    
-- ex 3
select distinct f_id, f_last
from faculty
join student using(f_id)
join enrollment using(s_id)
join course_section using(f_id)
join course using(course_no)
where grade = 'A'
and lower(course_name) like '%database%';

-- ex 4
select f.f_last
from faculty f
join course_section cs on(f.f_id = cs.f_id)
join location loc on(cs.loc_id = loc.loc_id)
where capacity = (select max(capacity) from location)
union
select f.f_last
from faculty f
join course_section cs on(cs.f_id = f.f_id)
left join enrollment e on(e.c_sec_id = cs.c_sec_id)
group by f.f_last, cs.c_sec_id
having count(s_id) = (
    select max(count(s_id))
    from enrollment
    group by c_sec_id);
    
-- ex 5
select distinct f_last
from faculty
join location using(loc_id)
join course_section using(f_id)
where capacity = (
    select min(capacity)
    from location)
and max_enrl = (
    select(min(max_enrl))
    from course_section cs
    join location ls on(cs.loc_id = ls.loc_id)
    where capacity = (
            select max(capacity)
            from location));
            
-- ex 6
with 
filtered_capacities as (
    select distinct ls.loc_id, ls.capacity
    from location ls
    join course_section cs on(ls.loc_id = cs.loc_id)
    join faculty using(f_id)
    where lower(f_last) || lower(f_first) = 'marxteresa'),
max_enroll_for_jones_tammy as (
    select max_enrl
    from course_section
    join enrollment using(c_sec_id)
    join student using(s_id)
    where lower(s_last) || lower(s_first) = 'tammyjones'),
total_values as (
    select capacity from filtered_capacities
    union all
    select max_enrl from
    max_enroll_for_jones_tammy)
select avg(capacity)
from total_values;

-- ex 7
select bldg_code, avg(capacity)
from location
where bldg_code in (
    select bldg_code
    from location
    join course_section using(loc_id)
    join course using(course_no)
    where lower(course_name) like '%systems%')
group by bldg_code;

-- ex 8
select avg(capacity)
from location
where bldg_code in (
    select bldg_code
    from location
    join course_section using(loc_id)
    join course using(course_no)
    where lower(course_name) like '%systems%');
    
-- ex 9
select course_no, course_name
from course
where course_name like (
    case
        when exists (select 1 from course where course_name like '%java%')
        then '%java%'
        else '%'
    end
);

-- ex 10
select distinct c.course_no, c.course_name
from course c
join course_section cs on(cs.course_no = c.course_no)
join location l on(l.loc_id = cs.loc_id)
join faculty f on(f.f_id = cs.f_id)
join enrollment e on(e.c_sec_id = cs.c_sec_id)
join student s on(s.s_id = e.s_id)
join term t on(t.term_id = cs.term_id)
where (
    decode(l.capacity, 42, 1, 0) +
    decode(lower(f.f_last), 'brown', 1, 0) +
    decode(lower(s.s_last)||lower(s.s_first), 'jonestammy', 1, 0) +
    decode(instr(lower(c.course_name), 'database'), 1, 1, 0) +
    decode(extract(year from t.start_date), 2007, 1, 0)
) >= 3;

-- ex 11
with
databases as (
    select term_desc, count(course_no) as "cnt_courses"
    from term 
    join course_section using(term_id)
    join course using(course_no)
    where lower(course_name) like '%database%'
    group by term_desc)
select distinct term_desc, "cnt_courses"
from databases
where "cnt_courses" in (
    select max("cnt_courses")
    from databases
);
    
-- ex 12
-- select * from enrollment;
with at_least_once as (
    select distinct grade, s_id
    from enrollment
    where grade is not null
),
all_grades as (
    select grade, count(s_id) as "cnt_students"
    from at_least_once
    group by grade)
select grade, "cnt_students"
from all_grades
where "cnt_students" in (
    select max("cnt_students")
    from all_grades);
    
-- ex 13
with all_possible_solutions as (
    select term_desc, count(course_no) as "cnt_3_credits"
    from term
    join course_section using(term_id)
    join course using(course_no)
    where credits = 3
    group by term_desc)
select term_desc, "cnt_3_credits"
from all_possible_solutions
where "cnt_3_credits" in (
    select max("cnt_3_credits")
    from all_possible_solutions);
    
-- ex 14
select loc_id, bldg_code, room
from location
join course_section using(loc_id)
join course using(course_no)
where lower(course_name) like '%c++%'
intersect
select loc_id, bldg_code, room
from location
join course_section using(loc_id)
join course using(course_no)
where lower(course_name) like '%database%';

-- ex 15
with good_locations as (
    select distinct bldg_code, loc_id
    from location
    join course_section using(loc_id)
    union
    select distinct bldg_code, loc_id
    from location
    join faculty using(loc_id)
)
select bldg_code, count(loc_id)
from good_locations
group by bldg_code
having count(loc_id) = 1;
