-- Create external table in Unity Catalog
CREATE EXTERNAL TABLE IF NOT EXISTS catalog_name.schema_name.nfl_teams
USING PARQUET
LOCATION 'abfss://your_container_name@your_storage_account_name.dfs.core.windows.net/raw/nflverse/teams/nfl_teams.parquet';