install.packages(c("rmarkdown", "knitr", "xaringan"))

rmarkdown::render(input = "presentation/index.Rmd", output_dir = "docs")

imgs <- list.files("presentation", pattern = ".*\\.((png)|(jpg))")

lapply(imgs, function(x){
  file.copy(from = paste0("presentation/", x),
            to = paste0("docs/", x))
})
