context("detect_phrases")

body = get_request_body()

test_that("detect_phrases works on single string", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP,
    detect_phrases(text = body$single$Text,
                  language = body$single$LanguageCode)
  )

  expected <- read.table(sep="\t", text="
  Index	BeginOffset	EndOffset	Score	Text
  0	 0	10	1	Jeff Bezos
  0	14	26	1	a famous CEO", header=TRUE, stringsAsFactors=FALSE)

  expect_similar(output, expected, tolerance = 1e-1)

})

test_that("detect_phrases works on character vector", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP,
    detect_phrases(text = body$batch$TextList,
                  language = body$batch$LanguageCode)
  )

  expected <- read.table(sep="\t", text="
  Index	BeginOffset	EndOffset	Score	Text
  0	 0	10	1	Jeff Bezos
  0	14	26	1	a famous CEO
  2	 0	 3	1	AWS
  2	13	30	1	numerous services", header=TRUE, stringsAsFactors=FALSE)
  attr(expected, "ErrorList") <- list()

  expect_similar(output, expected, tolerance = 1e-1)

})


