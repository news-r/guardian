#' Search
#' 
#' The content endpoint returns all pieces of content in the API.
#' 
#' @param q The search query parameter supports \code{AND}, \code{OR} and \code{NOT} operators.
#' @param ... Any other parameter, or filter, see the full list at \url{https://open-platform.theguardian.com/documentation/}.
#' @param items Vector of API links to items.
#' @param pages Number of pages to collect.
#' 
#' @examples
#' \dontrun{
#' (to_search <- gd_search("debates", pages = 13))
#' results <- gd_call(to_search)
#' 
#' # select items to retrieve
#' items_to_get <- gd_items(results$apiUrl[1:13])
#' items <- gd_call(items_to_get)
#' }
#' 
#' @name calls
#' @export
gd_search <- function(q = NULL, ..., pages = 1) {
  .build_calls(q = q, ..., pages = pages, endpoint = "search")
}

#' @rdname calls
#' @export
gd_tags <- function(q = NULL, ..., pages = 1) {
  .build_calls(q = q, ..., pages = pages, endpoint = "tags")
}

#' @rdname calls
#' @export
gd_sections <- function(q = NULL, ..., pages = 1) {
  .build_calls(q = q, ..., pages = pages, endpoint = "tags")
}

#' @rdname calls
#' @export
gd_editions <- function(q = NULL, ..., pages = 1) {
  .build_calls(q = q, ..., pages = pages, endpoint = "tags")
}

#' @rdname calls
#' @export
gd_items <- function(items, ...) {
  map(items, function(x){

    url <- parse_url(x)
    url$query <- list(..., `api-key` = .get_key())
    url <- build_url(url)

    list(
      call = url,
      endpoint = "item"
    )
  })  %>% 
    .construct_call()
}

#' Call
#' 
#' Executes calls from \code{guardianCalls} objects
#' 
#' @param ... Objects of class \code{guardianCalls}.
#' @param batch_size Size of each batch.
#' 
#' @examples
#' \dontrun{
#' (to_search <- gd_search("debates", pages = 13))
#' results <- gd_call(to_search)
#' }
#' 
#' @export
gd_call <- function(..., batch_size = 12) UseMethod("gd_call")

#' @rdname gd_call
#' @method gd_call guardianCalls
#' @export
gd_call.guardianCalls <- function(..., batch_size = 12){
  
  # flatten calls
  call_objs <- list(...) %>% 
    flatten()

  # compute size
  size <- (batch_size %/% 12) + 1

  cat(
    crayon::blue(cli::symbol$info), "Making", length(call_objs), "calls in", crayon::green(size), "batches of", batch_size, "\n"
  )

  calls <- map(call_objs, "call")
  endpoint <- map(call_objs, "endpoint")
  
  calls %>% 
    split(rep_len(1:size, length(calls))) %>% 
    map(unlist) %>% 
    .call_map()
  
}

.http_warn_for_status <- function(response){
  if(response$status_code != 200){
    warning(crayon::red(cli::symbol$cross), " Call error", call. = FALSE)
  }
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
    flatten() %>% 
    map("response") %>% 
    map(function(response){
      if(length(response$content))
        return(response$content)
      return(response$results)
    }) %>% 
    map_dfr(dplyr::bind_rows)
}