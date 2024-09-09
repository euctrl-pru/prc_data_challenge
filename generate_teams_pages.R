library(jsonlite)
library(tidyverse)
library(here)

# `t` is the list (one team) as read from json
generate_team_page <- function(t) {
  page <- "
  ## {name}

  ### Description
  {description}

  ### Rationale for participation
  {rationale}

  "

  # t_name <- t["team_name"] |> str_remove("^team_")
  t_name <- t["team_name"]
  t_description <- t["description"]
  t_rationale <- t["rationale"]

  str_glue(page,
           name = t_name,
           description = t_description,
           rationale = t_rationale) |>
    write_lines(here("teams", paste0(t["team_name"],".qmd")))
}

tt <- read_json("media/teams_private.json")
tt |>
  walk(.f = generate_team_page)
