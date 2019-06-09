#' Setup
#' 
#' Setup your session, all subsequent calls will be done using the API key and given the batch limit.
#'
#' @param cps Calls per second: maximum number of calls per seconds. 
#' @param key Your API key, freely available at \url{https://open-platform.theguardian.com}.
#' 
#' @note You can specify \code{GUARDIAN_API_KEY} as environment variable, likely in your \code{.Renviron} file.
#' 
#' @examples
#' \dontrun{
#' guardian_key("xXXxxXxXxXXx")  
#' }
#' 
#' @import async
#' @import httr
#' @import assertthat
#' 
#' @name setup
#' @export
guardian_key <- function(key){
  assert_that(!missing(key), msg = "Missing key")
  Sys.setenv(GUARDIAN_API_KEY = key)
}

#' @rdname setup
#' @export
guardian_batches <- function(cps = 12){
  Sys.setenv(GUARDIAN_BATCH_SIZE = cps)
}