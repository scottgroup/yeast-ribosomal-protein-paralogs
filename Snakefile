import os

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

wildcard_constraints:
    sample_ID = "({})".format("|".join(config["datasets"]))

rule all:
    input:
        all_counts = expand(
            os.path.join(config['path']['counts'], '{PM}_all.tsv'),
            PM=['CPM', 'TPM']
        )
