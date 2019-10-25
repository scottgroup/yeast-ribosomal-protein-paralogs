import os

rule coco_cc:
    input:
        gtf = rules.coco_ca.output.ref,
        bam = rules.STAR_align.output.bam
    output:
        counts = os.path.join(
            config["path"]["coco_cc"],
            '{bcl_ID}',
            '{sample_ID}.tsv'
        )
    params:
        coco_path = 'other_git_repos/coco/bin'
    threads:
        4
    conda:
        '../envs/coco_dependencies.yaml'
    shell:
        'python {params.coco_path}/coco.py cc'
        ' --countType both'
        ' --thread {threads}'
        ' --strand 1'
        ' --paired'
        ' {input.gtf}'
        ' {input.bam}'
        ' {output.counts}'
