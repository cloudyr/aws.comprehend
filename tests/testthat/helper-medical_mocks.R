#' Regenerate and save a mock response for comprehendHTTP (medical service)
#'
#' @action A valid AWS Comprehend action
#' @body Request body
#' @path Path where raw response should be saved. Filename will be <action>.rds.
#'
generate_mock_medical <- function(action, body, path = "tests/testthat/mocks/comprehendHTTP_medical") {
  raw_res <- comprehendHTTP(action = action, body = body, service = "comprehendmedical")
  saveRDS(raw_res, file.path(path, paste0(action, ".rds")))
  return(raw_res)
}

#' Regenerate mocks for all available AWS comprehend medical actions.
#'
generate_mocks_medical <- function() {
  # Request body for medical entities and PHI
  body <- get_request_body()

  # Mapping between actions and request bodies to use
  actions <- list(
    "DetectPHI" = body$medical,
    "DetectEntities" = body$medical,
    "DetectEntitiesV2" = body$medical
  )

  mapply(generate_mock_medical, names(actions), actions)

}

#' A mock drop-in replacement for comprehendHTTP (medical service).
#'
#' This mock ignores the request body and returns a fixed response based on the action.
#' All potential responses are saved under tests/testthat/mocks/comprehendHTTP_medical.
mock_comprehendHTTP_medical <- function(action, ...) {
  response_dir <- test_path("mocks/comprehendHTTP_medical")
  response_files <- list.files(response_dir)
  target_file <- paste0(action, ".rds")
  if (target_file %in% response_files) {
    raw_res <- readRDS(file.path(response_dir, target_file))
    return(raw_res)
  } else {
    stop("No mock response available for action: ", action)
  }
}
