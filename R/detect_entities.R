#' @title Detect named entities in a source text
#' @description Detect entities in a source text
#' @param text A character string containing a text to entities analyze, or a character vector to perform analysis separately for each element.
#' @param language A character string containing a two-letter language code. Currently \dQuote{en} and \dQuote{es} are supported.
#' @param \dots Additional arguments passed to \code{\link{comprehendHTTP}}.
#' @return A data frame
#' @examples
#' \dontrun{
#'   # simple example
#'   detect_entities("Amazon provides web services. Jeff is their leader.")
#'
#'   txt <-c("Amazon provides web services, like Microsoft and Google.",
#'           "Jeff is their leader.")
#'   detect_entities(txt)
#' }
#' @export
#' @importFrom purrr map2
detect_entities <-
function(
  text,
  language = "en",
  ...
) {
    if (length(text) > 1L) {
        bod <- list(TextList = text, LanguageCode = language)
        out <- comprehendHTTP(action = "BatchDetectEntities", body = bod, ...)
        # build response data frame
        x <- out$ResultList
        x <- purrr::map2(x$Index, x$Entities,
                         function(index, df) {
                           cbind(Index = index, df)
                         })
        x <- do.call("rbind", x)
        return(structure(x, ErrorList = out$ErrorList))
    } else {
        bod <- list(Text = text, LanguageCode = language)
        out <- comprehendHTTP(action = "DetectEntities", body = bod, ...)
        return(cbind(Index = 1, out$Entities))
    }
}
