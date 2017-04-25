chop_fill_data <- function(ts, date, fill) {
  
  # This function chops and fills (or not) the extracted datasets
  #
  # Args:
  #   ts:  time series information to chop and/or fill.
  #   date: date to which we wish to chop the data.
  #   fill: # 0 not to fill, 1 to fill the time series.
  #
  # Returns:
  #   processed time series
  
  k <- which(ts$Date == date)
  if (length(k) == 1) {
    ts_p <- ts[-(1:(k-1)), ]
    a <- which(duplicated(colnames(ts_p)))
    if(length(a) == 0) {
      ts_c = ts_p
    } else {
      b <- a - 1
      na_count0 <- sapply(ts_p, function(y) sum(length(which(is.na(y)))))
      ra <- a[which(na_count0[a] > na_count0[b])]
      rb <- b[which(na_count0[a] <= na_count0[b])]
      rem <- sort(c(ra, rb))
      ts_c <- ts_p[, -rem]
    }
    if (fill == 1) {
      na_count <- sapply(ts_c, function(y) sum(length(which(is.na(y)))))
      ts_c <- ts_c[, which(na_count < dim(ts_c)[1]*0.75)]
      if (is.null(dim(ts_c)) == TRUE) {
        ts_f = NULL
      } else {
        ts_f <- cbind(Date = ts_c$Date, as.data.frame(na.approx(ts_c[-1], maxgap = 6, na.rm = FALSE)))
      }
    } else {
      ts_f <- ts_c
    }
  }
  if (length(k) == 0) {
    ts_f <- NULL
  }
  return(ts_f)
}