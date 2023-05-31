#' @title Identify clinical terms in a source medical text
#' @description Identify clinical terms in a source medical text and link them to Systematized Nomenclature of Medicine, Clinical Terms (SNOMED CT) codes
#' @param text A character string containing a text to entities analyze, or a character vector to perform analysis separately for each element.
#' @param language A character string containing a two-letter language code. Currently only \dQuote{en} is supported.
#' @param \dots Additional arguments passed to \code{\link{comprehendHTTP}}.
#' @return A data frame
#' @references \href{https://docs.aws.amazon.com/comprehend-medical/latest/dev/ontology-linking-snomed.html}{AWS Comprehend Medical Developer Guide}
#' @examples
#' \dontrun{
#'   # simple example
#'   infer_snowmed_ct("BHEENT : Boggy inferior turbinates. No oropharyngeal lesion.")
#'
#'   txt <-c("BHEENT : Boggy inferior turbinates.",
#'           "No oropharyngeal lesion.")
#'   infer_snowmed_ct(txt)
#' }
#' @export
infer_snowmed_ct <- function(text, language = "en", ...) {
  bod <- list(Text = text, LanguageCode = language)
  out <- comprehendHTTP(action = "InferSNOMEDCT", body = bod, service = "comprehendmedical", ...)
  return(cbind(Index = 0, out$Entities))
}
