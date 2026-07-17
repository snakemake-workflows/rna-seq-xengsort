## Workflow overview

This workflow is a best-practice workflow for removing host genome reads from RNAseq data from xenograft samples using [xengsort](https://gitlab.com/genomeinformatics/xengsort).
The workflow is built using [snakemake](https://snakemake.readthedocs.io/en/stable/) and consists of the following steps:

1. Adapter trimming with fastp.
2. Download of the host and graft reference genomes and transcriptomes.
3. Create a `xengsort index` hash from the reference.
4. Use `xengsort classify` to sort reads into host and graft categories.

The workflow is designed, so that its output can easily be used in the [`rna-seq-kallisto-sleuth` workflow](https://snakemake.github.io/snakemake-workflow-catalog/docs/workflows/snakemake-workflows/rna-seq-kallisto-sleuth.html).
You will most likely want to provide the output that `xengsort classify` determined as coming from the `graft` genome as the `fq1` and (optionall) `fq2` files in [that workflow's units sheet](https://snakemake.github.io/snakemake-workflow-catalog/docs/workflows/snakemake-workflows/rna-seq-kallisto-sleuth.html#units-sheet).
They will usually be either of the following two options:

1. For single-end reads: `<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-graft.fq.gz"`
2. For paired-end reads: `<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-graft.1.fq.gz"` and `<results>/xengsort_classify/{sample}/{sample}_{unit}.{graft_species}_{graft_build}.{host_species}_{host_build}-graft.2.fq.gz"`


## Running the workflow

### units sheet

This workflow requires a [units sheet similar to the `rna-seq-kallisto-sleuth` workflow](https://snakemake.github.io/snakemake-workflow-catalog/docs/workflows/snakemake-workflows/rna-seq-kallisto-sleuth.html#units-sheet), but with fewer columns.
The units sheet has the following layout:

| sample  | unit | fq1                       | fq2                           | fastp_adapters | fastp_extra | 
| ------- | -----| ------------------------- | ----------------------------- | -------------- | ----------- |
| sample1 | u1   | sample1.u1.read1.fastq.gz | sample1.u1.bwa.read2.fastq.gz |                |             |
| sample2 | u1   | sample2.u1.read1.fastq.gz |                               |                |             |

The columns `sample` (sample name), `unit` (there may be multiple sequenced units per sample), and `fq1` are required.
`fq1` specifies the path to a `fastq` file for the sample-unit combination.
`fq2` only specifies a second `fastq` file for the same sample-unit combination if that sample was sequenced with paired-end reads.

The `fastp_adapters` and `fastp_extra` columns should only be used to customize `fastp` parameters, if the [default `fastp` parameters as described in the `rna-seq-kallisto-sleuth` workflow](https://snakemake.github.io/snakemake-workflow-catalog/docs/workflows/snakemake-workflows/rna-seq-kallisto-sleuth.html#adapter-trimming-and-read-filtering) do not detect the correct sequencing adapters or if the trimming somehow doesn't work well.
To determine this, [check the `fastp` quality control report as described in the `rna-seq-kallisto-sleuth` workflow](https://snakemake.github.io/snakemake-workflow-catalog/docs/workflows/snakemake-workflows/rna-seq-kallisto-sleuth.html#adapter-trimming-and-read-filtering).

### config.yaml

This file contains the general workflow configuration.
Configurable options should be explained in the comments above the respective entry, so the easiest way to set it up for your workflow is to carefully read through the `config/config.yaml` file and adjust it to your needs.
If something is unclear, don’t hesitate to [file an issue in the `rna-seq-xengsort` GitHub repository](https://github.com/snakemake-workflows/rna-seq-xengsort/issues/new/choose).