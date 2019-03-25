options(repos = c("MyRepo"="https://benbarnard.github.io/dataPkgBuild",
                  "CRAN"="https://cran.rstudio.org"))

install.packages(c('rsconnect', 'shiny', "dataPkgBuild"))

rsconnect::setAccountInfo(name='ben-barnard',
                          token=Sys.getenv("shiny_token"),
                          secret=Sys.getenv("shiny_secret"))
library(rsconnect)
rsconnect::deployApp('inst/flightsApp',
                     forceUpdate = TRUE,
                     launch.browser = FALSE)

