CREATE OR REPLACE FUNCTION get_default_owner() RETURNS "user" AS $$
DECLARE
    defaultOwner "user"%rowtype;
    defaultOwnerUsername varchar(500) := 'Default Owner';
BEGIN
    select * into defaultOwner from "user" where username = defaultOwnerUsername;
    IF NOT FOUND THEN
        INSERT INTO "user"(id,username) VALUES (nextval('id_generator'),defaultOwnerUsername);
        select * into defaultOwner from "user" where username = defaultOwnerUsername;
    END IF;
    RETURN defaultOwner;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fix_activities_without_owner() RETURNS SETOF activity AS $$
DECLARE
	idDefaultOwner "user"%rowtype;
	nowDate date = now();
BEGIN
	idDefaultOwner := get_default_owner();
	RETURN QUERY
		UPDATE activity
		SET owner_id = idDefaultOwner.id,
			modification_date = nowDate
		WHERE owner_id IS NULL
		RETURNING *;
END
$$ LANGUAGE plpgsql;