if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("minfi")
BiocManager::install("IlluminaHumanMethylationEPICanno.ilm10b4.hg19")
BiocManager::install("IlluminaHumanMethylationEPICmanifest")
BiocManager::install("wateRmelon")
BiocManager::install("limma")
BiocManager::install("RPMM")
BiocManager::install("DMwR2")
BiocManager::install("ChAMP")
BiocManager::install("SWAN")

# study link : https://rdrr.io/bioc/ChAMP/man/champ.DMP.html

library(limma)
library(wateRmelon)
library(minfi)
library(IlluminaHumanMethylationEPICanno.ilm10b4.hg19)
library(IlluminaHumanMethylationEPICmanifest)
library(RPMM)
library(DMwR2)
library(ChAMP)
library(dplyr)


# 1.读取 ADNI 甲基化数据
basedir <- "/data/AD/data/ADNI/DNA_Methytion/ADNI_iDAT_files"  # 存放IDAT文件的文件夹
adniLoad <- champ.load(directory = basedir, arraytype = "EPIC")

# 2.插补NA值
adni_impute <- champ.impute(
    beta = adniLoad$beta,
    pd = adniLoad$pd,
    method = "KNN",
    k = 100)

# 3.对源于芯片中 I，II 型探针的分布进行同分布校正
adni_norm <- champ.norm(
    beta = adni_impute$beta,
    method = "BMIQ",
    arraytype = "EPIC",
    cores = 5)

# 4.使用Benjamini-Hochberg算法进行校正p值,矫正p值为0.05的显著性差异
results <- champ.DMP(
    beta = adni_norm,
    pheno = adni_impute$pd$Sample_Group,
    arraytype = "EPIC",
    adjust.method = "BH") 


com_ret_AtoC <- results$A_to_C
com_ret_AtoM <- results$A_to_M
com_ret_CtoM <- results$C_to_M

significantProbes_CtoM <- com_ret_CtoM[com_ret_CtoM$adj.P.Val < 0.001, ]
dim(significantProbes_CtoM)

# 使用 subset 函数
probes_AtoC <- subset(adni_norm, rownames(adni_norm) %in% com_probes_AtoC$Probes)
probes_AtoM <- subset(adni_norm, rownames(adni_norm) %in% com_probes_AtoM$Probes)
probes_CtoM <- subset(adni_norm, rownames(adni_norm) %in% com_probes_CtoM$Probes)
dim(probes_AtoM)
# 输出结果
# # 6085 20
# write.csv(probes_AtoC, "/data/AD/data/ADNI/methytionAnalysis/results/CN_AD/probes_AtoC.csv")
# # 7442 20
# write.csv(probes_AtoM, "/data/AD/data/ADNI/methytionAnalysis/results/MCI_AD/probes_AtoM.csv")
# # 6145 20
# write.csv(probes_CtoM, "/data/AD/data/ADNI/methytionAnalysis/results/CN_MCI/probes_CtoM.csv")


# 5.筛选出位于CpG island上的探针
islandProbes_AtoC <- com_probes_AtoC[com_probes_AtoC$cgi == "island", ]
dim(islandProbes_AtoC) # 942   20

islandProbes_AtoM <- com_probes_AtoM[com_probes_AtoM$cgi == "island", ]
dim(islandProbes_AtoM) # 961 21
str(islandProbes_AtoM$Probes)

islandProbes_CtoM <- com_probes_CtoM[com_probes_CtoM$cgi == "island", ]
dim(islandProbes_CtoM) # 2512 21

# 使用 subset 函数
specified_probes_AtoC <- subset(adni_norm, rownames(adni_norm) %in% islandProbes_AtoC$Probes)
specified_probes_AtoM <- subset(adni_norm, rownames(adni_norm) %in% islandProbes_AtoM$Probes)
specified_probes_CtoM <- subset(adni_norm, rownames(adni_norm) %in% islandProbes_CtoM$Probes)
# 输出结果
# 942   20
write.csv(specified_probes_AtoC, "/data/AD/data/ADNI/methytionAnalysis/results/CN_AD/specified_probes_AtoC.csv")
# 961   21
write.csv(specified_probes_AtoM, "/data/AD/data/ADNI/methytionAnalysis/results/MCI_AD/specified_probes_AtoM.csv")
# 2512   21
write.csv(specified_probes_CtoM, "/data/AD/data/ADNI/methytionAnalysis/results/CN_MCI/specified_probes_CtoM.csv")


