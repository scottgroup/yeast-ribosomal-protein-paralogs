import os

rule feature_counts:
    input:
        genome = rules.merge_chromosomes.output.genome,
        gtf = rules.create_gtf.output.gtf,
        bam = rules.STAR_align.output.bam
    output:
        csv = os.path.join(config['path']['counts'], '{sample_ID}.tsv')
    conda:
        '../envs/subread.yaml'
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
        ' -o {output.csv}'
        ' {input.bam}'
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
