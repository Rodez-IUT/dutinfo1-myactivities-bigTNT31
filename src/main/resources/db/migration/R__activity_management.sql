CREATE OR REPLACE FUNCTION add_activity(in_title varchar, in_description text, in_owner_id bigint DEFAULT null) RETURNS activity AS $$

	DECLARE
	
		line activity%ROWTYPE;
	
	BEGIN
	
		IF in_owner_id IS NULL THEN
			SELECT id INTO in_owner_id FROM "user" WHERE username = 'Default Owner';
		END IF;
	
		INSERT INTO activity (id, title, description, owner_id)
		VALUES (nextval('id_generator'), in_title, in_description, in_owner_id)
		RETURNING * INTO line;
		
		RETURN line;
	
	END;

$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION find_all_activities(activities_cursor refcursor) RETURNS refcursor AS $$

	BEGIN
	
		OPEN activities_cursor FOR SELECT activity.id, activity.title, "user".username
								   FROM activity
					               LEFT JOIN "user" ON "user".id = activity.owner_id
					               ORDER BY title ASC, "user".username ASC;
					    
		RETURN activities_cursor;
		
	END;

$$ LANGUAGE plpgsql;