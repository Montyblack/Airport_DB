SET search_path = airport, public;

create function Update ()
returns trigger as $$
  begin
  if OLD.flight_hours_num >= 1000 and OLD.flight_hours_num < 2000 and OLD.position_title like '%pilot%' then
    NEW.position_title := 'third class pilot';
  elsif OLD.flight_hours_num >= 2000 and OLD.flight_hours_num < 3000 and OLD.position_title like '%pilot%' then
    NEW.position_title := 'second class pilot';
  elsif OLD.flight_hours_num >= 3000 and OLD.position_title like '%pilot%' then
    NEW.position_title := 'first class pilot';
  end if;
  return NEW;
  end;
  $$ language plpgsql;

drop function Update() cascade ;

create trigger Checking before UPDATE
  on staff for each row
  execute procedure Update();

drop trigger Checking on staff;

update staff SET flight_hours_num = 2001 where staff_id = 85141;


create function Delete_func ()
returns trigger as $$
  declare
    _passenger_num int;
    _tickets_num int;
    _ticket_num int := NEW.ticket_no;
  begin
    select passengers_num
    from plane_model
    where plane_model.plane_model = (
        select plane_model
        from plane
        where plane_id = (
          select f.plane_id
          from flight f
            inner join ticket t on f.flight_no = t.flight_no
          where t.ticket_no = _ticket_num
        )
    ) into _passenger_num;

    select count(*)
    from passenger
    where ticket_no = _ticket_num into _tickets_num;

    if _tickets_num = _passenger_num then
      delete from passenger where ticket_no = _ticket_num;
      delete from ticket where ticket_no = _ticket_num;
    end if;
  return NEW;
  end;
  $$ language plpgsql;

create trigger Deleter after INSERT
  on passenger for each row
  execute procedure Delete_func();

insert into passenger values (228, 435, 4593587344, 'Gregory', 'Jarvis', '+39437842743');
insert into boarding_pass values (228, 23, 7, cast('15:10' as TIME));

insert into passenger values (331, 435, 4593587344, 'Gregory', 'Jarvis', '+39437842743');
insert into boarding_pass values (331, 23, 7, cast('15:10' as TIME));

delete from passenger where boarding_pass_no = 331;
update plane_model set passengers_num = 3 where plane_model.plane_model like 'Airbus-A310';
