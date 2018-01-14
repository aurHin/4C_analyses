SelectInterval<-function(dataset){
  return(subset(dataset,dataset[,1]==chrom&dataset[,2]>=coordInf&dataset[,3]<=coordSup))
}

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
