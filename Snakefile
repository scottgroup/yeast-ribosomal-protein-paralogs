

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


rule bcl2fastq:
    input:
        bcl = os.path.join(config["path"]["bcl"],"{bcl_ID}")
    output:
        fastq = os.path.join(config["path"]["fastq"],"{bcl_ID}")
    params:
        extra = "--no-lane-splitting"
    conda:
        "envs/bcl2fastq.yaml"
    log:
        "logs/bcl2fastq/{bcl_ID}.log"
    threads:
        24
    shell:
        "bcl2fastq -R {input.bcl} -o {output.fastq} {params.extra}"
