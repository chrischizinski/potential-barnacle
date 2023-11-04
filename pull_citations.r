# Test script to generate a publications list from google scholar for the lab

# Load libraries
require(xfun)
xfun::pkg_attach2(c("tidyverse", "scholar", "vitae", "tinytex", "bib2df", "tm", "quarto"), message = FALSE)
source("functions.r")

quarto::quarto_add_extension("mps9506/quarto-cv", no_prompt = TRUE)

# set id information 

tribble(
        ~person, ~scholar_id, ~year_in, ~year_out, ~pubs,
        "Chris Chizinski",   'kAdpcMUAAAAJ&hl', 2011, NA, NA,
        "Matt Gruntorad",   'IpqOh28AAAAJ&hl', 2015, NA, NA) -> lab_scholar_ids

BibOptions(check.entries = FALSE, bib.style = "authoryear")

test <- ReadGS(scholar.id = "kAdpcMUAAAAJ", limit = Inf, sort.by.date = TRUE)
as_tibble(test)
lab_scholar_ids |> 
  mutate(year_out = ifelse(is.na(year_out), get_current_year(), year_out))  ->  lab_scholar_ids2

lab_scholar_ids2 |> 
        group_by(scholar_id) |>
        nest(data = pubs) |> 
        rename(pubs = data) |> 
        mutate(pubs = map(.x = scholar_id,
                        ~scholar::get_publications(.x))) |> 
        unnest(pubs) |> 
        ungroup() |> 
        distinct(pubid, .keep_all = TRUE) |>
        filter(year >= year_in & year <= year_out)  |> 
        select(author, title, journal, number, year)  |>
        mutate(bibtexkey = create_bitex_key(author, title, year),
        bibtype = "article",
        number = separate_number_scholar(number))  |> 
        separate(number, into = c("volume", "issue", "pages"), sep = "\\|")  |>
        mutate(across(c(volume, issue, pages), ~str_replace(.x, "NA", "")))  |>
        mutate(author = str_split(author, pattern = ", ")) |>
        rename_all(toupper)  |> 
        arrange(desc(YEAR), AUTHOR)->  pubs_with_id

dir.create('bib', showWarnings = FALSE)

bib2df::df2bib(pubs_with_id, file = here::here('bib', 'lab_pubs.bib'))

quarto::quarto_render("ref-template.qmd")
