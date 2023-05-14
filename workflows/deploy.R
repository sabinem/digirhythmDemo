# deploy app to shiny
app_dir <- getwd()
rsconnect::deployApp(app_dir)
