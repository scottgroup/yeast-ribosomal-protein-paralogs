import os


checkpoint bcl2fastq:
    input:
        bcl = os.path.join(
            config['path']['bcl'],
            '{bcl_ID}'
        )
    output:
        fastq = directory(os.path.join(config['path']['fastq'], '{bcl_ID}'))
    params:
        extra = '--no-lane-splitting',
        output_dir = os.path.join(
            config['path']['fastq'],
            '{bcl_ID}'
        )
    conda:
        '../envs/bcl2fastq.yaml'
    log:
        'logs/bcl2fastq/{bcl_ID}.log'
    threads:
        24
    shell:
        'bcl2fastq -R {input.bcl} -o {params.output_dir} {params.extra}'
