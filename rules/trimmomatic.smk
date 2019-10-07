import os

rule trimmomatic:
    input:
        input_r1 = '{ID}.R1.fastq.gz',
        input_r2 = '{ID}.R2.fastq.gz'
    output:
        output_r1_paired = '{ID}_R1_paired.fq.gz',
        output_r1_unpaired = '{ID}_R1_unpaired.fq.gz',
        output_r2_paired = '{ID}_R2_paired.fq.gz',
        output_r2_unpaired = '{ID}_R2_unpaired.fq.gz'
    threads:
    conda:
        '../envs/trimmomatic.yaml'
    log:
    shell:
        'trimmomatic PE -threads {threads}'
        ' -phred33'
        ' {input_r1} {input_r2}'
        ' {output_r1_paired} {output_r1_unpaired}'
        ' {output_r2_paired} {output_r2_unpaired}'
        ' ILLUMINACLIP:Adapters-PE_NextSeq.fa:2:12:10:8:true'
        ' TRAILING:30'
