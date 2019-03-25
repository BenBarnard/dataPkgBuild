library(dataPkgBuild)

shinyServer(
  function(input, output) {

    output$main_plot <- renderPlot({

      hist(flights_sqldb_df$delay,
           probability = TRUE,
           breaks = as.numeric(input$n_breaks),
           xlab = "Delay (minutes)",
           main = "Departure delay duration")

      if (input$individual_obs) {
        rug(flights_sqldb_df$delay)
      }

      if (input$density) {
        dens <- density(flights_sqldb_df$delay,
                        adjust = input$bw_adjust,
                        na.rm = TRUE)
        lines(dens, col = "blue")
      }

    })
  }
)
