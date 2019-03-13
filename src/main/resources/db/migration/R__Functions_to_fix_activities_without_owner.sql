CREATE OR REPLACE FUNCTION get_default_owner() RETURNS "user" AS $$
	DECLARE
		defaultOwner "user"%rowtype;
		defaultOwnerUsername varchar(500) := 'Default Owner';
	BEGIN
		SELECT * into defaultOwnerUsername FROM "user"
			WHERE username = defaultOwnerUsername;
		if not found THEN
			INSERT INTO "user" (id, username)
				VALUES (nextval('id_generator'), defaultOwnerUsername);
			SELECT * INTO defaultOwner FROM "user"
				WHERE username = defaultOwnerUsername;
		END if;
		return defaultOwner;
	END
	$$ LANGUAGE plpgsql;	

CREATE OR REPLACE FUNCTION fix_activities_without_owner() RETURNS SETOF activity AS $$

	DECLARE

	BEGIN

	END

$$ LANGUAGE plpgsql;