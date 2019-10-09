import os

include: 'downloads.smk'


rule create_gtf:
    ''' Create annotation from Yeastmine '''
    input:
        path = rules.download_git_projects.output.git_gtf_folder
    output:
        gtf = config['path']['gtf']
    params :
        link = os.path.join(
            'http://gitlabscottgroup.med.usherbrooke.ca',
            'gaspard/yeast_annotation.git'
        ),
        git_folder = 'other_git_repos/annotation'
    conda:
        '../envs/pypackages.yaml'
    shell:
        'python {input.path}/make_gtf.py {output.gtf}'
