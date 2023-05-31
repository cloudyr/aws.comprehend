#' @title Detect conditions and associated ICD10 codes in a source medical text
#' @description Detect detect possible medical conditions as entities and link them to ICD10 codes in a source medical text
#' @param text A character string containing a text to entities analyze, or a character vector to perform analysis separately for each element.
#' @param language A character string containing a two-letter language code. Currently only \dQuote{en} is supported.
#' @param \dots Additional arguments passed to \code{\link{comprehendHTTP}}.
#' @return A data frame
#' @references \href{https://docs.aws.amazon.com/comprehend-medical/latest/dev/ontology-icd10.html}{AWS Comprehend Medical Developer Guide}
#' @examples
#' \dontrun{
#'   # simple example
#'   infer_icd10("Mrs. Smith comes in today complaining of shortness of breath.")
#'
#'   txt <-c("Mrs. Smith comes in today.",
#'           "She is complaining of shortnesss of breath.")
#'   infer_icd10(txt)
#' }
#' @export
infer_icd10 <- function(text, language = "en", ...) {
    bod <- list(Text = text, LanguageCode = language)
    out <- comprehendHTTP(action = "InferICD10CM", body = bod, service = "comprehendmedical", ...)
    return(cbind(Index = 0, out$Entities))
  }
