source("/Users/Hintermann/Desktop/LAB/4C/4C_WPprojectNew/4C_Rscripts/4C_log2/Functions_4C_log2.R")

library(graphics)
#source("https://bioconductor.org/biocLite.R")
#biocLite("GenomicRanges")
library(GenomicRanges)

setwd("/Users/Hintermann/Desktop/LAB/4C/4C_WPprojectNew")

# File to average (score mean)
A_File<-"OriginalBedGraphs/normalised_scorePerFeature_Hoxd9_brain1_rep51414.bedGraph"
B_File<-"OriginalBedGraphs/normalised_scorePerFeature_Hoxd9_brain2_rep51438.bedGraph"

A_GR<-ImpSelGR(A_File)
B_GR<-ImpSelGR(B_File)

Avg_AB<-AvgRep(A_GR,B_GR)
Avg_BG<-GRtoBG(Avg_AB)

BG_name<-"Hoxd9_b1b2"

#BG_header<-paste("track type=bedGraph name='",BG_name,"' description='",BG_name,"' visibility=full autoScale=off windowingFunction=maximum smoothingWindow=11\n",sep="")
BG_header<-paste("track type=bedGraph name='",BG_name,"' description='",BG_name,"' visibility=full autoScale=off windowingFunction=maximum\n",sep="")

writeBedGraph(BG_header,Avg_BG,BG_name)

##########
##########
#########


Num_bed<-ImportBedGraph("normalised_scorePerFeature_Hoxd1_brain1_rep51415.bedGraph")
Denom_bed<-ImportBedGraph("normalised_scorePerFeature_Hoxd9_brain2_rep51414.bedGraph")

setwd(dirname("/Users/Hintermann/Desktop/LAB/4C/4C_WPprojectNew/OriginalBedGraphs"))
#Check that the files contain the same intervals
which((Denom_bed$V2==Num_bed$V2)==F)
which((Denom_bed$V3==Num_bed$V3)==F)


Denom_bed_HoxD<-SelectInterval(Denom_bed,chrom,coordInf,coordSup)
Num_bed_HoxD<-SelectInterval(Num_bed,chrom,coordInf,coordSup)

BG_log<-log2bedGraph(Num_bed_HoxD,Denom_bed_HoxD)

BG_header<-"track type=bedGraph name='d9_wpFB_log2' description='d9_wpFB_log2' visibility=full windowingFunction=maximum\n"
writeBedGraph(BG_header,BG_log,"d9_wpFB_log2")

#Transform bed to GRanges, select non-zero values, subset by overlaps and create an new GRange with log2 value. 
#Write the bedGraph from this GRange

