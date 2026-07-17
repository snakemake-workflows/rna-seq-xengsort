rule xengsort_index:
    input:
        host_cdna="<resources>/{host_species}.cdna.fa.gz",
        host_dna="<resources>/{host_species}.dna.fa.gz",
        graft_cdna="<resources>/{graft_species}.cdna.fa.gz",
        graft_dna="<resources>/{graft_species}.dna.fa.gz",
    output:
        hash="<resources>/xengsort_index/{graft_species}_{host_species}.cdna_dna.hash",
        info="<resources>/xengsort_index/{graft_species}_{host_species}.cdna_dna.info",
    log:
        "<logs>/xengsort_index/{graft_species}_{host_species}.cdna_dna.hash",
    conda:
        "../envs/xengsort.yaml"
    threads: 12
    params:
        prefix=subpath(output.hash, strip_suffix=".hash"),
        nobjects=lookup(within=config, dpath="xengsort/index/nobjects"),
        kmersize=lookup(within=config, dpath="xengsort/index/kmersize"),
        bucketsize=lookup(within=config, dpath="xengsort/index/bucketsize"),
        fill=lookup(within=config, dpath="xengsort/index/fill"),
    shell:
        "xengsort index "
        " --index {params.prefix} "
        " --host {input.host_cdna} {input.host_dna} "
        " --graft {input.graft_cdna} {input.graft_dna} "
        " --weakthreads {threads} "
        " --nobjects {params.nobjects} "
        " --kmersize {params.kmersize} "
        " --bucketsize {params.bucketsize} "
        " --fill {params.fill} "
        ">{log} 2>&1 "


rule xengsort_classify_single:
    input:
        hash="<resources>/xengsort_index/{graft_species}_{host_species}.cdna_dna.hash",
        info="<resources>/xengsort_index/{graft_species}_{host_species}.cdna_dna.info",
        fq1="<results>/trimmed/{sample}/{sample}_{unit}.fastq.gz",
    output:
        ambiguous="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-ambiguous.fq.gz",
        both="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-both.fq.gz",
        graft="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-graft.fq.gz",
        host="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-host.fq.gz",
        neither="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-neither.fq.gz",
        sites="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-sites.fq.gz",
    log:
        "<logs>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}.xengsort_classify_single.log",
    conda:
        "../envs/xengsort.yaml"
    params:
        index_prefix=subpath(input.hash, strip_suffix=".hash"),
        unit_prefix=subpath(output.graft, strip_suffix="-graft.fq.gz"),
    shell:
        "xengsort classify "
        " --index {params.index_prefix} "
        " --fastq {input.fq1} "
        " --prefix {params.unit_prefix} "
        " --mode count "
        ">{log} 2>&1 "


rule xengsort_classify_paired:
    input:
        hash="<resources>/xengsort_index/{graft_species}_{host_species}.cdna_dna.hash",
        info="<resources>/xengsort_index/{graft_species}_{host_species}.cdna_dna.info",
        fq1="<results>/trimmed/{sample}/{sample}_{unit}.1.fastq.gz",
        fq2="<results>/trimmed/{sample}/{sample}_{unit}.2.fastq.gz",
    output:
        ambiguous_1="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-ambiguous.1.fq.gz",
        ambiguous_2="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-ambiguous.2.fq.gz",
        both_1="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-both.1.fq.gz",
        both_2="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-both.2.fq.gz",
        graft_1="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-graft.1.fq.gz",
        graft_2="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-graft.2.fq.gz",
        host_1="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-host.1.fq.gz",
        host_2="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-host.2.fq.gz",
        neither_1="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-neither.1.fq.gz",
        neither_2="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-neither.2.fq.gz",
        sites_1="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-sites.1.fq.gz",
        sites_2="<results>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}-sites.2.fq.gz",
    log:
        "<logs>/xengsort_classify/{sample}/{sample}_{unit}_{graft_species}_{host_species}.xengsort_classify_paired.log",
    conda:
        "../envs/xengsort.yaml"
    threads: 8
    params:
        index_prefix=subpath(input.hash, strip_suffix=".hash"),
        unit_prefix=subpath(output.graft, strip_suffix="-graft.fq.gz"),
    shell:
        "xengsort classify "
        " --index {params.index_prefix} "
        " --fastq {input.fq1} "
        " --pairs {input.fq2} "
        " --prefix {params.unit_prefix} "
        " --mode count "
        " --threads {threads} "
        ">{log} 2>&1 "
