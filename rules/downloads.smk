import os

rule download_chr:
    output:
        chromosomes = os.path.join(config['path']['chromosomes'], '{chr}.fa')
    params:
        link = ''.join([config['download']['chromosomes'], '{chr}.fa.gz'])
    shell:
        'wget -O {output.chromosomes}.gz {params.link}'
        ' && gunzip {output.chromosomes}.gz'


rule download_ensembl_gtf:
    output:
        gtf = os.path.join(config['path']['gtf'], 'ensembl.gtf')
    params:
        link = ''.join(config['download']['gtf'])
    shell:
        'wget -O {output.gtf}.gz {params.link}'
        ' && gunzip {output.gtf}.gz'
