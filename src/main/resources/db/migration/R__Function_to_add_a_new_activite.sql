CREATE OR REPLACE FUNCTION add_activity_with_title(title CHARACTER VARYING(200)) RETURNS bigint AS $$
    INSERT INTO activity (title, id)
    VALUES (title, nextval('id_generator')) returning id;
$$ LANGUAGE SQL;