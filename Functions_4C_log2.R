### LIBRARIES

library(plyr)
library(ggplot2)
library(graphics)
library(GenomicRanges)

### VARIABLES

#Choose the genomic region you want to work on
chrom<-"chr2"
coordInf<-72239991
coordSup<-76840007

### FUNCTIONS

# General functions

ImportBedGraph<-function(x){return(read.table(x, sep="\t", fill = TRUE,header=FALSE, skip=2, quote="\"", stringsAsFactors=F))}

SelectInterval<-function(dataset){
  return(subset(dataset,dataset[,1]==chrom&dataset[,2]>=coordInf&dataset[,3]<=coordSup))
}

writeBedGraph<-function(header,table,fname){
  svName<-paste(getwd(),"/",fname,".bedGraph",sep="")
  cat(header,file=svName)
  write.table(table,svName,col.names = F, row.names = F,quote = F,append = T, sep="\t")
}

SaveCSV<-function(toSave){
  ScoreSumCSV<-askInput("Enter the name to save the dataframe in a csv: ")
  ScoreSumCSV<-paste(ScoreSumCSV,".csv",sep="")
  write.csv(toSave,ScoreSumCSV)
}

StringToVar<-function(string){return(eval(parse(text = string)))}

ReWrite<-function(x){
  head <- read.table(x, nrows = 2, header = FALSE, sep =';', stringsAsFactors = FALSE)
  head<-unlist(head)
  head<-paste(head[1],"\n",head[2],"\n",sep="")
  
  tab<-read.table(x, sep=" ", fill = TRUE,header=T, skip=2, quote="\"", stringsAsFactors=F)
  svName<-paste("tab_",unlist(strsplit(x,"[.]"))[1],sep="")
  writeBedGraph(head,tab,svName)
}
# To average replicates

AreSameIntervals<-function(IntV1,IntV2){
  if(nrow(IntV1)==nrow(IntV2)){
    if(all(IntV1[,1:3]==IntV2[,1:3])){
      return(T)
    } else {return(F)
    }
  } else {return(F)
  }
}

AvgRep<- function(DF_rep1,DF_rep2){
  if(AreSameIntervals(DF_rep1,DF_rep2)){
      Avg_DF<-DF_rep1
      Avg_DF[,4]<-((DF_rep1[,4]+DF_rep2[,4])/2)
      return(Avg_DF)}
   else {
      cat("The replicates do not have the same intervals.\n")
      return(NA)
    }
 }
  
# AvgRep<- function(DF_rep1,DF_rep2){
#   if(nrow(DF_rep1)==nrow(DF_rep2)){
#     if(all(DF_rep1[,1:3]==DF_rep2[,1:3])){
#       Avg_DF<-DF_rep1
#       Avg_DF[,4]<-((DF_rep1[,4]+DF_rep2[,4])/2)
#       return(Avg_DF)
#     } else {
#       cat("The replicates do not have the same intervals.\n")
#       return(NA)
#     }
#   } else {
#     cat("The replicates do not have the same number of intervals.\n")
#     return(NA)
#   }
# }


# This function works but it removes zero values. Instead, you can take all value and do log2 of x+1/y+1.
#log2bedGraph<-function(Num_BedGraph,Denom_BedGraph,fname){
#   GR_num<-BedToGR(Num_BedGraph)
#   GR_denom<-BedToGR(Denom_BedGraph)
#   
#   GR_num_no0<-GR_num[which(GR_num$score!=0)]
#   GR_denom_no0<-GR_denom[which(GR_denom$score!=0)]
#   
#   GR_num_overlap<-subsetByOverlaps(GR_num_no0,GR_denom_no0)
#   GR_denom_overlap<-subsetByOverlaps(GR_denom_no0,GR_num_no0)
#   
#   GR_log2<-GR_denom_overlap[,0]
#   GR_log2$log2ratio<-log2(GR_num_overlap$score/GR_denom_overlap$score)
#   
#   writeBed<-data.frame(seqnames=seqnames(GR_log2),starts=start(GR_log2)-1,ends=end(GR_log2),scores=GR_log2$log2ratio)
#   BedGraphName<-paste("/Users/Hintermann/Desktop/LAB/4C/4C_WPprojectNew/",fname,".bedGraph",sep="")
#   write.table(writeBed,BedGraphName,col.names = F,row.names = F)
# }

log2bedGraph<-function(Num_BedGraph,Denom_BedGraph){
  GR_log2<-Num_BedGraph
  GR_log2$V4<-log2((Num_BedGraph$V4+1)/(Denom_BedGraph$V4+1))
 return(GR_log2)
}

# log2bedGraph<-function(Num_BedGraph,Denom_BedGraph){
#   GR_num<-BedToGR(Num_BedGraph)
#   GR_denom<-BedToGR(Denom_BedGraph)
#   
#   GR_log2<-GR_num[,0]
#   GR_log2$log2ratio<-log2((GR_num$score+1)/(GR_denom$score+1))
#   
#   log2_BG<-data.frame(seqnames=seqnames(GR_log2),starts=start(GR_log2)-1,ends=end(GR_log2),scores=GR_log2$log2ratio)
#   return(log2_BG)
# }

ChgCoord<-function(coord,Rname,add){
  coord$V2[coord$V4==Rname]<-coord$V6[coord$V4==Rname]-add
  coord$V3[coord$V4==Rname]<-coord$V7[coord$V4==Rname]+add
  return(coord)
}

#PUll request
