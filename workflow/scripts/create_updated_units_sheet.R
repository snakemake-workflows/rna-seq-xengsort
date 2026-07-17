log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(tidyverse)

rlang::global_entrace()

unit_sheet <- read_tsv(snakemake@input[["unit_sheet"]]) |>
  select(-c("fq1", "fq2"))

xengsort_results <- enframe(
    unlist(snakemake@input[["xengsort_results"]]),
    name = NULL,
    value = "fq_path"
  ) |>
  filter(
    str_detect(
      fq_path,
      fixed("-graft.")
    )
  ) |>
  separate_wider_regex(
    fq_path,
    c(
      "^.+/xengsort_classify/",
      sample = "[^/]+",
      rest = "/.+$"
    ),
    cols_remove = FALSE
  ) |>
  mutate(
    rest = str_remove(rest, c("/", sample, "_"))
  ) |>
  separate_wider_regex(
    rest,
    c(
      unit = ".+",
      "\\.",
      snakemake@params[["graft_species"]],
      "_",
      snakemake@params[["graft_build"]],
      "\\.",
      snakemake@params[["host_species"]],
      "_",
      snakemake@params[["host_build"]],
      "-graft\\.",
      fq = "(?:[12]\\.)?",
      "\\.fq\\.gz$"
    )
  ) |>
  mutate(
    fq = case_when(
      fq == "1" ~ "fq1",
      fq == "2" ~ "fq2",
      .default = "fq1"
    )    
  ) |>
  pivot_wider(
    names_from = fq,
    values_from = fq_path
  )

new_unit_sheet <- unit_sheet |> left_join(xengsort_results, by = join_by(sample, unit))

write_tsv(new_unit_sheet, snakemake@output[["unit_sheet"]])
