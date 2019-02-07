#' BLS API Data
#'
#' A dataset from bls API
#'
#' @format A data frame with 10 variables:
#' \describe{
#'   \item{seriesID}{SOme info}
#'   \item{year}{I guess its a year}
#'   ...
#' }
#' @source \url{https://www.bls.gov}
#'
#' @importFrom usethis use_data
#' @importFrom httr POST content_type_json
#' @importFrom rjson fromJSON toJSON
#' @importFrom tibble tibble
#' @importFrom purrr map_dfr
"bls_test_df"

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

usethis::use_data(bls_test_df)
