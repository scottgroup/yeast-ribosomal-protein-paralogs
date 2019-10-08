
import os

def bcl2fastq(path):
    sample_file = os.path.join(path, 'SampleSheet.csv')
    found_data = False
    HEADER = []
    samples = []
    with open(sample_file) as file:
        for line in file:
            if line.startswith('Sample_ID'):
                found_data = True
                l = line.strip('\n')
                HEADER = l.split(',')
                continue

            if found_data:
                l = line.strip('\n')
                samples.append(l.split(','))
    print(HEADER)
    print(samples)
    names = [for sample in samples]


if __name__ in '__main__':
    bcl2fastq('/home/gaspard/Documents/Projects/snakemake_mustafa/sequencing_Mustafa_sample_sheets')
