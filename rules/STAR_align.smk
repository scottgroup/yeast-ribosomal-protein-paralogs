import os

rule STAR_align:
    input:
        index = config['path']['STAR_ref'],
        f1 = os.path.join(config['path']['raw'], '{ID}_R1_paired.fq.gz'),
        f2 = os.path.join(config['path']['raw'], '{ID}_R2_paired.fq.gz')
    output:
        bam = os.path.join(
            config['path']['STAR_align'],
            '{ID}_Aligned.sortedByCoord.out.bam'
        )
    threads:
        16
    conda:
        '../envs/STAR.yaml'
    log:
        'logs/STAR_align.{ID}.log'
    params:
        outFileNamePrefix = os.path.join(config['path']['STAR_align'], '{ID}_')
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
