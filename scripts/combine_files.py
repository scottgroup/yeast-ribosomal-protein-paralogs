#!/usr/bin/env python3

import os
import pandas as pd
import sys


def main(input_dir):
    files_df = [
        (
            pd.read_csv(
                entry.path,
                sep='\t',
                header=0,
                # header=None,
                index_col=False,
                # names=['gene_id', 'gene_name', 'gene_biotype', 'length', 'counts', 'cpm', 'tpm']
            ),
            entry.name.split('.')[0]
        )
        for entry in os.scandir(input_dir)
        if entry.is_file() and entry.name.endswith('.tsv')
    ]

    ref_df = files_df[0][0]
    cpm_df = ref_df[['gene_id', 'gene_name']]
    tpm_df = ref_df[['gene_id', 'gene_name']]

    for i, file in enumerate(files_df):
        df, name = file
        df.columns = map(str.lower, df.columns)
        cpm_df[name] = cpm_df.gene_id.map(dict(zip(df.gene_id, df.cpm)))
        tpm_df[name] = cpm_df.gene_id.map(dict(zip(df.gene_id, df.tpm)))

    return cpm_df, tpm_df


if __name__ in "__main__":
    input_dir = sys.argv[1]
    out_dir = sys.argv[2]
    cpm_out = os.path.join(out_dir, 'CPM_all.tsv')
    tpm_out = os.path.join(out_dir, 'TPM_all.tsv')
    cpm_df, tpm_df = main(input_dir)
    cpm_df.to_csv(cpm_out, sep='\t', header=True, index=False)
    tpm_df.to_csv(tpm_out, sep='\t', header=True, index=False)
