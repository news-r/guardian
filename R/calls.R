#' Search
#' 
#' The content endpoint returns all pieces of content in the API.
#' 
#' @param q The search query parameter supports \code{AND}, \code{OR} and \code{NOT} operators.
#' @param pages Number of pages to collect.
#' 
#' @export
gd_search <- function(q = NULL, pages = 1) {
  .build_calls(q = q, pages = pages, endpoint = "search")
}

#' Call
#' 
#' Executes calls from \code{guardianCalls} objects
#' 
#' @param ... Objects of class \code{guardianCalls}.
#' @param batch_size Size of each batch.
#' 
#' @export
gd_call <- function(..., batch_size = 12) UseMethod("gd_call")

#' @rdname gd_call
#' @method gd_call guardianCalls
#' @export
gd_call.guardianCalls <- function(..., batch_size = 12){
  
  # flatten calls
  calls <- list(...) %>% 
    flatten()

  # compute size
  size <- (batch_size %/% 12) + 1

  cat(
    crayon::blue(cli::symbol$info), "Making", crayon::blue(length(calls)), "calls in", crayon::blue(size), "batches of", batch_size, "\n"
  )
  
  batches <- calls %>% 
    split(rep_len(1:size, length(calls))) %>% 
    map(unlist)


}

.http_warn_for_status <- function(response){
  if(response$status_code != 200)
    warning("error")
  return(response)
}

.call <- function(batch) {

  http_response <- function(url) {
    http_get(url)$
      then(.http_warn_for_status)$
      then(function(response) rawToChar(response$content))$
      then(function(response) jsonlite::fromJSON(response))
  }

  async_map(batch, http_response)
}

.call_map <- function(batches){
  batches %>% 
    map(
    function(x){
      if(length(batches) > 1)
        Sys.sleep(3)
      synchronise(.call(x))
    }
  ) %>% 
    flatten()
}