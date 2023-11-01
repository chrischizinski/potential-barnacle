# Test script to generate a publications list from google scholar for the lab

# Load libraries
library(tidyverse)
library(scholar)
library(vitae)

# set id information

tribble(
        ~person, ~scholar_id, ~publications,
        "Chris Chizinski",   'kAdpcMUAAAAJ&hl', NA,
        "Matt Gruntorad",   'IpqOh28AAAAJ&hl', NA,
        "Katherine Graham",   'IpqOh28AAAAJ&hl', NA,) -> lab_scholar_ids


lab_scholar_ids

runif

get_publications(id_matt)

plot(iris)


