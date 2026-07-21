# Snakemake workflow: `rna-seq-xengsort`

[![Snakemake](https://img.shields.io/badge/snakemake-≥8.0.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/snakemake-workflows/rna-seq-xengsort/workflows/Tests/badge.svg?branch=main)](https://github.com/snakemake-workflows/rna-seq-xengsort/actions?query=branch%3Amain+workflow%3ATests)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![workflow catalog](https://img.shields.io/badge/Snakemake%20workflow%20catalog-darkgreen)](https://snakemake.github.io/snakemake-workflow-catalog/docs/workflows/snakemake-workflows/rna-seq-xengsort)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.21419632.svg)](https://doi.org/10.5281/zenodo.21419632)

A Snakemake workflow for separating host and graft sequencing reads from RNAseq data using [`xengsort`](https://gitlab.com/genomeinformatics/xengsort):

- [Usage](#usage)
- [Deployment options](#deployment-options)
- [Workflow profiles](#workflow-profiles)
- [Authors](#authors)
- [References](#references)

`xengsort` was chosen, as it clearly outperformed all other tools in [a recent independent benchmarking study](https://doi.org/10.1038/s41698-025-00902-z) that also thoroughly evaluated the effects of mouse host genome contamination.
For full citations, see the [references below](#references)

## Usage

The usage of this workflow is described in the [Snakemake Workflow Catalog](https://snakemake.github.io/snakemake-workflow-catalog/docs/workflows/snakemake-workflows/rna-seq-xengsort).
This includes a visualization of the workflow diagram and a table with all workflow parameters.

Detailed information about input data and workflow configuration can also be found in the [`config/README.md`](config/README.md).

If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this repository or its DOI.

## Deployment options

To run the workflow from command line, change the working directory.

```bash
cd path/to/snakemake-workflow-name
```

Adjust options in the default config file `config/config.yaml`.
Before running the complete workflow, you can perform a dry run using:

```bash
snakemake --dry-run
```

To run the workflow with test files using **conda**:

```bash
snakemake --cores 2 --sdm conda --directory .test
```

## Workflow profiles

The `profiles/` directory can contain any number of [workflow-specific profiles](https://snakemake.readthedocs.io/en/stable/executing/cli.html#profiles) that users can choose from.
The [profiles `README.md`](profiles/README.md) provides more details.

## Authors

- David Lähnemann
  - German Cancer Consortium (DKTK), partner site Essen-Düsseldorf, A partnership between DKFZ and University Hospital Essen
  - https://orcid.org/0000-0002-9138-4112
- Pankaj Singroul
  - German Cancer Consortium (DKTK), partner site Essen-Düsseldorf, A partnership between DKFZ and University Hospital Essen
  - Bridge Institute of Experimental Tumor Therapy (BIT), Division of Solid Tumor Translational Oncology (DKTK), West German Cancer Center, University Hospital Essen, University of Duisburg-Essen, Essen, Germany
  - Institute of Cell Biology (Cancer Research), University Hospital Essen, University of Duisburg-Essen, Essen, Germany
  - https://orcid.org/0000-0001-9855-1828

## References

> Zentgraf, J., Rahmann, S. Fast lightweight accurate xenograft sorting. Algorithms Mol Biol 16, 2 (2021). https://doi.org/10.1186/s13015-021-00181-w

> Bhandari, M., He, F., Rogojina, A. et al. Benchmarking mouse contamination removing protocols in patient-derived xenografts genomic profiling. npj Precis. Onc. 9, 113 (2025). https://doi.org/10.1038/s41698-025-00902-z

> Chen, Shifu. 2025. “ fastp 1.0: An Ultra-Fast All-Round Tool for FASTQ Data Quality Control and Preprocessing.” iMeta 4, e70078. https://doi.org/10.1002/imt2.70078

> Köster, J., Mölder, F., Jablonski, K. P., Letcher, B., Hall, M. B., Tomkins-Tinch, C. H., Sochat, V., Forster, J., Lee, S., Twardziok, S. O., Kanitz, A., Wilm, A., Holtgrewe, M., Rahmann, S., & Nahnsen, S. _Sustainable data analysis with Snakemake_. F1000Research, 10:33, 10, 33, **2021**. https://doi.org/10.12688/f1000research.29032.2.
