context("infer_rxnorm")

body = get_request_body()

test_that("infer_rxnorm works on single string", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP_medical,
    infer_rxnorm(text = body$medical$Text,
                language = body$medical$LanguageCode)
  )

  rxcui_codes <- Reduce(rbind, output$RxNormConcepts)
  expected_rxcui_codes <- read.table(sep = "\t", text = "
  Code	Description	Score
  2599	clonidine	0.840667128562927
  884185	clonidine hydrochloride 0.2 mg oral tablet	0.208982422947884
  884173	clonidine hydrochloride 0.1 mg oral tablet	0.189939811825752
  216094	clinidine	0.129013881087303
  884225	10 ml clonidine hydrochloride 0.5 mg/ml injection	0.0852060243487358",
  colClasses = c("Code" = "character", "Description" = "character", "Score" = "numeric"),
  header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)
  expect_similar(rxcui_codes, expected_rxcui_codes)

  # These columns are lists of data.frames - complicated to test
  output$Attributes <- NULL
  output$RxNormConcepts <- NULL
  output$Traits <- NULL

  expected <- read.table(sep = "\t", text = "
  Index	BeginOffset	Category	EndOffset	Id	Score	Text	Type
  0	83	MEDICATION	92	1	0.997781932353973	Clonidine	GENERIC_NAME",
  header = TRUE, stringsAsFactors = FALSE)

  expect_similar(output, expected)

})
