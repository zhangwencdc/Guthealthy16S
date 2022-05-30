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
#install.packages("vioplot")#°²×°vioplot°ü

library("vioplot") 
args=commandArgs(T)
input<-args[1]
phy <- read.delim(input, row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE)
#phy <- read.delim("phylum.txt", row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE)

t<-phy[,1]
Firmicutes=ggplot(phy, aes(x=factor(t), y=Firmicutes,color=t))+
  geom_violin(aes(fill = t)) +  
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.1, fill="transparent") + 
  labs(x="Groups", y="Firmicutes")+theme(legend.position='none') 


Bacteroidetes=ggplot(phy, aes(x=factor(t), y=Bacteroidetes,color=t))+
  geom_violin(aes(fill = t)) +  
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.1, fill="transparent") + 
  labs(x="Groups", y="Bacteroidetes")+theme(legend.position='none') 

Proteobacteria=ggplot(phy, aes(x=factor(t), y=Proteobacteria,color=t))+
  geom_violin(aes(fill = t)) +  
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.1, fill="transparent") + 
  labs(x="Groups", y="Proteobacteria")+theme(legend.position='none') 

Actinobacteria=ggplot(phy, aes(x=factor(t), y=Actinobacteria,color=t))+
  geom_violin(aes(fill = t)) +  
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.1, fill="transparent") + 
  labs(x="Groups", y="Actinobacteria")+theme(legend.position='none') 

 Lentisphaerae=ggplot(phy, aes(x=factor(t), y=Lentisphaerae,color=t))+
  geom_violin(aes(fill = t)) +  
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.1, fill="transparent") + 
  labs(x="Groups", y="Lentisphaerae")+theme(legend.position='none') 


Verrucomicrobia=ggplot(phy, aes(x=factor(t), y=Verrucomicrobia,color=t))+
  geom_violin(aes(fill = t)) +  
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.1, fill="transparent") + 
  labs(x="Groups", y="Verrucomicrobia")+theme(legend.position='none') 

Cyanobacteria=ggplot(phy, aes(x=factor(t), y=Cyanobacteria,color=t))+
  geom_violin(aes(fill = t)) +  
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.1, fill="transparent") + 
  labs(x="Groups", y="Cyanobacteria")+theme(legend.position='none') 

Fusobacteria=ggplot(phy, aes(x=factor(t), y=Fusobacteria,color=t))+
  geom_violin(aes(fill = t)) +  
  geom_boxplot(alpha=1, outlier.size=0, size=0.7, width=0.1, fill="transparent") + 
  labs(x="Groups", y="Fusobacteria")+theme(legend.position='none') 

com= grid.arrange(Firmicutes,Bacteroidetes,Proteobacteria,Actinobacteria,Lentisphaerae,Verrucomicrobia,Cyanobacteria,Fusobacteria,ncol=2)
ggsave(paste("Phylum.pdf", sep=""), com, width = 18, height = 6)