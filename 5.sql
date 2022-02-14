-- Loading Your Data

-- First Create a table in Snowflake under the schema and warehouse
CREATE TABLE TEST (
    <column_name>  <column_type>
);


ALTER WAREHOUSE <warehouse_name> RESUME;

-- For copying specific data into snowflake table use pattern
COPY INTO <target_table_name>
  FROM @my_azure_stage
  PATTERN = '<provide-azure-storage-blob-file-name'
  FILE_FORMAT = (format_name = my_json_format);