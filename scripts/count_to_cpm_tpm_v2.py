#!/usr/bin/env python3

# Public modules
import argparse
import os
import sys
import pandas as pd

# User modules
import utils


def main(input, gtf, mean_FL):
    gtf_df = utils.get_gtf(gtf)
    gtf_df = gtf_df.loc[gtf_df.feature=='gene']
    gtf_df = gtf_df.reset_index(drop=True)
    ref_df = gtf_df[['gene_id', 'gene_name', 'gene_biotype']]
    counts_df = pd.read_csv(
        input,
        sep='\t',
        header=0,
        index_col=False
    )
    counts_df.columns = [
        'gene_id',
        'chr',
        'start',
        'end',
        'strand',
        'length',
        'counts'
    ]
    ref_df['length'] = ref_df.gene_id.map(
        dict(zip(counts_df.gene_id, counts_df.length))
    )
    ref_df['counts'] = ref_df.gene_id.map(
        dict(zip(counts_df.gene_id, counts_df.counts))
    )
    ref_df['CPM'] = utils.count_to_CPM(ref_df.counts)
    ref_df['TPM'] = utils.count_to_TPM(ref_df.counts, ref_df.length, mean_FL)
    return ref_df


if __name__ in '__main__':

    parser = argparse.ArgumentParser()

    parser.add_argument(
        "input",
        help="Path to csv file. Can also be from stdin if the argument is '-'"
    )
    parser.add_argument("annotation", help="Path to .gtf file")
    parser.add_argument("mean_fragment_length", help="Mean fragment length of sample")

    args = parser.parse_args()
    gtf_file = args.annotation
    gtf_file = os.path.realpath(gtf_file)

    input = args.input

    if input == '-':
        input = sys.stdin
    else:
        input = os.path.realpath(input)

    MFL = int(float(args.mean_fragment_length))


    df = main(input, gtf_file, MFL)
    df = utils.df_to_stdin(df, header=True)
    sys.stdout.write(df)
