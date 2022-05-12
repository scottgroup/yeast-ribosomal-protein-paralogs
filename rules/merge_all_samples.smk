import os

rule merge_all_samples:
    input:
        counts = expand(
            os.path.join(config['path']['counts'], '{sample_ID}.tsv'),
            sample_ID=config['datasets']
        )
    output:
        cpm = os.path.join(config['path']['counts'], 'CPM_all.tsv'),
        tpm = os.path.join(config['path']['counts'], 'TPM_all.tsv')
    script:
        'scripts/combine_files.py'
