import sys

sys.stderr = open(snakemake.log[0], "w", buffering=1)

import pandas as pd
import altair as alt

xengsort_logs_summary = pd.read_csv(
    snakemake.input["xengsort_logs_summary"],
    sep="\t",
)

stacked_horizontal_bars = alt.Chart(xengsort_logs_summary).mark_bar().encode(
    x='sum(number_of_reads):Q',
    y='sample_unit:N',
    color='species:N',
    tooltip=[
        "sample_unit:N",
        "species:N",
        "number_of_reads:Q",
    ],
)

stacked_horizontal_bars.save(snakemake.output["html"])