### CONFIG

directory<-"/Users/Hintermann/Desktop/4C_Analyses/4C_GAL_process"
Input_folder<-"normalised_mBR"
Output_folder<-"quantification"
fBrain<-"normalised_scorePerFeature_Hoxd1_brain1_rep51415_HoxD_mBR.bedGraph"
fWP<-"normalised_scorePerFeature_Hoxd1_wp2_rep51433_HoxD_mBR.bedGraph"

TDOM<-c(74775578,75599915,"TDOM")
CT<-c(74775578,75139471,"CT")
TT<-c(75139472,75599915,"TT")
ECs<-c(74878880,74913844,"ECs")
HR1<-c(74838793,74913189,"HR1")
Mtx2_prom<-c(74820405,74833305,"Mtx2_prom")

RegionsToQuant<-list(TDOM,CT,TT,ECs,HR1,Mtx2_prom)
#RegionsToQuant[[1]][3]

### FUNCTIONS

MeanOfRegion<-function(df,region){
  reg<-subset(df,df[,2]<=region[2]&df[,3]>=region[1])
  return(mean(reg$V4))
}

SumOfRegion<-function(df,region){
  reg<-subset(df,df[,2]<=region[2]&df[,3]>=region[1])
  return(sum(reg$V4))
}

### SCRIPT
setwd(directory)

fn<-list.files(Input_folder,full.names=F)
fn
Quantification_Summary<-data.frame(fn)
colnames(Quantification_Summary)<-"FileName"

for (reg in RegionsToQuant){
  Quantification_Summary[reg[3]]<-0
}

View(Quantification_Summary)
setwd(Input_folder)
for (file in fn){
  df<-read.table(file, sep="\t", fill = TRUE,header=FALSE, skip=0, quote="\"", stringsAsFactors=F)
  ratio<-c()
  for (reg in RegionsToQuant){
     ratio<-c(ratio,MeanOfRegion(df,reg)/MeanOfRegion(df,TDOM))
     #print(length(ratio))   
  }
  row=which(Quantification_Summary$FileName==file)
  Quantification_Summary[row,1:length(RegionsToQuant)+1]<-ratio
  }

setwd(directory)
ratioName<-"/RatioRegToTDOM.csv"
write.csv(Quantification_Summary,paste(Output_folder,ratioName,sep=""), row.names = F,quote = F)

