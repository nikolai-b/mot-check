check_mot <- function(registration) {
  req <- httr::GET(
    "https://beta.check-mot.service.gov.uk/", 
    path= "trade/vehicles/mot-tests", 
    query = list(registration = registration),
    httr::add_headers("x-api-key" = Sys.getenv("MOT_API_KEY"), Accept = "application/json+v6")
  )
  httr::stop_for_status(req)
  status <- httr::http_status(req)
  if (status$reason != "OK" ) {
    stop(paste("Error: MOT check had error response:", status$message))
  }
  
  content <- httr::content(req, as = "text", encoding = "UTF-8")
  if (content == "") {
    stop("Error: MOT check did not return a valid result.")
  }
  jsonlite::fromJSON(content)
}
