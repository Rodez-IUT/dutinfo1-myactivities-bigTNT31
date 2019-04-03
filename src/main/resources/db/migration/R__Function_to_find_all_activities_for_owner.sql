CREATE OR REPLACE FUNCTION find_all_activities_for_owner(nom varchar) RETURNS SETOF activity AS $$

SELECT activity.*
FROM activity
JOIN "user" ON "user".id = activity.owner_id
WHERE "user".username = nom

$$ LANGUAGE SQL;