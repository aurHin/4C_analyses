### LIBRARIES

library(plyr)
library(ggplot2)
library(graphics)
#library(GenomicRanges)

### FUNCTIONS

# General functions

#ImportBedGraph<-function(x){return(read.table(x, sep="\t", fill = TRUE,header=FALSE, skip=2, quote="\"", stringsAsFactors=F))}

SelectInterval<-function(dataset){
  return(subset(dataset,dataset[,1]==chrom&dataset[,2]>=coordInf&dataset[,3]<=coordSup))
}

writeBedGraph<-function(header,table,fname){
  cat(header,file=fname)
  write.table(table,fname,col.names = F, row.names = F,quote = F,append = T, sep="\t")
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

log2bedGraph<-function(Num_BedGraph,Denom_BedGraph){
  BG_log2<-Num_BedGraph
  BG_log2$V4<-log2((Num_BedGraph$V4+1)/(Denom_BedGraph$V4+1))
 return(BG_log2)
}

ChgCoord<-function(coord,Rname,add){
  coord$V2[coord$V4==Rname]<-coord$V6[coord$V4==Rname]-add
  coord$V3[coord$V4==Rname]<-coord$V7[coord$V4==Rname]+add
  return(coord)
}

RemoveNAfromBG<-function(x,inputFolder,outputFolder){
  BG_DF<-read.table(paste(inputFolder,x,sep = ""), sep="\t", fill = TRUE,skip=1,header=F, quote="\"", stringsAsFactors=F)
  BG_DF_woNA<-na.omit(BG_DF)
  
  BG_header<-as.character(read.table(paste(inputFolder,x,sep = ""), sep="\t", fill = TRUE,nrows=1,header=F, quote="\"", stringsAsFactors=F))
  
  BG_name<-paste(outputFolder,unlist(strsplit(x,"[.]"))[1],"_woNAs",sep = "")
  writeBedGraph(BG_header,BG_DF_woNA,BG_name)
  }
