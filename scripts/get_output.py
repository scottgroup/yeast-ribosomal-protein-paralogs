#!/usr/bin/env python3
import os

def bcl2fastq(config):
    """
    A typical fastq file named by the bcl2fastq software is:
    samplename_samplerank_run[12]_001.fastq.gz
    """
    datasets = config['download']['datasets_all']
    path = config['path']['bcl']
    outpath = config['path']['coco_cc']
    all_samples = []
    for dataset in datasets:
        sample_file = os.path.join(path, dataset, 'SampleSheet.csv')
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
                    if col[1]:
                        # samples.append(f'{col[1]}_S{line_number}_R1_001.fastq.gz')
                        # samples.append(f'{col[1]}_S{line_number}_R2_001.fastq.gz')
                        samples.append(f'{col[1]}_S{line_number}.tsv')
                        # samples.append(f'{col[1]}_S{line_number}_R2_001.fastq.gz')
                    else:
                        # samples.append(f'{col[0]}_S{line_number}_R1_001.fastq.gz')
                        # samples.append(f'{col[0]}_S{line_number}_R2_001.fastq.gz')
                        samples.append(f'{col[0]}_S{line_number}.tsv')
                    line_number += 1
        samples = [f'{outpath}/{dataset}/{sample}' for sample in samples]
        all_samples.extend(samples)
    print(all_samples)
    return all_samples



def bcl2fastq_v2(config, wildcards):
    print('This is config: ', config)
    print('This is wildcards: ', wildcards)
    datasets = config['download']['datasets_all']
    # print(datasets)
    # datasets = ['191004_NB502083_0068_AHH3KGBGX9']
    path = config['path']['fastq']
    output_path = config['path']['trimmed']
    output_path2 = config['path']['STAR_align']
    # path = '/home/gaspard/Documents/Projects/snakemake_mustafa/data/datasets/fastq'
    # path = 'data/datasets/fastq'
    all_samples = []
    for dataset in datasets:
        try:
            fastq_path = os.path.join(path, dataset)
            files = [
                entry.name
                for entry in os.scandir(fastq_path)
                if (
                    entry.is_file()
                    and not entry.name.startswith('Undetermined')
                    and entry.name.endswith('.fastq.gz')
                )
            ]

            names = [file.split('.')[0] for file in files]
            names = ["_".join(file.split('_')[:-2]) for file in names]
            print(names)

            # Specify the ones we want

            ## trim
            # trim_r1 = [f'{file}_R1_paired.fq.gz' for file in names]
            # trim_r2 = [f'{file}_R2_paired.fq.gz' for file in names]

            ## Coco
            # _Aligned.sortedByCoord.out.bam
            a = [f'{file}_R1.tsv' for file in names]
            b = [f'{file}_R2.tsv' for file in names]
            ab = a+b
            ab = [os.path.join(output_path, dataset, file) for file in ab]

            c = [f'{file}_Aligned.sortedByCoord.out.bam' for file in names]
            c = [os.path.join(output_path2, dataset, file) for file in c]
            # files = trim_r1 + trim_r2 + coco_cc
            # files = coco_cc + coco_cc2
            # files = [os.path.join(output_path, dataset, file) for file in files]
            # files = ab+c
            files = c
        except FileNotFoundError:
            files = []
        # print(files)
        all_samples.extend(files)
    print('This is all_samples')
    print(all_samples)
    return all_samples
