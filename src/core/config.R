# Get environment variables with defaults
get_env_var <- function(var_name, default = NULL) {
    # Try to get from Databricks secrets first
    val <- tryCatch({
        if (exists("spark")) {
            secret_scope <- "dfl_scope"
            spark.read.format("databricks-secrets").load(secret_scope, var_name)
        }
    }, error = function(e) NULL)
    
    # If not found in secrets, try environment variable
    if (is.null(val)) {
        val <- Sys.getenv(var_name, unset = default)
    }
    
    if (is.null(val)) {
        stop(paste("Environment variable", var_name, "not found"))
    }
    
    return(val)
}

# ADLS configuration
get_adls_config <- function() {
    list(
        storage_account = get_env_var("DFL_STORAGE_ACCOUNT"),
        container = get_env_var("DFL_CONTAINER"),
        # Using a more organized structure with raw/bronze layer for initial data ingestion
        directory = "raw/nflverse/teams"  # Changed from "nflverse/teams" to include data layer
    )
}