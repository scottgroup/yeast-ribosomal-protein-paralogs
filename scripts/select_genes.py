#!/usr/bin/env python3

# Public modules
import csv
import pandas as pd
import sys

# User modules
import utils

pd.set_option("display.max_colwidth", 100000)

def main(gene_ids, gtf):
    gtf_df = utils.get_gtf(gtf)
    gtf_df = gtf_df.loc[gtf_df.gene_id.isin(gene_ids)]
    gtf_df = gtf_df.loc[gtf_df.gene_biotype=='ORF']
    gtf_df = utils.build_features_gtf(gtf_df)
    return gtf_df


if __name__ in "__main__":
    gene_ids = [line.strip() for line in sys.stdin]
    gtf = sys.argv[1]
    gtf_df = main(gene_ids, gtf)
    gtf_df = utils.df_to_stdin(gtf_df)
    sys.stdout.write(gtf_df)
