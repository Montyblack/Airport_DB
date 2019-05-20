SET search_path = airport, public;

create function GetCurrentFlight ()
returns setof int as $$
  declare
    flights int;
begin
  for flights in
  select FLightInfo.flight_no
  from (
      select distinct PlaneInfo.passengers_num - count(*) as difference, PlaneInfo.flight_no, PlaneInfo.departure_dttm
      from passenger p
            inner join (
      select plane_model.passengers_num, FlightInfo.flight_no, FlightInfo.ticket_no, FlightInfo.departure_dttm
      from plane_model
            inner join (
        select plane.plane_model, FlightInfo.flight_no, FlightInfo.ticket_no, FlightInfo.departure_dttm
        from plane
              inner join (
          select f.plane_id, f.flight_no, t.ticket_no, f.departure_dttm
          from flight f
                inner join ticket t on f.flight_no = t.flight_no
          ) FlightInfo on FlightInfo.plane_id = plane.plane_id
        ) FlightInfo on FlightInfo.plane_model = plane_model.plane_model
      ) PlaneInfo on PlaneInfo.ticket_no = p.ticket_no
      group by PlaneInfo.ticket_no, PlaneInfo.passengers_num, PlaneInfo.flight_no, PlaneInfo.departure_dttm
  ) FLightInfo
where difference > 0 and departure_dttm >= current_date
    loop
      return next flights;
    end loop;
end;
  $$ language plpgsql;

select * from GetCurrentFlight();
