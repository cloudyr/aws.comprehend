context("bind_and_index")

test_that("Handles simple case", {
  res <- bind_and_index(1:2, list(data.frame(col = "a"), data.frame(col = "b")))
  expect_equal(res, data.frame(Index = c(1, 2), col = c("a", "b")))
})

test_that("Handles different number of records", {
  res <- bind_and_index(1:2, list(data.frame(col = "a"), data.frame(col = c("b", "c"))))
  expect_equal(res, data.frame(Index = c(1, 2, 2), col = c("a", "b", "c")))
})

test_that("Handles empty records", {
  res <- bind_and_index(1:2, list(data.frame(col = "a"), data.frame()))
  expect_equal(res, data.frame(Index = c(1), col = c("a")))

  res <- bind_and_index(1:2, list(data.frame(), data.frame(col = "b")))
  expect_equal(res, data.frame(Index = c(2), col = c("b")))

  res <- bind_and_index(1:3, list(data.frame(col = "a"), data.frame(), data.frame(col = "c")))
  expect_equal(res, data.frame(Index = c(1, 3), col = c("a", "c")))
})

test_that("Respects indices", {
  res <- bind_and_index(c(10, 20), list(data.frame(col = "a"), data.frame(col = "b")))
  expect_equal(res, data.frame(Index = c(10, 20), col = c("a", "b")))
})


batch_results <- readRDS(test_path("batch_results.rds"))

# batch_results.rds was generated with:
#
# body <- list(TextList = c(
#   "Jeff Bezos is a famous CEO.",
#   "A+",
#   "AWS provides numerous services."),
#   LanguageCode = "en")
#
# body_language <- list(TextList = c(
#   "Bonjour, comment vas-tu?",
#   "Hi, how are you?",
#   "automobile" # ambiguous
# ))
#
# batch_results <- list(
#   Entities = comprehendHTTP(action = "BatchDetectEntities", body = body),
#   KeyPhrases = comprehendHTTP(action = "BatchDetectKeyPhrases", body = body),
#   Sentiment = comprehendHTTP(action = "BatchDetectSentiment", body = body),
#   Syntax = comprehendHTTP(action = "BatchDetectSyntax", body = body),
#   Language = comprehendHTTP(action = "BatchDetectDominantLanguage", body = body_language)
# )

test_that("Works with BatchDetectEntities", {
  res_list <- batch_results$Entities$ResultList
  output <- bind_and_index(res_list$Index, df_list = res_list$Entities)

  expected <- read.table(sep = "\t",
                         header = TRUE,
                         stringsAsFactors = FALSE,
                         text = "
  Index	BeginOffset	EndOffset	Score	Text	Type
  0	 0	10	0.9999857	Jeff Bezos	PERSON
  0	23	26	0.6394255	CEO	PERSON
  2	 0	 3	0.9972390	AWS	ORGANIZATION
  2	13	21	0.5615919	numerous	QUANTITY")

  expect_similar(output, expected)
})

test_that("Works with BatchDetectKeyPhrases", {
  res_list <- batch_results$KeyPhrases$ResultList
  output <- bind_and_index(res_list$Index, df_list = res_list$KeyPhrases)

  expected <- read.table(sep = "\t",
                         header = TRUE,
                         stringsAsFactors = FALSE,
                         text = "
  Index	BeginOffset	EndOffset	Score	Text
  0	 0	10	1	Jeff Bezos
  0	14	26	1	a famous CEO
  2	 0	 3	1	AWS
  2	13	30	1	numerous services")

  expect_similar(output, expected)
})

test_that("Works with BatchDetectSyntax", {
  res_list <- batch_results$Syntax$ResultList
  output <- bind_and_index(res_list$Index, df_list = res_list$SyntaxTokens)

  expected <- read.table(sep = "\t",
                         header = TRUE,
                         stringsAsFactors = FALSE,
                         text = "
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
  2	30	31	0.9999958	PUNCT	.	5")

  expect_similar(output, expected)
})

test_that("Works with BatchDetectDominantLanguage", {
  res_list <- batch_results$Language$ResultList
  output <- bind_and_index(res_list$Index, df_list = res_list$Languages)

  expected <- read.table(sep = "\t",
                         header = TRUE,
                         stringsAsFactors = FALSE,
                         text = "
  Index	LanguageCode	Score
  0	fr	0.98000991
  1	en	0.99972916
  2	en	0.75387710
  2	fr	0.11801571
  2	it	0.07860542")

  expect_similar(output, expected)
})
