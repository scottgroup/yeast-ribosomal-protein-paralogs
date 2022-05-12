#!/usr/bin/env python3

import pandas as pd


def main(input, cpm_out, tpm_out):
    files_df = [
        (
            pd.read_csv(
                file,
                sep='\t',
                header=0,
                index_col=False
            ),
            file.split('/')[-1].split('.')[-2]
        )
        for file in input
    ]

    ref_df = files_df[0][0]
    cpm_df = ref_df[['gene_id', 'gene_name']]
    tpm_df = ref_df[['gene_id', 'gene_name']]

    for i, file in enumerate(files_df):
        df, name = file
        df.columns = map(str.lower, df.columns)
        cpm_df[name] = cpm_df.gene_id.map(dict(zip(df.gene_id, df.cpm)))
        tpm_df[name] = tpm_df.gene_id.map(dict(zip(df.gene_id, df.tpm)))

    cpm_df.to_csv(cpm_out, sep='\t', header=True, index=False)
    tpm_df.to_csv(tpm_out, sep='\t', header=True, index=False)


main(snakemake.input.counts, snakemake.output.cpm, snakemake.output.tpm)
