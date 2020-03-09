context("detect_sentiment")

body = get_request_body()

test_that("detect_sentiment works on single string", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP,
    detect_sentiment(text = body$single$Text,
                  language = body$single$LanguageCode)
  )

  expected <- read.table(sep="\t", text="
  Index	Sentiment	Mixed	Negative	Neutral	Positive
  0	POSITIVE	4.089085e-06	0.008974612	0.2708658	0.7201555",
                         header=TRUE, stringsAsFactors=FALSE)

  expect_similar(output, expected)

})

test_that("detect_sentiment works on character vector", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP,
    detect_sentiment(text = body$batch$TextList,
                  language = body$batch$LanguageCode)
  )

  expected <- read.table(sep="\t", text="
  Index	Sentiment	Mixed	Negative	Neutral	Positive
  0	POSITIVE	4.089085e-06	8.974612e-03	0.270865828	0.72015548
  1	POSITIVE	2.819010e-06	7.270827e-05	0.007048493	0.99287605
  2	NEUTRAL	3.774663e-06	7.069100e-05	0.953713119	0.04621244",
                         header=TRUE, stringsAsFactors=FALSE)
  attr(expected, "ErrorList") <- list()

  expect_similar(output, expected)

})


