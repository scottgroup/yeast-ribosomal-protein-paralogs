import os

import scripts.get_output as get_output

configfile: 'config.json'


__author__ = 'Gaspard Reulet'
__email__ = 'gaspard.reulet@usherbrooke.ca'
__license__ = 'MIT'


include: 'rules/downloads.smk'
include: 'rules/merge_chromosomes.smk'
include: 'rules/gtf.smk'
include: 'rules/bcl2fastq.smk'
include: 'rules/trimmomatic.smk'
include: 'rules/STAR_index.smk'
include: 'rules/STAR_align.smk'
include: 'rules/featurecounts.smk'


rule all:
    input:
        fastq = expand(
            os.path.join(
                config['path']['fastq'],
                '191004_NB502083_0068_AHH3KGBGX9',
                '{sample_ID}_{pair}_001.fastq.gz'
            ),
            sample_ID = config['bcl_datasets']['191004_NB502083_0068_AHH3KGBGX9'],
            pair = ['R1', 'R2']
        ),
        csv = expand(
            os.path.join(config['path']['counts'], '{sample_ID}.tsv'),
            sample_ID = config['bcl_datasets']['191004_NB502083_0068_AHH3KGBGX9']
        ),
        # qc = expand(
        #     os.path.join(
        #         config['path']['qc'],
        #         '191004_NB502083_0068_AHH3KGBGX9',
        #         '{sample_ID}_{pair}_'
        #     )
        # )
