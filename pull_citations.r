# Test script to generate a publications list from google scholar for the lab

# Load libraries
require(xfun)
xfun::pkg_attach2(c("tidyverse", "scholar", "vitae", "tinytex"), message = FALSE)


# set id information 

tribble(
        ~person, ~scholar_id, ~year_in, ~year_out, ~pubs,
        "Chris Chizinski",   'kAdpcMUAAAAJ&hl', 2011, NA, NA,
        "Matt Gruntorad",   'IpqOh28AAAAJ&hl', 2015, NA, NA) -> lab_scholar_ids

get_current_year <- function(){
  Sys.Date() |> 
        lubridate::ymd() |> 
        year()

}

lab_scholar_ids |> 
  mutate(year_out = ifelse(is.na(year_out), get_current_year(), year_out)) - lab_scholar_ids2

lab_scholar_ids |> 
        group_by(scholar_id) |>
        nest(data = pubs) |> 
        rename(pubs = data) |> 
        mutate(pubs = map(.x = scholar_id,
                        ~scholar::get_publications(.x))) |> 

 



        split(lab_scholar_ids$person) |> 
        map(scholar_id, get_publications)


        map(get_publications(scholar_id))



        group_by(person, scholar_id) |>
        nest() |> 
        mutate(publications = map(data, get_publications(scholar_id, ~get_publications(.x))))

runif

get_publications(lab_scholar_ids$scholar_id[1])

plot(iris)


