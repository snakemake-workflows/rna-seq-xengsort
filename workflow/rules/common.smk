# import basic packages
import pandas as pd
from snakemake.utils import validate

# read sample sheet
units = pd.read_csv(config["unit_sheet"], sep="\t", dtype=str)


# validate sample sheet and config file
validate(units, schema="../schemas/units.schema.yaml")
validate(config, schema="../schemas/config.schema.yaml")

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


def is_single_end(sample, unit):
    """Determine whether unit is single-end."""
    return column_missing_or_empty(
        "fq2", units, sample, unit
    ) and column_missing_or_empty("bam_paired", units, sample, unit)


# final results requested in rule all, the default_target


def get_final_results(wildcards):
    final_results = []

    for entry in units.rows:
        if is_single_end(sample=entry.sample, unit=entry.unit):
            final_results.extend(
                expand(
                    [
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}-ambiguous.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}-both.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}-graft.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}-host.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}-neither.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}-sites.fq.gz",
                    ],
                    sample=entry.sample,
                    unit=unit.sample,
                )
            )
        else:
            final_results.extend(
                expand(
                    [
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}-ambiguous.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}-both.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}-graft.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}-host.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}-neither.{read}.fq.gz",
                        "<results>/xengsort_classify/{sample}/{sample}_{unit}-sites.{read}.fq.gz",
                    ],
                    sample=entry.sample,
                    unit=unit.sample,
                    read=["1", "2"],
                )
            )

    return final_results
