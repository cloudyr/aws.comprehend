context("detect_medical_phi")

body = get_request_body()

test_that("detect_medical_phi works on single string", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP_medical,
    detect_medical_phi(text = body$medical$Text,
                       language = body$medical$LanguageCode)
  )

  # Trait column is a list of data.frames - complicated to test
  output$Traits <- NULL

  expected <- read.table(sep="\t", text="
  Index	BeginOffset	Category	EndOffset	Id	Score	Text	Type
  0	6	PROTECTED_HEALTH_INFORMATION	10	0	0.998251140117645	40yo	AGE
  0	19	PROTECTED_HEALTH_INFORMATION	37	1	0.411352604627609	highschool teacher	PROFESSION",
                         header=TRUE, stringsAsFactors=FALSE)

  expect_similar(output, expected)

})
