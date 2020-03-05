#' Bind and index a ResultList
#'
#' Turn a list of data.frames (of different lengths and potentially empty)
#' into a single indexed data.frame. Useful to process a ResultList from `comprehendHTTP`.
#' 
#' @param index Vector of indices
#' @param df_list List of data.frames to bind and index. Should NOT be a data.frame.
#' 
#' @details `index` and `df_list` should be the same length. An error is raised otherwise.
#' 
#' bind_and_index(1:2, list(data.frame(col = "a"), data.frame(col = "b")))
#' 
#' bind_and_index(1:3, list(
#'      data.frame(col = "a"), 
#'      data.frame(), 
#'      data.frame(c("b", "c"))))
#' 
bind_and_index <- function(index, df_list) {
  
  if (length(index) != length(df_list)) {
    stop("Index and df_list must be the same length.")
  }
  
  indexed <- mapply(function(i, df) {
    if (nrow(df) > 0) {
      # Flatten and add Index as first col
      cbind(data.frame(Index = i), flatten(df))
    } else {
      df
    }
  }, index, df_list, SIMPLIFY = FALSE)
  
  do.call(rbind, indexed)
}


#' Flatten embedded data.frames (1 level max)
#' @param df data.frame to flatten
#' 
flatten <- function(df) {
  as.data.frame(as.list(df), stringsAsFactors = FALSE)
}
