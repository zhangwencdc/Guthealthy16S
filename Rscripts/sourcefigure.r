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



compaired <- list(c("M1", "Y1"),c("Y1", "Y2"),c("Y2", "Y3"))
cmp = read.table(input, row.names= 1,  header=T, sep="\t")

p = ggplot(cmp, aes(x=factor(TimeGroup,level=c("M1","Y1","Y2","Y3")), y=Value, color=People))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Proportions") + 
  geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)
ggsave(paste("sourcetracker-wilcoxtest.png", sep=""), p, width = 5, height = 3)
ggsave(paste("sourcetracker-wilcoxtest.pdf", sep=""), p, width = 5, height = 3)
p = ggplot(cmp, aes(x=factor(TimeGroup), y=Value, color=People))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Proportions") + 
  geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = t.test)
ggsave(paste("sourcetracker--t-test.png", sep=""), p, width = 5, height = 3)
ggsave(paste("sourcetracker--t-test.pdf", sep=""), p, width = 5, height = 3)
