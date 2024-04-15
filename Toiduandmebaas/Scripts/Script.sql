 CREATE TABLE accounts (
	id serial PRIMARY key,
	kogus_kaal float,
	nimi VARCHAR ( 50 ) UNIQUE NOT NULL,
	tootja integer not null,
	kogus_voi_kaal boolean
	
);