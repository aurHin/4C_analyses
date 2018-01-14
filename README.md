# GETTING THE DATA

### Get the raw data (fastq file) from lims
login https://uhts-gva.vital-it.ch/user/getdata/dataruns
user data > get labdata > ProjectName > show hide > http link
Here, no work on fastq files but on the files pre-processed by HTSstation.

### Get the analysed files from HTS
Connect http://htsstation.epfl.ch/
list of analyses > ProjectName > download all files

### Select files of interest
Work in directory NameOfProject.
Save all files in NameOfProject/allFiles folder.
Select normalised files of interest with terminal and save in NameOfProject/normalised. 
!!! Check carefully oufiles.xlxs to have the detail of analyses done by HTS.

NOTE: 
-dealing with replicates: fileNames containing "rep" deal with individual biological replicates. Without "rep", replicates are merged. Here, deal only with individual replicates. Check the oufiles.xlxs carefully to see how to deal with replicates. Here, smoothing is done because smoothing from HTS merge replicates. If not replicates specified, the "norep" file is the rounded value of "rep" file.
Example:
wp2_repXXX.bedGraph$V4[1184787]		0.08561154
wp2. bedGraph$V4[1184787]			0.09

# Select_ROI.R
Select specified ROI on all files in NameOfProject/normalised
OutputName<-InputName_HoxD.bedGraph
Save output in NameOfProject/normalised_HoxD
NOTE: do not remove NAs at this step, it makes problems to merge replicates, as intervals would not remain the same

# Average-4C
How to average 4C data from two biological replicates?

I do the mean of the score for each fragments in the bedGraph.
Replicate 1= normalised_scorePerFeature_Hoxd9_brain1_rep51414.bedGraph  
Replicate 2= normalised_scorePerFeature_Hoxd9_brain2_rep51438.bedGraph

I think the profile in UCSC does not look like the average of the two replicates. Is it true? Should I average the fastq?

AvgRep<-function(GR_rep1,GR_rep2){
  Avg_GR<-GR_rep1[,0]
  Avg_GR$score<-((GR_rep1$score+GR_rep2$score)/2)
  return(Avg_GR)
}

# January 2018 - WP, tailbud, brain 4C
Application of these tools on 4C fot the WP project
The sample wp1 was removed for analyses because it is not showing expected profile, while wp2 does. Need to repeat.
Download from lims: fastq for GAL1 and GAL2
Download form HTS GAL1 and GAL2 (run by Leo), replicates not specified

Files of interest selected in 4C_GAL_process/allFIles with normalised_sc*Hox*rep* command and saved in 4C_GAL_process/normalised
Intervals covering HoxD region selected in 4C_GAL_process/normalised by Select_ROI.R output saved to 4C_GAL_process/normalised_HoxD
HoxD region chrom<-"chr2"coordInf<-72239991 coordSup<-76840007
Merge biological replicates of 4C_GAL_process/normalised_HoxD with

