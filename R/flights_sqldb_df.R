#' Flight data from SQL database.
#'
#' A dataset containing flight data.
#'
#' @format A data frame with some flight data:
#' \describe{
#'   \item{dest}{probably destination}
#'   \item{delay}{delay maybe?}
#'   ...
#' }
#'
#' @importFrom DBI dbconnect
#' @importFrom nycflghts flights
#' @importFrom dplyr tbl collect summarise group_by copy_to
#' @importFrom RSQLite SQLite
#' @importFrom usethis use_data
#'
"flights_sqldb_df"

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


usethis::use_data(flights_sqldb_df)
