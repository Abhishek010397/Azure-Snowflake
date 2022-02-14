-- Inorder to create snowpipe for automating data ingestion from azure blob to snowflake


-- 1. Create Storage Queues in Azure Storage Account, after creation note the URL obtained/displayed on the page

create notification integration azure_snowflake
enabled = true
type = queue
notification provider = azure storage queue
azure storage queue primary_uri='https://<storage-account-name>.queue.core.windows.net/snowflake-queue'
azure tenant id = 'azure-tenant-id';

-- 2. After Queue is Created create Events in Azure Storage Account

-- 1. Click on Event Subscription
-- 2. Give it a name and select Storage Account,choose event type(Blob Created),on endpoint details choose the queue
--    you created above.

-- 3. Obtain the consent URL for granting Snowflake access to the Storage Queue

DESC NOTIFICATION INTEGRATION azure_snowflake;

-- Note the consent url and hit on the url and accept it when asked for

-- Now login to Azure and head on to Azure Active Directory --> Enterprise Edition & verify the snowflake application creation with the timestamp(new created)


-- Now navigate to Queues » storage_queue_name, where storage_queue_name is the name of the storage queue you created in Create a Storage Queue.
-- Click Access Control (IAM) » Add role assignment.
-- Grant the Snowflake app the following permissions:
--     Role: Storage Queue Data Contributor
--     Assign access to: Azure AD user, group, or service principal
--     Select: Snowflake Application Name
-- The Snowflake application identifier should now be listed under Storage Queue Data Contributor (on the same dialog).


-- Now create the pipe as below

create pipe DB_NAME.SCHEMA_NAME.snowflake_pipe
auto ingest = true
integration = 'AZURE SNOWFLAKE'
as
copy into DB_NAME.SCHEMA_NAME.TABLE_NAME
from @DB_NAME.SCHEMA_NAME.STAGE_NAME
file format = (type = 'JSON*);


