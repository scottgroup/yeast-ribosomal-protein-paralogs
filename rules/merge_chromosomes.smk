import os

chrs = [
    'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X',
    'XI', 'XII', 'XIII', 'XIV', 'XV', 'XVI', 'Mito'
]

rule merge_chromosomes:
    input:
        chromosomes = expand(
            os.path.join(config['path']['chromosomes'], '{chr}.fa'),
            chr=chrs
        )
    output:
        genome = config['path']['genome']
    shell:
        'cat {input.chromosomes} > {output.genome}'
