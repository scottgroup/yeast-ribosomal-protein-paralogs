

configfile: 'config.json'


__author__ = 'Gaspard Reulet'
__email__ = 'gaspard.reulet@usherbrooke.ca'
__license__ = 'MIT'


include: 'rules/bcl2fastq.smk'

rule all:
    input:
        fastq = expand(
            os.path.join(
                config['path']['fastq'],
                '{bcl_ID}'
            ),
            bcl_ID = config['download']['datasets']
        )
