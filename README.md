# AWS Comprehend Client Package

**aws.comprehend** is a package for natural language processing.

To use the package, you will need an AWS account and to enter your credentials into R. Your keypair can be generated on the [IAM Management Console](https://aws.amazon.com/) under the heading *Access Keys*. Note that you only have access to your secret key once. After it is generated, you need to save it in a secure location. New keypairs can be generated at any time if yours has been lost, stolen, or forgotten. The [**aws.iam** package](https://github.com/cloudyr/aws.iam) profiles tools for working with IAM, including creating roles, users, groups, and credentials programmatically; it is not needed to *use* IAM credentials.

A detailed description of how credentials can be specified is provided at: https://github.com/cloudyr/aws.signature/. The easiest way is to simply set environment variables on the command line prior to starting R or via an `Renviron.site` or `.Renviron` file, which are used to set environment variables in R during startup (see `? Startup`). They can be also set within R:

```R
Sys.setenv("AWS_ACCESS_KEY_ID" = "mykey",
           "AWS_SECRET_ACCESS_KEY" = "mysecretkey",
           "AWS_DEFAULT_REGION" = "us-east-1",
           "AWS_SESSION_TOKEN" = "mytoken")
```

## Code Examples

Here are some simple code examples:




```r
library("aws.comprehend")

# simple language detection
detect_language("This is a test sentence in English")
```

```
##   LanguageCode     Score
## 1           en 0.9729235
```

```r
# multi-lingual language detection
detect_language("A: ¡Hola! ¿Como está, usted? B: Bien, merci. Et toi?")
```

```
##   LanguageCode     Score
## 1           fr 0.7126021
## 2           es 0.2452095
```

```r
# sentiment analysis
detect_sentiment("I have never been happier. This is the best day ever.")
```

```
##   Index Sentiment       Mixed     Negative      Neutral  Positive
## 1     1  POSITIVE 1.21042e-06 5.316024e-05 0.0003428663 0.9996029
```

```r
# named entity recognition
txt <- c("Amazon provides web services.", "Jeff is their leader.")
detect_entities(txt)
```

```
##   Index BeginOffset EndOffset     Score   Text         Type
## 1     0           0         6 0.9999992 Amazon ORGANIZATION
## 2     1           0         4 1.0000000   Jeff       PERSON
```

```r
# key phrase detection
detect_phrases(txt)
```

```
##   Index BeginOffset EndOffset Score         Text
## 1     0           0         6     1       Amazon
## 2     1          16        28     1 web services
## 3     0           0         4     1         Jeff
## 4     1           8        20     1 their leader
```

```r
# syntax analysis
detect_syntax("The quick fox jumps over the lazy dog.")
```

```
##   Index BeginOffset EndOffset PartOfSpeech.Score PartOfSpeech.Tag  Text TokenId
## 1     1           0         3          0.9999670              DET   The       1
## 2     1           4         9          0.9966556              ADJ quick       2
## 3     1          10        13          0.9957780             NOUN   fox       3
## 4     1          14        19          0.8895551             VERB jumps       4
## 5     1          20        24          0.9910401              ADP  over       5
## 6     1          25        28          0.9999968              DET   the       6
## 7     1          29        33          0.9885939              ADJ  lazy       7
## 8     1          34        37          0.9999415             NOUN   dog       8
## 9     1          37        38          0.9999982            PUNCT     .       9
```

```r
# medical entity detection
medical_txt <- "Pt is 40yo mother, highschool teacher. HPI : Sleeping trouble on present dosage of Clonidine."
detect_medical_entities(medical_txt)
```

```
##   Index BeginOffset                     Category EndOffset Id     Score               Text                    Traits         Type
## 1     1           6 PROTECTED_HEALTH_INFORMATION        10  0 0.9982511               40yo                      NULL          AGE
## 2     1          19 PROTECTED_HEALTH_INFORMATION        37  1 0.4113526 highschool teacher                      NULL   PROFESSION
## 3     1          45            MEDICAL_CONDITION        61  3 0.7587468   Sleeping trouble SYMPTOM, 0.52603405714035      DX_NAME
## 4     1          83                   MEDICATION        92  2 0.9932888          Clonidine                      NULL GENERIC_NAME
```

```r
# Protected Health Information (PHI) detection
detect_medical_phi(medical_txt)
```

```
##   Index BeginOffset                     Category EndOffset Id     Score               Text Traits       Type
## 1     1           6 PROTECTED_HEALTH_INFORMATION        10  0 0.9982511               40yo   NULL        AGE
## 2     1          19 PROTECTED_HEALTH_INFORMATION        37  1 0.4113526 highschool teacher   NULL PROFESSION
```

All of the functions accept either a single character string or a character vector.

## Installation

[![CRAN](https://www.r-pkg.org/badges/version/aws.comprehend)](https://cran.r-project.org/package=aws.comprehend)
![Downloads](https://cranlogs.r-pkg.org/badges/aws.comprehend)
[![Travis Build Status](https://travis-ci.org/cloudyr/aws.comprehend.png?branch=master)](https://travis-ci.org/cloudyr/aws.comprehend)
[![Appveyor Build Status](https://ci.appveyor.com/api/projects/status/PROJECTNUMBER?svg=true)](https://ci.appveyor.com/project/cloudyr/aws.comprehend)
[![codecov.io](https://codecov.io/github/cloudyr/aws.comprehend/coverage.svg?branch=master)](https://codecov.io/github/cloudyr/aws.comprehend?branch=master)

This package is not yet on CRAN. To install the latest development version you can install from the cloudyr drat repository:

```R
# latest stable version
install.packages("aws.comprehend", repos = c(cloudyr = "http://cloudyr.github.io/drat", getOption("repos")))
```

Or, to pull a potentially unstable version directly from GitHub:

```R
if (!require("remotes")) {
    install.packages("remotes")
}
remotes::install_github("cloudyr/aws.comprehend")
```

---
[![cloudyr project logo](https://i.imgur.com/JHS98Y7.png)](https://github.com/cloudyr)
