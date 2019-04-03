drop trigger if exists modif_registration on registration;

drop trigger if exists modif_activity on activity;

--trigger si l'on modifie la table activity
create or replace function audit_modif_activity() returns trigger as $modif_activity$
begin
	IF (TG_OP = 'DELETE') THEN
        INSERT INTO action_log values (nextval('id_generator'), 'delete', TG_TABLE_NAME, user, old.id);
        RETURN OLD;
    END IF;
    RETURN NULL; -- le résultat est ignoré car il s'agit d'un trigger AFTER
end 
$modif_activity$ language plpgsql;
    
create or replace function audit_modif_registration() returns trigger as $modif_registration$
begin
	if (TG_OP = 'INSERT') THEN
        INSERT INTO action_log values (nextval('id_generator'), 'insert', TG_TABLE_NAME, user, new.id);
        RETURN NEW;
    elseif (TG_OP = 'DELETE') then
    	INSERT INTO action_log values (nextval('id_generator'), 'delete', TG_TABLE_NAME, user, old.id);
    	return old;
    END IF;	
    return null;
end 
$modif_registration$ language plpgsql;

create TRIGGER modif_registration
    AFTER insert or delete ON registration
    FOR EACH ROW EXECUTE PROCEDURE audit_modif_registration();
    
create TRIGGER modif_activity
    AFTER DELETE ON activity
    FOR EACH ROW EXECUTE PROCEDURE audit_modif_activity();