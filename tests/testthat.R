library("testthat")
library("PACKAGENAME")

if (Sys.getenv("AWS_ACCESS_KEY_ID") != "") {
    test_check("PACKAGENAME", filter = "authenticated")
}

test_check("PACKAGENAME", filter = "public")
