SET search_path = airport, public;

/*самолеты, не проходившие техническое обслуживание, и компании, которым эти самолеты принадлежат*/
select plane_info.plane_id, a.air_company_nm
from air_company a
inner join (
  select p.plane_id, p.air_company_id
  from plane p
         left join maintenance m on p.plane_id = m.plane_id
  where m.plane_id is null
) plane_info on a.air_company_id=plane_info.air_company_id;

/*средняя цена билета на рейс Лондон - Москва*/
select avg(t.ticket_price) as avg_price
from ticket t
inner join flight f on t.flight_no = f.flight_no
where f.city_departure_nm like 'London' and f.city_destination_nm like 'Moscow';

/*вес багажа, перевозимого рейсом 692089*/
select sum(l.luggage_weight)
from luggage l
where l.boarding_pass_no in (
  select p.boarding_pass_no
  from passenger p
  where ticket_no in (
    select t.ticket_no
    from flight f
           inner join ticket t on f.flight_no = t.flight_no
    where f.flight_no = 692089
  )
);

/*самолет какой модели ни разу не совершал полета*/
select pm.plane_model
from plane_model pm
where pm.plane_model not in(
  select p.plane_model
  from plane p
  inner join flight f on p.plane_id = f.plane_id
  );

/*сколько билетов класса премиум было продано на рейс 692089*/
select count(*)
from ticket
where ticket_type like 'PREMIUM' and flight_no=692089;
