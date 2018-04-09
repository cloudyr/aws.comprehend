#' @title Detect language in a source text
#' @description Detect language(s) in a source text
#' @param text A character string containing a textual source, or a character vector to detect languages separately for each element.
#' @param \dots Additional arguments passed to \code{\link{comprehendHTTP}}.
#' @return A data frame of language probabilities.
#' @examples
#' \dontrun{
#'   # simple example
#'   detect_language("This is a test sentence in English")
#'   
#'   # two languages in a single text
#'   txt <- "A: ¡Hola! ¿Como está, usted?\nB: Ça va bien. Merci. Et toi?"
#'   detect_language(txt)
#' 
#'   # "batch" mode
#'   detect_language(c("A: ¡Hola! ¿Como está, usted?",
#'                     "B: Ça va bien. Merci. Et toi?"))
#' }
#' @export
detect_language <-
function(
  text,
  ...
) {
    if (length(text) > 1L) {
        bod <- list(TextList = text)
        out <- comprehendHTTP(action = "BatchDetectDominantLanguage", body = bod, ...)
        
        # build response data frame
        x <- out$ResultList
        x <- cbind(Index = x$Index, do.call("rbind", x$Languages))
        return(structure(x, ErrorList = out$ErrorList))
    } else {
        bod <- list(Text = text)
        out <- comprehendHTTP(action = "DetectDominantLanguage", body = bod, ...)
        return(out$Languages)
    }
}
