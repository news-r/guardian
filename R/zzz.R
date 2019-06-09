.onAttach <- function(...) {
  key <- Sys.getenv("GUARDIAN_API_KEY")

  msg <- "No API key found, see `guardian_key`"
  if(nchar(key) > 1) msg <- "API key loaded!"

  packageStartupMessage(msg)
}