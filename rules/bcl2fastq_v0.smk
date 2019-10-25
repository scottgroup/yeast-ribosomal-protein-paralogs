import os

import scripts.get_output as get_output

rule bcl2fastq:
    input:
        bcl = os.path.join(
            config['path']['bcl'],
            '191004_NB502083_0068_AHH3KGBGX9'
        )
    output:
        fastq = expand(
            os.path.join(
                config['path']['fastq'],
                '191004_NB502083_0068_AHH3KGBGX9',
                '{sample_ID}_{pair}_001.fastq.gz'
            ),
            sample_ID = config['bcl_datasets']['191004_NB502083_0068_AHH3KGBGX9'],
            pair = ['R1', 'R2']
        )
    params:
        extra = '--no-lane-splitting',
        output_dir = os.path.join(
            config['path']['fastq'],
            '191004_NB502083_0068_AHH3KGBGX9'
        )
    conda:
        '../envs/bcl2fastq.yaml'
    log:
        'logs/bcl2fastq/191004_NB502083_0068_AHH3KGBGX9.log'
    threads:
        24
    shell:
        'bcl2fastq -R {input.bcl} -o {params.output_dir} {params.extra}'
