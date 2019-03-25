install.packages('drat')
date <- gsub('-', '.', Sys.Date())
pkg <- paste0('dataPkgBuild_', date, '.tar.gz')
drat::insertPackage(pkg, repodir = 'docs')
