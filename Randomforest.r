#! /usr/bin/env Rscript
library("ggplot2") # load related packages
library(randomForest)

args=commandArgs(T)
input<-args[1]
meta<-args[2]
#genus<- read.delim("Genus.txt", row.names = 1,sep = '\t', stringsAsFactors = TRUE, check.names = FALSE)
genus<- read.delim(input, row.names = 1,sep = '\t', stringsAsFactors = TRUE, check.names = FALSE)
# 颠倒矩阵genus<-t(genus)
#info <- read.delim("sample.group", row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE)
info <- read.delim(meta, row.names = 1, sep = '\t', stringsAsFactors = TRUE, check.names = FALSE)
##对于otu需先筛选 otu_its_t <- otu[,which(colSums(otu >= 5) >= 5)]
genus_its_t <- log2(genus+ 1)

cmp<-merge(info,genus_its_t,  by = "row.names", all = TRUE)
set.seed(315)
cmpfilter<-cmp[,-1]
rf = randomForest(Group ~ ., data=cmpfilter, importance=TRUE,proximity=TRUE,, ntree=1000, keep.forest=FALSE)
result = rfcv(cmpfilter, cmpfilter$Group, cv.fold=10)
result$error.cv
imp= as.data.frame(rf$importance)
imp = imp[order(imp[,1],decreasing = T),]
rffig<-varImpPlot(rf, main = "Top 5 - Feature importance",n.var = 5, bg = par("bg"),
           color = par("fg"), gcolor = par("fg"), lcolor = "gray" )
write.csv(rffig, 'random_forest.csv', quote = FALSE)

pdf()
