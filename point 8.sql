SET search_path = airport, public;

create view view_1 as (
  select a.air_company_nm, s.staff_id, s.position_title, s.first_name, second_name, s.flight_hours_num
  from air_company a
  inner join staff s on a.air_company_id = s.air_company_id
);

create view view_2 as (
  select p.plane_id, p.air_company_id, pm.*
  from plane p
  inner join plane_model pm on p.plane_model = pm.plane_model
);
