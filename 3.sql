-- Step 3: Create an External Stage

-- Create an external (Azure) stage that references the storage integration

GRANT CREATE STAGE ON SCHEMA <schema-name> TO ROLE ACCOUNT_ADMIN;

GRANT USAGE ON snowflake TO ROLE ACCOUNT_ADMIN;