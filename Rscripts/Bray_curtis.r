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
p = ggplot(cmp, aes(x=factor(GroupTime), y=Bray, color=GroupTime))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Bray-curtis Distance") + 
  geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)
ggsave(paste("Bray-Curtis Distance-wilcoxtest-Time-v2.png", sep=""), p, width = 5, height = 5)
ggsave(paste("Bray-Curtis Distance-wilcoxtest-Time-v2.pdf", sep=""), p, width = 5, height = 5)
p = ggplot(cmp, aes(x=factor(GroupTime), y=Bray, color=GroupTime))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Bray-curtis Distance") + 
  geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = t.test)
ggsave(paste("Bray-Curtis Distance-t-test-Time-v2.png", sep=""), p, width = 5, height = 5)
ggsave(paste("Bray-Curtis Distance-t-test-Time-v2.pdf", sep=""), p, width = 5, height = 5)

cmp1<-cmp[cmp$GroupA=="P1",]
p1 = ggplot(cmp1, aes(x=factor(GroupTime), y=Bray, color=GroupTime))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="P1", y="Bray-curtis Distance")

		ggsave(paste("P1.pdf", sep=""), p1, width = 5, height = 5)
cmp1<-cmp[cmp$GroupA=="P2",]
p2 = ggplot(cmp1, aes(x=factor(GroupTime), y=Bray, color=GroupTime))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="P2", y="Bray-curtis Distance")

		ggsave(paste("P2.pdf", sep=""), p2, width = 5, height = 5)
cmp1<-cmp[cmp$GroupA=="P3",]
p3 = ggplot(cmp1, aes(x=factor(GroupTime), y=Bray, color=GroupTime))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="P3", y="Bray-curtis Distance")

		ggsave(paste("P3.pdf", sep=""), p3, width = 5, height = 5)
cmp1<-cmp[cmp$GroupA=="P4",]
p4 = ggplot(cmp1, aes(x=factor(GroupTime), y=Bray, color=GroupTime))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="P4", y="Bray-curtis Distance") 

		ggsave(paste("P4.pdf", sep=""), p4, width = 5, height = 5)
cmp1<-cmp[cmp$GroupA=="P5",]
p5 = ggplot(cmp1, aes(x=factor(GroupTime), y=Bray, color=GroupTime))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="P5", y="Bray-curtis Distance") 
		ggsave(paste("P5.pdf", sep=""), p5, width = 5, height = 5)
cmp1<-cmp[cmp$GroupA=="P6",]
p6 = ggplot(cmp1, aes(x=factor(GroupTime), y=Bray, color=GroupTime))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="P6", y="Bray-curtis Distance") 

		ggsave(paste("P6.pdf", sep=""), p6, width = 5, height = 5)
cmp1<-cmp[cmp$GroupA=="P7",]
p7 = ggplot(cmp1, aes(x=factor(GroupTime), y=Bray, color=GroupTime))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="P7", y="Bray-curtis Distance")

		ggsave(paste("P7.pdf", sep=""), p7, width = 5, height = 5)

com= grid.arrange(p1,p2,p3,p4,p5,p6,p7,ncol=7)
ggsave(paste("People_sum.pdf", sep=""), com, width = 35, height = 5)