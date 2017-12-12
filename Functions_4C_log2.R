#Choose the genomic region you want to work on
chrom<-"chr2"
coordInf<-72239991
coordSup<-76840007

ImportBedGraph<-function(x){return(read.table(x, sep="\t", fill = TRUE,header=FALSE, skip=1, quote="\"", stringsAsFactors=F))}

SelectInterval<-function(dataset){
  return(subset(dataset,dataset[,1]==chrom&dataset[,2]>=coordInf&dataset[,3]<=coordSup))
}

BedToGR<-function(bedG){
  GR<-GRanges(seqnames = bedG$V1,ranges = IRanges(start<-bedG$V2,end<-bedG$V3),score=bedG$V4)
  return(GR)
}

GRtoBG<-function(GR){
  BG<-data.frame(seqnames=seqnames(GR),starts=start(GR)-1,ends=end(GR),score=GR$score)
  return(BG)
}

ImpSelGR<-function(BedGraph){
  BG<-ImportBedGraph(BedGraph)
  BG_Sel<-SelectInterval(BG)
  GR_Sel<-BedToGR(BG_Sel)
  return(GR_Sel)
}

AvgRep<-function(GR_rep1,GR_rep2){
  Avg_GR<-GR_rep1[,0]
  Avg_GR$score<-(GR_rep1$score+GR_rep2$score)/2
  return(Avg_GR)
}
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
  GR_num<-BedToGR(Num_BedGraph)
  GR_denom<-BedToGR(Denom_BedGraph)
  
  GR_log2<-GR_num[,0]
  GR_log2$log2ratio<-log2((GR_num$score+1)/(GR_denom$score+1))
  
  log2_BG<-data.frame(seqnames=seqnames(GR_log2),starts=start(GR_log2)-1,ends=end(GR_log2),scores=GR_log2$log2ratio)
 return(log2_BG)
}


#track type=bedGraph name='Hoxd1_brain1rep_51415 normalised (factor=43.2436284601687)' description='Hoxd1_brain1rep_51415 normalised (factor=43.2436284601687)' visibility=full windowingFunction=maximum
writeBedGraph<-function(header,table,fname){
  svName<-paste(getwd(),"/",fname,".bedGraph",sep="")
  cat(header,file=svName)
  write.table(table,svName,col.names = F,row.names = F,quote = F,append = T)
}

