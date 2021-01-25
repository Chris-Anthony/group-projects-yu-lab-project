# *CellRanger related scripts*

### *Authors:* Alyx Gray, Chris Chua, & Matt Chang

#### *Brief background on sequencing data*

Tissue was from the olfactory epithelium of a 10-day old mouse. 10X Chromium version 2 was used.

#### *Trimming R1 by one nucleotide base*

Read 1 contained the cell barcode (C) and the unique molecular identifier (UMI) (U). There is a 16-nucleotide cell barcode and a 10-nucleotide UMI, situated as such:

CCCCCCCCCCCCCCCCUUUUUUUUUU

Original concactenated FASTQ reads have 27 nucleotides in the sequence portion of Read 1. These reads need to have the last nucleotide removed before downstream analysis can begin. 

```
#!/bin/bash
#SBATCH --partition=bgmp        
#SBATCH --cpus-per-task=1       
#SBATCH --account=bgmp          

/usr/bin/time -v zcat L35291_S1_L001_R1_001.fastq.gz | sed '2~4s/[ATCGN]$//' | sed '4~4s/[!-J]$//' > L35291_Trimmed_S1_L001_R1_001.fastq

/usr/bin/time -v gzip L35291_Trimmed_S1_L001_R1_001.fastq

/usr/bin/time -v mv L35291_Trimmed_S1_L001_R1_001.fastq.gz TrimmedFull/

```

#### *Running CellRanger counts pipeline:*

Takes the FASTQ files and aligns, filters, counts barcodes and UMIs. 
Outputs the feature-barcode matrices for downstream analysis (in Seurat).

```
#!/usr/bin/env bash

#SBATCH --job-name=cellrangerV4_count_%j
#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output=cellrangerV4_count_%j.out
#SBATCH --error=cellrangerV4_count_%j.err
#SBATCH --time=1-23:59:59
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G

conda activate bgmp_py37

dir="/projects/bgmp/shared/groups/2020/neuron_nerds"

/usr/bin/time -v \
$dir/CellRanger/cellranger-4.0.0/bin/cellranger count \
--id=Full_trimmed_count \
--fastqs=$dir/full_data/TrimmedFull \
--sample=L35291_Trimmed \
--transcriptome=$dir/refdata-gex-mm10-2020-A \
--localcores=8 \
--localmem=64

```