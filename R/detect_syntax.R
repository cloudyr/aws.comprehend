#' @title Detect syntax in a source text
#' @description Detect syntax in a source text
#' @param text A character string containing a text to syntax analyze, or a character vector to perform analysis separately for each element.
#' @param language A character string containing a two-letter language code.
#' @param \dots Additional arguments passed to \code{\link{comprehendHTTP}}.
#' @return A data frame
#' @examples
#' \dontrun{
#'   # simple example
#'   detect_syntax("The quick brown fox jumps over the lazy dog.")
#'
#'   txt <-c("The quick brown fox jumps over the lazy dog.",
#'           "I have never been happier!")
#'   detect_syntax(txt)
#' }
#' @export
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
      res_list <- mapply(out$ResultList$Index, out$ResultList$SyntaxTokens,
                  FUN = function(index, df) {
                    # fixing nested 'PartOfSpeech' df
                    df <- as.data.frame(as.list(df))
                    # rep handles case where nrow(df) is 0
                    cbind(Index = rep(index, nrow(df)), df)
                  }, SIMPLIFY = FALSE, USE.NAMES = FALSE)
      res <- do.call(rbind, res_list)
      return(structure(res, ErrorList = out$ErrorList))
    } else {
      bod <- list(Text = text, LanguageCode = language)
      out <- comprehendHTTP(action = "DetectSyntax", body = bod, ...)
      # fixing nested 'PartOfSpeech' df
      x <- as.data.frame(as.list(out$SyntaxTokens))
      return(cbind(Index = 1, x))
    }
  }
