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
cmp1=subset(cmp,People=="P1")
p1 = ggplot(cmp1, aes(x=factor(TimeGroup,level=c("M1","Y1","Y2","Y3")), y=Value, color=People))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Proportions") + 
  geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)

ggsave(paste("sourcetracker-wilcoxtest-P1.pdf", sep=""), p1, width = 5, height = 3)

cmp2=subset(cmp,People=="P2")
p2 = ggplot(cmp2, aes(x=factor(TimeGroup,level=c("M1","Y1","Y2","Y3")), y=Value, color=People))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Proportions") + 
  geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)
#ggsave(paste("sourcetracker-wilcoxtest-P2.png", sep=""), p1, width = 5, height = 3)
ggsave(paste("sourcetracker-wilcoxtest-P2.pdf", sep=""), p2, width = 5, height = 3)

cmp2=subset(cmp,People=="P3")
p3 = ggplot(cmp2, aes(x=factor(TimeGroup,level=c("M1","Y1","Y2","Y3")), y=Value, color=People))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Proportions") + 
  geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)
#ggsave(paste("sourcetracker-wilcoxtest-P3.png", sep=""), p1, width = 5, height = 3)
ggsave(paste("sourcetracker-wilcoxtest-P3.pdf", sep=""), p3, width = 5, height = 3)

cmp2=subset(cmp,People=="P4")
p4 = ggplot(cmp2, aes(x=factor(TimeGroup,level=c("M1","Y1","Y2","Y3")), y=Value, color=People))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Proportions") + 
  geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)
#ggsave(paste("sourcetracker-wilcoxtest-P4.png", sep=""), p1, width = 5, height = 3)
ggsave(paste("sourcetracker-wilcoxtest-P4.pdf", sep=""), p4, width = 5, height = 3)

cmp2=subset(cmp,People=="P5")
p5 = ggplot(cmp2, aes(x=factor(TimeGroup,level=c("M1","Y1","Y2","Y3")), y=Value, color=People))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Proportions") + 
  geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)
#ggsave(paste("sourcetracker-wilcoxtest-P5.png", sep=""), p1, width = 5, height = 3)
ggsave(paste("sourcetracker-wilcoxtest-P5.pdf", sep=""), p5, width = 5, height = 3)

cmp2=subset(cmp,People=="P6")
p6 = ggplot(cmp2, aes(x=factor(TimeGroup,level=c("M1","Y1","Y2","Y3")), y=Value, color=People))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Proportions") + 
  geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)
#ggsave(paste("sourcetracker-wilcoxtest-P6.png", sep=""), p1, width = 5, height = 3)
ggsave(paste("sourcetracker-wilcoxtest-P6.pdf", sep=""), p6, width = 5, height = 3)

cmp2=subset(cmp,People=="P7")
p7 = ggplot(cmp2, aes(x=factor(TimeGroup,level=c("M1","Y1","Y2","Y3")), y=Value, color=People))+
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.5, fill="transparent") +  
  labs(x="Groups", y="Proportions") + 
  geom_signif(comparisons = compaired,
                step_increase = 0.3,
                map_signif_level = T,
                test = wilcox.test)
#ggsave(paste("sourcetracker-wilcoxtest-P7.png", sep=""), p1, width = 5, height = 3)
ggsave(paste("sourcetracker-wilcoxtest-P7.pdf", sep=""), p7, width = 5, height = 3)


com= grid.arrange(p1,p2,p3,p4,p5,p6,p7,ncol=7)
ggsave(paste("Source_7people.pdf", sep=""), com, width = 35, height = 8)