context("detect_language")

body = get_request_body()

test_that("detect_language works on single string", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP,
    detect_language(text = body$single_language$Text)
  )

  expected <- read.table(sep="\t", text="
  Index	LanguageCode	Score
  0	en	0.9962505", header=TRUE, stringsAsFactors=FALSE)

  expect_similar(output, expected)

})

test_that("detect_language works on character vector", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP,
    detect_language(text = body$batch$TextList,
                  language = body$batch$LanguageCode)
  )

  expected <- read.table(sep="\t", text="
  Index	LanguageCode	Score
  0	fr	0.9800099
  1	en	0.9997292", header=TRUE, stringsAsFactors=FALSE)
  attr(expected, "ErrorList") <- list()

  expect_similar(output, expected)

})


