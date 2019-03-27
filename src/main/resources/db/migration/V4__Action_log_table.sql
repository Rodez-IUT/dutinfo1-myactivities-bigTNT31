CREATE TABLE action_log
(
	id BIGINT not null
		constraint pk_action_log
			PRIMARY KEY,
	action_name VARCHAR(100) not null,
	entity_name VARCHAR(100) not null,
	entity_id BIGINT not null,
        author VARCHAR(100),
        action_date timestamp NOT NULL
);