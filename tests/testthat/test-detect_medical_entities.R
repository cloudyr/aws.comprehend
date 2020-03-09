context("detect_medical_entities V1")

body = get_request_body()

test_that("detect_medical_entities V1 works on single string", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP_medical,
    detect_medical_entities(text = body$medical$Text,
                            language = body$medical$LanguageCode,
                            version = "1")
  )

  # Trait column is a list of data.frames - complicated to test
  output$Traits <- NULL

  expected <- read.table(sep="\t", text="
  Index	BeginOffset	Category	EndOffset	Id	Score	Text	Type
  0	 6	PROTECTED_HEALTH_INFORMATION	10	2	0.9982511	40yo	AGE
  0	19	PROTECTED_HEALTH_INFORMATION	37	3	0.4113526	highschool teacher	PROFESSION
  0	45	MEDICAL_CONDITION	61	1	0.7587468	Sleeping trouble	DX_NAME
  0	83	MEDICATION	92	0	0.9932888	Clonidine	GENERIC_NAME",
                         header=TRUE, stringsAsFactors=FALSE)

  expect_similar(output, expected)

})

context("detect_medical_entities V2")

test_that("detect_medical_entities V2 works on single string", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP_medical,
    detect_medical_entities(text = body$medical$Text,
                            language = body$medical$LanguageCode,
                            version = "2")
  )

  # Trait column is a list of data.frames - complicated to test
  output$Traits <- NULL

  expected <- read.table(sep="\t", text="
  Index	BeginOffset	Category	EndOffset	Id	Score	Text	Type
  0	 6	PROTECTED_HEALTH_INFORMATION	10	2	0.9982511	40yo	AGE
  0	19	PROTECTED_HEALTH_INFORMATION	37	3	0.4113526	highschool teacher	PROFESSION
  0	45	MEDICAL_CONDITION	61	1	0.7587468	Sleeping trouble	DX_NAME
  0	83	MEDICATION	92	0	0.9932888	Clonidine	GENERIC_NAME",
                         header=TRUE, stringsAsFactors=FALSE)

  expect_similar(output, expected)

})
