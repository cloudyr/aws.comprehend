context("detect_entities")

body = get_request_body()

test_that("detect_entities works on single string", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP,
    detect_entities(text = body$single$Text,
                  language = body$single$LanguageCode)
  )

  expected <- read.table(sep="\t", text="
  Index	BeginOffset	EndOffset	Score	Text	Type
  0	 0	10	0.9999857	Jeff Bezos	PERSON
  0	23	26	0.6394255	CEO	PERSON", header=TRUE, stringsAsFactors=FALSE)

  expect_similar(output, expected)

})

test_that("detect_entities works on character vector", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP,
    detect_entities(text = body$batch$TextList,
                  language = body$batch$LanguageCode)
  )

  expected <- read.table(sep="\t", text="
  Index	BeginOffset	EndOffset	Score	Text	Type
  0	 0	10	0.9999857	Jeff Bezos	PERSON
  0	23	26	0.6394255	CEO	PERSON
  2	 0	 3	0.9972390	AWS	ORGANIZATION
  2	13	21	0.5615919	numerous	QUANTITY", header=TRUE, stringsAsFactors=FALSE)
  attr(expected, "ErrorList") <- list()

  expect_similar(output, expected)

})


