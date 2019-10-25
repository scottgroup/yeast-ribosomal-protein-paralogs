import os

rule download_chr:
    output:
        chromosomes = os.path.join(config['path']['chromosomes'], '{chr}.fa')
    params:
        link = ''.join([config['download']['chromosomes'], '{chr}.fa.gz'])
    shell:
        'wget -O {output.chromosomes}.gz {params.link}'
        ' && gunzip {output.chromosomes}.gz'


rule download_git_projects:
    output:
        git_gtf_folder = directory('other_git_repos/annotation'),
        git_coco_folder = directory('other_git_repos/coco')
    params:
        git_gtf_link = os.path.join(
            'http://gitlabscottgroup.med.usherbrooke.ca',
            'gaspard/yeast_annotation.git'
        ),
        git_coco_link = os.path.join(
            'http://gitlabscottgroup.med.usherbrooke.ca',
            'scott-group/coco.git'
        )
    conda:
        '../envs/git.yaml'
    shell:
        'mkdir -p {output.git_gtf_folder}'
        ' && git clone {params.git_gtf_link} {output.git_gtf_folder}'
        ' && mkdir -p {output.git_coco_folder}'
        ' && git clone {params.git_coco_link} {output.git_coco_folder}'


# rule download_pairedBamToBed12:
#     output:
#          folder = 'other_git_repos/pairedBamToBed12-pairedbamtobed12/bin/pairedBamToBed12'
#     params:
#         link = os.path.join(
#             'https://github.com/Population-Transcriptomics/pairedBamToBed12',
#             'archive/pairedbamtobed12.zip'
#         ),
#         dir = 'other_git_repos'
#     conda:
#         # It isn't indicated on the github, but it's needs samtools for the make test
#         '../envs/samtools.yaml'
#     shell:
#         'wget -P {params.dir} {params.link}'
#         ' && unzip -d {params.dir} {params.dir}/pairedbamtobed12.zip'
#         ' && cd {params.dir}/pairedBamToBed12-pairedbamtobed12'
#         ' && make'
#         ' && make test'
