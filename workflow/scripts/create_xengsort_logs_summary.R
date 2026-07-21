log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(tidyverse)

rlang::global_entrace()

xengsort_logs <- unlist(snakemake@input[["xengsort_logs"]]) |>
  map(
    \(x)
      read_file(x) |>
      str_extract("prefix\thost\tgraft\tambiguous\tboth\tneither\n.*\n") |>
      I() |>
      read_tsv(col_types="ciiiii")
  ) |>
  bind_rows() |>
  separate_wider_regex(
    prefix,
    c("^.+/xengsort_classify/", sample = ".+", "/", unit = ".*$")
  ) |>
  mutate(
    unit = str_remove(unit, str_c(sample, "_")),
    unit = str_remove(
      unit,
      fixed(str_c(
        ".", snakemake@wildcards[["graft_species"]], "_", snakemake@wildcards[["graft_build"]],
        ".", snakemake@wildcards[["host_species"]], "_", snakemake@wildcards[["host_build"]]
      ))
    )
  ) |>
  pivot_longer(
    !c(sample, unit),
    names_to = "species",
    values_to = "number_of_reads"
  ) |>
  mutate(
    species = replace_values(
      species,
      "host" ~ snakemake@wildcards[["host_species"]],
      "graft" ~ snakemake@wildcards[["graft_species"]]
    )
  ) |>
  mutate(sample_unit = str_c(sample, "_", unit))

write_tsv(xengsort_logs, snakemake@output[["xengsort_logs_summary"]], na = "")
