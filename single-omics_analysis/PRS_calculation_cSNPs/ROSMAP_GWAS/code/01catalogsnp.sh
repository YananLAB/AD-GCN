rosmap_filter=/data/AD/data/ROSMAP/wgs_gvcf/merge/plinkfilter/clean/ROSMAP.clean.filter
extract_snp=/data/AD/data/ROSMAP/onlyCatalog/plinkfilter/ext.txt
ext_ovp_snp=/data/AD/data/ROSMAP/onlyCatalog/plinkfile/ext.ovp.txt
plink_catalog=/data/AD/data/ROSMAP/onlyCatalog/plinkfile
pca_dir=/data/AD/data/ROSMAP/onlyCatalog/pca
covar_dir=/data/AD/data/ROSMAP/onlyCatalog/covar
phenotype_dir=/data/AD/data/ROSMAP/onlyCatalog/phenotype
logistic_dir=/data/AD/data/ROSMAP/onlyCatalog/logistic

# 1.catalog snp 2242  1922
# plink \
#     --bfile $rosmap_filter \
#     --extract $ext_ovp_snp \
#     --make-bed \
#     --out $plink_catalog/catalogsnps/rosmap.catalog


# # 2.split CN_AD CN_MCI MCI_AD plinkfile
# for nfile in CN_AD CN_MCI MCI_AD
# do
#     plink \
#         --bfile $plink_catalog/catalogsnps/rosmap.catalog \
#         --keep $plink_catalog/$nfile/names.txt \
#         --make-bed \
#         --export vcf \
#         --out $plink_catalog/$nfile/$nfile.SNP
# done

# 3. calculate pca
# for nfile in CN_AD CN_MCI MCI_AD
# do
#     plink \
#         --bfile $plink_catalog/$nfile/$nfile.SNP \
#         --pca 6 \
#         --out $pca_dir/$nfile \
#         --threads 20
# done


# 4.merge covar and pca.top3 (p<0.005)
# for nfile in CN_AD CN_MCI MCI_AD
# do
#     awk '{print $3,$4,$5}' $pca_dir/$nfile.eigenvec \
#         > $pca_dir/$nfile.pca.top3.txt
#     paste $covar_dir/$nfile.covar $pca_dir/$nfile.pca.top3.txt |sed 's/\s\+/ /g' \
#         > $covar_dir/$nfile.cov
# done


# 5. logistic regression
# for nfile in CN_AD CN_MCI MCI_AD
# do
#     plink \
#         --bfile $plink_catalog/$nfile/$nfile.SNP \
#         --logistic \
#         --pheno $phenotype_dir/$nfile.phe \
#         --covar $covar_dir/$nfile.cov \
#         --ci 0.95 \
#         --out $logistic_dir/$nfile/$nfile \
#         --threads 20 \
#         --hide-covar
# done









# plink \
#     --bfile /data/AD/data/ROSMAP/onlyCatalog/plinkfile/catalogsnps/rosmap.catalog \
#     --pca 6 \
#     --out /data/AD/data/ROSMAP/onlyCatalog/pca/rosmap \
#     --threads 20


# awk '{print $3,$4,$5}' /data/AD/data/ROSMAP/onlyCatalog/pca/rosmap.eigenvec \
#     > /data/AD/data/ROSMAP/onlyCatalog/pca/rosmap.pca.top3.txt
# paste /data/AD/data/ROSMAP/onlyCatalog/covar/rosmap.covar /data/AD/data/ROSMAP/onlyCatalog/pca/rosmap.pca.top3.txt |sed 's/\s\+/ /g' \
#     > /data/AD/data/ROSMAP/onlyCatalog/covar/rosmap.cov


plink \
    --bfile /data/AD/data/ROSMAP/onlyCatalog/plinkfile/catalogsnps/rosmap.catalog \
    --logistic \
    --pheno /data/AD/data/ROSMAP/onlyCatalog/phenotype/rosmap.phe \
    --covar /data/AD/data/ROSMAP/onlyCatalog/covar/rosmap.cov \
    --ci 0.95 \
    --out /data/AD/data/ROSMAP/onlyCatalog/logistic/rosmap \
    --threads 20 \
    --hide-covar