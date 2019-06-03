/*
PREZENTARE (cod_pr, data, oras, nume)
SPONSOR (cod_sponsor, nume, info, tara_origine)
SUSTINE (cod_pr, cod_sp, suma)
VESTIMENTATIE (cod_vestimentatie, denumire, valoare, cod_prezentare)
*/

create table prezentare(
    cod_pr INT NOT NULL primary key,
    data DATE NOT NULL,
    oras VARCHAR(20) NOT NULL,
    nume VARCHAR(20) NOT NULL,
    PRIMARY KEY (cod_pr));
    
create table sponsor(
    cod_sponsor INT NOT NULL,
    nume VARCHAR(20) NOT NULL,
    info VARCHAR(20) NOT NULL,
    tara_origine VARCHAR(20) NOT NULL,
    PRIMARY KEY (cod_sponsor));

create table sustine(
    cod_pr INT NOT NULL,
    cod_sp INT NOT NULL,
    suma INT NOT NULL,
    FOREIGN KEY (cod_pr) REFERENCES prezentare(cod_pr),
    FOREIGN KEY (cod_sp) REFERENCES sponsor(cod_sponsor));
    
create table vestimentatie(
    cod_vestimentatie INT NOT NULL,
    denumire VARCHAR(20) NOT NULL,
    valoare INT NOT NULL,
    cod_prezentare INT NOT NULL,
    PRIMARY KEY (cod_vestimentatie),
    FOREIGN KEY (cod_prezentare) REFERENCES prezentare(cod_pr));


insert into prezentare(cod_pr, data, oras, nume) values (1, to_date('12/02/2001', 'dd/mm/yyyy'), 'Bucuresti', 'Prezentare1');
insert into prezentare(cod_pr, data, oras, nume) values (2, to_date('12/02/2001', 'dd/mm/yyyy'), 'Bucuresti', 'Prezentare2');
insert into prezentare(cod_pr, data, oras, nume) values (3, to_date('12/02/2020', 'dd/mm/yyyy'), 'Iasi', 'Prezentare3');
insert into prezentare(cod_pr, data, oras, nume) values (4, to_date('12/02/2009', 'dd/mm/yyyy'), 'Pitesti', 'Prezentare4');
insert into prezentare(cod_pr, data, oras, nume) values (5, to_date('24/08/2001', 'dd/mm/yyyy'), 'Bucuresti', 'Prezentare5');

insert into sponsor(cod_sponsor, nume, info, tara_origine) values (1, 'Coca-Cola', 'info1', 'SUA');
insert into sponsor(cod_sponsor, nume, info, tara_origine) values (2, 'Pepsi', 'info2', 'SUA');
insert into sponsor(cod_sponsor, nume, info, tara_origine) values (3, 'ROM', 'info3', 'Romania');

insert into sustine(cod_pr, cod_sp, suma) values (1, 1, 2000);
insert into sustine(cod_pr, cod_sp, suma) values (1, 3, 500);
insert into sustine(cod_pr, cod_sp, suma) values (2, 2, 5000);
insert into sustine(cod_pr, cod_sp, suma) values (3, 1, 1000);
insert into sustine(cod_pr, cod_sp, suma) values (3, 2, 5000);
insert into sustine(cod_pr, cod_sp, suma) values (4, 1, 2000);
insert into sustine(cod_pr, cod_sp, suma) values (4, 3, 500);
insert into sustine(cod_pr, cod_sp, suma) values (5, 2, 5000);
insert into sustine(cod_pr, cod_sp, suma) values (5, 1, 1000);

insert into vestimentatie(cod_vestimentatie, denumire, valoare, cod_prezentare) values(1, 'Vestimentatie1', 100, 1);
insert into vestimentatie(cod_vestimentatie, denumire, valoare, cod_prezentare) values(2, 'Vestimentatie2', 200, 1);
insert into vestimentatie(cod_vestimentatie, denumire, valoare, cod_prezentare) values(3, 'Vestimentatie3', 100, 2);
insert into vestimentatie(cod_vestimentatie, denumire, valoare, cod_prezentare) values(4, 'Vestimentatie4', 100, 2);
insert into vestimentatie(cod_vestimentatie, denumire, valoare, cod_prezentare) values(5, 'Vestimentatie5', 200, 2);
insert into vestimentatie(cod_vestimentatie, denumire, valoare, cod_prezentare) values(6, 'Vestimentatie6', 100, 3);
insert into vestimentatie(cod_vestimentatie, denumire, valoare, cod_prezentare) values(7, 'Vestimentatie7', 500, 4);
insert into vestimentatie(cod_vestimentatie, denumire, valoare, cod_prezentare) values(8, 'Vestimentatie8', 700, 4);
insert into vestimentatie(cod_vestimentatie, denumire, valoare, cod_prezentare) values(9, 'Vestimentatie9', 200, 5);
insert into vestimentatie(cod_vestimentatie, denumire, valoare, cod_prezentare) values(10, 'Vestimentatie10', 700, 5);
insert into vestimentatie(cod_vestimentatie, denumire, valoare, cod_prezentare) values(11, 'Vestimentatie11', 100, 5);

-- ex 1
select s.nume, p.nume, v.denumire
from sponsor s
join sustine ss on(ss.cod_sp = s.cod_sponsor)
join prezentare p on (p.cod_pr = ss.cod_pr)
join vestimentatie v on(v.cod_prezentare = p.cod_pr);

-- ex 2
with
sponsori_prezentari_grupati as(
    select s.cod_sponsor, s.tara_origine, count(*) as cnt_prezentari
    from sponsor s
    join sustine ss on(ss.cod_sp = s.cod_sponsor)
    group by s.cod_sponsor, s.tara_origine)
select tara_origine
from sponsori_prezentari_grupati
where cnt_prezentari = (
    select max(cnt_prezentari)
    from  sponsori_prezentari_grupati);
    
-- ex 3
with 
max_valoare1 as(
    select max(valoare)
    from vestimentatie),
max_valoare2 as(
    select max(valoare)
    from vestimentatie
    where valoare not in (select * from max_valoare1)),
max_valoare3 as(
    select max(valoare)
    from vestimentatie
    where valoare not in (select * from max_valoare1)
    and valoare not in (select * from max_valoare2))
select denumire, valoare
from vestimentatie
where valoare in (select * from max_valoare1)
or valoare in (select * from max_valoare2)
or valoare in (select * from max_valoare3);
    
-- ex 4
create table pv(
    cod_prezentare INT NOT NULL,
    suma_vest INT NOT NULL,
    FOREIGN KEY(cod_prezentare) REFERENCES prezentare(cod_pr));
    
insert into pv(cod_prezentare, suma_vest) 
select cod_pr as cod_prezentare, sum(valoare) as suma_vest
    from prezentare
    join vestimentatie on(cod_pr = cod_prezentare)
    group by cod_pr;
select * from pv;