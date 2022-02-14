-- Step 2: Grant Snowflake Access to the Storage Location

DESC STORAGE INTEGRATION snowflake;


    -- Where:

    --     integration_name is the name of the integration you created in Step 1: Create a Cloud Storage Integration in Snowflake.

    -- Note the values in the following columns:

    -- AZURE_CONSENT_URL

    --     URL to the Microsoft permissions request page.
    -- AZURE_MULTI_TENANT_APP_NAME

    --     Name of the Snowflake client application created for your account. In a later step in this section, you will need to grant this application the permissions necessary to obtain an access token on your allowed storage locations.

    -- In a web browser, navigate to the URL in the AZURE_CONSENT_URL column. The page displays a Microsoft permissions request page.

    -- Click the Accept button. This action allows the Azure service principal created for your Snowflake account to obtain an access token on any resource inside your tenant. Obtaining an access token succeeds only if you grant the service principal the appropriate permissions on the container (see the next step).

    -- The Microsoft permissions request page redirects to the Snowflake corporate site (snowflake.com).

    -- Log into the Microsoft Azure portal.

    -- Navigate to Azure Services » Storage Accounts. Click on the name of the storage account you are granting the Snowflake service principal access to.

    -- Click Access Control (IAM) » Add role assignment.

    -- Select the desired role to grant to the Snowflake service principal:

    --     Storage Blob Data Reader grants read access only. This allows loading data from files staged in the storage account.

    --     Storage Blob Data Contributor grants read and write access. This allows loading data from or unloading data to files staged in the storage account. The role also allows executing the REMOVE command to remove files staged in the storage account.

    -- Search for the Snowflake service principal. This is the identity in the AZURE_MULTI_TENANT_APP_NAME property in the DESC STORAGE INTEGRATION output (in Step 1). Search for the string before the underscore in the AZURE_MULTI_TENANT_APP_NAME property.



-- Important

--     It can take an hour or longer for Azure to create the Snowflake service principal requested through the Microsoft request page in this section. If the service principal is not available immediately, we recommend waiting an hour or two and then searching again.

--     If you delete the service principal, the storage integration stops working.

