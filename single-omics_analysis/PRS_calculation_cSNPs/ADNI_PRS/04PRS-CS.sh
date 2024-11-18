###add rsIDS to plink
# IID SNP
adni_plink=/data/AD/data/ADNI/onlyCatalog/clean_plink
rsIDF=/data/AD/data/ADNI/onlyCatalog/PRS/PRS-CS/rsID.txt
rs_plink=/data/AD/data/ADNI/onlyCatalog/rs_plink
sumstats=/data/AD/data/ROSMAP/onlyCatalog/sumstats

# step1: 将CN_AD CN_MCI MCI_AD 的plink文件的SNP转化为rs号，以及各自的GWAS结果中的SNP也变成rs号

for nfile in CN_AD CN_MCI MCI_AD;do
    (1)更改plink文件 
    awk 'BEGIN{FS=OFS="\t"}
        FNR==NR {rs[$1]=$2; next}
        /^#/ {print; next}
        {chrom_pos_a1_a2=$3; if(chrom_pos_a1_a2 in rs) $3=rs[chrom_pos_a1_a2]; print}' \
        $rsIDF $adni_plink/${nfile}/${nfile}.ovp.vcf \
        > $rs_plink/${nfile}/${nfile}.rsID.vcf
    
    plink \
        --vcf $rs_plink/${nfile}/${nfile}.rsID.vcf \
        --make-bed \
        --out $rs_plink/${nfile}/${nfile}.rsID \
        --const-fid

    (2)更改sumstats文件   对应SNP	A1	A2	OR	P
    awk 'BEGIN{FS=OFS="\t"}
        FNR==NR {rs[$1]=$2; next}
        /^#/ {print; next}
        {
            chrom_pos_a1_a2=$1; 
            if(chrom_pos_a1_a2 in rs) $1=rs[chrom_pos_a1_a2]; 
            print $1,$4,$5,$6,$8
        }' \
        $rsIDF $sumstats/${nfile}.sumstats.txt \
        > $sumstats/${nfile}.sumstats.rsID.txt
done








# study link :https://github.com/getian107/PRScs
# link2 : https://www.cog-genomics.org/plink/1.9/score


adni_bed=/data/AD/data/ADNI/onlyCatalog/rs_plink
rosmap_sum=/data/AD/data/ROSMAP/onlyCatalog/sumstats
postBeta_dir=/data/AD/data/ADNI/onlyCatalog/PRS/PRS-CS/postBeta
eur_ld=/data/AD/data/ADNI/onlyCatalog/tools/ldblk_1kg_eur
 
# step2：计算后验效应值
### 全局比例系数 ：1e-1, 1.5e-2, 1e-2, 1.5e-3, 1e-3, 1e-4, 1e-6
# 最优结果：eur的phi=1e-2  1.5e-2  1e-4
# CN_AD(209/35) 874   CN_MCI(209/345) 676    MCI_AD(345/35) 792
python /data/AD/data/ADNI/onlyCatalog/tools/PRScs/PRScs.py \
    --ref_dir $eur_ld \
    --bim_prefix $adni_bed/CN_AD/CN_AD.rsID \
    --sst_file $rosmap_sum/CN_AD.sumstats.rsID.txt \
    --n_gwas 874 \
    --out_dir $postBeta_dir/CN_AD/CN_AD \
    --phi 1e-2 \
    --seed 123

python /data/AD/data/ADNI/onlyCatalog/tools/PRScs/PRScs.py \
    --ref_dir $eur_ld \
    --bim_prefix $adni_bed/CN_MCI/CN_MCI.rsID \
    --sst_file $rosmap_sum/CN_MCI.sumstats.rsID.txt \
    --n_gwas 676 \
    --out_dir $postBeta_dir/CN_MCI/CN_MCI \
    --phi 1.5e-2 \
    --seed 123

python /data/AD/data/ADNI/onlyCatalog/tools/PRScs/PRScs.py \
    --ref_dir $eur_ld \
    --bim_prefix $adni_bed/MCI_AD/MCI_AD.rsID \
    --sst_file $rosmap_sum/MCI_AD.sumstats.rsID.txt \
    --n_gwas 792 \
    --out_dir $postBeta_dir/MCI_AD/MCI_AD \
    --phi 1e-4 \
    --seed 123
 
# 结果：rsID，碱基位置，A1，A2 与后验效应量估计值

# step3: 计算PRS
adni_pheno=/data/AD/data/ADNI/onlyCatalog/PRS/PRS-CS/phe
adni_covar=/data/AD/data/ADNI/onlyCatalog/PRS/PRS-CS/cov
scores=/data/AD/data/ADNI/onlyCatalog/PRS/PRS-CS/scores

# 1e-04 2e-03 1e-02 1e-01  2e-02
for nfile in CN_AD CN_MCI MCI_AD;do
    plink \
        --bfile $adni_bed/$nfile/$nfile.rsID \
        --score $postBeta_dir/$nfile/${nfile}_phi1e-02_merged.txt 2 4 6 \
        --pheno $adni_pheno/$nfile.phe \
        --all-pheno \
        --allow-no-sex \
        --out $scores/$nfile.prscs1e-02
done

