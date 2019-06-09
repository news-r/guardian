#' @export
print.guardianCalls <- function(x, ...) {
  cat(
    crayon::blue(cli::symbol$info), length(x), "calls", ..., "\n"
  )
}