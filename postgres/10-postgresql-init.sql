CREATE ROLE "liferay" LOGIN PASSWORD 'demo' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
CREATE SCHEMA "liferay" AUTHORIZATION "liferay";
GRANT ALL ON SCHEMA "liferay" TO "liferay";
GRANT ALL ON ALL TABLES IN SCHEMA liferay TO liferay;
GRANT ALL ON ALL SEQUENCES IN SCHEMA liferay TO liferay;
