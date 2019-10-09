#!/usr/bin/env python3
import os

def bcl2fastq(path):
    """
    A typical fastq file named by the bcl2fastq software is:
    samplename_samplerank_run[12]_001.fastq.gz
    """
    sample_file = os.path.join(path, 'SampleSheet.csv')
    found_data = False
    line_number = 1
    samples = []
    with open(sample_file) as file:
        for i, line in enumerate(file):
            if line.startswith('Sample_ID'):
                found_data = True
                continue

            if found_data:
                l = line.strip('\n')
                col = l.split(',')
                samples.append(f'{col[1]}_S{line_number}_R1_001.fastq.gz')
                samples.append(f'{col[1]}_S{line_number}_R2_001.fastq.gz')
                line_number += 1
    # print(samples)
    return samples


if __name__ in '__main__':
    samples = bcl2fastq('/home/gaspard/Documents/Projects/snakemake_mustafa/sequencing_Mustafa_sample_sheets')
    file = '/home/gaspard/Documents/Projects/snakemake_mustafa/samples.txt'
    with open(file, 'w') as f:
        for sample in samples:
            f.write(f'{sample}\n')
