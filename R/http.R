#' @title Execute AWS Comprehend API Request
#' @description This is the workhorse function to execute calls to the Comprehend API.
#' @param action A character string specifying the API action to take
#' @param query An optional named list containing query string parameters and their character values.
#' @param headers A list of headers to pass to the HTTP request.
#' @param body A request body
#' @param verbose A logical indicating whether to be verbose. Default is given by \code{options("verbose")}.
#' @param region A character string containing the AWS region. If missing, defaults to \dQuote{us-east-1}.
#' @param key A character string containing an AWS Access Key ID. See \code{\link[aws.signature]{locate_credentials}}.
#' @param secret A character string containing an AWS Secret Access Key. See \code{\link[aws.signature]{locate_credentials}}.
#' @param session_token A character string containing an AWS Session Token. See \code{\link[aws.signature]{locate_credentials}}.
#' @param service the Comprehend service to use. Currently either `comprehend` for the base service or `comprehendmedical`
#' for the Comprehend Medical service.
#' @param \dots Additional arguments passed to \code{\link[httr]{GET}}.
#' @return If successful, a named list. Otherwise, a data structure of class \dQuote{aws-error} containing any error message(s) from AWS and information about the request attempt.
#' @details This function constructs and signs an Polly API request and returns the results thereof, or relevant debugging information in the case of error.
#' @author Thomas J. Leeper
#' @import httr
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom aws.signature signature_v4_auth locate_credentials
#' @export
comprehendHTTP <-
function(
  action,
  query = list(),
  headers = list(),
  body = NULL,
  verbose = getOption("verbose", FALSE),
  region = Sys.getenv("AWS_DEFAULT_REGION","us-east-1"),
  key = NULL,
  secret = NULL,
  session_token = NULL,
  service = c("comprehend", "comprehendmedical"),
  ...
) {
    # locate and validate credentials
    credentials <- aws.signature::locate_credentials(key = key, secret = secret, session_token = session_token, region = region, verbose = verbose)
    key <- credentials[["key"]]
    secret <- credentials[["secret"]]
    session_token <- credentials[["session_token"]]
    region <- credentials[["region"]]
    
    # Fail early if credentials cannot be found
    if ((is.null(key) || is.null(secret)) && is.null(session_token)) {
      stop("Unable to locate AWS credentials.")
    }

    service <- match.arg(service)
    target_prefix <- switch(service,
                            "comprehend" = "Comprehend_20171127",
                            "comprehendmedical" = "ComprehendMedical_20181030")

    # generate request signature
    d_timestamp <- format(Sys.time(), "%Y%m%dT%H%M%SZ", tz = "UTC")
    url <- paste0("https://", service, ".",region,".amazonaws.com")

    Sig <- signature_v4_auth(
           datetime = d_timestamp,
           region = region,
           service = service,
           verb = "POST",
           action = "/",
           query_args = query,
           canonical_headers = list(host = paste0(service,".",region,".amazonaws.com"),
                                    `x-amz-date` = d_timestamp,
                                    "X-Amz-Target" = paste0(target_prefix, ".", action),
                                    "Content-Type" = "application/x-amz-json-1.1"),
           request_body = if (length(body)) jsonlite::toJSON(body, auto_unbox = TRUE) else "",
           key = key,
           secret = secret,
           session_token = session_token,
           verbose = verbose)
    # setup request headers
    headers[["x-amz-date"]] <- d_timestamp
    headers[["X-Amz-Target"]] <- paste0(target_prefix, ".", action)
    headers[["x-amz-content-sha256"]] <- Sig$BodyHash
    headers[["Content-Type"]] <- "application/x-amz-json-1.1"
    headers[["Authorization"]] <- Sig[["SignatureHeader"]]
    if (!is.null(session_token) && session_token != "") {
        headers[["x-amz-security-token"]] <- session_token
    }
    H <- do.call(add_headers, headers)

    # execute request
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
