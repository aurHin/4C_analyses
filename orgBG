# Takes all files of input folder and select for ROI
# Adds the same header as input file
# Saves in output folder, under the same name as input file with "_HoxD" added

source("/Users/Hintermann/Desktop/201712_4C_WPprojectNew/4C_Rscripts/4C_Functions_1712.R")

### CONFIG
#Selection of the ROI (here, around HoxD)
chrom<-"chr2"
coordInf<-72239991
coordSup<-76840007

# Dir and files
directory<-"/Users/Hintermann/Desktop/4C_GAL_process"

# To select files in the current folder according to their name conatining a pattern, type following command in terminal:
# cp pattern destinationFolder
# Example:
# cp normalised_*Hox*[t,b,w,T,B,W]* /Users/Hintermann/Desktop/4C_GAL/tbw_normalised
# cp *Hox*[t,b,w,T,B,W]*norm_smoo /Users/Hintermann/Desktop/4C_GAL/tbw_norm_smoothed

In_file<-"normalised"
Out_file<-"normalised_HoxD"

### Script

setwd(directory)

fn<-list.files(In_file,full.names=F)
fn

for (file in fn){
  SelHoxD<-SelectInterval(read.table(paste(getwd(),In_file,file,sep="/"), sep="\t", fill = TRUE,skip=1,header=F, quote="\"", stringsAsFactors=F))
  #normSmoothed_DF_woNAs<-na.omit(normSmoothed_DF)
  NS_header<-as.character(read.table(paste(getwd(),In_file,file,sep="/"), sep="\t", fill = TRUE,nrows=1,header=F, quote="\"", stringsAsFactors=F))
  NS_fname<-paste(getwd(),Out_file,paste(unlist(strsplit(file,"[.]"))[1],"_HoxD.bedGraph",sep=""),sep="/")
  cat(NS_header,file = NS_fname)
  write.table(SelHoxD,NS_fname,col.names = F, row.names = F,quote = F,append = T, sep="\t")
  print(file)
}

