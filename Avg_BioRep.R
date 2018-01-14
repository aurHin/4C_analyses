# Takes one file for each of two replicates in the Input folder
# Output_file is the average the score of each replicate if intervals are the same
# Outfile header = File_Rep1 header
# Outfile name = File_Rep1 name + mBR.bedGraph, saved in Output_folder

### Input files are normalised over 5Mb --- normalised_scorePerFeature ---

source("/Users/Hintermann/Desktop/201712_4C_WPprojectNew/4C_Rscripts/4C_Functions_1712.R")

### CONFIG
directory<-"/Users/Hintermann/Desktop/4C_GAL_process"

Input_folder<-"normalised_HoxD"
Output_folder<-"normalised_mBR"
### Avg BioRep
setwd(directory)
setwd(Input_folder)

File_Rep1<-"normalised_scorePerFeature_Hoxd13_tb1_rep51421_HoxD.bedGraph"
File_Rep2<-"normalised_scorePerFeature_Hoxd13_tb2_rep51435_HoxD.bedGraph"

BG_Rep1<-read.table(File_Rep1, sep="\t", fill = TRUE,header=FALSE, skip=2, quote="\"", stringsAsFactors=F)
BG_Rep2<-read.table(File_Rep2, sep="\t", fill = TRUE,header=FALSE, skip=2, quote="\"", stringsAsFactors=F)

# Takes two tables and creates a table with average scores, if intervals are the same

BG_Avg<-AvgRep(BG_Rep1,BG_Rep2)
NS_header<-as.character(read.table(File_Rep1, sep="\t", fill = TRUE,nrows=1,header=F, quote="\"", stringsAsFactors=F))
setwd(directory)
setwd(Output_folder)
NS_fname<-paste(getwd(),paste(unlist(strsplit(File_Rep1,"[.]"))[1],"_mBR.bedGraph",sep=""),sep="/")
cat(NS_header,file = NS_fname)
write.table(BG_Avg,NS_fname,col.names = F, row.names = F,quote = F,append = T, sep="\t")
