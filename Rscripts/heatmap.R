#! /usr/bin/env Rscript
library("ggplot2") # load related packages
library("grid")
library("scales")
library("vegan")
library("agricolae")
library("gridExtra")
library("dplyr")
library("ggrepel")
library("gggenes")
library("ggsignif")
library("pheatmap")
library(reshape2)
library(picante)      #picante 包加载时默认同时加载 vegan
args=commandArgs(T)
input<-args[1]
#meta<-args[2]
#taxonomy<-args[3]
otu <- read.delim(input, row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE)
info<-otu[,1]
otu<-otu[,-1]
otu_its_t <- otu[,which(colSums(otu >= 0) >= 0)]
scale_test <- apply(otu_its_t , 2, function(x) log2(x+1))
anno_row = data.frame(Group = info, row.names = rownames(otu))
###如果要指定颜色
#ann_colors = list(
#    Group = c(Q = "#1B9E77", Z = "#D95F02"))
#pheatmap(mat=scale_test,
#  treeheight_col=15,treeheight_row=15,
#  annotation_names_row= T,annotation_names_col=T,
#  annotation_col = anno_col,annotation_row = anno_row,annotation_colors = ann_colors,
#  filename = paste("heatmap.OTU.filter_log2.pdf", sep=""),width=20, height=38)


#otu_its_t
write.csv(otu_its_t, 'otu_its_t.csv', quote = FALSE)
pheatmap(mat=otu_its_t,
  treeheight_row=15,cluster_cols = FALSE,
  annotation_names_row= T,
  annotation_row = anno_row,
  filename = paste("heatmap.stable.all.pdf", sep=""),width=20, height=38)

  ####filter后热力图
pheatmap(mat=scale_test,
  treeheight_row=15,cluster_cols = FALSE,
  annotation_names_row= T,
  annotation_row = anno_row,
  filename = paste("heatmap.log2.all.pdf", sep=""),width=20, height=38)

