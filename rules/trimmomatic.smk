import os

rule trimmomatic:
    input:
        r1 = os.path.join(
            config['path']['fastq'],
            '{sample_ID}_R1_001.fastq.gz'
        ),
        r2 = os.path.join(
            config['path']['fastq'],
            '{sample_ID}_R2_001.fastq.gz'
        )
    output:
        r1_paired = os.path.join(
            config['path']['trimmed'],
            '{sample_ID}_R1_paired.fq.gz'
        ),
        r1_unpaired = os.path.join(
            config['path']['trimmed'],
            '{sample_ID}_R1_unpaired.fq.gz'
        ),
        r2_paired = os.path.join(
            config['path']['trimmed'],
            '{sample_ID}_R2_paired.fq.gz'
        ),
        r2_unpaired = os.path.join(
            config['path']['trimmed'],
            '{sample_ID}_R2_unpaired.fq.gz'
        )
    params:
        adapters = config['path']['adapters'],
        r1 = os.path.join(
            config['path']['fastq'],
            '{sample_ID}_R1_001.fastq.gz'
        ),
        r2 = os.path.join(
            config['path']['fastq'],
            '{sample_ID}_R2_001.fastq.gz'
        )
    threads:
        8
    conda:
        '../envs/trimmomatic.yaml'
    shell:
        'trimmomatic PE -threads {threads}'
        ' -phred33'
        ' {params.r1} {params.r2}'
        ' {output.r1_paired} {output.r1_unpaired}'
        ' {output.r2_paired} {output.r2_unpaired}'
        ' ILLUMINACLIP:{params.adapters}:2:12:10:8:true'
        ' TRAILING:30'
