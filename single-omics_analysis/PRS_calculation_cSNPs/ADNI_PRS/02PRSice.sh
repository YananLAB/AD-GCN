#!/bin/bash

# This script is used to run PRSice R package for GWAS analysis.
# PRSice document link : https://github.com/choishingwan/PRSice/blob/master/docs/command_detail.md
# refrence : https://blog.csdn.net/yijiaobani/article/details/127488997

prsice_dir=/data/AD/data/ADNI/onlyCatalog/PRS/PRSice
base_gwas=/data/AD/data/ROSMAP/onlyCatalog/logistic
target_bfile=/data/AD/data/ADNI/onlyCatalog/plinkfile
target_pheno=/data/AD/data/ADNI/onlyCatalog/phenotype
target_covar=/data/AD/data/ADNI/onlyCatalog/covar


for nfile in CN_AD CN_MCI MCI_AD
do
    mkdir -p $prsice_dir/$nfile
    Rscript /data/AD/data/ADNI/onlyCatalog/tools/PRSice/PRSice.R \
        --dir /data/AD/data/ADNI/onlyCatalog/tools/PRSice \
        --prsice /data/AD/data/ADNI/onlyCatalog/tools/PRSice/PRSice_linux \
        --base $base_gwas/$nfile/$nfile.assoc.logistic \
        --target $target_bfile/$nfile/$nfile.SNP \
        --pheno $target_pheno/$nfile.phe \
        --cov $target_covar/$nfile.cov \
        --lower 1.9e-3 \
        --thread 20 \
        --stat OR \
        --or \
        --binary-target T \
        --out $prsice_dir/$nfile/$nfile
done

