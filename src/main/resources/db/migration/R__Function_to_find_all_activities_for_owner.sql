CREATE OR replace FUNCTION find_all_activities_for_owner(nom "user".username%TYPE) RETURNS setof activity AS $$
		SELECT activity.*
		FROM activity
		JOIN "user" ON owner_id = "user".id 
		WHERE "user".username = nom;
$$ LANGUAGE SQL;