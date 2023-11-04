# Test script to generate a publications list from google scholar for the lab
BibOptions(check.entries = FALSE, bib.style = "authoryear")
# Load libraries
require(xfun)
xfun::pkg_attach2(c("tidyverse", "scholar", "vitae", "tinytex", "RefManageR", "tm", "quarto"), message = FALSE)
source("functions.r")

quarto::quarto_add_extension("mps9506/quarto-cv", no_prompt = TRUE)

# set id information 

tribble(
        ~person, ~scholar_id, ~year_in, ~year_out, pubs,
        "Chris Chizinski",   'kAdpcMUAAAAJ', 2012, NA, NA
        "Matt Gruntorad",   'IpqOh28AAAAJ', 2015, NA, NA) -> lab_scholar_ids

lab_scholar_ids |> 
  mutate(year_out = ifelse(is.na(year_out), get_current_year(), year_out))  ->  lab_scholar_ids2

lab_scholar_ids2 |> 
        group_by(scholar_id) |>
        mutate(pubs = map(.x = scholar_id,
                        ~as.data.frame(RefManageR::ReadGS(scholar.id =.x, limit = Inf, sort.by.date = TRUE, check.entries = FALSE))))  |> 
        unnest(pubs) |> 
        ungroup() |> 
        distinct(title, .keep_all = TRUE) |>
        filter(year >= year_in & year <= year_out)  |> 
        select(-person, -scholar_id, -cites, -institution, -type)  |>
        mutate(bibtexkey = create_bitex_key(author, title, year)) |> 
        mutate(across(c(volume, number, pages), ~str_replace(.x, "NA", "")))  |>
        arrange(desc(year), author)  |> 
        as.data.frame() ->  pubs_with_id


as.BibEntry(pubs_with_id) -> pubs_bibentry

dir.create('bib', showWarnings = FALSE)

RefManageR::WriteBib(pubs_bibentry, file = here::here('bib', 'lab_pubs.bib'),
                      verbose = FALSE, bibstyle = "year", keep_all = TRUE)

quarto::quarto_render("ref-template.qmd")

rmarkdown::pandoc_convert("ref-template.tex", to = "gfm", citeproc = TRUE, output = "md/lab_pubs.md")
