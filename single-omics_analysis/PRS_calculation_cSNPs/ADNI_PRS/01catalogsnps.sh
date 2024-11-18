adni_filter=/data/AD/data/ADNI/WGS_Omni2.5M/merge/plinkfilter/ADNI.clean.filter
extract_snp=/data/AD/data/ADNI/onlyCatalog/plinkfile/ext.txt
ext_ovp_snp=/data/AD/data/ROSMAP/onlyCatalog/plinkfile/ext.ovp.txt
plink_catalog=/data/AD/data/ADNI/onlyCatalog/plinkfile
pca_dir=/data/AD/data/ADNI/onlyCatalog/pca
covar_dir=/data/AD/data/ADNI/onlyCatalog/covar

# 1.catalog snp 2242  1922 
plink \
    --bfile $adni_filter \
    --extract $ext_ovp_snp \
    --make-bed \
    --out $plink_catalog/catalogsnps/adni.catalog

# # # 2.split CN_AD CN_MCI MCI_AD plinkfile
for nfile in CN_AD CN_MCI MCI_AD
do
    plink \
        --bfile $plink_catalog/catalogsnps/adni.catalog \
        --keep $plink_catalog/$nfile/names.txt \
        --make-bed \
        --export vcf \
        --out $plink_catalog/$nfile/$nfile.SNP
done

# 3. calculate pca
for nfile in CN_AD CN_MCI MCI_AD
do
    plink \
        --bfile $plink_catalog/$nfile/$nfile.SNP \
        --pca 6 \
        --out $pca_dir/$nfile \
        --threads 20
done


# 4.merge covar and pca.top3 (p<0.005)
for nfile in CN_AD CN_MCI MCI_AD
do
    awk '{print $3,$4,$5}' $pca_dir/$nfile.eigenvec \
        > $pca_dir/$nfile.pca.top3.txt
    paste $covar_dir/$nfile.covar $pca_dir/$nfile.pca.top3.txt |sed 's/\s\+/ /g' \
        > $covar_dir/$nfile.cov
done








### 1322 snp 拆分
# adni_plink=/data/AD/data/ADNI/onlyCatalog/clean_plink
# for nfile in CN_AD CN_MCI MCI_AD
# do
#     plink \
#         --bfile $adni_plink/clean/adni.cleansnps \
#         --keep $adni_plink/$nfile/names.txt \
#         --make-bed \
#         --export vcf \
#         --out $adni_plink/$nfile/$nfile.ovp
# done