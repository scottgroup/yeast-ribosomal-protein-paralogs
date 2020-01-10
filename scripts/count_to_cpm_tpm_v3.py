#!/usr/bin/env python3

# Public modules
import argparse
import os
import pandas as pd
import sys

# User defined modules
import utils
from gtf import dataframe

def get_main_transcript(dtranscript):
    """
    Keeps only the main transcript for each genes.
    The main transcript is determined by all these parameters,
    ranging from most important to least:
        transcript_support_level,
        source (ensembl_havana first, havana second, all the others after)
        and transcript_name.
    :param dtranscript: dataframe containing all transcripts
    :return: dataframe containing one main transcript per gene_id
    """
    if 'transcript_biotype' in dtranscript.columns:
        dtranscript = dtranscript[
            dtranscript['gene_biotype'] == dtranscript['transcript_biotype']
        ]
    # source with highest level of confidence.
    dtranscript.loc[dtranscript['source'] == 'ensembl_havana', 'source'] = 'aa'
    # source with second level of confidence.
    dtranscript.loc[dtranscript['source'] == 'havana', 'source'] = 'ab'
    columns_sort = [
        'gene_id',
        'transcript_support_level',
        'source',
        'transcript_name'
    ]
    columns_sort = [x for x in columns_sort if x in dtranscript.columns]
    dtranscript = dtranscript.sort_values(by=columns_sort)
    dtranscript = dtranscript.drop_duplicates(subset=['gene_id'])
    return dtranscript


def get_true_length_from_gtf(gtf_df):
    # Gives true length of transcripts without introns
    dtranscript = gtf_df[gtf_df['feature'] == 'transcript']
    dtranscript = get_main_transcript(dtranscript)
    dtranscript = dtranscript[['gene_id', 'transcript_id']]
    dexon = gtf_df[gtf_df['feature'] == 'exon']
    dexon = dexon[
        dexon['transcript_id'].isin(dtranscript['transcript_id']) == True
    ]
    dexon['length'] = dexon['end'] - dexon['start']
    gtf_df = gtf_df[gtf_df['feature'] == 'gene']
    dexon_groupby = dexon.groupby('gene_id', as_index=False)['length'].sum()
    gtf_df = pd.merge(gtf_df, dexon_groupby, how='left', on='gene_id')
    gtf_df = gtf_df.sort_values(by='gene_id')
    return gtf_df


def add_pm_counts(dcount, gtf_file, max_read_size):

    # Open GTF file
    gtf_df = dataframe(gtf_file)
    columns_keep = [
        'seqname',
        'source',
        'feature',
        'start',
        'end',
        'strand',
        'gene_id',
        'transcript_id',
        'exon_number',
        'gene_name',
        'gene_biotype',
        'transcript_name',
        'transcript_biotype',
        'transcript_support_level'
    ]
    columns_keep = [x for x in columns_keep if x in gtf_df.columns]

    gtf_df = gtf_df[columns_keep]
    gtf_df['seqname'] = gtf_df['seqname'].map(str)
    gtf_df['start'] = gtf_df['start'].map(int)
    gtf_df['end'] = gtf_df['end'].map(int)
    gtf_df['seqname'] = gtf_df['seqname'].map(str)
    gtf_df['start'] = gtf_df['start'].map(int)
    gtf_df['end'] = gtf_df['end'].map(int)
    gtf_df = get_true_length_from_gtf(gtf_df)
    columns_sort = [
        'gene_id',
        'gene_name',
        'gene_biotype',
        'length',
        'count',
        'cpm',
        'tpm'
    ]
    columns_sort = [x for x in columns_sort if x in gtf_df.columns]
    gtf_df = gtf_df[columns_sort]

    # dcount requires gene_id and count column
    Assigned = dcount['count'].sum()
    dcount['cpm'] = (dcount['count'].map(float) / Assigned) * 1E6
    dcount = pd.merge(dcount, gtf_df, how='right', on='gene_id')
    dcount.loc[dcount.gene_name.isnull(), 'gene_name'] = dcount['gene_id']
    dcount['temp'] = dcount['count'] / dcount['length']
    dcount.loc[
        dcount['length'] < max_read_size,
        'temp'] = dcount['count'] / max_read_size
    sum_temp = dcount['temp'].sum()
    dcount['tpm'] = (dcount['temp'] / sum_temp) * 1E6
    # del dcount['temp']
    columns_sort = [
        'gene_id',
        'gene_name',
        'gene_biotype',
        'length',
        'count',
        'cpm',
        'tpm'
    ]
    columns_sort = [x for x in columns_sort if x in dcount.columns]
    dcount = dcount[columns_sort]
    return dcount


if __name__ in '__main__':
    parser = argparse.ArgumentParser()

    parser.add_argument(
        'input',
        help = "Path to csv file. Can be from stdin if the argument is '-'"
    )
    parser.add_argument(
        'annotation',
        help = 'Path to .gtf file.'
    )
    parser.add_argument(
        'max_read_size',
        help = 'Max read size'
    )

    args = parser.parse_args()

    gtf_file = args.annotation
    gtf_file = os.path.realpath(gtf_file)

    max_read_size = int(float(args.max_read_size))

    input = args.input

    if input == '-':
        input = sys.stdin
    else:
        input.os.path.realpath(input)

    df = pd.read_csv(
        input,
        sep='\t',
        header=0,
        index_col=False
    )
    df.columns = [
        'gene_id',
        'chr',
        'start',
        'end',
        'strand',
        'length',
        'count'
    ]

    df = add_pm_counts(
        df[['gene_id', 'count']],
        gtf_file,
        max_read_size
    )
    df = utils.df_to_stdin(df, header=True)
    sys.stdout.write(df)
