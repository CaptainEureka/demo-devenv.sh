CREATE TABLE IF NOT EXISTS public."users" (
	id serial PRIMARY KEY,
	name VARCHAR UNIQUE
);
