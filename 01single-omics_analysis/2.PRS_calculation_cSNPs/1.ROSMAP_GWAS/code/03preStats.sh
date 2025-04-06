#!/bin/bash

####### 根据GWAS的结果为 CN_AD CN_MCI MCI_AD 构建 sumstats.txt #######

# rsid   
# chr
# pos   
# a0 
# a1  
# beta   
# beta_se
# N
# p 


base_bim=/data/AD/data/ROSMAP/onlyCatalog/plink_eur
base_log=/data/AD/data/ROSMAP/onlyCatalog/logistic_eur
ret_sums=/data/AD/data/ROSMAP/onlyCatalog/sumstats
tmp=/data/AD/data/ROSMAP/onlyCatalog/tmp

### logistic sumstats    SNP CHR POS REF ALT OR SE PVAL N
# for nfile in CN_AD CN_MCI MCI_AD;do
#     awk '{print $2, $1, $4, $5, $6}' $base_bim/$nfile/$nfile.ovp.bim | sed '1i SNP CHR POS A1 A2' > $tmp/$nfile.sum1.txt
#     awk '{print $7, $8, $12}' $base_log/$nfile.assoc.logistic > $tmp/$nfile.sum2.txt
#     paste -d ' ' $tmp/$nfile.sum1.txt $tmp/$nfile.sum2.txt $tmp/$nfile.N.txt > $ret_sums/$nfile.sumstats.txt
# done

# 修改P 为 PVAL

# 244  554  380


# 提取1322个snp

