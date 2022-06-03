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

 ##构建函数
alpha <- function(x, tree = NULL, base = exp(1)) {
       est <- estimateR(x)
       Richness <- est[1, ]
       Chao1 <- est[2, ]
       ACE <- est[4, ]
       Shannon <- diversity(x, index = 'shannon', base = base)
       Simpson <- diversity(x, index = 'simpson')    #Gini-Simpson 指数
       Pielou <- Shannon / log(Richness, base)
       goods_coverage <- 1 - rowSums(x == 1) / rowSums(x)
       
       result <- data.frame(Richness, Shannon, Simpson, Pielou, Chao1, ACE, goods_coverage)
       if (!is.null(tree)) {
              PD_whole_tree <- pd(x, tree, include.root = FALSE)[1]
              names(PD_whole_tree) <- 'PD_whole_tree'
              result <- cbind(result, PD_whole_tree)
       }
       result
}
otu <- read.delim(input, row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE)
#去除一些低丰度OTU，在至少i个样本中具有至少j个序列
#otu_its_t <- otu[which(rowSums(otu >= 5) >= 5),]
otu_its_t <- otu[,which(colSums(otu >= 5) >= 5)]

otu<-otu_its_t
alpha_all <- alpha(otu, base = 2)
write.csv(alpha_all, 'otu_alpha.csv', quote = FALSE)


info <- read.delim(meta, row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE)

cmp<-merge(info,alpha_all,  by = "row.names", all = TRUE)

t<-cmp[,2]
compaired <- list(c("P1", "P2"),c("P1", "P3"),c("P1", "P4"),c("P1", "P5"),c("P1", "P6"),c("P1", "P7"),c("P2", "P3"),c("P2", "P4"),c("P2", "P5"),c("P2", "P6"),c("P2", "P7"),c("P3", "P4"),c("P3", "P5"),c("P3", "P6"),c("P3", "P7"),c("P4", "P5"),c("P4", "P6"),c("P4", "P7"),c("P5", "P6"),c("P5", "P7"),c("P6", "P7"))####"***"=0.001,  "**"=0.01, "*"=0.0
richness = ggplot(cmp, aes(x=factor(t), y=Richness,color=t))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Richness")+theme(legend.position='none') +
      geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)

ace = ggplot(cmp, aes(x=factor(t), y=ACE,color=t))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="ACE1")+theme(legend.position='none') +
      geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)

shannon = ggplot(cmp, aes(x=factor(t), y=Shannon,color=t))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Shannon")+theme(legend.position='none') +
      geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)

pielou = ggplot(cmp, aes(x=factor(t), y=Pielou,color=t))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Pielou")+theme(legend.position='none') +
      geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)

simpson = ggplot(cmp, aes(x=factor(t), y=Simpson,color=t))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Simpson")+theme(legend.position='none') +
      geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)

chao = ggplot(cmp, aes(x=factor(t), y=Chao1,color=t))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Chao1")+theme(legend.position='none') +
      geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)

com= grid.arrange(richness,ace,shannon,simpson,pielou,chao,ncol=2)
ggsave(paste("OTU_sum.pdf", sep=""), com, width = 10, height = 18)
ggsave(paste("OTU_sum.png", sep=""), com, width = 10, height = 18)

otu=as.data.frame(otu/rowSums(otu)*100)

bray_curtis = vegdist(otu, method = "bray")

bray_curtis= as.matrix(bray_curtis)
dis=bray_curtis
#bray_curtis
write.csv(bray_curtis, 'bray_curtis.csv', quote = FALSE)
# 准备行/列注释
anno_col = data.frame(Group = t, row.names = cmp[,1])
anno_row = data.frame(Group = t, row.names = cmp[,1])


# 绘图dist Heatmap
pheatmap(dis,
  treeheight_col=15,treeheight_row=15,
  annotation_names_row= T,annotation_names_col=T,
  annotation_col = anno_col,annotation_row = anno_row,
  filename = paste("heatmap.Bray-Curtis.jpg", sep=""),width=20, height=18,
  fontsize=7,display_numbers=F)
pheatmap(dis,
  treeheight_col=15,treeheight_row=15,
  annotation_names_row= T,annotation_names_col=T,
  annotation_col = anno_col,annotation_row = anno_row,
  filename = paste("heatmap.Bray-Curtis.pdf", sep=""),width=20, height=18,
  fontsize=7,display_numbers=F)





