#!/usr/bin/env python3

import pandas as pd

from gtf import dataframe


def count_to_TPM(counts, effective_length):
    counts_per_base = counts / effective_length
    sum_counts_per_base = 1 / sum(counts_per_base)
    tpm = counts_per_base * sum_counts_per_base * 1E6
    return tpm


def get_effective_length(length, mean_FL):
    effective_length = length - mean_FL + 1
    return effective_length


def count_to_CPM(df):
    df['CPM'] = (df['counts']/df['counts'].sum())*1E6
    return df


def get_gtf(gtf_file):
    """
    Path to gtf file, returns the .gtf file in a dataframe for a .bed format
    Only contains the 'gene' features.
    Sorts the bed, so it's easier to use for the bedtools suite.
    :param gtf_file: original gtf file
    """
    if gtf_file.endswith('.gtf') == True:
        print('Reading gtf')
    else:
        print('Annotation file:', gtf_file)
        print('error: Wrong annotation format. Only .gtf files are accepted')
        sys.exit(1)

    gtf_df = dataframe(gtf_file)

    gtf_df['start'] = gtf_df['start'].map(int)
    gtf_df['start'] = gtf_df['start']-1
    gtf_df.sort_values(by=['seqname', 'start'], inplace=True)
    gtf_df = gtf_df.reset_index(drop=True)
    gtf_df['score'] = 1
    gtf_df['end'] = gtf_df['end'].map(int)
    gtf_df = gtf_df.rename(index=str, columns={'seqname': 'chr'})

    gtf_df = gtf_df[gtf_df.feature == 'gene']
    gtf_df = gtf_df[['gene_id', 'gene_name', 'gene_biotype']]
    gtf_df.loc[gtf_df["gene_name"].isnull(
    ), 'gene_name'] = gtf_df.loc[gtf_df["gene_name"].isnull(), 'gene_id']
    return gtf_df


def cols_2_dict(col_key, col_value):
    return dict(zip(col_key, col_value))
