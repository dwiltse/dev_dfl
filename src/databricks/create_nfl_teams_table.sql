-- Create external table in Unity Catalog
CREATE EXTERNAL TABLE IF NOT EXISTS ${bundle.target}_dfl.nfl.bronze_teams
USING PARQUET
LOCATION 'abfss://${DFL_CONTAINER}@${DFL_STORAGE_ACCOUNT}.dfs.core.windows.net/raw/nflverse/teams/nfl_teams.parquet';