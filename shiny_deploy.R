install.packages(c('rsconnect', 'shiny'))

rsconnect::setAccountInfo(name='ben-barnard',
                          token=Sys.getenv("shiny_token"),
                          secret=Sys.getenv("shiny_secret"))
library(rsconnect)
rsconnect::deployApp('inst/flightsApp',
                     forceUpdate = TRUE,
                     launch.browser = FALSE)

