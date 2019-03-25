devtools::install_github('BenBarnard/dataPkgBuild')
install.packages('rsconnect')

rsconnect::setAccountInfo(name='ben-barnard',
                          token=Sys.getenv("shiny_token"),
                          secret=Sys.getenv("shiny_secret"))
library(rsconnect)
rsconnect::deployApp('inst/flightsApp',
                     forceUpdate = TRUE,
                     launch.browser = FALSE)

