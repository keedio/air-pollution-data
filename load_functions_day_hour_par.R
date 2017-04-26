# The following functions extract the rawdata information
#
# Args:
#   filenames: rawdata file names.
#
# Returns:
#   data frame with all the corresponding time series
# 
# Author: Joanna Rodríguez
# e-mail: jrodriguez@keedio.com

get_day_matrix <- function(file_names){
  
  split_days <- unlist(strsplit(substr(file_names, start = 22, stop = 44), "\\."))
  k1 <- seq(1, length(split_days)-1, by = 2)
  k2 <- seq(2, length(split_days), by = 2)
  
  start <- min(sort(as.Date(split_days[k1], format = "%d-%m-%Y")))
  end <- max(sort(as.Date(split_days[k2], format = "%d-%m-%Y")))
  
  all_Dates <- seq.Date(as.Date(start), as.Date(end), by = "day")
  
  registerDoSEQ() # specify that %dopar% should run sequentially (foreach exec)
  cl = makeCluster(3) # create a cluster with 3 cores
  registerDoParallel(cl) # register the cluster
  
  r <- foreach(i = 1:length(file_names), .combine = 'cbind', .packages = 'Hmisc') %dopar% {
    x <- read.table(file_names[i])
    k <- seq(3, 63, by = 2)
    for(l in k){
      s <- which(x[,l] <= 0)
      if (length(s) != 0) {
        for (j in s) {
          x[s, l-1] = NA
        }
      }
    }
    x <- x[, -c(k)]
    x$V1 <- as.Date(x$V1)
    
    all_Dates_x <- seq.Date(min(x$V1), max(x$V1), by = "month")
    all_Values <- merge(x = data.frame(V1 = all_Dates_x), x, all = TRUE)
    x_all <- t(all_Values)
    list <- double()
    for (m in 1:dim(x_all)[2]) {
      b <- as.numeric(x_all[1:monthDays(as.Date(x_all[1, m])) + 1, m])
      list <- append(list, b)
    }
    
    if (monthDays(max(x$V1)) == 28) {d <- 27}
    if (monthDays(max(x$V1)) == 29) {d <- 28}
    if (monthDays(max(x$V1)) == 30) {d <- 29}
    if (monthDays(max(x$V1)) == 31) {d <- 30}
    
    all_Dates_day <- seq.Date(min(x$V1), max(x$V1) + d, by = "day")
    x_new <- cbind(data.frame(V1 = all_Dates_day), list) 
    r_x <- merge(data.frame(V1 = all_Dates), x_new, all = TRUE)
    
    if (i == 1) {
      r_x
    } else {
      r_x[c("list")]
    }
  }
  
  stopCluster(cl) # shut down the cluster
  colnames(r) <- c("Date",c(substr(file_names, start = 1, stop = 7)))
  return(r)
}

# Get hour

get_hour_matrix <- function(file_names){
  
  split_hours <- unlist(strsplit(substr(file_names, start = 23, stop = 44), "\\."))
  k1 <- seq(1, length(split_hours)-1, by = 2)
  k2 <- seq(2, length(split_hours), by = 2)
  
  start <- min(sort(as.Date(split_hours[k1], format = "%d-%m-%Y")))
  end <- max(sort(as.Date(split_hours[k2], format = "%d-%m-%Y")))
  
  all_Dates <- seq(from=as.POSIXct(paste(start,'0:00'), tz = "UTC"),
                   to = as.POSIXct(paste(end,'23:00'), tz = "UTC"),
                   by = "hour")  
  
  registerDoSEQ() # specify that %dopar% should run sequentially (foreach exec)
  cl = makeCluster(3) # create a cluster with 3 cores
  registerDoParallel(cl) # register the cluster
  
  h <- foreach(i = 1:length(file_names), .combine = 'cbind', .packages = 'Hmisc') %dopar% {
    x <- read.table(file_names[i])
    k <- seq(3, 49, by = 2)
    for(l in k){
      s <- which(x[,l] <= 0)
      if (length(s) !=0 ) {
        for (j in s) {
          x[s, l-1] = NA
        }
      }
    }
    x <- x[, -c(k)]
    x$V1 <- as.Date(x$V1)
    
    all_Dates_x <- seq.Date(min(x$V1), max(x$V1), by = "day")
    all_Values <- merge(x = data.frame(V1 = all_Dates_x), x, all = TRUE)
    x_all <- t(all_Values)
    list <- double()
    for (m in 1:dim(x_all)[2]){
      b <- as.numeric(x_all[2:25, m])
      list <- append(list, b)
    }
    
    all_Dates_hour <- seq(from = as.POSIXct(paste(min(x$V1),'0:00'), tz = "UTC"),
                          to = as.POSIXct(paste(max(x$V1), '23:00'), tz = "UTC"),
                          by = "hour") 
    x_new <- cbind(data.frame(V1 = all_Dates_hour), list) 
    r_x <- merge(data.frame(V1 = all_Dates), x_new, all = TRUE)
    
    if (i == 1) {
      r_x
    } else {
      r_x[c("list")]
    }
  }
  
  stopCluster(cl) # shut down the cluster
  colnames(h) <- c("Date", c(substr(file_names, start = 1, stop = 7)))
  return(h)
}

