# Takes Input_file and size of sliding window
# Apply smoothing
# Removes NAs from Input_file and Smoothed_file for visualisation with IGV
# Gives short names for ease of visualisation "Viewpoint_Tissue_Smoothing.bedGraph"
# Saves in Outputfolder with respectively "_noSmooth.bedGraph" and "_SmoothSize" name added

### CONFIG

# Input_file<-"normalised_scorePerFeature_Hoxd1_wp2_rep51433_HoxD_mBR.bedGraph"
SlidingW<-3
directory<-"/Users/Hintermann/Desktop/4C_GAL_process"
Input_folder<-"normalised_mBR"
Output_folder<-"norm_smoothed_woNA"

### SCRIPT
setwd(directory)
fn<-list.files(Input_folder,full.names=F)
fn
for (file in fn){
  setwd(directory)
  setwd(Input_folder)
  dfSmoo<-read.table(file, sep="\t", fill = TRUE,header=FALSE, skip=2, quote="\"", stringsAsFactors=F)
  Smoothed<-dfSmoo
  
  for (i in 1:(length(Smoothed$V4)-5)) {
    print(Smoothed$V4[i])
    Smoothed$V4[(i+((SlidingW-1)/2))]<-mean(dfSmoo$V4[i:(i+(SlidingW-1))])
  }
  
  ## Removes NAs and save
  setwd(directory)
  setwd(Output_folder)
  dfSmoo<-na.omit(dfSmoo)
  noSmooName<-paste(unlist(strsplit(file,"_"))[3],"_",unlist(strsplit(file,"_"))[4],"_noSmooth.bedGraph",sep="")
  write.table(dfSmoo,noSmooName,col.names = F, row.names = F,quote = F,append = T, sep="\t")
  
  Smoothed<-na.omit(Smoothed)
  SmooName<-paste(unlist(strsplit(file,"_"))[3],"_",unlist(strsplit(file,"_"))[4],"_Smooth",as.character(SlidingW),".bedGraph",sep="")
  write.table(Smoothed,SmooName,col.names = F, row.names = F,quote = F,append = T, sep="\t")
  
}

# 
# setwd(Input_folder)
# 
# 
# dfSmoo<-read.table(Input_file, sep="\t", fill = TRUE,header=FALSE, skip=2, quote="\"", stringsAsFactors=F)
# 
# Smoothed<-dfSmoo
# for (i in 1:(length(Smoothed$V4)-5)) {
#   print(Smoothed$V4[i])
#   Smoothed$V4[(i+((SlidingW-1)/2))]<-mean(dfSmoo$V4[i:(i+(SlidingW-1))])
#   }
# 
# ## Removes NAs and save
# setwd(directory)
# setwd(Output_folder)
# dfSmoo<-na.omit(dfSmoo)
# noSmooName<-paste(unlist(strsplit(Input_file,"[.]"))[1],"_noSmooth.bedGraph",sep="")
# write.table(dfSmoo,noSmooName,col.names = F, row.names = F,quote = F,append = T, sep="\t")
# 
# Smoothed<-na.omit(Smoothed)
# SmooName<-paste(unlist(strsplit(Input_file,"[.]"))[1],"_Smooth",as.character(SlidingW),".bedGraph",sep="")
# write.table(Smoothed,SmooName,col.names = F, row.names = F,quote = F,append = T, sep="\t")
