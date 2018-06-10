# GETTING THE DATA

### Get the raw data (fastq file) from lims
login https://uhts-gva.vital-it.ch/user/getdata/dataruns
user data > get labdata > ProjectName > show hide > http link
Here, no work on fastq files but on the files pre-processed by HTSstation.

### Get the analysed files from HTS
Connect http://htsstation.epfl.ch/
list of analyses > ProjectName > download all files

# ANALYSING THE DATA

Select files

Select_ROI.R
Avg_BioRep.R
Smoothing.R

4C_Functions.R

### Select files of interest
Work in directory NameOfProject.
Save all files in NameOfProject/allFiles folder.
Select normalised files of interest with terminal and save in NameOfProject/normalised. 
normalised_scorePerFeature_viewpoint_tissue_repXXX.bedGraph

!!! Check carefully oufiles.xlxs to have the detail of analyses done by HTS.

NOTE: 
dealing with replicates: fileNames containing "rep" deal with individual biological replicates. Without "rep", replicates are merged. Here, deal only with individual replicates. Check the oufiles.xlxs carefully to see how to deal with replicates. Here, smoothing is done because smoothing from HTS merge replicates. If not replicates specified, the "norep" file is the rounded value of "rep" file.
Example:
wp2_repXXX.bedGraph$V4[1184787]		0.08561154
wp2. bedGraph$V4[1184787]			0.09

### Select_ROI.R
Select specified ROI on all files in NameOfProject/normalised
Save output in NameOfProject/normalised_HoxD
normalised_scorePerFeature_viewpoint_tissue_repXXX_HoxD.bedGraph

NOTE: do not remove NAs at this step, it makes problems to merge replicates, as intervals would not remain the same

### Avg_BioRep.R
NOTE: here, the script does not apply on all files of the folder. Need to manually enter the two file names to merge, because sometimes there are not two replicates. In this case, copy paste the file of the single replicate from NameOfProject/normalised_HoxD to NameOfProject/normalised_mBR

Choose two inputfiles in NameOfProject/normalised_HoxD
Check if intervals of fragments are the same in the two files.
Do score mean for each fragment.
Save one output file in NameOfProject/normalised_mBR
normalised_scorePerFeature_viewpoint_tissue_repXXX_HoxD_mBR.bedGraph

### Smoothing.R
Choose size of Sliding window.
Smooth all files in NameOfProject/normalised_HoxD.
Removes NAs for visualisation in IGV - of smoothed and unsmoothed (=input) files.
Save smoothed and unsmoothed files in NameOfProject/norm_smoothed_woNA. NOTE: names are simplified for ease of visualization.
Respectively Viewpoint_Tissue_SmoothSizeSlidingWindow.bedGraph Viewpoint_Tissue_noSmooth.bedGraph
NOTE: output files ready to use in IGV

### 4C_Functions.R
Contains function called by the scripts above

## Use files in normalised_mBR for analyse and in norm_smoothed_woNA for visualisation.

### Quantification.R
Do the ratio ROI/TDOM for all regions specified at the beginning of the script.
Apply on all files in NameOfProject/normalised_mBR
Save Quantification.csv in NameOfProject/quantification

### CumulReads.R
Calculate and plots cumulative Reads over ROI
Apply on all files in NameOfProject/normalised_HoxD_mBR
Save CumulReads_XX.csv and CumulReads_XX.pdf

By commenting/uncommenting lines, you can add highlights or vertical lines to delimit region on the plot

# January 2018 - WP, tailbud, brain 4C
Application of these tools on 4C fot the WP project
The sample wp1 was removed for analyses because it is not showing expected profile, while wp2 does. Need to repeat.
Download from lims: fastq for GAL1 and GAL2
Download form HTS GAL1 and GAL2 (run by Leo), replicates not specified

Files of interest selected in 4C_GAL_process/allFIles with normalised_sc*Hox*rep* command and saved in 4C_GAL_process/normalised
normalised_scorePerFeature_Hoxd1_brain1_rep51415.bedGraph

Intervals covering HoxD region selected in 4C_GAL_process/normalised by Select_ROI.R output saved to 4C_GAL_process/normalised_HoxD
HoxD region chrom<-"chr2"coordInf<-72239991 coordSup<-76840007
normalised_scorePerFeature_Hoxd1_brain1_rep51415_HoxD.bedGraph

Merge biological replicates of 4C_GAL_process/normalised_HoxD with Avg_BioRep.R output saved to 4C_GAL_process/normalised_mBR
One replicate copied by hand in normalised_mBR: Hoxd1 to Hoxd9 for wp2 and Hoxd1 to Hoxd4 for tb1
Two replicates merged with Avg_BioRep.R and saved in normalised_mBR: Hoxd1 to Hoxd9 brain1 brain2 and brain1 Brain2 and Hoxd8 to Hoxd13 tb1 tb2
normalised_scorePerFeature_Hoxd1_brain1_rep51415_HoxD_mBR.bedGraph

For all files in 4C_GAL_process/normalised_mBR apply Smoothing.R with size of sliding window =3 and =11.
In 4C_GAL_process/norm_smoothed_woNA, for each file in 4C_GAL_process/normalised_mBR, there is one file noSmooth, one Smooth3 and one Smooth11.
Ready to use with IGV: no NAs and names are simplified.
Hoxd1_brain1_noSmooth.bedGraph ; Hoxd1_brain1_Smooth3.bedGraph ; Hoxd1_brain1_Smooth11.bedGraph

# March 2018 - WP, tailbud, brain 4C

I applied Cumulative reads to 4 datasets: d1, d4, wp brain for each.I choose region HR1 to CS38 and zoom on HR1.

# June 2018 - WP, tailbud, brain 4C
Add tb to analyses done with wp and brain (highest 10)
Take normalised_mBR files from NAS for tb, viewpoints d1,d4,d9.
Apply log2.R to get log
