#' @title Detect named entities in a source medical text
#' @description Detect entities in a source medical text
#' @param text A character string containing a text to entities analyze, or a character vector to perform analysis separately for each element.
#' @param language A character string containing a two-letter language code. Currently only \dQuote{en} is supported.
#' @param version A character string containing the version of the API that should be used. Currently only "1" or "2" are supported.
#' @param \dots Additional arguments passed to \code{\link{comprehendHTTP}}.
#' @return A data frame
#' @examples
#' \dontrun{
#'   # simple example
#'   medical_detect_entities("Mrs. Smith comes in today complaining of shortness of breath.")
#'   
#'   txt <-c("Mrs. Smith comes in today.",
#'           "She is complaining of shortnesss of breath.")
#'   medical_detect_entities(txt)
#' }
#' @export
medical_detect_entities <- function(text, language = "en", version = c("2", "1"), ...) {
  version <- match.arg(version)
  operation <- switch(version,
                      "1" = "DetectEntities",
                      "2" = "DetectEntitiesV2")
  bod <- list(Text = text, LanguageCode = language)
  out <- comprehendHTTP(action = operation, body = bod, service = "comprehendmedical", ...)
  return(cbind(Index = 1, out$Entities))
}
