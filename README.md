# Snowflake Storage integration

Storage integrations allows Snowflake to read data from and write data to an Azure container referenced in an external (Azure) stage.

## Create storage integration as below:-

~~~
CREATE STORAGE INTEGRATION myintegrtion
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = AZURE
  ENABLED = TRUE
  AZURE_TENANT_ID = 'my-tenant-id'
  STORAGE_ALLOWED_LOCATIONS = ('azure://storage-account-name.blob.core.windows.net/container-name')
~~~

## Grant Snowflake Access to the storage locations

For granting the access two values are required.
1. **AZURE_CONSENT_URL**: URL to the Microsoft permissions request page.
2. **AZURE_MULTI_TENANT_APP_NAME**: Name of the Snowflake client application created for your account.

We will need to grant this application the permissions necessary to obtain an access token on your allowed storage locations. These are as follows:-


1. In the web browser, navigate to the URL in the **AZURE_CONSENT_URL** column. The page displays a Microsoft permissions request page.

2. Click the Accept button. This action allows the Azure service principal created for your Snowflake account to obtain an access token on any resource inside your tenant. Obtaining an access token succeeds only if you grant the service principal the appropriate permissions on the container.

3. The Microsoft permissions request page redirects to the Snowflake.

4. Log into the Microsoft Azure portal.

5. Navigate to Azure Services » Storage Accounts. Click on the name of the storage account you are granting the Snowflake service principal access to.

6. Click Access Control (IAM) » Add role assignment.

7. Select the desired role to grant to the Snowflake service principal:

8. **Storage Blob Data Reader** grants read access only. This allows loading data from files staged in the storage account.

9. **Storage Blob Data Contributor** grants read and write access. This allows loading data from or unloading data to files staged in the storage account. The role also allows executing the REMOVE command to remove files staged in the storage account.

10. Search for the Snowflake service principal. This is the identity in the **AZURE_MULTI_TENANT_APP_NAME** property in the **DESC STORAGE INTEGRATION** output. Search for the string before the underscore in the **AZURE_MULTI_TENANT_APP_NAME** property.

11. Click the Save button.

## Create a file format

~~~
create file format JSON
   type = json;
~~~

## Create External stage

~~~
use schema DATABASE_NAME.SCHEMA_NAME;

create stage AZURE_STAGE
  storage_integration = myintegration
  url = 'azure://storage-account-name.blob.core.windows.net/container-name'
  file_format = JSON;
~~~


## Create table in the Snowflake under the schema and the warehouse

~~~
CREATE TABLE DATA (
    COL1  VARIANT
);
~~~

## For copying specific file to snowflake table use below command:-

~~~
ALTER WAREHOUSE DATA_WH RESUME;

COPY INTO 
  FROM @AZURE_STAGE
  PATTERN = 'filename.json'
  FILE_FORMAT = (format_name = JSON);
~~~

## For creating snowpipe for automating the data ingestion from blob storage to snowflake follow the below steps:-

1. Create storage queue in storage account. Once the creation is done note the url obtained on the page

~~~
create notification integration azure
  enabled = true
  type = queue
  notification_provider = azure_storage_queue
  azure_storage_queue_primary_uri = 'https://storage-account-name.queue.core.windows.net/your-queue'
  azure_tenant_id = 'azure-tenant-id'
~~~

2. Once the queue has been created create the events in storage account.

    - Go to event subscription.
    - Select storage account -> Choose event type(blob) -> Under the endpoints sections choose the queue created 

3. Get the consent url by running the below command:-
~~~
DESC NOTIFICATION INTEGRATION azure;
~~~

  - The above command output displays **AZURE_CONSENT_URL**, NOTE  **AZURE_CONSENT_URL**
  - Login to Azure --> Azure Active Directory --> Enterprise Edition and verify the snowflake application with the timestamp
  - Navitage to Queues --> storage_queue_name (azure_storage_queue)
  - Click Access Control (IAM) --> Add role assisgnment
  - Grant the Snowflake application the following permissions:- 
          - **Role**: Storage Queue Data Contributor
  - Assign the access to Azure AD user, group or service principal
  - Select the Snowflake application name.
  - The Snowflake application identifier should now be listed under Storage Queue Data Contributor (on the same dialog box).


4. Create Event Grid Subscription

     1. Login to Azure Portal, head to the storage account created.
     2. In the left menu, select **Events** >> **Event Subscription**
     3. In the **Create Event Subscription** window within the Basic tab, provide the following values:-

            |----------------------|---------------------------------|
            |Setting               |     Field Description           |
            |----------------------|---------------------------------|     
            |Name	               |      The name of the event grid |
            |                      |    subscription that you want to|
            |                      |        create.                  |
            |----------------------|---------------------------------| 
            |Event Schema          |    The schema that should be    |
            |                      |    used for the Event Grid      |
            |                      |    (**Default** is Event Grid   |
            |                      |     Schema).                    |                      
            |----------------------|---------------------------------|
            |Topic Type	           | The type of event grid topic.   |
            |                      | Automatically populated         |
            |                      |(**Default** is Storage account).|
            |----------------------|---------------------------------|
            |Source Resource**	   |The name of your storage account.| 
            |                      | Automatically populated.        |
            |----------------------|---------------------------------|
            |System Topic Name     |The system topic where Azure     |
            |                      |Storage publishes events. This   |
            |                      |system topic then forwards the   |
            |                      |event to a subscriber that       |
            |                      | receives and processes events.  |
            |                      |Automatically populated(Name Of  |
            |                      |your Storage Account).           |
            |----------------------|---------------------------------|
            |Filter to Event Types | Which specific events to get    |
            |                      |notified for. When creating the  |
            |                      |subscription.Provide Blob Created|                    
	        |----------------------|---------------------------------|

     4. In the **ENDPOINT DETAILS**, select **Storage Queues** for **Endpoint Type**. Create a **Storage Queue** if not created under the same **Storage Account**.
     5. Click on **Select an endpoint** for **Endpoint** and provide your **Storage Account** and choose either of the one:-
                      - if **Storage Queue** is created, then choose **select from existing queue**.
                      - if **Storage Queue** is not created, then select **create a new queue**
     6. Select **Create** at the last.


4. Create pipe as follows:-

~~~
create pipe DATABASE_NAME.SCHEMA_NAME.SNOWPIPE
  auto_ingest = true
  integration = 'AZURE'
  as
  copy into DATABASE_NAME.SCHEMA_NAME.DATA
  from @DATABASE_NAME.SCHEMA_NAME.AZURE_STAGE
  file_format = (type = 'JSON');
~~~


