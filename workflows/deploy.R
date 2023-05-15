# deploy app to shiny
library(rsconnect)
rsconnect::deployApp(here::here())
