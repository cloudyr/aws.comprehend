#' @title Detect key phrases
#' @description Detect key phrases in a source text
#' @param text A character string containing a text to analyze, or a character vector to perform analysis separately for each element.
#' @param language A character string containing a two-letter language code. Currently \dQuote{en} and \dQuote{es} are supported.
#' @param \dots Additional arguments passed to \code{\link{comprehendHTTP}}.
#' @return A data frame
#' @examples
#' \dontrun{
#'   # simple example
#'   detect_phrases("Amazon provides web services. Jeff is their leader.")
#'   
#'   txt <-c("Amazon provides web services.",
#'           "Jeff is their leader.")
#'   detect_phrases(txt)
#' }
#' @export
detect_phrases <-
function(
  text,
  language = "en",
  ...
) {
    if (length(text) > 1L) {
        bod <- list(TextList = text, LanguageCode = language)
        out <- comprehendHTTP(action = "BatchDetectKeyPhrases", body = bod, ...)
        x <- bind_and_index(out$ResultList$Index, out$ResultList$KeyPhrases)
        return(structure(x, ErrorList = out$ErrorList))
    } else {
        bod <- list(Text = text, LanguageCode = language)
        out <- comprehendHTTP(action = "DetectKeyPhrases", body = bod, ...)
        return(cbind(Index = 0, out$KeyPhrases))
    }
}
