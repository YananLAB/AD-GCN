#!/bin/bash

## study link : https://github.com/bvilhjal/ldpred/tree/master
### https://github.com/EnricMartin/LDpred_PRS_tutoral

## clean adni(1322 snps)
clean_snp=/data/AD/data/ADNI/onlyCatalog/clean_plink/clean.snps.txt
# plink \
#     --bfile /data/AD/data/ADNI/onlyCatalog/plinkfile/catalogsnps/adni.catalog \
#     --extract $clean_snp \
#     --make-bed \
#     --out /data/AD/data/ADNI/onlyCatalog/clean_plink/adni.cleansnps

## ldpred
wkgp_eur_plink=/data/AD/data/wkgp_EUR/plinkfile/clean_eur/wkgp.eur.cleansnps
wkgp_eur_ld=/data/AD/data/wkgp_EUR/LDpanel/ld_wkgp_eur.ld
rosmap_sumstats=/data/AD/data/ROSMAP/onlyCatalog/sumstats
out_coord=/data/AD/data/ADNI/onlyCatalog/PRS/Ldpred/hdf5s


# Step 1 导入数据  CN_AD(209/35) 874   CN_MCI(209/345) 676    MCI_AD(345/35) 792
ldpred coord \
    --gf $wkgp_eur_plink \
    --ssf $rosmap_sumstats/MCI_AD.sumstats.txt \
    --out $out_coord/MCI_AD.coord.hdf5 \
    --N 792 \
    --chr CHR \
    --pos POS \
    --rs SNP \
    --A1 A1 \
    --A2 A2 \
    --pval P \
    --se SE \
    --eff OR \
    --eff_type OR


# SNP CHR POS A1 A2 OR SE P N


# awk '{print $2}' $wkgp_eur_plink.bim | sort > plink_snps.txt
# awk '{print $1}' $rosmap_sumstats/CN_AD.clean.stats.txt | sort > sumstats_snps.txt
# comm -23 sumstats_snps.txt plink_snps.txt > missing_snps.txt


 
# step 2 生成 LDpred SNP 权重  CN_AD   CN_MCI    MCI_AD
out_weights=/data/AD/data/ADNI/onlyCatalog/PRS/Ldpred/weights

for i in 1e-4 5e-4 1e-3 5e-3;do
    ldpred gibbs \
        --cf $out_coord/CN_MCI.coord.hdf5 \
        --ldr 1000 \
        --f $i \
        --ldf $wkgp_eur_ld \
        --out $out_weights/CN_MCI/CN_MCI.weights
done

adni_plink=/data/AD/data/ADNI/onlyCatalog/clean_plink
adni_pheno=/data/AD/data/ADNI/onlyCatalog/PRS/Ldpred/phe
adni_covar=/data/AD/data/ADNI/onlyCatalog/PRS/Ldpred/cov
out_scores=/data/AD/data/ADNI/onlyCatalog/PRS/Ldpred/scores


# step 3 生成PRS
for nfile in CN_AD CN_MCI MCI_AD;do
    ldpred score \
        --gf $adni_plink/$nfile/$nfile.ovp \
        --rf $out_weights/$nfile/$nfile.weights \
        --out $out_scores/$nfile/$nfile.ldpred.scores.txt \
        --pf $adni_pheno/$nfile.phe \
        --cov-file $adni_covar/$nfile.cov
done
