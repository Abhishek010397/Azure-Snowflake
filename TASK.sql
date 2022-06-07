CREATE TASK task
  WAREHOUSE = mywarehouse,
  SCHEDULE = '60 MINUTE'
AS MERGE INTO STAGING_TABLE USING SOURCE_TABLE
    ON STAGING_TABLE.ID = SOURCE_TABLE.ID
    WHEN MATCHED THEN
        UPDATE SET  STAGING_TABLE.COL1 = SOURCE_TABLE.COL1,
                    STAGING_TABLE.COL2= SOURCE_TABLE.COL2,
                    ......................................,
                    ......................................,
                    STAGING_TABLE.COLN = SOURCE_TABLE.COLN
    WHEN NOT MATCHED THEN INSERT (
        COL1,
        COL2,
        ....,
        ....,
        COLN
     ) VALUES (
        SOURCE_TABLE.COL1,
        SOURCE_TABLE.COL2,
        .................,
        .................,
        .................,
        SOURCE_TABLE.COLN,
     )
