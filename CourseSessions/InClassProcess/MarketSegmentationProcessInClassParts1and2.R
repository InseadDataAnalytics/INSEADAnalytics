
RUN_PART_2 = 1

############################################################################################################
############################################################################################################
# PART 1 PARAMETERS

# Please ENTER the name of the file with the data used. The file should be a .csv with one row per observation (e.g. person) and one column per attribute. Do not add .csv at the end, make sure the data are numeric.
# CHOOSE FILE TO ANALYSE
datafile_name = "CourseSessions/Sessions23/data/Boats.csv" # FOR BOATS DATA
#datafile_name = "CourseSessions/Sessions23/data/MBAadmin.csv" # FOR MBA DATA
#datafile_name = "CourseSessions/Sessions45/data/Mall_Visits.csv" # FOR SHOPPING MALL DATA


# Please ENTER the original raw attributes to use. 
# Please use numbers, not column names, e.g. c(1:5, 7, 8) uses columns 1,2,3,4,5,7,8
factor_attributes_used = c(2:30) # FOR BOATS DATA
#factor_attributes_used = c(1:7) # FOR MBA DATA
#factor_attributes_used = c(2:7) # FOR SHOPPING MALL DATA

# Please ENTER the selection criteria for the factors to use. 
# Choices: "eigenvalue", "variance", "manual"
factor_selectionciterion = "manual"

# Please ENTER the desired minumum variance explained 
# (Only used in case "variance" is the factor selection criterion used). 
minimum_variance_explained = 65  # between 1 and 100

# Please ENTER the number of factors to use 
# (Only used in case "manual" is the factor selection criterion used).
#manual_numb_factors_used = 12
manual_numb_factors_used = 10

# Please ENTER the rotation eventually used (e.g. "none", "varimax", "quatimax", "promax", "oblimin", "simplimax", and "cluster" - see help(principal)). Default is "varimax"
rotation_used = "varimax"
MIN_VALUE = 0.5

############################################################################################################
############################################################################################################

# PART 2 PARAMETERS
# Please ENTER then original raw attributes to use for the segmentation (the "segmentation attributes")
# Please use numbers, not column names, e.g. c(1:5, 7, 8) uses columns 1,2,3,4,5,7,8
#segmentation_attributes_used = c(28,25,27,14,20,8,3,12,13,5,9,11,2,30,24) # FOR BOATS DATA
segmentation_attributes_used = c(1:5) # FOR MBA DATA
#segmentation_attributes_used = c(2:7) # FOR SHOPPING MALL DATA

# Please ENTER then original raw attributes to use for the profiling of the segments (the "profiling attributes")
# Please use numbers, not column names, e.g. c(1:5, 7, 8) uses columns 1,2,3,4,5,7,8
#profile_attributes_used = c(2:82)  # FOR BOATS DATA
profile_attributes_used = c(1:7)  # FOR MBA DATA
#profile_attributes_used = c(2:9)  # FOR SHOPPING MALL DATA

# Please ENTER the number of clusters to eventually use for this report
#numb_clusters_used = 7 # for boats possibly use 5, for Mall_Visits use 3
numb_clusters_used = 3 # for boats possibly use 5, for Mall_Visits use 3

# Please enter the method to use for the segmentation:
profile_with = "kmeans" #  "hclust" or "kmeans"

# Please ENTER the distance metric eventually used for the clustering in case of hierarchical clustering 
# (e.g. "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski" - see help(dist)). 
# DEFAULT is "euclidean"
distance_used = "euclidean"

# Please ENTER the hierarchical clustering method to use (options are:
# "ward", "single", "complete", "average", "mcquitty", "median" or "centroid").
# DEFAULT is "ward"
hclust_method = "ward.D2"

# Please ENTER the kmeans clustering method to use (options are:
# "Hartigan-Wong", "Lloyd", "Forgy", "MacQueen").
# DEFAULT is "Lloyd"
kmeans_method = "Lloyd"

############################################################################################################
############################################################################################################
############################################################################################################


######################################################
# installs all necessary libraries from CRAN or Github

get_libraries <- function(filenames_list) suppressPackageStartupMessages({ 
  lapply(filenames_list, function(thelibrary){    
    thelibrary.split <- strsplit(thelibrary, "/")[[1]]
    if (length(thelibrary.split) > 1) {
      # install from Github
      if (!suppressWarnings(require(thelibrary.split[2], character.only=TRUE))) {
        devtools::install_github(thelibrary, quiet=TRUE)
        library(thelibrary.split[2], character.only=TRUE)
      }
    } else {
      # install from CRAN
      if (!suppressWarnings(require(thelibrary, character.only=TRUE))) {
        install.packages(thelibrary, repos="http://cran.r-project.org/", quiet=TRUE)
        library(thelibrary, character.only=TRUE)
      }
    }
  })
})

libraries_used=c("devtools","knitr","graphics","grDevices","xtable","pryr",
                 "Hmisc","vegan","fpc","GPArotation","FactoMineR","cluster",
                 "psych","stringr","googleVis", "png","ggplot2","googleVis", 
                 "gridExtra", "reshape2", "DT", "ramnathv/slidifyLibraries",
                 "ramnathv/slidify", "cttobin/ggthemr", "dplyr","vkapartzianis/formattable", "ggdendro","ROCR",
                 "networkD3","rpart.plot","mrjoh3/c3","glmnet","hong-revo/glmnetUtils","randomForest","xgboost")
get_libraries(libraries_used)
#############

my_summary <- function(thedata){
  res = apply(thedata, 2, function(r) c(min(r), quantile(r, 0.25), quantile(r, 0.5), mean(r), quantile(r, 0.75), max(r), sd(r)))
  res <- round(res,2)
  colnames(res) <- colnames(thedata)
  rownames(res) <- c("min", "25 percent", "median", "mean", "75 percent", "max", "std")
  t(res)
}

################################################################################
ProjectData <- read.csv(datafile_name)
ProjectData <- data.matrix(ProjectData) 
ProjectData_INITIAL <- ProjectData

factor_attributes_used <- intersect(factor_attributes_used, 1:ncol(ProjectData))
ProjectDataFactor <- ProjectData[,factor_attributes_used]
ProjectDataFactor <- data.matrix(ProjectDataFactor)

# STEP 2: SUMMARY OF THE DATA
#"Summary of the data used:"
SUMMARY_STATISTICS = round(my_summary(ProjectDataFactor), 2)
View(SUMMARY_STATISTICS)

# STEP 3: CHECK THE CORRELATION MATRIX
thecor = round(cor(ProjectDataFactor),2)
#"Correlation Matrix:"
CORRELATION_MATRIX = round(thecor, 2)
View(CORRELATION_MATRIX)
write.csv(round(thecor,2), file = "thecor.csv")

############################################################################################################

# Here is how the `principal` function is used 
UnRotated_Results<-principal(ProjectDataFactor, nfactors=ncol(ProjectDataFactor), rotate="none",score=TRUE)
UnRotated_Factors<-round(UnRotated_Results$loadings,2)
UnRotated_Factors<-as.data.frame(unclass(UnRotated_Factors))
colnames(UnRotated_Factors)<-paste("Comp",1:ncol(UnRotated_Factors),sep="")

# STEP 4: CHOOSE NUMBER OF FACTORS
Variance_Explained_Table_results<-PCA(ProjectDataFactor, graph=FALSE)
Variance_Explained_Table<-Variance_Explained_Table_results$eig
Variance_Explained_Table_copy<-Variance_Explained_Table

rownames(Variance_Explained_Table) <- paste("Component", 1:nrow(Variance_Explained_Table), sep=" ")
colnames(Variance_Explained_Table) <- c("Eigenvalue", "Pct of explained variance", "Cumulative pct of explained variance")

#"Variance Explained and Eigenvalues:"
VARIANCE_EXPLAINED= round(Variance_Explained_Table,2)
View(VARIANCE_EXPLAINED)
write.csv(round(Variance_Explained_Table,2), file = "Variance_Explained_Table.csv")

# Scree plot
eigenvalues  <- Variance_Explained_Table[, "Eigenvalue"]
df           <- cbind(as.data.frame(eigenvalues), c(1:length(eigenvalues)), rep(1, length(eigenvalues)))
colnames(df) <- c("eigenvalues", "components", "abline")
plot(eigenvalues)
abline(h=1, col="red")

#######
if (factor_selectionciterion == "eigenvalue")
  factors_selected = sum(Variance_Explained_Table_copy[,1] >= 1)
if (factor_selectionciterion == "variance")
  factors_selected = 1:head(which(Variance_Explained_Table_copy[,"cumulative percentage of variance"]>= minimum_variance_explained),1)
if (factor_selectionciterion == "manual")
  factors_selected = manual_numb_factors_used

Rotated_Results<-principal(ProjectDataFactor, nfactors=max(factors_selected), rotate=rotation_used,score=TRUE)
Rotated_Factors<-round(Rotated_Results$loadings,2)
Rotated_Factors<-as.data.frame(unclass(Rotated_Factors))
colnames(Rotated_Factors)<-paste("Comp.",1:ncol(Rotated_Factors),sep="")

sorted_rows <- sort(Rotated_Factors[,1], decreasing = TRUE, index.return = TRUE)$ix
Rotated_Factors <- Rotated_Factors[sorted_rows,]

write.csv(Rotated_Factors, file = "Rotated_Factors.csv")

# Threshold them
Rotated_Factors_thres <- Rotated_Factors
Rotated_Factors_thres[abs(Rotated_Factors_thres) < MIN_VALUE]<-NA
colnames(Rotated_Factors_thres)<- colnames(Rotated_Factors)
rownames(Rotated_Factors_thres)<- rownames(Rotated_Factors)

ROTATED_FACTORS = round(Rotated_Factors_thres,2)
View(ROTATED_FACTORS)
write.csv(Rotated_Factors_thres, file = "Rotated_Factors_thres.csv")

############################################################################################################
# STEP 6: SAVE FACTOR DATA
NEW_ProjectData <- round(Rotated_Results$scores[,1:factors_selected,drop=F],2)
colnames(NEW_ProjectData)<-paste("DV (Factor)",1:ncol(NEW_ProjectData),sep=" ")

FACTOR_SCORES_SAMPLE = round((head(NEW_ProjectData, 10)),2)
View(FACTOR_SCORES_SAMPLE)
write.csv(NEW_ProjectData, file = "FactorScores.csv")

############################################################################################################
############################################################################################################
# PART 2: SEGMENTATION
############################################################################################################
############################################################################################################
############################################################################################################
if (RUN_PART_2){
  
  
  ProjectData <- ProjectData_INITIAL
  
  segmentation_attributes_used <- intersect(segmentation_attributes_used, 1:ncol(ProjectData))
  profile_attributes_used <- intersect(profile_attributes_used, 1:ncol(ProjectData))
  
  ProjectData_segment <- ProjectData[,segmentation_attributes_used]
  ProjectData_profile <- ProjectData[,profile_attributes_used]
  
  ProjectData_scaled <- apply(ProjectData, 2, function(r) if (sd(r)!=0) (r-mean(r))/sd(r) else 0*r)
  
  Hierarchical_Cluster_distances <- dist(ProjectData_segment, method=distance_used)
  Hierarchical_Cluster <- hclust(Hierarchical_Cluster_distances, method=hclust_method)
  # Display dendogram
  labels <- (length(Hierarchical_Cluster$labels) > 40)
  ggdendrogram(Hierarchical_Cluster, theme_dendro=FALSE, labels=labels) +
    xlab("Observations") + ylab("Height")
  
  
  num <- nrow(ProjectData) - 1
  DENDROGRAM_DISTANCES = head(Hierarchical_Cluster$height[length(Hierarchical_Cluster$height):1],20)
  plot(DENDROGRAM_DISTANCES, type="l")
  
  ####
  # Save the clusters
  
  cluster_memberships_hclust <- as.vector(cutree(Hierarchical_Cluster, k=numb_clusters_used)) # cut tree into as many clusters as numb_clusters_used
  cluster_ids_hclust=unique(cluster_memberships_hclust)
  
  ProjectData_with_hclust_membership <- cbind(1:length(cluster_memberships_hclust),cluster_memberships_hclust)
  colnames(ProjectData_with_hclust_membership)<-c("Observation Number","Cluster_Membership")
  
  write.csv(round(ProjectData_with_hclust_membership, 2), file = "ProjectData_with_hclust_membership.csv")
  
  ### K-MEANS 
  kmeans_clusters <- kmeans(ProjectData_segment,centers= numb_clusters_used, iter.max=2000, algorithm=kmeans_method)
  ProjectData_with_kmeans_membership <- cbind(1:length(kmeans_clusters$cluster),kmeans_clusters$cluster)
  colnames(ProjectData_with_kmeans_membership)<-c("Observation Number","Cluster_Membership")
  write.csv(round(ProjectData_with_kmeans_membership, 2), file = "ProjectData_with_kmeans_membership.csv")
  
  cluster_memberships_kmeans <- kmeans_clusters$cluster 
  cluster_ids_kmeans <- unique(cluster_memberships_kmeans)
  
  if (profile_with == "hclust"){
    cluster_memberships <- cluster_memberships_hclust
    cluster_ids <-  cluster_ids_hclust  
  }
  if (profile_with == "kmeans"){
    cluster_memberships <- cluster_memberships_kmeans
    cluster_ids <-  cluster_ids_kmeans
  }
  
  ### PROFILE THE SEGMENTS
  NewData = matrix(cluster_memberships,ncol=1)
  
  population_average = matrix(apply(ProjectData_profile, 2, mean), ncol=1)
  colnames(population_average) <- "Population"
  Cluster_Profile_mean <- sapply(sort(cluster_ids), function(i) apply(ProjectData_profile[(cluster_memberships==i), ], 2, mean))
  if (ncol(ProjectData_profile) <2)
    Cluster_Profile_mean=t(Cluster_Profile_mean)
  colnames(Cluster_Profile_mean) <- paste("Seg.", 1:length(cluster_ids), sep="")
  cluster.profile <- cbind (population_average,Cluster_Profile_mean)
  
  SEGMENT_PROFILES= round(cluster.profile, 2)
  View(SEGMENT_PROFILES)
  write.csv(SEGMENT_PROFILES, file = "cluster.profile.csv")
  
  ######
  
  ProjectData_scaled_profile = ProjectData_scaled[, profile_attributes_used,drop=F]
  
  Cluster_Profile_standar_mean <- sapply(sort(cluster_ids), function(i) apply(ProjectData_scaled_profile[(cluster_memberships==i), ,drop = F], 2, mean))
  if (ncol(ProjectData_scaled_profile) < 2)
    Cluster_Profile_standar_mean = t(Cluster_Profile_standar_mean)
  colnames(Cluster_Profile_standar_mean) <- paste("Seg ", 1:length(cluster_ids), sep="")
  
  iplot.df(melt(cbind.data.frame(idx=as.numeric(1:nrow(Cluster_Profile_standar_mean)), Cluster_Profile_standar_mean), id="idx"), xlab="Profiling variables (standardized)",  ylab="Mean of cluster")
  
  df_toplot = melt(cbind.data.frame(idx=as.numeric(1:nrow(Cluster_Profile_standar_mean)), 
                                    Cluster_Profile_standar_mean), 
                   id="idx")
  ggplot(df_toplot,
         aes_string(x=colnames(df_toplot)[1], y="value", colour="variable")) + 
    geom_line()

  write.csv(round(Cluster_Profile_standar_mean, 2), file = "Cluster_Profile_standar_mean.csv")

  ####
  
  population_average_matrix <- population_average[,"Population",drop=F] %*% matrix(rep(1,ncol(Cluster_Profile_mean)),nrow=1)
  cluster_profile_ratios <- (ifelse(population_average_matrix==0, 0,Cluster_Profile_mean/population_average_matrix))
  colnames(cluster_profile_ratios) <- paste("Seg.", 1:ncol(cluster_profile_ratios), sep="")
  rownames(cluster_profile_ratios) <- colnames(ProjectData)[profile_attributes_used]
  ## printing the result in a clean-slate table
  SEGMENT_PROFILES_RELATIVE = round(cluster_profile_ratios-1, 2)
  View(SEGMENT_PROFILES_RELATIVE)
  write.csv(SEGMENT_PROFILES_RELATIVE, file = "cluster.profile.relative.csv")
  
}
