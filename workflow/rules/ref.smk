rule get_transcriptome:
    output:
        "resources/{species}.cdna.fa.gz",
    log:
        "<logs>/get_transcriptome/{species}.cdna.log",
    cache: "omit-software"  # save space and time with between workflow caching (see docs)
    localrule: True
    params:
        species="{species}",
        datatype="cdna",
        build=lookup(within=config, dpath="resources/ref/build"),
        release=lookup(within=config, dpath="resources/ref/release"),
    wrapper:
        "v9.12.0/bio/reference/ensembl-sequence"


rule get_genome:
    output:
        "resources/{species}.dna.fa.gz",
    log:
        "<logs>/get_genome/{species}.dna.log",
    cache: "omit-software"  # save space and time with between workflow caching (see docs)
    localrule: True
    params:
        species="{species}",
        datatype="dna",
        build=lookup(within=config, dpath="resources/ref/build"),
        release=lookup(within=config, dpath="resources/ref/release"),
    wrapper:
        "v9.12.0/bio/reference/ensembl-sequence"
