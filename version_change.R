d <- read.dcf('DESCRIPTION')
d[1,3] <- gsub('-', '.', Sys.Date())
write.dcf(d, 'DESCRIPTION')
