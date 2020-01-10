import os

from functools import partial

import scripts.get_output as get_output

configfile: 'config.json'


__author__ = 'Gaspard Reulet'
__email__ = 'gaspard.reulet@usherbrooke.ca'
__license__ = 'MIT'


include: 'rules/downloads.smk'
include: 'rules/merge_chromosomes.smk'
include: 'rules/trimmomatic.smk'
include: 'rules/STAR_index.smk'
include: 'rules/STAR_align.smk'
include: 'rules/featurecounts.smk'
include: 'rules/merge_all_samples.smk'

annotations = ['ensembl', 'ensemblUTR']

wildcard_constraints:
    sample_ID = "[A-Z0-9_]+"

rule all:
    input:
        csv = expand(
            os.path.join(
                config['path']['counts'],
                '{annotation}',
                '{sample_ID}.tsv'
            ),
            annotation=annotations,
            sample_ID = config['datasets']
        ),
        all_counts = expand(
            os.path.join(
                config['path']['counts'],
                '{annotation}',
                '{PM}_all.tsv'
            ),
            annotation=annotations,
            PM=['CPM', 'TPM']
        )
