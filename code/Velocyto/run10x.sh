#!/usr/bin/bash
#SBATCH --partition=bgmp        ### Partition (like a queue in PBS)
#SBATCH --job-name=VelocytoRun10x    ### Job Name
#SBATCH --output=OUT_%j.txt        ### File in which to store job output
#SBATCH --error=ERR_%j.txt         ### File in which to store job error messages
#SBATCH --time=1-00:00:00       ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1               ### Number of nodes needed for the job
#SBATCH --ntasks-per-node=1     ### Number of tasks to be launched per Node
#SBATCH --account=bgmp          ### Account used for job submission
#SBATCH --mem=40G
#SBATCH --cpus-per-task=4

conda activate velocyto



cd /projects/bgmp/shared/groups/2020/neuron_nerds/matt/Velocyto


LC_ALL=en_US
export LC_ALL


/usr/bin/time -v velocyto run10x /projects/bgmp/shared/groups/2020/neuron_nerds/CellRanger/cellranger-4.0.0/FullCounts/ /projects/bgmp/shared/groups/2020/neuron_nerds/refdata-gex-mm10-2020-A/genes/genes.gtf

