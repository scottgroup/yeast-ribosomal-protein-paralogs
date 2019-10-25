#!/usr/bin/env python3

import pandas as pd
import re
import subprocess

from gtf import dataframe

pd.set_option("display.max_colwidth", 100000)

def build_features_gtf(df):
    df['transcript_name'] = df['gene_name']
    df['transcript_source'] = df['source']
    df['transcript_biotype'] = df['gene_biotype']
    df.loc[df.exon_number.isnull(), 'exon_number'] = 0
    df['exon_number'] = df.exon_number.map(str)
    df['exon_id'] = df['gene_id'].values + '.' + df['exon_number'].values
    df['protein_version'] = '1'
    # df = df.sort_values(
    #     by=['seqname', 'gene_id', 'transcript_id', 'feature', 'exon_number']
    # )

    attributes = {
        'gene_id': 'gene_id "' + df['gene_id'],
        'gene_name': '"; gene_name "' + df['gene_name'],
        'gene_source': '"; gene_source "' + df['source'],
        'gene_biotype': '"; gene_biotype "' + df['gene_biotype'],
        'transcript_id': '"; transcript_id "' + df['transcript_id'],
        'transcript_name': '"; transcript_name "' + df['transcript_name'],
        'transcript_source': '"; transcript_source "' + df['transcript_source'],
        'transcript_biotype': '"; transcript_biotype "' + df['transcript_biotype'],
        'exon_number': '"; exon_number "' + df['exon_number'],
        'exon_id': '"; exon_id "' + df['exon_id'],
        'protein_id': '"; protein id "' + df['gene_id'],
        'protein_version': '"; protein_version "' + df['protein_version']
    }

    attributes2 = {
        'gene_id': f'gene_id "{df.gene_id}',
        'gene_name': f'"; gene_name "{df.gene_name}',
        'gene_source': f'"; gene_source "{df.source}',
        'gene_biotype': f'"; gene_biotype "{df.gene_biotype}',
        'transcript_id': f'"; transcript_id "{df.transcript_id}',
        'transcript_name': f'"; transcript_name "{df.transcript_name}',
        'transcript_source': f'"; transcript_source "{df.transcript_source}',
        'transcript_biotype': f'"; transcript_biotype "{df.transcript_biotype}',
        'exon_number': f'"; exon_number "{df.exon_number}',
        'exon_id': f'"; exon_id "{df.exon_id}'
    }

    df.loc[df['feature'] == 'gene', 'attribute'] = attributes['gene_id'] \
        + attributes['gene_name'] \
        + attributes['gene_source'] \
        + attributes['gene_biotype'] \
        + '";'

    df.loc[df['feature'] == 'transcript', 'attribute'] = attributes['gene_id'] \
        + attributes['transcript_id'] \
        + attributes['gene_name'] \
        + attributes['gene_source'] \
        + attributes['gene_biotype'] \
        + attributes['transcript_name'] \
        + attributes['transcript_source'] \
        + attributes['transcript_biotype'] \
        + '";'

    df.loc[df['feature'] == 'CDS', 'attribute'] = attributes['gene_id'] \
        + attributes['transcript_id'] \
        + attributes['exon_number'] \
        + attributes['gene_name'] \
        + attributes['gene_source'] \
        + attributes['gene_biotype'] \
        + attributes['transcript_name'] \
        + attributes['transcript_source'] \
        + attributes['transcript_biotype'] \
        + attributes['protein_id'] \
        + attributes['protein_version'] \
        + '";'

    df.loc[df['feature'] == 'exon', 'attribute'] = attributes['gene_id'] \
        + attributes['transcript_id'] \
        + attributes['exon_number'] \
        + attributes['gene_name'] \
        + attributes['gene_source'] \
        + attributes['gene_biotype'] \
        + attributes['transcript_name'] \
        + attributes['transcript_source'] \
        + attributes['transcript_biotype'] \
        + attributes['exon_id'] \
        + '";'

    df.loc[df['feature'] == 'five_prime_UTR', 'attribute'] = attributes['gene_id'] \
        + attributes['transcript_id'] \
        + attributes['exon_number'] \
        + attributes['gene_name'] \
        + attributes['gene_source'] \
        + attributes['gene_biotype'] \
        + attributes['transcript_name'] \
        + attributes['transcript_source'] \
        + attributes['transcript_biotype'] \
        + attributes['exon_id'] \
        + '";'

    df.loc[df['feature'] == 'three_prime_UTR', 'attribute'] = attributes['gene_id'] \
        + attributes['transcript_id'] \
        + attributes['exon_number'] \
        + attributes['gene_name'] \
        + attributes['gene_source'] \
        + attributes['gene_biotype'] \
        + attributes['transcript_name'] \
        + attributes['transcript_source'] \
        + attributes['transcript_biotype'] \
        + attributes['exon_id'] \
        + '";'

    df['score'] = '.'
    df['frame'] = '.'
    df = df[
        [
            'seqname',
            'source',
            'feature',
            'start',
            'end',
            'score',
            'strand',
            'frame',
            'attribute'
        ]
    ]
    return df


def cols_2_dict(col_key, col_value):
    return dict(zip(col_key, col_value))


def count_to_CPM(counts):
    # df['CPM'] = (df['counts']/df['counts'].sum())*1E6
    # return df
    sum_counts = sum(counts)
    return [(count/sum_counts)*1E6 for count in counts]


def count_to_TPM(counts, lengths, mean_fragment_length):
    eff_lengths =  [
        (length - mean_fragment_length + 1)
        if (length - mean_fragment_length + 1) >= 1
        else 1
        for length in lengths
    ]
    counts_per_base = [x/y for x, y in zip(counts, eff_lengths)]
    sum_counts_per_base = 1/sum(counts_per_base)
    tpm = [i*sum_counts_per_base * 1E6 for i in counts_per_base]
    # counts_per_base = counts / effective_length
    # sum_counts_per_base = 1 / sum(counts_per_base)
    # tpm = counts_per_base * sum_counts_per_base * 1E6
    return tpm


def df_to_stdin(df, header=False, encode=False):
    df = df.to_string(index=False, header=header)
    df = re.sub('\n\s{1,}', '\n', df).strip()
    df = re.sub('\s{2,}', '\t', df).strip()
    df = f'{df}\n'
    if encode is True:
        df = df.encode(encoding='utf-8')
    return df


def get_gtf(gtf_file):
    gtf_df = dataframe(gtf_file)
    gtf_df['start'] = gtf_df['start'].map(int)
    gtf_df['start'] = gtf_df['start']-1
    gtf_df.sort_values(by=['seqname', 'start'], inplace=True)
    gtf_df['score'] = 1
    gtf_df['end'] = gtf_df['end'].map(int)
    gtf_df.loc[gtf_df["gene_name"].isnull(
    ), 'gene_name'] = gtf_df.loc[gtf_df["gene_name"].isnull(), 'gene_id']
    return gtf_df
