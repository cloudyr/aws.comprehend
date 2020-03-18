# AWS Comprehend Client Package


[![CRAN](https://www.r-pkg.org/badges/version/aws.comprehend)](https://cran.r-project.org/package=aws.comprehend)
![Downloads](https://cranlogs.r-pkg.org/badges/aws.comprehend)
[![Travis Build Status](https://travis-ci.org/cloudyr/aws.comprehend.png?branch=master)](https://travis-ci.org/cloudyr/aws.comprehend)
[![codecov.io](https://codecov.io/github/cloudyr/aws.comprehend/coverage.svg?branch=master)](https://codecov.io/github/cloudyr/aws.comprehend?branch=master)


**aws.comprehend** is a package for natural language processing.

## Code Examples


All of the functions (except `detect_medical_*`) accept either a single character string or a character vector. Note that AWS currently limits batch queries to 25 documents, so character vectors should have 25 elements maximum.

The default language is English (`"en"`) but this is easily changed using the `language` argument.




### Sentiment analysis


```r
library("aws.comprehend")

detect_sentiment("I have never been happier. This is the best day ever.")
```

```
##   Index Sentiment       Mixed     Negative      Neutral  Positive
## 1     0  POSITIVE 1.21042e-06 5.316024e-05 0.0003428663 0.9996029
```

```r
# Sentiment analysis in Spanish
detect_sentiment("¡Hoy estoy feliz!", language = "es")
```

```
##   Index Sentiment        Mixed    Negative    Neutral  Positive
## 1     0  POSITIVE 0.0001126147 0.002433205 0.03607949 0.9613748
```

### Language detection


```r
# simple language detection
detect_language("This is a test sentence in English")
```

```
##   Index LanguageCode     Score
## 1     0           en 0.9729235
```

```r
# multi-lingual language detection
detect_language("A: ¡Hola! ¿Como está, usted? B: Bien, merci. Et toi?")
```

```
##   Index LanguageCode     Score
## 1     0           fr 0.7126021
## 2     0           es 0.2452095
```

### Named Entity Recognition


```r
txt <- c("Amazon provides web services.", "Jeff is their leader.")
detect_entities(txt)
```

```
##   Index BeginOffset EndOffset     Score   Text         Type
## 1     0           0         6 0.9992782 Amazon ORGANIZATION
## 2     1           0         4 0.9999498   Jeff       PERSON
```

### Key Phrase Detection


```r
txt <- c("Amazon provides web services.", "Jeff is their leader.")
detect_phrases(txt)
```

```
##   Index BeginOffset EndOffset Score         Text
## 1     0           0         6     1       Amazon
## 2     0          16        28     1 web services
## 3     1           0         4     1         Jeff
## 4     1           8        20     1 their leader
```

### Syntax Analysis


```r
detect_syntax("The quick fox jumps over the lazy dog.")
```

```
##   Index BeginOffset EndOffset PartOfSpeech.Score PartOfSpeech.Tag  Text TokenId
## 1     0           0         3          0.9999670              DET   The       1
## 2     0           4         9          0.9966556              ADJ quick       2
## 3     0          10        13          0.9957780             NOUN   fox       3
## 4     0          14        19          0.8895551             VERB jumps       4
## 5     0          20        24          0.9910401              ADP  over       5
## 6     0          25        28          0.9999968              DET   the       6
## 7     0          29        33          0.9885939              ADJ  lazy       7
## 8     0          34        37          0.9999415             NOUN   dog       8
## 9     0          37        38          0.9999982            PUNCT     .       9
```

### Medical Entity and Personal Health Information (PHI) Detection


```r
# medical entity detection
medical_txt <- "Pt is 40yo mother, highschool teacher. HPI : Sleeping trouble on present dosage of Clonidine."
detect_medical_entities(medical_txt)
```

```
##   Index BeginOffset                     Category EndOffset Id     Score               Text                    Traits         Type
## 1     0           6 PROTECTED_HEALTH_INFORMATION        10  2 0.9982511               40yo                      NULL          AGE
## 2     0          19 PROTECTED_HEALTH_INFORMATION        37  3 0.4113526 highschool teacher                      NULL   PROFESSION
## 3     0          45            MEDICAL_CONDITION        61  1 0.7587468   Sleeping trouble SYMPTOM, 0.52603405714035      DX_NAME
## 4     0          83                   MEDICATION        92  0 0.9932888          Clonidine                      NULL GENERIC_NAME
```

```r
# Protected Health Information (PHI) detection
detect_medical_phi(medical_txt)
```

```
##   Index BeginOffset                     Category EndOffset Id     Score               Text Traits       Type
## 1     0           6 PROTECTED_HEALTH_INFORMATION        10  0 0.9982511               40yo   NULL        AGE
## 2     0          19 PROTECTED_HEALTH_INFORMATION        37  1 0.4113526 highschool teacher   NULL PROFESSION
```


## Setting up credentials

To use the package, you will need an AWS account and to enter your credentials into R. Your keypair can be generated on the [IAM Management Console](https://aws.amazon.com/) under the heading *Access Keys*. Note that you only have access to your secret key once. After it is generated, you need to save it in a secure location. New keypairs can be generated at any time if yours has been lost, stolen, or forgotten. The [**aws.iam** package](https://github.com/cloudyr/aws.iam) profiles tools for working with IAM, including creating roles, users, groups, and credentials programmatically; it is not needed to *use* IAM credentials.

A detailed description of how credentials can be specified is provided at: https://github.com/cloudyr/aws.signature/. The easiest way is to simply set environment variables on the command line prior to starting R or via an `Renviron.site` or `.Renviron` file, which are used to set environment variables in R during startup (see `? Startup`). They can be also set within R:

```R
Sys.setenv("AWS_ACCESS_KEY_ID" = "mykey",
           "AWS_SECRET_ACCESS_KEY" = "mysecretkey",
           "AWS_DEFAULT_REGION" = "us-east-1",
           "AWS_SESSION_TOKEN" = "mytoken")
```


## Installation

You can install this package from CRAN or, to install the latest development version, from the cloudyr drat repository:

```R
# Install from CRAN
install.packages("aws.comprehend")

# Latest version passing CI tests, from drat repo
install.packages("aws.comprehend", repos = c(getOption("repos"), "http://cloudyr.github.io/drat"))
```

You can also pull a potentially unstable version directly from GitHub, using the `remotes` package:

```R
remotes::install_github("cloudyr/aws.comprehend")
```


---
[![cloudyr project logo](https://i.imgur.com/JHS98Y7.png)](https://github.com/cloudyr)
