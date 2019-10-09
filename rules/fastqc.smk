import os

rule fastqc:
    input:
        file = os.path.join(
            "data/datasets",
            "{step}",
            QC_VERSION,
            "{sample_ID}",
            "{sample_ID}_{read}.fastq"
        )
    output:
        html = os.path.join(
            config["path"]["qc"],
            QC_VERSION,
            "{sample_ID}",
            "{step}",
            "{read}_fastqc.html"
        ),
        zip = os.path.join(
            config["path"]["qc"],
            QC_VERSION,
            "{sample_ID}",
            "{step}",
            "{read}_fastqc.zip"
        )
    params:
        outdir = os.path.basename('{output.html}')
    conda:
        '../envs/fastqc.yaml'
    threads:
    log:
    shell:
        'fastqc --quiet'
        ' --outdir {params.outdir}'
        ' {input.file}'
        ' {log}'
