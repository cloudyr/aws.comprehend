#' @title Detect syntax in a source text
#' @description Detect syntax in a source text
#' @param text A character string containing a text to syntax analyze, or a character vector to perform analysis separately for each element.
#' @param language A character string containing a two-letter language code. Currently \dQuote{en} and \dQuote{es} are supported.
#' @param \dots Additional arguments passed to \code{\link{comprehendHTTP}}.
#' @return A data frame
#' @examples
#' \dontrun{
#'   # simple example
#'   detect_syntax("The quick brown fox jumps over the lazy dog.")
#'
#'   txt <-c("The quick brown fox jumps over the lazy dog.",
#'           "I have never been happier. This is the best day ever.")
#'   detect_syntax(txt)
#' }
#' @export
#' @importFrom purrr map2
detect_syntax <-
  function(
    text,
    language = "en",
    ...
  ) {
    if (length(text) > 1L) {
      bod <- list(TextList = text, LanguageCode = language)
      out <- comprehendHTTP(action = "BatchDetectSyntax", body = bod, ...)
      # build response data frame
      x <- out$ResultList
      x <- purrr::map2(x$Index, x$SyntaxTokens,
                  function(index, df) {
                    # fixing nested df
                    df <- as.data.frame(as.list(df))
                    cbind(Index = index, df)
                  })
      x <- do.call(rbind, x)
      return(structure(x, ErrorList = out$ErrorList))
    } else {
      bod <- list(Text = text, LanguageCode = language)
      out <- comprehendHTTP(action = "DetectSyntax", body = bod, ...)
      # fixing nested df
      x <- as.data.frame(as.list(out$SyntaxTokens))
      return(cbind(Index = 1, x))
    }
  }
