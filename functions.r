## Functions

get_current_year <- function(){
  Sys.Date() |> 
        lubridate::ymd() |> 
        year()
}

create_bitex_key <- function(author, title, year){
  # requires stringr and tm packages
  tm::stopwords("english")
  author_name <- str_extract(author, pattern = "\\s([[:alpha:]]+),")
  author_name <- str_remove(author_name, pattern = "[[:punct:]]")

  title_word <- str_remove_all(title, pattern = paste0('\\b', tm::stopwords('english'), collapse = ' |'))
  title_word <- str_extract(title_word, pattern = "\\b\\w+")

  key <- tolower(str_squish(paste0(author_name, year, title_word)))
  return(key)

}



