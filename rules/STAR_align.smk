import os

rule STAR_align:
    input:
        index = os.path.join(config['path']['STAR_ref'], '{annotation}.gtf'),
        f1 = rules.trimmomatic.output.r1_paired,
        f2 = rules.trimmomatic.output.r2_paired
    output:
        bam = os.path.join(
            config['path']['STAR_align'],
            '{annotation}',
            '{sample_ID}_Aligned.sortedByCoord.out.bam'
        )
    threads:
        16
    conda:
        '../envs/STAR.yaml'
    log:
        'logs/STAR_align.{annotation}.{sample_ID}.log'
    params:
        outFileNamePrefix = os.path.join(
            config['path']['STAR_align'],
            '{annotation}',
            '{sample_ID}_'
        )
    shell:
        'STAR'
        ' --runMode alignReads'
        ' --genomeDir {input.index}'
        ' --readFilesIn {input.f1} {input.f2}'
        ' --outFileNamePrefix {params.outFileNamePrefix}'
        ' --runThreadN {threads}'
        ' --readFilesCommand zcat'
        ' --outReadsUnmapped Fastx'
        ' --outStd Log'
        ' --outSAMtype BAM SortedByCoordinate'
        ' --outSAMunmapped None'
        ' &> {log}'
