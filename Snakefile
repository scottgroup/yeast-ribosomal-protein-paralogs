

configfile: "config.json"


__author__ = "Gaspard Reulet"
__email__ = "gaspard.reulet@usherbrooke.ca"

rule all:
    input:
        fastq = expand(
            os.path.join(
                config["path"]["fastq"],
                "{bcl_ID}"
            ),
            bcl_ID = config["download"]["datasets"]
        )


rule bcl_to_fastq:
    output:
        fastq = os.path.join(config["path"]["fastq"],"{bcl_ID}")
    params:
    conda:
    log:
    threads:
    shell:
