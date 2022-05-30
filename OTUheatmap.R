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
meta<-args[2]
taxonomy<-args[3]
otu <- read.delim(input, row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE)

info <- read.delim(meta, row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE)

tax_its <- read.delim(taxonomy, row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE)
 ###去除一些低丰度OTU，在至少i个样本中具有至少j个序列
# otu <- read.delim('taxa.OTU.Count', row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE)
#otu_its_t <- otu[,which(colSums(otu >= j) >= i)] 这两步在读入文件时已操作
i<-0.5*nrow(otu)
i
otu_its_t <- otu[,which(colSums(otu >= 10) >= i)]  ##多于10个read 且存在于50%以上得样本中
otu_its_t=as.data.frame(otu_its_t/rowSums(otu_its_t)*100)
write.csv(otu_its_t, 'otu_its_t.csv', quote = FALSE)
anno_col = data.frame(Group = tax_its, row.names = rownames(tax_its))
anno_row = data.frame(Group = info, row.names = rownames(info))
#scale_test <- apply(otu_its_t, 2, function(x) log2(x+1))

###如果要指定颜色
#ann_colors = list(
#    Group = c(Q = "#1B9E77", Z = "#D95F02"))
#pheatmap(mat=scale_test,
#  treeheight_col=15,treeheight_row=15,
#  annotation_names_row= T,annotation_names_col=T,
#  annotation_col = anno_col,annotation_row = anno_row,annotation_colors = ann_colors,
#  filename = paste("heatmap.OTU.filter_log2.pdf", sep=""),width=20, height=38)

#热力图
otu_all <- otu[,which(colSums(otu >= 10) >= 0.1*nrow(otu))]  ##多于10个read 且存在于10%以上得样本中
otu_all=as.data.frame(otu_all /rowSums(otu_all )*100)

pheatmap(mat=otu_all,
  treeheight_col=15,treeheight_row=15,
  annotation_names_row= T,annotation_names_col=T,
  annotation_col = anno_col,annotation_row = anno_row,
  filename = paste("heatmap.OTU.all.pdf", sep=""),width=20, height=38)

  ####filter后热力图
pheatmap(mat=scale_test,
  treeheight_col=15,treeheight_row=15,
  annotation_names_row= T,annotation_names_col=T,
  annotation_col = anno_col,annotation_row = anno_row,
  filename = paste("heatmap.OTU.filter_log2.pdf", sep=""),width=20, height=38)
pheatmap(mat=otu_its_t,
  treeheight_col=15,treeheight_row=15,
  annotation_names_row= T,annotation_names_col=T,
  annotation_col = anno_col,annotation_row = anno_row,
  filename = paste("heatmap.OTU.filter.pdf", sep=""),width=20, height=38)
sort <- colSums(otu_its_t)
otu_order <- otu_its_t[, order(sort, decreasing=TRUE)]
##top20 OTU
mat <- otu_order[1:20]
pheatmap(mat,
  treeheight_col=15,treeheight_row=15,
  annotation_names_row= T,annotation_names_col=T,
  annotation_col = anno_col,annotation_row = anno_row,
  filename = paste("heatmap.OTU.top20.pdf", sep=""),width=20, height=38,
  fontsize=7,display_numbers=T)
# log2 转换，通常百万比经常log2转换，数据范围由1-1000000变为1-20
scale_test <- apply(mat, 2, function(x) log2(x+1))
pheatmap(mat=scale_test, treeheight_col=15,treeheight_row=15,
  annotation_names_row= T,annotation_names_col=T,
  annotation_col = anno_col,annotation_row = anno_row,
         filename="pheatmap_OTU_top20_sample_log2.pdf", width=20, height=38)

##top100 OTU
mat <- otu_order[1:100]
pheatmap(mat=mat,
  treeheight_col=15,treeheight_row=15,
  annotation_names_row= T,annotation_names_col=T,
  annotation_col = anno_col,annotation_row = anno_row,
  filename = paste("heatmap.OTU.top100.pdf", sep=""),width=20, height=38,
  fontsize=7,display_numbers=T)
# log2 转换，通常百万比经常log2转换，数据范围由1-1000000变为1-20
scale_test <- apply(mat, 2, function(x) log2(x+1))
pheatmap(mat=scale_test, treeheight_col=15,treeheight_row=15,
  annotation_names_row= T,annotation_names_col=T,
  annotation_col = anno_col,annotation_row = anno_row,
         filename="pheatmap_OTU_top100_sample_log2.pdf", width=20, height=38)


