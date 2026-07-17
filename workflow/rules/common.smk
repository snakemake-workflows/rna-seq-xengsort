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


# final results requested in rule all, the default_target

def get_final_results(wildcards):
    final_results = []

    for entry in units.itertuples(index=False):
        if column_missing_or_empty(column_name="fq2", dataframe=units, sample=entry.sample, unit=entry.unit):
            final_results.extend(
                expand(
                    [
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-ambiguous.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-both.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-graft.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-host.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-neither.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-sites.fq.gz",
                    ],
                    sample=entry.sample,
                    unit=entry.unit,
                    graft_species=lookup(within=config, dpath="resources/ref/species"),
                    host_species=lookup(within=config, dpath="resources/ref/host_species"),
                )
            )
        else:
            final_results.extend(
                expand(
                    [
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-ambiguous.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-both.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-graft.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-host.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-neither.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-sites.{read}.fq.gz",
                    ],
                    sample=entry.sample,
                    unit=entry.unit,
                    graft_species=lookup(within=config, dpath="resources/ref/species"),
                    host_species=lookup(within=config, dpath="resources/ref/host_species"),
                    read=["1", "2"],
                )
            )

    return final_results
