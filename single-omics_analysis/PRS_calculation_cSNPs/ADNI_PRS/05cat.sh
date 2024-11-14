cd /data/AD/data/ADNI/onlyCatalog/PRS/PRS-CS/postBeta
#/CN_AD/CN_AD_pst_eff_a1_b0.5_phi1e-04_chr1.txt
nfile=CN_AD
# CN_AD   CN_MCI    MCI_AD
# 1e-4 :1e-04
# 1.5e-3 :2e-03
# 1e-2 :1e-02
# 1e-1 :1e-01
# for nfile in CN_AD CN_MCI MCI_AD;do
cat ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr1.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr2.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr3.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr4.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr5.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr6.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr7.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr8.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr9.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr10.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr11.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr12.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr13.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr14.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr15.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr16.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr17.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr18.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr19.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr20.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr21.txt \
    ./${nfile}/${nfile}_pst_eff_a1_b0.5_phi1e-02_chr22.txt \
    > ./${nfile}/${nfile}_phi1e-02_merged.txt
# done