CREATE OR replace FUNCTION get_default_owner() RETURNS "user" AS $$
declare
	nom "user"%rowtype;
begin
	-- ajout et verification de l'existence du default owner
	if not exists (select * from "user" where "user".username = 'Default Owner') then
		insert into "user" (id, username)
		values (nextval('id_generator'), 'Default Owner');
	end if;
	select * from "user"
	where username='Default Owner' INTO nom;
	return nom;
end
$$ LANGUAGE plpgSQL;

create or replace function fix_activities_without_owner() returns setof activity as $$
begin
	--si une activité n'a pas de owner on lui rajoute l'id du default owner
	update activity
	set owner_id = (select "id" from get_default_owner())
	where activity.owner_id is null;
	return query select * from activity
	where owner_id = (select "id" from get_default_owner());
	return;
end 
$$ language plpgsql;