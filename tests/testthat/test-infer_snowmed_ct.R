context("infer_snowmed_ct")

body = get_request_body()

test_that("infer_snowmed_ct works on single string", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP_medical,
    infer_snowmed_ct(text = body$medical$Text,
                 language = body$medical$LanguageCode)
  )

  snowmed_codes <- Reduce(rbind, output$SNOMEDCTConcepts)
  expected_snowmed_codes <- read.table(sep = "\t", text = "
  Code	Description	Score
  301345002	Difficulty sleeping (finding)	0.0105650639161468
  39898005	Sleep disorder (disorder)	0.00971199851483107
  26677001	Sleep pattern disturbance (finding)	0.00622155796736479
  89675003	Sleep terror disorder (disorder)	0.00587156973779202
  248259004	Symptoms interfere with sleep (disorder)	0.00511229783296585",
  colClasses = c("Code" = "character", "Description" = "character", "Score" = "numeric"),
  header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)
  expect_similar(snowmed_codes, expected_snowmed_codes)

  # These columns are lists of data.frames - complicated to test
  output$Attributes <- NULL
  output$SNOMEDCTConcepts <- NULL
  output$Traits <- NULL

  expected <- read.table(sep = "\t", text = "
  Index	BeginOffset	Category	EndOffset	Id	Score	Text	Type
  0	45	MEDICAL_CONDITION	61	1	0.678973436355591	Sleeping trouble	DX_NAME",
  header = TRUE, stringsAsFactors = FALSE)

  expect_similar(output, expected)

})
