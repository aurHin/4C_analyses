wd<-getwd()
setwd("/Users/Hintermann/Dropbox/4C_WPprojectNew/4C_Rscripts/")

#wd<-"/Users/Hintermann/Desktop/log2test"
source("4C_Functions_1712.R")

# I did this just one time because I did not put sep="\t" in the function writeBedGraph, 
# so the files saved by this function could not be red by ImportBedGraph 
# filenames<-list.files()
# filenames
# lapply(filenames,ReWrite)

setwd(paste(wd,"tab_Avg_bedGraphs",sep="/"))

### Here I upload the bedGraph I want to compare by log2 ratio

Num_bed<-ImportBedGraph(readline("Type the name of the numerator bedGraph (with extension)."))
#Num_bed<-ImportBedGraph("tab_AVG_Hoxd1_wp2_normalised_scorePerFeature.bedGraph")

Denom_bed<-ImportBedGraph(readline("Type the name of the denominator bedGraph (with extension)."))
#Denom_bed<-ImportBedGraph("tab_AVG_Hoxd1_b1b2_normalised_scorePerFeature.bedGraph")

### This one I manually modified in order to test the if statement = F
test_notEq<-ImportBedGraph("uneq_tab_AVG_Hoxd8_wp1_wp2_normalised_scorePerFeature.bedGraph")

### I need to modify the function readline in order to be able to use it to write a header that I can use with the function writeBedGraph.
### For now it is not writing correctly the \n in the bedGraph.
### This is a way around it because I think today I lost enough time working with header, \n and write.table...
### It works like this for now ^^

BG_header<-"browser position chr2:73780012-75730964 \ntrack type=bedGraph name='d1_wpFB_log2_testLog2' description='d1_wpFB_log2_testLog2' visibility=full windowingFunction=maximum smoothingWindow=11\n"
message(paste("Your header for the output file is: \n\n",BG_header,"\nYou need to modify it now.",sep=""))

### I put your comments in a function AreSameInterval that returns TRUE if intervals are the same and F if they are different.
### Then I can use it each time to verify if they are the same.

### Here I test if == F (intervals are different)

if (AreSameIntervals(Num_bed,test_notEq)){
  setwd(paste(wd,"log2_ratios",sep="/"))
  log2_fname<-readline("Enter the name of the output file containing the log2 profile.\n(No extension).")
  BG_log<-log2bedGraph(Num_bed,Denom_bed)
  writeBedGraph(BG_header,BG_log,log2_fname)
} else{
  cat("The files do not have the same intervals.\n")
}

### Here I test if ==T (intervals are equivalent)

if (AreSameIntervals(Num_bed,Denom_bed)){
  setwd(paste(wd,"log2_ratios",sep="/"))
  log2_fname<-readline("Enter the name of the output file containing the log2 profile.\n(No extension).")
  BG_log<-log2bedGraph(Num_bed,Denom_bed)
  writeBedGraph(BG_header,BG_log,log2_fname)
} else{
  cat("The files do not have the same intervals.\n")
}

### It works when I tried to upload the bedGrahp in UCSC
