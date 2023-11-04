## Functions

get_current_year <- function(){
  Sys.Date() |> 
        lubridate::ymd() |> 
        year()
}

authors = "D S Kane and K L Pope and K D Koupal and M A Pegg and C J Chizinski and M A Kaemingk"
title = "The influence of the COVI"

create_bitex_key <- function(authors, title, year){
  # requires stringr and tm packages

  first_author_name <- str_extract(authors, pattern = "\\S+\\s+(\\S+)\\s+\\S+")
  first_author_name <- str_remove(first_author_name, pattern = "^(\\S+\\s+){2}")

  title_words <- str_remove_all(tolower(title), pattern = paste0('\\b', tm::stopwords('english'), collapse = ' |'))
  first_title_word <- str_extract(title_words, pattern = "\\b\\w+")

  key <- tolower(str_squish(paste0(first_author_name, year, first_title_word)))
  return(key)

}


separate_number_scholar <- function(number){
  volume <- str_squish(str_extract(number, pattern =  "([[:digit:]]+)\\s"))


  issue <- str_extract(number, pattern = "\\((\\d+)\\),")
  issue <- str_remove_all(issue, pattern = "\\(|\\)|\\,")

pgs <- str_extract(number, pattern = "\\b(\\d+)-(\\d+)\\b")

paste(volume, issue, pgs, sep = "|")
}

