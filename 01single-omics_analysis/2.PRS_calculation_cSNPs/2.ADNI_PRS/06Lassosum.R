# library("devtools")
# install_github("tshmak/lassosum@v0.4.5")

library(lassosum)
library(data.table)
library(ggplot2)

### Read summary statistics file ###
CN_AD.ss <- fread("/data/AD/data/ROSMAP/onlyCatalog/sumstats/CN_AD.sumstats.txt")
CN_MCI.ss <- fread("/data/AD/data/ROSMAP/onlyCatalog/sumstats/CN_MCI.sumstats.txt")
MCI_AD.ss <- fread("/data/AD/data/ROSMAP/onlyCatalog/sumstats/MCI_AD.sumstats.txt")
# head(ss)

### Specify the PLINK file stub of the reference panel ###
ref.bfile <- "/data/AD/data/wkgp_EUR/plinkfile/clean_eur/wkgp.eur.cleansnps"

### Specify the PLINK file stub of the target data ###
CN_AD.bfile <- "/data/AD/data/ADNI/onlyCatalog/clean_plink/CN_AD/CN_AD.ovp"
CN_MCI.bfile <- "/data/AD/data/ADNI/onlyCatalog/clean_plink/CN_MCI/CN_MCI.ovp"
MCI_AD.bfile <- "/data/AD/data/ADNI/onlyCatalog/clean_plink/MCI_AD/MCI_AD.ovp"


### Read LD region file ###
# EUR_ldblocks <- "EUR.hg19"
# AFR_ldblocks <- "/data/AD/PRS/lassosum/LDregion/AFR.hg19.bed"

# Convert p-values to correlation coefficients using t-statistics
#  CN_AD(209/35) 874   CN_MCI(209/345) 676    MCI_AD(345/35) 792
CN_AD.cor <- p2cor(p = CN_AD.ss$P, n = 874, sign=log(CN_AD.ss$OR))
CN_MCI.cor <- p2cor(p = CN_MCI.ss$P, n = 676, sign=log(CN_MCI.ss$OR))
MCI_AD.cor <- p2cor(p = MCI_AD.ss$P, n = 792, sign=log(MCI_AD.ss$OR))
# n is the sample size
# help(p2cor)

### Running lassosum using standard pipeline ###
CN_AD_out <- lassosum.pipeline(cor=CN_AD.cor, 
                         chr=CN_AD.ss$CHR, 
                         pos=CN_AD.ss$POS, 
                         A1=CN_AD.ss$A1, 
                         A2=CN_AD.ss$A2,
                         ref.bfile=ref.bfile, 
                         test.bfile=CN_AD.bfile, 
                         LDblocks = "EUR.hg19",
                         s = c(1e-3, 1e-2, 0.1, 0.2, 0.5, 0.7, 0.9),
                         lambda = exp(seq(log(1e-4), log(0.1), length.out = 100))
)
CN_MCI_out <- lassosum.pipeline(cor=CN_MCI.cor, 
                               chr=CN_MCI.ss$CHR, 
                               pos=CN_MCI.ss$POS, 
                               A1=CN_MCI.ss$A1, 
                               A2=CN_MCI.ss$A2,
                               ref.bfile=ref.bfile, 
                               test.bfile=CN_MCI.bfile, 
                               LDblocks = "EUR.hg19",
                               s = c(1e-3, 1e-2, 0.1, 0.2, 0.5, 0.7, 0.9),
                               lambda = exp(seq(log(1e-4), log(0.1), length.out = 100))
)
MCI_AD_out <- lassosum.pipeline(cor=MCI_AD.cor, 
                               chr=MCI_AD.ss$CHR, 
                               pos=MCI_AD.ss$POS, 
                               A1=MCI_AD.ss$A1, 
                               A2=MCI_AD.ss$A2,
                               ref.bfile=ref.bfile, 
                               test.bfile=MCI_AD.bfile, 
                               LDblocks = "EUR.hg19",
                               s = c(1e-3, 1e-2, 0.1, 0.2, 0.5, 0.7, 0.9),
                               lambda = exp(seq(log(1e-4), log(0.1), length.out = 100))
)
# str(target_out)
# help(lassosum.pipeline)

## Read in the phenotype and covfile
CN_AD.pheno <- fread("/data/AD/data/ADNI/onlyCatalog/PRS/Lassosum/phecov/CN_AD.phe")
CN_AD.covar <- fread("/data/AD/data/ADNI/onlyCatalog/PRS/Lassosum/phecov/CN_AD.cov")
CN_AD.phe <- as.data.frame(CN_AD.pheno)
CN_AD.cov <- as.data.frame(CN_AD.covar)

CN_MCI.pheno <- fread("/data/AD/data/ADNI/onlyCatalog/PRS/Lassosum/phecov/CN_MCI.phe")
CN_MCI.covar <- fread("/data/AD/data/ADNI/onlyCatalog/PRS/Lassosum/phecov/CN_MCI.cov")
CN_MCI.phe <- as.data.frame(CN_MCI.pheno)
CN_MCI.cov <- as.data.frame(CN_MCI.covar)

MCI_AD.pheno <- fread("/data/AD/data/ADNI/onlyCatalog/PRS/Lassosum/phecov/MCI_AD.phe")
MCI_AD.covar <- fread("/data/AD/data/ADNI/onlyCatalog/PRS/Lassosum/phecov/MCI_AD.cov")
MCI_AD.phe <- as.data.frame(MCI_AD.pheno)
MCI_AD.cov <- as.data.frame(MCI_AD.covar)


### Add phe and cov ### 

CN_AD_v <- validate(CN_AD_out, pheno=CN_AD.phe, covar=CN_AD.cov)
CN_MCI_v <- validate(CN_MCI_out, pheno=CN_MCI.phe, covar=CN_MCI.cov)
MCI_AD_v <- validate(MCI_AD_out, pheno=MCI_AD.phe, covar=MCI_AD.cov)

# help(validate)
# str(target_v)

# EUR
print(CN_AD_v$best.s) #s=0.2
print(CN_AD_v$best.lambda) #lambda=0.05722368
print(max(CN_AD_v$validation.table$value)) # r2 = 0.0486936
write.csv(CN_AD_v$results.table,"lassosum.CN_AD-EUR.csv")

print(CN_MCI_v$best.s) #s=0.5
print(CN_MCI_v$best.lambda) #lambda=0.0869749
print(max(CN_MCI_v$validation.table$value)) # r2 = 0.1110722
write.csv(CN_MCI_v$results.table,"lassosum.CN_MCI-EUR.csv")

print(MCI_AD_v$best.s) #s=0.001
print(MCI_AD_v$best.lambda) #lambda=0.05722368
print(max(MCI_AD_v$validation.table$value)) # r2 = 0.103996
write.csv(MCI_AD_v$results.table,"lassosum.MCI_AD-EUR.csv")


### Redraw the curve between R2 and lambda in target

plotR2 <- MCI_AD_v$validation.table
plotR2$lambda <- as.numeric(as.character(plotR2$lambda))
plotR2$value <- as.numeric(as.character(plotR2$value))
ggplot(data = plotR2, aes(x = lambda, y = value, group = s, color = as.factor(s))) +
  geom_line() +  
  geom_point() +
  labs(x = "Lambda", y = "R2", title = "R2 vs. Lambda for different s(MCI_AD)") +
  theme_minimal() +
  scale_color_manual(
    values = c('0.2' = '#0089B2', '0.5' = '#FDF060',
               '0.7' = '#FFA6B2', '0.9' = "#BFF217", 
               '1' = '#60D5FD')) +
  theme(
    plot.title = element_text(hjust = 0.5, size=11),  
    panel.border = element_rect(colour = "black", fill=NA, size=0.5)  
  )+ scale_colour_discrete(name="values of s")

