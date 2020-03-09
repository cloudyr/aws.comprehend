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
      x <- bind_and_index(out$ResultList$Index, out$ResultList$SyntaxTokens)
      return(structure(x, ErrorList = out$ErrorList))
    } else {
      bod <- list(Text = text, LanguageCode = language)
      out <- comprehendHTTP(action = "DetectSyntax", body = bod, ...)
      # Fix nested 'PartOfSpeech' df. `flatten` is defined in bind_and_index.R.
      x <- flatten(out$SyntaxTokens)
      return(cbind(Index = 0, x))
    }
  }
