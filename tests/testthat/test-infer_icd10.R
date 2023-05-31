context("infer_icd10")

body = get_request_body()

test_that("infer_icd10 works on single string", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP_medical,
    infer_icd10(text = body$medical$Text,
                       language = body$medical$LanguageCode)
  )

  icd10_codes <- Reduce(rbind, output$ICD10CMConcepts)
  expected_icd10_codes <- read.table(sep = "\t", text = "
  Code	Description	Score
  R45.83	Excessive crying of child, adolescent or adult	0.737255275249481
  G47.9	Sleep disorder, unspecified	0.592359900474548
  Z72.821	Inadequate sleep hygiene	0.291808724403381
  Y93.84	Activity, sleeping	0.153297811746597
  F51.9	Sleep disorder not due to a substance or known physiological condition, unspecified	0.146037772297859",
  header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)
  expect_similar(icd10_codes, expected_icd10_codes)

  # These columns are lists of data.frames - complicated to test
  output$Attributes <- NULL
  output$ICD10CMConcepts <- NULL
  output$Traits <- NULL

  expected <- read.table(sep = "\t", text = "
  Index	BeginOffset	Category	EndOffset	Id	Score	Text	Type
  0	45	MEDICAL_CONDITION	61	1	0.678973436355591	Sleeping trouble	DX_NAME",
  header = TRUE, stringsAsFactors = FALSE)

  expect_similar(output, expected)

})
