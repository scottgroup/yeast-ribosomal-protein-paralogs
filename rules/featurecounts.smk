import os

rule feature_counts:
    input:
        genome = rules.merge_chromosomes.output.genome,
        gtf = os.path.join(config['path']['gtf'], '{annotation}.gtf'),
        bam = rules.STAR_align.output.bam
    output:
        tsv = os.path.join(
            config['path']['counts'],
            '{annotation}',
            '{sample_ID}.tsv'
        )
    params:
        script = '../scripts/count_to_cpm_tpm_v3.py',
        temp_tsv = os.path.join(
            config['path']['counts'],
            '{annotation}',
            'temp_{sample_ID}.tsv'
        ),
        max_read_size = '75'
    conda:
        '../envs/featurecounts.yaml'
    threads:
        12
    log:
    shell:
        'featureCounts -T {threads}'
        ' --minOverlap 10'
        ' -p'                   # Is paired end
        ' -B'                   # Only count read pairs with both ends aligned
        ' -C'                   # Chimeric fragments NOT counted
        ' -s 2'                 # Strand specific read counting 2 = reversely stranded???
        ' -F GTF'
        ' -t exon'
        ' -g gene_id'
        ' -a {input.gtf}'
        ' -G {input.genome}'
        ' -o {params.temp_tsv}'
        ' {input.bam}'
        ' && tail -n +2 {params.temp_tsv}'
        ' | python3 {params.script} - {input.gtf} {params.max_read_size}'
        ' > {output.tsv}'
        ' && rm {params.temp_tsv}'


        # Rsubread featureCounts(Aligned.sortedByCoord.out.bam,
        # genome=Saccharomyces_cerevisiae.R64-1-1.dna.chromosome.all.fa,
        # annot.ext=Saccharomyces_cerevisiae.R64-1-1.90.gtf,
        # isGTFAnnotationFile=TRUE,
        # GTF.featureType="exon",
        # GTF.attrType="gene_id",
        # countChimericFragments=FALSE,
        # largestOverlap=FALSE,
        # isPairedEnd=TRUE,
        # useMetaFeatures=TRUE,
        # requireBothEndsMapped=TRUE,
        # strandSpecific=2,
        # minOverlap=10,
        # autosort=TRUE,
        # allowMultiOverlap=FALSE,
        # reportReads=TRUE,
        # juncCounts=FALSE,
        # fraction=FALSE,
        # countMultiMappingReads=FALSE)
