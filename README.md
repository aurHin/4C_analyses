# OrgBG
Start from a directory with an Input file containing bedGraphs and an empty output file.
The script applies to all bedGraphs of input file.
Selects intervals within ROI and removes NAs.
Save new bedGraphs in the output file.

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

