#' Expectation: relaxed equality
#'
#' A very tolerant equality check to compare AWS results with same results but different probabilities.
#' This should allow the stored mock responses to be regenerated without breaking all the tests,
#' even if the AWS model has slightly changed.
#'
#' @param object Object to test
#' @param expected Expected value
#' @param tolerance Numeric absolute tolerance. Default = 0.5.
#' @param ... Passed to expect_equal
#'
#' @description
#' A wrapper around expect_equal to check if objects (typically data.frames)
#' are equal with a high tolerance for numeric differences.
#'
#' This is used to compare AWS requests results with stored value.
#' We expect the results to have the same format and same headline results but
#' the probabilities may differ slightly in later requests.
#'
#' This is equivalent to `expect_equal` with `scale = 1` and `tolerance = .5`.
#' This tolerance value is a strict check for integer but a very tolerant check on probabilities.
#'
#' @examples
#'   # A motivating example
#'   res <- data.frame(Sentiment = "POSITIVE", Probability = 0.998)
#'   expected <- data.frame(Sentiment = "POSITIVE", Probability = 0.999)
#'   expect_similar(res, expected) # OK
#'
#' \dontrun{
#'  # To illustrate why expect_similar is useful, consider this:
#'  # Surprisingly, this actually passes!
#'  expect_equal(data.frame(a = 10), data.frame(a = 11), tolerance = 0.5)
#'
#'  # On the other hand, expect_similar fails as expected
#'  expect_similar(data.frame(a = 10), data.frame(a = 11, tolerance = 0.5))
#'}
#'
#'
expect_similar <- function(object, expected, tolerance = .5, ...) {
  testthat::expect_equal(object, expected, scale = 1, tolerance = tolerance, ...)
}
