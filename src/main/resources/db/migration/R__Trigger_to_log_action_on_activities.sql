CREATE OR REPLACE FUNCTION audit_actionLog() RETURNS trigger AS $$
	DECLARE
		id bigint;
	BEGIN
	
		/* id := OLD.id; */
		IF OLD.id IS NOT NULL THEN
			id := OLD.id;
		ELSE
			id := NEW.id;
		END IF;
			
		INSERT INTO action_log (id, action_name, entity_name, entity_id, author, action_date)
		VALUES (nextval('id_generator'), LOWER(TG_OP), TG_RELNAME, id, current_user, now());
		
		RETURN NULL;
	
	END;

$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS action_log_stamp ON activity;

CREATE TRIGGER action_log_stamp
	AFTER DELETE ON activity
	FOR EACH ROW EXECUTE PROCEDURE audit_actionLog();