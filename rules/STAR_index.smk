rule STAR_generateGenome:
    input:
        genome = rules.merge_chromosomes.output.genome,
        gtf = os.path.join(config['path']['gtf'], '{annotation}.gtf')
    output:
        directory(os.path.join(config['path']['STAR_ref'], '{annotation}.gtf'))
    threads:
        16
    conda:
        '../envs/STAR.yaml'
    log:
        'logs/STAR_generateGenome.{annotation}.log'
    shell:
        'mkdir {output}'
        ' && STAR'
        ' --runMode genomeGenerate'
        ' --runThreadN {threads}'
        ' --genomeDir {output}'
        ' --genomeFastaFiles {input.genome}'
        ' --sjdbGTFfile {input.gtf}'
        ' --sjdbOverhang 75'
