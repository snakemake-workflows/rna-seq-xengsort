rule fastp_se:
    input:
        sample=lookup(
            within=units, query="sample == '{sample}' & unit == '{unit}'", cols="fq1"
        ),
    output:
        trimmed="<results>/trimmed/{sample}/{sample}_{unit}.fastq.gz",
        failed="<results>/trimmed/{sample}/{sample}_{unit}.failed.fastq.gz",
        html=report(
            "<results>/trimmed/{sample}/{sample}_{unit}.html",
            caption="../report/fastp.rst",
            category="quality control",
            subcategory="fastp",
            labels={
                "sample-unit": "{sample}_{unit}",
            },
        ),
        json="<results>/trimmed/{sample}/{sample}_{unit}.json",
    log:
        "<logs>/trimmed/{sample}/{sample}_{unit}.log",
    threads: 4
    params:
        adapters=lookup(
            within=units,
            query="sample == '{sample}' & unit == '{unit}'",
            cols="fastp_adapters",
            default="",
        ),
        extra=lookup(
            within=units,
            query="sample == '{sample}' & unit == '{unit}'",
            cols="fastp_extra",
            default="--trim_poly_x --poly_x_min_len 7 --trim_poly_g --poly_g_min_len 7 --length_required 33",
        ),
    wrapper:
        "v7.1.0/bio/fastp"


rule fastp_pe:
    input:
        sample=lookup(
            within=units,
            query="sample == '{sample}' & unit == '{unit}'",
            cols=["fq1", "fq2"],
        ),
    output:
        trimmed=[
            "<results>/trimmed/{sample}/{sample}_{unit}.1.fastq.gz",
            "<results>/trimmed/{sample}/{sample}_{unit}.2.fastq.gz",
        ],
        # Unpaired reads separately
        unpaired1="<results>/trimmed/{sample}/{sample}_{unit}.unpaired.1.fastq.gz",
        unpaired2="<results>/trimmed/{sample}/{sample}_{unit}.unpaired.u2.fastq.gz",
        failed="<results>/trimmed/{sample}/{sample}_{unit}.failed.fastq.gz",
        html=report(
            "<results>/trimmed/{sample}/{sample}_{unit}.html",
            caption="../report/fastp.rst",
            category="quality control",
            subcategory="fastp",
            labels={
                "sample-unit": "{sample}_{unit}",
            },
        ),
        json="<results>/trimmed/{sample}/{sample}_{unit}.json",
    log:
        "<logs>/trimmed/{sample}/{sample}_{unit}.log",
    threads: 8
    params:
        adapters=lookup(
            within=units,
            query="sample == '{sample}' & unit == '{unit}'",
            cols="fastp_adapters",
            default="--detect_adapter_for_pe",
        ),
        extra=lookup(
            within=units,
            query="sample == '{sample}' & unit == '{unit}'",
            cols="fastp_extra",
            default="--trim_poly_x --poly_x_min_len 7 --trim_poly_g --poly_g_min_len 7 --length_required 33",
        ),
    wrapper:
        "v7.1.0/bio/fastp"
