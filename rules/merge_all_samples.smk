import os

def merge_samples_inputs(wildcards):
    files = [
        os.path.join(
            config['path']['counts'],
            wildcards['annotation'],
            f'{sample}.tsv'
        )
        for sample in config['datasets_test']
    ]
    return files


rule merge_all_samples:
    input:
        counts = expand(
            os.path.join(
                config['path']['counts'],
                '{{annotation}}',
                '{sample_ID}.tsv'
            ),
            sample_ID=config['datasets']
        )
    output:
        cpm = os.path.join(
            config['path']['counts'],
            '{annotation}',
            'CPM_all.tsv'
        ),
        tpm = os.path.join(
            config['path']['counts'],
            '{annotation}',
            'TPM_all.tsv'
        )
    params:
        in_dir = os.path.join(config['path']['counts'], '{annotation}'),
        script = 'scripts/combine_files.py',
        out_dir = os.path.join(config['path']['counts'], '{annotation}')
    conda:
        '../envs/pypackages.yaml'
    shell:
        'python3 {params.script} {params.in_dir} {params.out_dir}'
