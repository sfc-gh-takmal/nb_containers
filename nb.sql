use role accountadmin;

CREATE DATABASE notebook_db;
CREATE SCHEMA notebook_db.notebook_schema;

CREATE COMPUTE POOL notebook_compute_pool
  MIN_NODES = 1
  MAX_NODES = 3
  INSTANCE_FAMILY = CPU_X64_M
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = FALSE
  AUTO_SUSPEND_SECS = 3600
  COMMENT = 'Compute pool for Snowflake Notebooks on Snowpark Container Services';

  DESCRIBE COMPUTE POOL NOTEBOOK_COMPUTE_POOL;

--GRANT USAGE ON WAREHOUSE notebooks_wh TO ROLE sysadmin;
GRANT USAGE ON COMPUTE POOL NOTEBOOK_COMPUTE_POOL TO ROLE sysadmin;
GRANT USAGE ON DATABASE notebook_db TO ROLE sysadmin;
GRANT USAGE ON SCHEMA notebook_db.notebook_schema TO ROLE sysadmin;
GRANT CREATE NOTEBOOK ON SCHEMA notebook_db.notebook_schema TO ROLE SYSADMIN;

-- For PyPI
CREATE OR REPLACE NETWORK RULE pypi_network_rule
MODE = EGRESS
TYPE = HOST_PORT
VALUE_LIST = ('pypi.org', 'pypi.python.org', 'pythonhosted.org', 'files.pythonhosted.org');

-- Allow all access
CREATE OR REPLACE NETWORK RULE allow_all_rule
MODE = 'EGRESS'
TYPE = 'HOST_PORT'
VALUE_LIST = ('0.0.0.0:443','0.0.0.0:80');

CREATE EXTERNAL ACCESS INTEGRATION pypi_access_integration
ALLOWED_NETWORK_RULES = (pypi_network_rule)
ENABLED = true;

CREATE EXTERNAL ACCESS INTEGRATION allow_all_integration
ALLOWED_NETWORK_RULES = (allow_all_rule)
ENABLED = true;

GRANT USAGE ON INTEGRATION pypi_access_integration TO ROLE sysadmin;

ALTER NOTEBOOK NB_CONTAINERS SET EXTERNAL_ACCESS_INTEGRATIONS = (allow_all_integration);



