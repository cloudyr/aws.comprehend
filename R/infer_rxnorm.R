#' @title Identify medications in a source medical text
#' @description Identify medications in a source medical text and link them to RxCUI codes
#' @param text A character string containing a text to entities analyze, or a character vector to perform analysis separately for each element.
#' @param language A character string containing a two-letter language code. Currently only \dQuote{en} is supported.
#' @param \dots Additional arguments passed to \code{\link{comprehendHTTP}}.
#' @return A data frame
#' @references \href{https://docs.aws.amazon.com/comprehend-medical/latest/dev/ontology-RxNorm.html}{AWS Comprehend Medical Developer Guide}
#' @examples
#' \dontrun{
#'   # simple example
#'   infer_rxnorm("fluoride topical ( fluoride 1.1 % topical gel ) 1 application Topically daily. Patient is not on warfarin.")
#'
#'   txt <-c("fluoride topical ( fluoride 1.1 % topical gel ) 1 application Topically daily.",
#'           "Patient is not on warfarin.")
#'   infer_rxnorm(txt)
#' }
#' @export
infer_rxnorm <- function(text, language = "en", ...) {
  bod <- list(Text = text, LanguageCode = language)
  out <- comprehendHTTP(action = "InferRxNorm", body = bod, service = "comprehendmedical", ...)
  return(cbind(Index = 0, out$Entities))
}
