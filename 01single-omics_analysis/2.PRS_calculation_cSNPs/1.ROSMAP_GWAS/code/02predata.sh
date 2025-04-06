# 直接按照 onlyCatalog 中划分好的名字，来提取对应的plink文件，phe和cov文件都可以沿用之前划分好的，然后重新计算GWAS

#!/bin/bash

extract_snp=/data/AD/data/ROSMAP/onlyCatalog/plinkfilter/ext.txt
ext_ovp_snp=/data/AD/data/ROSMAP/onlyCatalog/plink_eur/clean.snps.txt
plink_catalog=/data/AD/data/ROSMAP/onlyCatalog/plinkfile
overlap_dir=/data/AD/data/ROSMAP/onlyCatalog/plink_eur
pca_dir=/data/AD/data/ROSMAP/onlyCatalog/pca
covar_dir=/data/AD/data/ROSMAP/onlyCatalog/covar
phenotype_dir=/data/AD/data/ROSMAP/onlyCatalog/phenotype
logistic_eur=/data/AD/data/ROSMAP/onlyCatalog/logistic_eur

# # 1.catalog overlap snp 1322
# for nfile in CN_AD CN_MCI MCI_AD
# do
#     plink \
#         --bfile $plink_catalog/$nfile/$nfile.SNP \
#         --extract $ext_ovp_snp \
#         --make-bed \
#         --out $overlap_dir/$nfile/$nfile.ovp
# done



# # # 2. logistic 关联分析
# for nfile in CN_AD CN_MCI MCI_AD
# do
#     plink \
#         --bfile $overlap_dir/$nfile/$nfile.ovp \
#         --logistic \
#         --pheno $phenotype_dir/$nfile.phe \
#         --covar $covar_dir/$nfile.cov \
#         --ci 0.95 \
#         --out $logistic_eur/$nfile \
#         --threads 20 \
#         --hide-covar
# done

