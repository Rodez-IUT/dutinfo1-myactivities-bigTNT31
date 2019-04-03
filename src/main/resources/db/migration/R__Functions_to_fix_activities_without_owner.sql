CREATE OR REPLACE FUNCTION get_default_owner() RETURNS "user" AS $$

	DECLARE
		user_id "user"%ROWTYPE;
	BEGIN

		SELECT * INTO user_id FROM "user" WHERE username = 'Default Owner';
		
		IF FOUND THEN
			RETURN user_id;
		END IF;
		
		INSERT INTO "user" (id, username) VALUES (1, 'Default Owner');
		SELECT * INTO user_id FROM "user" WHERE username = 'Default Owner';
		RETURN user_id;
		
	END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION fix_activities_without_owner() RETURNS SETOF activity AS $$

	DECLARE
		user_id "user"%rowtype;
	BEGIN
		user_id := get_default_owner();
		
		RETURN QUERY UPDATE activity
		             SET owner_id = user_id.id
		             WHERE owner_id IS NULL
		             RETURNING *;
		
	END;

$$ LANGUAGE plpgsql;