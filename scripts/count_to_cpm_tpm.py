#!/usr/bin/env python3

import argparse
import os
import sys
import pandas as pd

import utils


def process_file(count_input, gtf_df, length_input='', mean_FL=0):
    counts_df = pd.read_csv(
        count_input,
        sep='\t',
        header=None,
        names=['gene_id', 'counts'],
        index_col=False
    )
    counts_df['gene_name'] = counts_df['gene_id'].map(
        utils.cols_2_dict(
            gtf_df['gene_id'],
            gtf_df['gene_name']
        )
    )
    counts_df['gene_biotype'] = counts_df['gene_id'].map(
        utils.cols_2_dict(
            gtf_df['gene_id'],
            gtf_df['gene_biotype']
        )
    )
    counts_df = counts_df[['gene_id', 'gene_name', 'gene_biotype', 'counts']]
    counts_df = utils.count_to_CPM(counts_df)
    return counts_df


def main(list_of_files, gtf, output):
    gtf_df = utils.get_gtf(gtf)
    gtf2 = gtf_df.copy(deep=True)
    gtf2 = gtf2[['gene_id']]
    gtf2.to_csv('gtf.csv',header=False,index=False)
    sys.exit(0)
    # gtf_df = pd.read_csv(
    #     gtf,
    #     sep='\t',
    #     header=0,
    #     index_col=False
    # )
    print(gtf_df)
    print(len(gtf_df))
    for _, file in enumerate(list_of_files):
        df = process_file(file, gtf_df)
        file_name = file.split('/')[-1].split('.')[0]
        gtf_df[f'{file_name}_CPM'] = gtf_df.gene_id.map(
            utils.cols_2_dict(
                df.gene_id,
                df.CPM
            )
        )
    return gtf_df


if __name__ in '__main__':

    parser = argparse.ArgumentParser()

    parser.add_argument("input", help="Path to directory containing the count files. Files should end in .tsv")
    parser.add_argument("annotation", help="Path to .gtf file")
    parser.add_argument('-o','--output', help="Path to output directory. Default: 'CPM.csv' in same input directory", default='None')

    args = parser.parse_args()

    gtf_file = args.annotation
    gtf_file = os.path.realpath(gtf_file)

    input = args.input
    input = os.path.realpath(input)
    files = [entry.name for entry in os.scandir(input) if entry.name.endswith('.tsv') and entry.is_file()]
    # print(files)
    files = [os.path.join(input, file) for file in files]

    output = args.output
    if output == 'None':
        output = input
    output = os.path.realpath(output)
    os.makedirs(output,exist_ok=True)
    output = f'{output}/CPM_TPM.csv'
    print(output)

    # gtf = '/home/gaspard/Documents/Projects/snakemake_mustafa/data/references/Saccharomyces_cerevisiae.R64-1-1.96.gtf'
    # input_file = '/media/gaspard/vincent_computer/Desktop/Sequencing/Mustafa/counts_total/Total_Stauro_RPL7AA_N2.CorrectCount.Rsubread.count.tsv'
    # input_file2 = '/media/gaspard/vincent_computer/Desktop/Sequencing/Mustafa/counts_total/Total_Stauro_RPL7AA_N3.CorrectCount.Rsubread.count.tsv'
    # output = '/home/gaspard/Documents/Projects/snakemake_mustafa/scripts/test.tsv'


    df = main(files, gtf_file, output)
    print(df)
    df.to_csv(output, sep='\t', header=True, index=False)
