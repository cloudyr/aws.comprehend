#' Named list of request bodies for comprehendHTTP
#'
get_request_body <- function() {

  list(
    # Request body for batch requests requiring language
    batch = list(
      TextList = c("Jeff Bezos is a famous CEO.",
                   "A+",
                   "AWS provides numerous services."),
      LanguageCode = "en"),

    # Request body for BatchDetectLanguage
    batch_language = list(
      TextList = c("Bonjour, comment vas-tu?",
                   "Hi, how are you?")),

    # Request body for single requests requiring language
    single = list(
      Text = "Jeff Bezos is a famous CEO.",
      LanguageCode = "en"),

    # Request body for single DetectLanguage
    single_language = list(
      Text = "This text is in English."),

    # Request body for medical entities and PHI
    medical = list(
      Text = "Pt is 40yo mother, highschool teacher. HPI : Sleeping trouble on present dosage of Clonidine."
    )
  )
}

#' Regenerate and save a mock response for comprehendHTTP
#'
#' @action A valid AWS Comprehend action
#' @body Request body
#' @path Path where raw response should be saved. Filename will be <action>.rds.
#'
generate_mock <- function(action, body, path = "tests/testthat/mocks/comprehendHTTP") {
  raw_res <- comprehendHTTP(action = action, body = body)
  saveRDS(raw_res, file.path(path, paste0(action, ".rds")))
  return(raw_res)
}

#' Regenerate mocks for all available AWS comprehend actions.
#'
generate_mocks <- function() {
  body <- get_request_body()
  # Mapping between actions and request bodies to use
  actions <- list(
    "DetectEntities" = body$single,
    "BatchDetectEntities" = body$batch,

    "DetectKeyPhrases" = body$single,
    "BatchDetectKeyPhrases" = body$batch,

    "DetectSyntax" = body$single,
    "BatchDetectSyntax" = body$batch,

    "DetectSentiment" = body$single,
    "BatchDetectSentiment" = body$batch,

    "DetectDominantLanguage" = body$single_language,
    "BatchDetectDominantLanguage" = body$batch_language

  )

  mapply(generate_mock, names(actions), actions)

}

#' A mock drop-in replacement for comprehendHTTP.
#'
#' This mock ignores the request body and returns a fixed response based on the action.
#' All potential responses are saved under tests/testthat/mocks/comprehendHTTP.
mock_comprehendHTTP <- function(action, ...) {
  response_dir <- test_path("mocks/comprehendHTTP")
  response_files <- list.files(response_dir)
  target_file <- paste0(action, ".rds")
  if (target_file %in% response_files) {
    raw_res <- readRDS(file.path(response_dir, target_file))
    return(raw_res)
  } else {
    stop("No mock response available for action: ", action)
  }
}
