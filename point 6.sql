SET search_path = airport, public;

insert into luggage values (47365, 537, 16);
create index on luggage(luggage_id);

explain analyse select distinct boarding_pass_no
from luggage
where luggage_weight >= 16;

update luggage set luggage_weight=10 where luggage_weight < 10;

delete from luggage
where luggage_weight >= 20;

insert into maintenance values (523, 2826, cast('2017-05-18' as DATE), 'Andrew', 'Drake', 'OK');

select *
from maintenance
where maintenance_dttm >= '2018-01-01';

update maintenance set results='OK' where results='FAIL';

delete from maintenance
where maintenance_dttm < '2016-01-01';
