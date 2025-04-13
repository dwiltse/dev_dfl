# NFL Teams Data Ingestion Script
# This script loads NFL team information from nflreadr package to ADLS.
# 
# USAGE: This script is designed to be run on-demand only, not scheduled.
# Run this job only when:
# 1. Initial data load
# 2. NFL team relocations (e.g., Raiders to Las Vegas)
# 3. Team rebrands (e.g., Washington Football Team to Commanders)
# 4. League expansion (extremely rare)
#
# Since NFL teams rarely change, there's no need for regular scheduling.
# The data loaded here serves as reference data for other NFL analytics.

# Install and load required packages
if(!require(arrow)) install.packages("arrow")
if(!require(nflreadr)) install.packages("nflreadr")
if(!require(tidyverse)) install.packages("tidyverse")

library(nflreadr)
library(tidyverse)
library(arrow)

# Source configuration
source("../core/config.R")

# Get ADLS configuration
config <- get_adls_config()

# Build ADLS path
adls_path <- sprintf("abfss://%s@%s.dfs.core.windows.net/%s",
                    config$container,
                    config$storage_account,
                    config$directory)

# Load and save teams data with error handling
tryCatch({
    teams_data <- nflreadr::load_teams()
    output_file <- file.path(adls_path, "nfl_teams.parquet")
    message("Attempting to save to: ", output_file)
    
    # Write directly to ADLS using arrow with ABFSS
    write_parquet(teams_data, output_file)
    message("File successfully written to ADLS")
    
}, error = function(e) {
    message("Error: ", e$message)
    stop(e)  # Re-throw the error to ensure the job fails if there's an issue
})