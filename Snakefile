import os

from functools import partial

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
include: 'rules/coco_ca.smk'
inculde: 'rules/coco_cc.smk'
# include: 'rules/featurecounts.smk'

wildcard_constraints:
    bcl_ID = "[A-Z0-9_]+",
    sample_ID = "[a-zA-Z0-9_]+"

rule all:
    input:
        gtf = config['path']['gtf'],
        # bcl = expand(
        #     os.path.join(
        #         config['path']['fastq'],
        #         '{bcl_ID}'
        #     ),
        #     bcl_ID=config['download']['datasets_all']
        # ),
        tsv = get_output.bcl2fastq(config)



# rule all:
#     input:
#         expand(
#             os.path.join(
#                 config["path"]["fastq"],
#                 '{bcl_ID}'
#             ),
#             bcl_ID=config['download']['datasets_all']
#         ),
#         partial(get_output.bcl2fastq_v2, config)


# checkpoint bli:
#     """
#     """
#     input:
#         bcl = os.path.join(
#             config['path']['bcl'],
#             '{bcl_ID}'
#         )
#     output:
#         fastq = directory(os.path.join(config['path']['fastq'], '{bcl_ID}'))
#         # fastq = directory(os.path.join(config['path']['fastq'], '{bcl_ID}'))
#     params:
#         dir = os.path.join(config['path']['fastq'], '{bcl_ID}')
#     shell:
#         "mkdir -p {params.dir}"
#         " && touch {params.dir}/f1_R1_001.fastq.gz"
#         " && touch {params.dir}/f1_R2_001.fastq.gz"
#         " && touch {params.dir}/f2_R1_001.fastq.gz"
#         " && touch {params.dir}/f2_R2_001.fastq.gz"
#         " && touch {params.dir}/f3_R1_001.fastq.gz"
#         " && touch {params.dir}/f3_R2_001.fastq.gz"
#         " && touch {params.dir}/f4_R1_001.fastq.gz"
#         " && touch {params.dir}/f4_R2_001.fastq.gz"
#         " && touch {params.dir}/f5_R1_001.fastq.gz"
#         " && touch {params.dir}/f5_R2_001.fastq.gz"
#         " && touch {params.dir}/Undetermined_R1_001.fastq.gz"
#         " && touch {params.dir}/Undetermined_R2_001.fastq.gz"
#
# rule trim:
#     input:
#         fastq = rules.bli.output.fastq
#     output:
#         tkn = os.path.join(
#             config['path']['trimmed'], '{bcl_ID}', '{sample_ID}_R1.tsv'
#         ),
#         tkn2 = os.path.join(
#             config['path']['trimmed'], '{bcl_ID}', '{sample_ID}_R2.tsv'
#         )
#     params:
#         f1 = 'data/datasets/fastq/{bcl_ID}/{sample_ID}_R1_001.fastq.gz',
#         f2 = 'data/datasets/fastq/{bcl_ID}/{sample_ID}_R2_001.fastq.gz'
#     shell:
#         "cp {params.f1} {output.tkn}"
#         " && cp {params.f2} {output.tkn2}"
#
#
# rule STAR_align:
#     input:
#         r1 = rules.trim.output.tkn,
#         r2 = rules.trim.output.tkn2
#     output:
#         bam = os.path.join(
#             config['path']['STAR_align'],
#             '{bcl_ID}',
#             '{sample_ID}_Aligned.sortedByCoord.out.bam'
#         )
#     shell:
#         "cp {input.r1} {output.bam}"
#

"""
rule all:
    input:
        expand(
            os.path.join(
                config["path"]["fastq"],
                '{bcl_ID}'
            ),
            bcl_ID=config['download']['datasets_all']
        ),
        partial(get_output.bcl2fastq_v2, config)


checkpoint bli:
    input:
        bcl = os.path.join(
            config['path']['bcl'],
            '{bcl_ID}'
        )
    output:
        fastq = directory(os.path.join(config['path']['fastq'], '{bcl_ID}'))
        # fastq = directory(os.path.join(config['path']['fastq'], '{bcl_ID}'))
    params:
        dir = os.path.join(config['path']['fastq'], '{bcl_ID}')
    shell:
        "mkdir -p {params.dir}"
        " && touch {params.dir}/f1_R1_001.fastq.gz"
        " && touch {params.dir}/f1_R2_001.fastq.gz"
        " && touch {params.dir}/f2_R1_001.fastq.gz"
        " && touch {params.dir}/f2_R2_001.fastq.gz"
        " && touch {params.dir}/f3_R1_001.fastq.gz"
        " && touch {params.dir}/f3_R2_001.fastq.gz"
        " && touch {params.dir}/f4_R1_001.fastq.gz"
        " && touch {params.dir}/f4_R2_001.fastq.gz"
        " && touch {params.dir}/f5_R1_001.fastq.gz"
        " && touch {params.dir}/f5_R2_001.fastq.gz"
        " && touch {params.dir}/Undetermined_R1_001.fastq.gz"
        " && touch {params.dir}/Undetermined_R2_001.fastq.gz"

rule trim:
    input:
        fastq = rules.bli.output.fastq
    output:
        r1 = os.path.join(
            config['path']['trimmed'], '{bcl_ID}', '{sample_ID}_R1_paired.fq.gz'
        ),
        r2 = os.path.join(
            config['path']['trimmed'], '{bcl_ID}', '{sample_ID}_R2_paired.fq.gz'
        )
    params:
        f1 = 'data/datasets/fastq/{bcl_ID}/{sample_ID}_R1_001.fastq.gz',
        f2 = 'data/datasets/fastq/{bcl_ID}/{sample_ID}_R2_001.fastq.gz'
    shell:
        "cp {params.f1} {output.r1}"
        " && cp {params.f2} {output.r2}"


rule STAR_align:
    input:
        r1 = rules.trim.output.r1,
        r2 = rules.trim.output.r2
    output:
        bam = os.path.join(
            config['path']['STAR_align'],
            '{bcl_ID}',
            '{sample_ID}_Aligned.sortedByCoord.out.bam'
        )
    shell:
        "cp {input.r1} {output.bam}"

rule counts:
    input:
        bam = rules.STAR_align.output.bam
    output:
        counts = os.path.join(
            config["path"]["coco_cc"],
            '{bcl_ID}',
            '{sample_ID}.tsv'
        )
    shell:
        "cp {input.bam} {output.counts}"

"""
