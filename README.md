# Important note
 The code in this package is intended to specifically run the analysis as it appears in `Malik Ghulam M. _et al._, 2022. Duplicated ribosomal protein paralogs promote alternative translation and drug resistance. _Under review_` Available from: _link_


# RNA-Seq pipeline

__Author__ : Gaspard Reulet

__Email__ :  _<gaspard.reulet@usherbrooke.ca>_

## Software to install
Conda (Miniconda3) needs to be installed (https://docs.conda.io/en/latest/miniconda.html)

For Linux users :
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

Answer `yes` to `Do you wish the installer to initialize Miniconda3?`

To create the Snakemake environment used to launch Snakemake, run the following.
The conda create command can appear to be stuck on Solving environment.
The command is probably not stuck, be patient.

To create the Snakemake environment used to launch Snakemake
```bash
exec bash
conda config --set auto_activate_base False
conda create --name smake -c bioconda -c conda-forge snakemake=5.7.0
```

Before running Snakemake, you have to initialize the environment
```bash
conda activate smake
```


## Usage

#### Step 1: Install workflow

If you simply want to use this workflow, download and extract the [latest release](https://github.com/scottgroup/yeast-ribosomal-protein-paralogs).

If you use this workflow in a paper, don't forget to give credits to the author by citing the URL of this repository and the publication. [Link]()

#### Step 2: Configure workflow

This workflow was developped for a [Slurm](https://slurm.schedmd.com/) cluster system.
The system used for developping, testing and running the analysis is described [here](https://docs.computecanada.ca/wiki/Cedar).

If you also use a `Slurm` cluster system, configure the workflow according to your system by editing the file `cluster.json`.

If you use a cluster system that operates with another schedule manager, configure the workflow according to your system via editing the files `cluster.json` and `scripts/slurmSubmit.py`
See the [Snakemake documentation](https://snakemake.readthedocs.io/en/stable/executable.html) for further details.

If you don't use a cluster system, you don't need to edit any file. Although, a cluster is highly recommended, certain steps of the worklfow are CPU and RAM intensive (eg: `rule trimmomatic, STAR_index, STAR_align`)

#### Step 3: Execute workflow

After initializing the environment, you can test your configuration by performing a dry run with:
```bash
snakemake --use-conda --dry-run --printshellcmds
# OR
snakemake --use-conda -np
```

You can visualize the steps of the workflow with:
```bash
snakemake --dag | dot -Tpdf > dag.pdf
# OR
snakemake --dag | dot -Tsvg > dag.svg
# OR
snakemake --dag | dot -Tpng > dag.png
```

Execute the workflow in a cluster with:
```bash
snakemake -j 999 --use-conda --immediate-submit --notemp --cluster-config cluster.json --cluster 'python3 scripts/slurmSubmit.py {dependencies}'
```
If the nodes of the cluster don't have access to Internet, you will need to download all the required files. Then, you will be able to execute the worklfow in the cluster:
```bash
snakemake --until merge_chromosomes download_ensembl_gtf &&
snakemake -j 999 --use-conda --immediate-submit --notemp --cluster-config cluster.json --cluster 'python3 scripts/slurmSubmit.py {dependencies}'
```

You can execute the workflow locally using `N` cores with:
```bash
snakemake --use-conda --cores N
```

#### Step 4: Investigate results

The CPM and TPM files should be located at `data/dataset/counts/*PM_all.tsv`
