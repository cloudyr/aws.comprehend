library("testthat")
library("aws.comprehend")

if (Sys.getenv("AWS_ACCESS_KEY_ID") != "") {
    test_check("aws.comprehend", filter = "authenticated")
}

test_check("aws.comprehend", filter = "public")
