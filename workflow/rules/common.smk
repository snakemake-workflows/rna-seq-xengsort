# import basic packages
import pandas as pd
from snakemake.utils import validate

# read sample sheet
units = pd.read_csv(config["unit_sheet"], sep="\t", dtype=str, comment="#").set_index(
    ["sample", "unit"],
    drop=False,
    verify_integrity=True,
)

# validate sample sheet and config file
validate(units, schema="../schemas/units.schema.yaml")
validate(config, schema="../schemas/config.schema.yaml")

# wildcard constraints


wildcard_constraints:
    sample="|".join(units["sample"]),
    unit="|".join(units["unit"]),
    graft_species=lookup(within=config, dpath="resources/ref/species"),
    graft_build=lookup(within=config, dpath="resources/ref/build"),
    host_species=lookup(within=config, dpath="resources/ref/host_species"),
    host_build=lookup(within=config, dpath="resources/ref/host_build"),


# final results requested in rule all, the default_target


def get_final_results(wildcards):
    final_results = [
        "<results>/units.tsv",
    ]

    final_results.extend(
        expand(
            "<results>/xengsort_classify/all_units_xengsort_classification.{graft_species}_{graft_build}.{host_species}_{host_build}.html",
            graft_species=lookup(within=config, dpath="resources/ref/species"),
            graft_build=lookup(within=config, dpath="resources/ref/build"),
            host_species=lookup(
                within=config, dpath="resources/ref/host_species"
            ),
            host_build=lookup(within=config, dpath="resources/ref/host_build"),

        )
    )

    return final_results


# helper functions


def column_missing_or_empty(column_name, dataframe, sample, unit):
    """Check whether a column is missing or empty."""
    if column_name in dataframe.columns:
        result = pd.isnull(dataframe.loc[(sample, unit), column_name])
        try:
            return bool(result)
        except ValueError:
            raise ValueError(
                f"Expected a single value for sample '{sample}', unit '{unit}' "
                f"in column '{column_name}', but got multiple values."
            )
    else:
        return True


# input functions


def get_xengsort_results(wildcards):

    xengsort_results = []

    for entry in units.itertuples(index=False):
        if column_missing_or_empty(
            column_name="fq2", dataframe=units, sample=entry.sample, unit=entry.unit
        ):
            xengsort_results.extend(
                expand(
                    [
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-ambiguous.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-both.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-graft.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-host.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-neither.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-sites.fq.gz",
                    ],
                    sample=entry.sample,
                    unit=entry.unit,
                    graft_species=lookup(within=config, dpath="resources/ref/species"),
                    graft_build=lookup(within=config, dpath="resources/ref/build"),
                    host_species=lookup(
                        within=config, dpath="resources/ref/host_species"
                    ),
                    host_build=lookup(within=config, dpath="resources/ref/host_build"),
                )
            )
        else:
            xengsort_results.extend(
                expand(
                    [
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-ambiguous.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-both.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-graft.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-host.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-neither.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-sites.{read}.fq.gz",
                    ],
                    sample=entry.sample,
                    unit=entry.unit,
                    graft_species=lookup(within=config, dpath="resources/ref/species"),
                    graft_build=lookup(within=config, dpath="resources/ref/build"),
                    host_species=lookup(
                        within=config, dpath="resources/ref/host_species"
                    ),
                    host_build=lookup(within=config, dpath="resources/ref/host_build"),
                    read=["1", "2"],
                )
            )

    return xengsort_results


def get_xengsort_logs(wildcards):

    xengsort_logs = []

    for entry in units.itertuples(index=False):
        if column_missing_or_empty(
            column_name="fq2", dataframe=units, sample=entry.sample, unit=entry.unit
        ):
            xengsort_logs.extend(
                expand(
                    "<logs>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}.xengsort_classify_single.log",
                    sample=entry.sample,
                    unit=entry.unit,
                    graft_species=lookup(within=config, dpath="resources/ref/species"),
                    graft_build=lookup(within=config, dpath="resources/ref/build"),
                    host_species=lookup(
                        within=config, dpath="resources/ref/host_species"
                    ),
                    host_build=lookup(within=config, dpath="resources/ref/host_build"),
                )
            )
        else:
            xengsort_logs.extend(
                expand(
                    "<logs>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}.xengsort_classify_paired.log",
                    sample=entry.sample,
                    unit=entry.unit,
                    graft_species=lookup(within=config, dpath="resources/ref/species"),
                    graft_build=lookup(within=config, dpath="resources/ref/build"),
                    host_species=lookup(
                        within=config, dpath="resources/ref/host_species"
                    ),
                    host_build=lookup(within=config, dpath="resources/ref/host_build"),
                )
            )

    return xengsort_logs

