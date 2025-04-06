rosmap_filter=/data/AD/data/ROSMAP/wgs_gvcf/merge/plinkfilter/clean/ROSMAP.clean.filter
extract_snp=/data/AD/data/ROSMAP/onlyCatalog/plinkfilter/ext.txt
ext_ovp_snp=/data/AD/data/ROSMAP/onlyCatalog/plinkfile/ext.ovp.txt
plink_catalog=/data/AD/data/ROSMAP/onlyCatalog/plinkfile
pca_dir=/data/AD/data/ROSMAP/onlyCatalog/pca
covar_dir=/data/AD/data/ROSMAP/onlyCatalog/covar
phenotype_dir=/data/AD/data/ROSMAP/onlyCatalog/phenotype
logistic_dir=/data/AD/data/ROSMAP/onlyCatalog/logistic

####在本脚本中，我们基于catalog提取的snp,将ROSMAP数据集分成三个子集：CN_MCI、MCI_AD、CN_AD######
####然后分别准备每一组用于GWAS分析的plink、covar和phe文件。######

# # 1.catalog snp
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

# # 3. calculate pca
# for nfile in CN_AD CN_MCI MCI_AD
# do
#     plink \
#         --bfile $plink_catalog/$nfile/$nfile.SNP \
#         --pca 6 \
#         --out $pca_dir/$nfile \
#         --threads 20
# done


# # 4.merge covar and pca.top3
# for nfile in CN_AD CN_MCI MCI_AD
# do
#     awk '{print $3,$4,$5}' $pca_dir/$nfile.eigenvec \
#         > $pca_dir/$nfile.pca.top3.txt
#     paste $covar_dir/$nfile.covar $pca_dir/$nfile.pca.top3.txt |sed 's/\s\+/ /g' \
#         > $covar_dir/$nfile.cov
# done



