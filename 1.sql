-- Step 1: Create a Cloud Storage Integration in Snowflake

--    Only account administrators (users with the ACCOUNTADMIN role) or a role with the global CREATE INTEGRATION privilege can execute this SQL command.
--    In STORAGE_ALLOWED_LOCATIONS for account give storage account name


CREATE STORAGE INTEGRATION snowflake
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = AZURE
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant_id>'
  STORAGE_ALLOWED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/')



