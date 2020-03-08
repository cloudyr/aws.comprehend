context("detect_syntax")

body = get_request_body()

test_that("detect_syntax works on single string", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP,
    detect_syntax(text = body$single$Text,
                  language = body$single$LanguageCode)
  )

  expected <- read.table(sep="\t", text="
  Index	BeginOffset	EndOffset	PartOfSpeech.Score	PartOfSpeech.Tag	Text	TokenId
  0	 0	 4	0.9999861	PROPN	Jeff	1
  0	 5	10	0.9999076	PROPN	Bezos	2
  0	11	13	0.9998015	VERB	is	3
  0	14	15	0.9999915	DET	a	4
  0	16	22	0.9992747	ADJ	famous	5
  0	23	26	0.6596355	NOUN	CEO	6
  0	26	27	0.9999983	PUNCT	.	7", header=TRUE, stringsAsFactors=FALSE)

  expect_similar(output, expected, tolerance = 1e-1)

})

test_that("detect_syntax works on character vector", {
  output <- with_mock(
    comprehendHTTP = mock_comprehendHTTP,
    detect_syntax(text = body$batch$TextList,
                  language = body$batch$LanguageCode)
  )

  expected <- read.table(sep="\t", text="
  Index	BeginOffset	EndOffset	PartOfSpeech.Score	PartOfSpeech.Tag	Text	TokenId
  0	 0	 4	0.9999861	PROPN	Jeff	1
  0	 5	10	0.9999076	PROPN	Bezos	2
  0	11	13	0.9998015	VERB	is	3
  0	14	15	0.9999915	DET	a	4
  0	16	22	0.9992747	ADJ	famous	5
  0	23	26	0.6596355	NOUN	CEO	6
  0	26	27	0.9999983	PUNCT	.	7
  1	 0	 1	0.7642077	NOUN	A	1
  1	 1	 2	0.8796068	NOUN	+	2
  2	 0	 3	0.9021474	PROPN	AWS	1
  2	 4	12	0.9997846	VERB	provides	2
  2	13	21	0.9966282	ADJ	numerous	3
  2	22	30	0.9999441	NOUN	services	4
  2	30	31	0.9999958	PUNCT	.	5", header=TRUE, stringsAsFactors=FALSE)
  attr(expected, "ErrorList") <- list()

  expect_similar(output, expected, tolerance = 1e-1)

})


