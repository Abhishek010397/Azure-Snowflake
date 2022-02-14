-- Create the stage using the CREATE STAGE command.

-- For account in URL give  --> azure storage account name 

USE SCHEMA <DB_NAME>.<SCHEMA_NAME>;

CREATE FILE FORMAT my_json_format
   TYPE = JSON ;

CREATE STAGE my_azure_stage
  STORAGE_INTEGRATION = snowflake
  URL = 'azure://myaccount.blob.core.windows.net/container1/path1'
  FILE_FORMAT = my_json_format;