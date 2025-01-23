SET (streamlit_warehouse)=(SELECT CURRENT_WAREHOUSE());

CREATE OR REPLACE STAGE SANDBOX.DATAOPS__W446374.SRC_FILES
DIRECTORY = (ENABLE = true);

-- get src files using UI data load tool
-- don't forget to set the role to sandbox.dataops__w446374

-- LIST @SANDBOX.DATAOPS__W446374.SRC_FILES;
-- show stages in schema sandbox.dataops__w446374;
-- describe stage SANDBOX.DATAOPS__W446374.SRC_FILES;
-- show grants on stage SANDBOX.DATAOPS__W446374.SRC_FILES;

CREATE OR REPLACE TABLE SANDBOX.DATAOPS__W446374.TABLE_CATALOG (
  TABLENAME VARCHAR
  ,DESCRIPTION VARCHAR
  ,CREATED_ON TIMESTAMP
  ,EMBEDDINGS VECTOR(FLOAT, 768)
  )
COMMENT = '{"origin": "sf_sit",
            "name": "data_catalog",
            "version": {"major": 1, "minor": 5}}';


CREATE OR REPLACE FUNCTION SANDBOX.DATAOPS__W446374.PCTG_NONNULL(records VARIANT)
returns STRING
language python
RUNTIME_VERSION = '3.10'
IMPORTS = ('@SANDBOX.DATAOPS__W446374.SRC_FILES/tables.py')
COMMENT = '{"origin": "sf_sit",
             "name": "data_catalog",
             "version": {"major": 1, "minor": 5}}'
HANDLER = 'tables.pctg_nonnulls'
PACKAGES = ('pandas','snowflake-snowpark-python');

CREATE OR REPLACE PROCEDURE SANDBOX.DATAOPS__W446374.CATALOG_TABLE(
                                                          tablename string,
                                                          prompt string,
                                                          sampling_mode string DEFAULT 'fast', 
                                                          n integer DEFAULT 5,
                                                          model string DEFAULT 'mistral-7b',
                                                          update_comment boolean Default FALSE)
RETURNS VARIANT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
IMPORTS = ('@SANDBOX.DATAOPS__W446374.SRC_FILES/tables.py', '@SANDBOX.DATAOPS__W446374.SRC_FILES/prompts.py')
PACKAGES = ('snowflake-snowpark-python','joblib', 'pandas', 'snowflake-ml-python')
HANDLER = 'tables.generate_description'
COMMENT = '{"origin": "sf_sit",
             "name": "data_catalog",
             "version": {"major": 1, "minor": 4}}'
EXECUTE AS CALLER;

CREATE OR REPLACE PROCEDURE SANDBOX.DATAOPS__W446374.DATA_CATALOG(target_database string, 
                                                         catalog_database string,
                                                         catalog_schema string,
                                                         catalog_table string,
                                                         target_schema string DEFAULT '',
                                                         include_tables ARRAY DEFAULT null,
                                                         exclude_tables ARRAY DEFAULT null,
                                                         replace_catalog boolean DEFAULT FALSE,
                                                         sampling_mode string DEFAULT 'fast', 
                                                         update_comment boolean Default FALSE,
                                                         n integer DEFAULT 5,
                                                         model string DEFAULT 'mistral-7b'
                                                         )
RETURNS TABLE()
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-snowpark-python','pandas', 'snowflake-ml-python')
IMPORTS = ('@SANDBOX.DATAOPS__W446374.SRC_FILES/tables.py',
           '@SANDBOX.DATAOPS__W446374.SRC_FILES/main.py',
           '@SANDBOX.DATAOPS__W446374.SRC_FILES/prompts.py')
HANDLER = 'main.run_table_catalog'
COMMENT = '{"origin": "sf_sit",
             "name": "data_catalog",
             "version": {"major": 1, "minor": 5}}'
EXECUTE AS CALLER;

CREATE OR REPLACE STREAMLIT SANDBOX.DATAOPS__W446374.DATA_CRAWLER
ROOT_LOCATION = '@sandbox.dataops__w446374.src_files'

MAIN_FILE = '/manage.py'
QUERY_WAREHOUSE = $streamlit_warehouse
COMMENT = '{"origin": "sf_sit",
            "name": "data_catalog",
            "version": {"major": 1, "minor": 5}}';