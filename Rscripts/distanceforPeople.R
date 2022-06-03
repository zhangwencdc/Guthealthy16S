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

library(picante)      #picante 包加载时默认同时加载 vegan
args=commandArgs(T)
input<-args[1]



compaired <- list(c("SamePeople", "DiffPeople"))
cmp = read.table(input, row.names= 1,  header=T, sep="\t")
p = ggplot(cmp, aes(x=factor(GroupPeople), y=Bray, color=GroupPeople))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Bray-curtis Distance") + 
  geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = F,
                test = wilcox.test)
ggsave(paste("Bray-Curtis Distance-wilcoxtest.png", sep=""), p, width = 5, height = 5)
ggsave(paste("Bray-Curtis Distance-wilcoxtest.pdf", sep=""), p, width = 5, height = 5)
p = ggplot(cmp, aes(x=factor(GroupPeople), y=Bray, color=GroupPeople))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Bray-curtis Distance") + 
  geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = F,
                test = t.test)
ggsave(paste("Bray-Curtis Distance-t-test.png", sep=""), p, width = 5, height = 5)
ggsave(paste("Bray-Curtis Distance-t-test.pdf", sep=""), p, width = 5, height = 5)
