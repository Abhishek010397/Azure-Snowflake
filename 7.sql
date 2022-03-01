#CREATE USERS FOR ACCESSING TABLES ON SNOWFLAKE


use role <your-role-name>;
grant usage on database <database-name> to role <role-name>;
grant usage on schema <database-name>.<schema-name> to role <role-name>;
#FOR WAREHOUSE GIVE OWNERSHIP PERMISSION
grant ownership on warehouse <warehouse-name> to role <role-name>;
#NOW GIVE ACCESS FOR SELECT OPERATION ON THE TABLE
grant select on all tables in schema <database-name>.<schema-name> to role <role-name>;
