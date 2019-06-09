#' Setup
#' 
#' Setup your session, all subsequent calls will be done using the API key.
#'
#' @param key Your API key, freely available at \url{https://open-platform.theguardian.com}.
#' 
#' @note You can specify \code{GUARDIAN_API_KEY} as environment variable, likely in your \code{.Renviron} file.
#' 
#' @examples
#' \dontrun{
#' newsapi_key("xXXxxXxXxXXx")  
#' }
#' 
#' @import async
#' @import httr
#' @import assertthat
#' 
#' @export
guardian_key <- function(key){
  assert_that(!missing(key), msg = "Missing key")
  Sys.setenv(GUARDIAN_API_KEY = key)
}
