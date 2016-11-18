explain analyze select * from person.address where addressid in (1,2,3,4,5,6);

select count(*) from person.address where addressid in (1,2,3,4,5,6);
select count(1) from person.address where addressid in (1,2,3,4,5,6);

explain analyze
select p.firstname, p.lastname, to_char(p.modifieddate, 'MM.DD'), sign.name
 from person.person as p
 left outer join (values 
  ('Baran', '03.21', '04.19'),('Byk', '04.20', '05.22'),('Bliźnięta', '05.23', '06.21'),
  ('Rak', '06.22', '07.22'),('Lew', '07.23', '08.23'),('Panna', '08.24', '09.22'),
  ('Waga', '09.23', '10.22'),('Skorpion', '10.23', '11.21'),('Strzelec', '11.22', '12.21'),
  ('Koziorożec', '12.22', '12.31'),('Koziorożec', '01.01', '01.19'),('Wodnik', '01.20', '02.18'),
  ('Ryby', '02.19', '03.20')) as sign(name, start, "end")
 on to_char(p.modifieddate, 'MM.DD') between sign.start and sign."end"
order by lastname offset 1000 limit 10;

explain analyze
select p.firstname, p.lastname, to_char(p.modifieddate, 'MM.DD'), sign.name
 from (select * from person.person order by lastname offset 1000 limit 10 ) as p
 left outer join (values 
  ('Baran', '03.21', '04.19'),('Byk', '04.20', '05.22'),('Bliźnięta', '05.23', '06.21'),
  ('Rak', '06.22', '07.22'),('Lew', '07.23', '08.23'),('Panna', '08.24', '09.22'),
  ('Waga', '09.23', '10.22'),('Skorpion', '10.23', '11.21'),('Strzelec', '11.22', '12.21'),
  ('Koziorożec', '12.22', '12.31'),('Koziorożec', '01.01', '01.19'),('Wodnik', '01.20', '02.18'),
  ('Ryby', '02.19', '03.20')) as sign(name, start, "end")
 on to_char(p.modifieddate, 'MM.DD') between sign.start and sign."end";


select 
  "group", name, countryregioncode, 
  sum(saleslastyear) over (partition by "group"), 
  count(saleslastyear) over (partition by "group"),
  sum(saleslastyear) over (partition by "name"), 
  count(saleslastyear) over (partition by "name") 
from sales.salesterritory;

select 
  distinct
  "group", name, countryregioncode, 
  sum(oh.totaldue) over grp, 
  count(oh.totaldue) over grp,
  sum(oh.totaldue) over n, 
  count(oh.totaldue) over n
from 
  sales.salesterritory t
  join sales.salesorderheader oh on t.territoryid = oh.territoryid
window 
  grp as (partition by "group"), 
  n as (partition by "name")

select 
  distinct on ("group", name)
  "group", name, countryregioncode, 
  sum(oh.totaldue) over grp, 
  count(oh.totaldue) over grp,
  sum(oh.totaldue) over n, 
  count(oh.totaldue) over n
from 
  sales.salesterritory t
  join sales.salesorderheader oh on t.territoryid = oh.territoryid
window 
  grp as (partition by "group"), 
  n as (partition by "name")

