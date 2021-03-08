# *CellRanger related scripts*

### *Authors:* Alyx Gray, Chris Chua, & Matt Chang

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

# *Summarized CellRanger Web Summary*

| **Cells** |     |
|-----      |-----|
| Est. Number of Cells      | 9,149 |
| Fraction Reads in Cells   | 65.8% |
| Mean Reads per Cell       | 38,189 |
| Median Genes per Cell     | 1,738 |
| Total Genes Detected      | 23,280 |
| Median UMI Counts per Cell | 3,343 |

| **Sequencing** |     |
|-----           |-----|
| Number of Reads       | 349,389,544 |
| Valid Barcodes        | 97.1% |
| Valid UMIs            | 99.9% |
| Sequencing Saturation | 75.3% |
| Q30 Bases in Barcode  | 96.7% |
| Q30 Bases in RNA Read | 88.5% |
| Q30 Bases in UMI      | 97.2% |


| **Mapping** |       |
|-----        |-----  |
| Reads Mapped to Genome                        | 96.2% |
| Reads Mapped Confidently to Genome            | 92.9% |
| Reads Mapped Confidently to Intergenic Regions | 3.9%|
| Reads mapped Confidently to Intronic Regions  | 17.7% |
| Reads Mapped Confidently to Exonic Regions    | 71.3% |
| Reads Mapped Confidently to Transcriptome     | 67.9% |
| Reads Mapped Antisense to Gene                | 2.1% |

