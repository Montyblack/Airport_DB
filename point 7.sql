SET search_path = airport, public;

create view air_company_view as
select *
from air_company;

create view boarding_pass_view as
select *
from boarding_pass;

create view control_room_view as
select *
from control_room;

create view flight_view as
select *
from flight;

create view luggage_view as
select *
from luggage;

create view maintenance_view as
select *
from maintenance;

create view passenger_view as
select boarding_pass_no, ticket_no, regexp_replace(cast(passport_no as varchar(50)), '[0-9]{4}$', '****') as passport_no,
       first_name, second_name, regexp_replace(phone_no, '[0-9]{4}$', '****') as phone_no
from passenger;

create view plane_view as
select *
from plane;

create view plane_model_view as
select *
from plane_model;

create view staff_view as
select *
from staff;

create view ticket_view as
select *
from ticket;
