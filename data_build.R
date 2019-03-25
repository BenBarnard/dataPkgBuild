install.packages(c("DBI",
                   "nycflights13",
                   "dplyr",
                   "RSQLite",
                   "usethis",
                   "httr",
                   "rjson",
                   "tibble",
                   "purrr",
                   "dbplyr"))

library(DBI)
library(nycflights13)
library(dplyr)
library(RSQLite)
library(usethis)
library(httr)
library(rjson)
library(tibble)
library(purrr)

payload <- list(
  'seriesid' = c('LAUCN040010000000005', 'LAUCN040010000000006'),
  'startyear' = 2010,
  'endyear' = 2012,
  'catalog' = FALSE,
  'calculations' = TRUE,
  'annualaverage' = TRUE)



response <- POST(url = "https://api.bls.gov/publicAPI/v1/timeseries/data/",
                 body = toJSON(payload),
                 content_type_json())

json <- fromJSON(rawToChar(response$content))

bls_test_df <- map_dfr(json$Results$series, function(x){
  cbind(tibble(seriesID = x$seriesID),
        map_dfr(x$data, function(y){
          tibble(year = y$year,
                 period = y$period,
                 periodName = y$periodName,
                 value = y$value,
                 footnotes = y$footnotes)
        })
  )
})

usethis::use_data(bls_test_df, overwrite = TRUE)


con <- DBI::dbConnect(RSQLite::SQLite(), path = ":memory:")

copy_to(con, nycflights13::flights, "flights",
        temporary = FALSE,
        indexes = list(
          c("year", "month", "day"),
          "carrier",
          "tailnum",
          "dest"
        )
)

flights_db <- tbl(con, "flights")

flights_sqldb_df <- collect(summarise(group_by(flights_db, dest),
                                      delay = mean(dep_time, na.rm = TRUE)))


usethis::use_data(flights_sqldb_df, overwrite = TRUE)

save(flights_sqldb_df, file = "inst/flightsApp/flights.rda")
