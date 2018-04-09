#' @title Execute AWS Comprehend API Request
#' @description This is the workhorse function to execute calls to the Comprehend API.
#' @param action A character string specifying the API action to take
#' @param query An optional named list containing query string parameters and their character values.
#' @param body A request body
#' @param version A character string specifying the API version.
#' @param region A character string containing an AWS region. If missing, the default \dQuote{us-east-1} is used.
#' @param key A character string containing an AWS Access Key ID. The default is pulled from environment variable \dQuote{AWS_ACCESS_KEY_ID}.
#' @param secret A character string containing an AWS Secret Access Key. The default is pulled from environment variable \dQuote{AWS_SECRET_ACCESS_KEY}.
#' @param session_token Optionally, a character string containing an AWS temporary Session Token. If missing, defaults to value stored in environment variable \dQuote{AWS_SESSION_TOKEN}.
#' @param ... Additional arguments passed to \code{\link[httr]{GET}}.
#' @return If successful, a named list. Otherwise, a data structure of class \dQuote{aws-error} containing any error message(s) from AWS and information about the request attempt.
#' @details This function constructs and signs an Polly API request and returns the results thereof, or relevant debugging information in the case of error.
#' @author Thomas J. Leeper
#' @import httr
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom aws.signature signature_v4_auth
#' @export
comprehendHTTP <- 
function(action,
         query = list(),
         body = NULL,
         region = NULL, 
         key = NULL, 
         secret = NULL, 
         session_token = NULL,
         ...) {
    d_timestamp <- format(Sys.time(), "%Y%m%dT%H%M%SZ", tz = "UTC")
    if (is.null(region) || region == "") {
        region <- "us-east-1"
    }
    url <- paste0("https://comprehend.",region,".amazonaws.com")
    Sig <- signature_v4_auth(
           datetime = d_timestamp,
           region = region,
           service = "comprehend",
           verb = "POST",
           action = "/",
           query_args = query,
           canonical_headers = list(host = paste0("comprehend.",region,".amazonaws.com"),
                                    `x-amz-date` = d_timestamp,
                                    "X-Amz-Target" = paste0("Comprehend_20171127.", action),
                                    "Content-Type" = "application/x-amz-json-1.1"),
           request_body = if (length(body)) jsonlite::toJSON(body, auto_unbox = TRUE) else "",
           key = key, 
           secret = secret,
           session_token = session_token)
    headers <- list(`x-amz-date` = d_timestamp,
                    `x-amz-content-sha256` = Sig$BodyHash,
                    `X-Amz-Target` = paste0("Comprehend_20171127.", action),
                    "Content-Type" = "application/x-amz-json-1.1",
                    Authorization = Sig$SignatureHeader)
    if (!is.null(session_token) && session_token != "") {
        headers[["x-amz-security-token"]] <- session_token
    }
    headers[["Authorization"]] <- Sig[["SignatureHeader"]]
    H <- do.call(add_headers, headers)
        
    if (length(query)) {
        r <- POST(url, H, query = query, body = body, encode = "json", ...)
    } else {
        r <- POST(url, H, body = body, encode = "json", ...)
    }
    
    if (http_error(r)) {
        x <- jsonlite::fromJSON(content(r, "text", encoding = "UTF-8"))
        warn_for_status(r)
        h <- headers(r)
        out <- structure(x, headers = h, class = "aws_error")
        attr(out, "request_canonical") <- Sig$CanonicalRequest
        attr(out, "request_string_to_sign") <- Sig$StringToSign
        attr(out, "request_signature") <- Sig$SignatureHeader
    } else {
        out <- try(jsonlite::fromJSON(content(r, "text", encoding = "UTF-8")), silent = TRUE)
        if (inherits(out, "try-error")) {
            out <- structure(content(r, "text", encoding = "UTF-8"), "unknown")
        }
    }
    return(out)
}
