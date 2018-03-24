library(ggplot2)

### Select the folder containing data to plot (4C bedgraphs that were normalised, selected fragments on large HoxD region merged biological replicates)

directory<-"/Users/Hintermann/Desktop/LAB/WP_paper_311017/WP_paper_v2/4C_twb_paper"
Input_folder<-"normalised_HoxD_mBR"
Output_folder<-"CumulReads"

setwd(directory)

fn<-list.files(Input_folder,full.names=F)
setwd(Input_folder)

### Region to calculate and plot cumulative reads

ROI<-c(74838793,74913189)
# c(74838793,75137845) HR1 to CS38
# c(74838793,74913189) HR1

# Generates a long table conatining informations about cumulative reads for each file (useful to plot to have all in one table)
RCumul<-data.frame(V1=c(),V2=c(),V3=c(),V4=c(),V5=c(),V6=c())

for (file in fn){
  df<-read.table(file, sep="\t", fill = TRUE,header=FALSE, skip=1, quote="\"", stringsAsFactors=F)
  df<-subset(df,df[,2]>=ROI[1]&df[,3]<=ROI[2])
  RegionTotal<-sum(df$V4)
  Cumul<-df
  Cumul$V4<-0
  Cumul$V4[1]<-df$V4[1]
  
  for(i in (2:length(df$V4)))
  {Cumul$V4[i]<-(Cumul$V4[i-1])+df$V4[i]}
  
  Cumul$V5<-Cumul$V4/RegionTotal
  ShortName<-paste(unlist(strsplit(file,"_"))[3],"_",unlist(strsplit(file,"_"))[4],sep="")
  Cumul$V6<-ShortName
  
  RCumul<-rbind(RCumul,Cumul)
  }

setwd(directory)
setwd(Output_folder)
 
Output_name<-paste("CumulReads_",readline(prompt="Enter a name for output file, without extension: "),sep="")
write.table(RCumul,paste(Output_name,".csv",sep=""),col.names = F, row.names = F,quote = F,append = T, sep="\t")

p<-ggplot(RCumul,aes(RCumul$V2,RCumul$V5,colour=RCumul$V6))+geom_line()+theme_bw()

###
###

### Uncomment following lines to add highlights on regions given in "rectXX" variable

rectHR1 <- data.frame(Region=c("EC1","EC2","EC3","EC4","EC5"),xmin=c(74898212,74881488,74892377,74905913,74854441), xmax=c(74903231,74885484,74895558,74910158,74856950), ymin=-Inf, ymax=Inf)
p + geom_rect(data=rectHR1, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),
              color="transparent",fill="coral1",
              alpha=0.1,
              inherit.aes = FALSE)

### Uncomment following lines to add vertical lines on coordinates given in "vlinesXX" variable
# vlines=c(74838793,74913189)
# p+geom_vline(xintercept =vlines ,colour="coral1",alpha=.3)

###
###

ggsave(paste(Output_name,".pdf",sep=""),dpi=300)
