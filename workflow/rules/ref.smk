rule get_transcriptome:
    output:
        "<resources>/{species}_{build}.cdna.fa.gz",
    log:
        "<logs>/get_transcriptome/{species}_{build}.cdna.log",
    cache: "omit-software"  # save space and time with between workflow caching (see docs)
    localrule: True
    params:
        species="{species}",
        datatype="cdna",
        build="{build}",
        release=lookup(within=config, dpath="resources/ref/release"),
    wrapper:
        "v9.12.0/bio/reference/ensembl-sequence"


rule get_genome:
    output:
        "<resources>/{species}_{build}.dna.fa.gz",
    log:
        "<logs>/get_genome/{species}_{build}.dna.log",
    cache: "omit-software"  # save space and time with between workflow caching (see docs)
    localrule: True
    params:
        species="{species}",
        datatype="dna",
        build="{build}",
        release=lookup(within=config, dpath="resources/ref/release"),
    wrapper:
        "v9.12.0/bio/reference/ensembl-sequence"
