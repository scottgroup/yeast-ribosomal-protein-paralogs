import os

rule STAR_generateGenome:
    input:
        genome = rules.merge_chromosomes.output.genome,
        gtf = config['path']['gtf']
    output:
        directory(os.path.join(config['path']['STAR_ref']))
    threads:
        16
    conda:
        '../envs/STAR.yaml'
    log:
        'logs/STAR_generateGenome.log'
    shell:
        'mkdir {output}'
        ' && STAR'
        ' --runMode genomeGenerate'
        ' --runThreadN {threads}'
        ' --genomeDir {output}'
        ' --genomeFastaFiles {input.genome}'
        ' --sjdbGTFfile {input.gtf}'
        ' --sjdbOverhang 75'
