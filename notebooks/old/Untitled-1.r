
library(dplyr)
taskInfo = read.csv2("../results/CellFie_Hu2025/CellFieOut/ESCC/taskInfo.csv", 
                     sep=",", stringsAsFactors = FALSE) %>%
                     setNames(c("Depth3.ID", "Depth3", "Depth1", "Depth2"))
DEG_files_H = "../results/CellFie_Hu2025/Limma/TaskDepth3/Limma_differentialAnalysis_result_Depth3.xlsx"
degs_H = lapply(openxlsx::getSheetNames(DEG_files_H), function(sheet) {
  openxlsx::read.xlsx(DEG_files_H, sheet = sheet) %>% 
    mutate(Cancer_type=sheet) %>%
    left_join(taskInfo %>% mutate(Task=Depth3))
}) %>% Reduce(rbind, .)

head(degs_H)


# Hu2025 metabolic task score datasets
cfs = readRDS("../results/CellFie_Hu2025/Summary/cfs.RDS")
head(cfs)
Sample_meta_Hu2025 = readRDS(
    "../results/CellFie_Hu2025/data/Hu2025/Meta_hu2025.RDS")
table(cfs$Group)
sub = cfs %>% filter(Group %in% grep("_NAT", Group, value=T))
head(sub)
sub = sub %>% dplyr::select(Sample, Depth3, TaskScore) %>%
    tidyr::spread(key=Sample, value=TaskScore) %>%
    tibble::column_to_rownames("Depth3") %>% as.data.frame()
head(sub)
# write an example of spread()
example_wide = sub %>% dplyr::select(Sample, Depth3, TaskScore) %>%
    tidyr::spread(key=Depth3, value=TaskScore)

pdf("Test.pdf")
lapply(1:20, function(i) {
    print(hist(sub[i,]%>%as.numeric()%>%log2()))
})
dev.off()

library(ggplot2)
pdf("Test.pdf")
lapply(1:100, function(i) {
    # sub[i,] %>% as.numeric() %>% log2() %>% shapiro.test() %>% print()
    # mean = mean(sub[i,] %>% as.numeric())
    # var = var(sub[i,] %>% as.numeric())
    # var/mean
    x = sub[i,] %>% as.numeric() 
    ggplot(data.frame(x), aes(x)) +
    geom_histogram(aes(y = ..density..), bins = 30, fill = "lightblue", color = "black") +
    stat_function(fun = dnorm, args = list(mean = mean(x), sd = sd(x)), col = "red", size = 1)

})
dev.off()


library(fitdistrplus)
pdf("Test_gamma.pdf")
lapply(1:100, function(i) {
    # sub[i,] %>% as.numeric() %>% log2() %>% shapiro.test() %>% print()
    # mean = mean(sub[i,] %>% as.numeric())
    # var = var(sub[i,] %>% as.numeric())
    # var/mean
    x = sub[i,] %>% as.numeric()
    x = sqrt(x + 0.01)
    fit_gamma = fitdist(x, "gamma")
    print(plot(fit_gamma))
    # ggplot(data.frame(x), aes(x)) +
    # geom_histogram(aes(y = ..density..), bins = 30, fill = "lightblue", color = "black") +
    # stat_function(fun = dnorm, args = list(mean = mean(x), sd = sd(x)), col = "red", size = 1)
})
dev.off()

pdf("Test_normal.pdf")
lapply(1:100, function(i) {
    # sub[i,] %>% as.numeric() %>% log2() %>% shapiro.test() %>% print()
    # mean = mean(sub[i,] %>% as.numeric())
    # var = var(sub[i,] %>% as.numeric())
    # var/mean
    x = sub[i,] %>% as.numeric()
    x = sqrt(x + 0.01)
    x = log2(x + 0.01)
    fit_normal = fitdist(x, "norm")
    print(plot(fit_normal))
    shapiro.test(x) %>% print()
    # ggplot(data.frame(x), aes(x)) +
    # geom_histogram(aes(y = ..density..), bins = 30, fill = "lightblue", color = "black") +
    # stat_function(fun = dnorm, args = list(mean = mean(x), sd = sd(x)), col = "red", size = 1)
})
dev.off()


pdf("Test_lnormal.pdf")
lapply(1:100, function(i) {
    # sub[i,] %>% as.numeric() %>% log2() %>% shapiro.test() %>% print()
    # mean = mean(sub[i,] %>% as.numeric())
    # var = var(sub[i,] %>% as.numeric())
    # var/mean
    x = sub[i,] %>% as.numeric()
    x = sqrt(x + 0.01)
    fit_lnormal = fitdist(x, "lnorm")
    print(plot(fit_lnormal))
    # ggplot(data.frame(x), aes(x)) +
    # geom_histogram(aes(y = ..density..), bins = 30, fill = "lightblue", color = "black") +
    # stat_function(fun = dnorm, args = list(mean = mean(x), sd = sd(x)), col = "red", size = 1)
})
dev.off()

limma_results = readRDS("../results/CellFie_Hu2025/Limma/TaskDepth3/result3.RDS")
fitted_vals = fitted(limma_results$rlst_list$ESCC$fitted.model)
# residuals = observed - fitted
res = limma_results$rlst_list$ESCC$data - fitted_vals

pdf("Shapiro_residuals.pdf")
padj = sapply(1:500, function(i) {
   x = as.numeric(res[i,])
   normT = shapiro.test(x)
   normT$p.value 
}) %>% na.omit() %>% p.adjust(method="BH") 
mean(padj)
