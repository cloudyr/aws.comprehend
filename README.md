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
## 1           en 0.9945121
```

```r
# multi-lingual language detection
detect_language("A: ¡Hola! ¿Como está, usted?\nB: Ça va bien. Merci. Et toi?")
```

```
##   LanguageCode     Score
## 1           fr 0.6712779
## 2           pt 0.2771675
```

```r
# sentiment analysis
detect_sentiment("I have never been happier. This is the best day ever.")
```

```
##   Index Sentiment       Mixed    Negative    Neutral  Positive
## 1     1  POSITIVE 0.002856119 0.003094881 0.03672606 0.9573229
```

```r
# named entity recognition
txt <- c("Amazon provides web services.", "Jeff is their leader.")
detect_entities(txt)
```

```
##   Index BeginOffset EndOffset     Score   Text         Type
## 1     0           0         6 0.9960732 Amazon ORGANIZATION
## 2     1           0         4 0.9994556   Jeff       PERSON
```

```r
# key phrase detection
detect_phrases(txt)
```

```
##   Index BeginOffset EndOffset     Score         Text
## 1     0           0         6 0.9884282       Amazon
## 2     1          16        28 0.9975396 web services
## 3     0           0         4 0.9950518         Jeff
## 4     1           8        20 0.9918150 their leader
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
