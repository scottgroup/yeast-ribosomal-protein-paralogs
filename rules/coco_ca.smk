rule coco_ca:
    input:
        path = rules.download_git_projects.output.git_coco_folder,
        gtf = rules.create_gtf.output.gtf
    output:
        ref = config["path"]["coco_ca"]
    params:
        coco_path = 'other_git_repos/coco/bin'
    conda:
        '../envs/coco_dependencies.yaml'
    shell:
        'python {params.coco_path}/coco.py ca'
        ' -b snoRNA,tRNA,snRNA,ncRNA'
        ' -o {output.ref}'
        ' {input.gtf}'
