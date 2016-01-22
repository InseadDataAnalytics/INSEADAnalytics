
repetitioncode_example <- function(distance_used,hclust_method,numb_clusters_used,dataset){
  
  Hierarchical_Cluster_distances <- dist(dataset, method=distance_used)
  Hierarchical_Cluster <- hclust(Hierarchical_Cluster_distances, method=hclust_method)
  
  plot1 %<a-% {plot(Hierarchical_Cluster, main = NULL, sub=NULL, labels = 1:nrow(dataset), xlab="Our Observations", cex.lab=1, cex.axis=1) 
    # Draw dendogram with red borders around the 3 clusters
    rect.hclust(Hierarchical_Cluster, k=numb_clusters_used, border="red") 
  }
  
  df1 <- cbind(as.data.frame(Hierarchical_Cluster$height[length(Hierarchical_Cluster$height):1]), c(1:(nrow(ProjectData)-1)))
  colnames(df1) <- c("distances","index")
  Line <- gvisLineChart(as.data.frame(df1), xvar="index", yvar="distances", options=list(title='Distances plot', legend="right", width=900, height=600, hAxis="{title:'Number of Components', titleTextStyle:{color:'black'}}", vAxes="[{title:'Distances'}]", series="[{color:'green',pointSize:3, targetAxisIndex: 0}]"))
  
  
  text1 = paste("We now use as distance_used the method **",distance_used, "** and as hclust_method used the method **",hclust_method,"**", sep="")
  text2 = "Finally, we can see the **dendrogram** (see class readings and online resources for more information) to have a first rough idea of what segments (clusters) we may have - and how many."
  
  text3 = "We can also plot the 'distances' traveled before we need to merge any of the lower and smaller in size clusters into larger ones - 
  the heights of the tree branches that link the clusters as we traverse the tree from its leaves to its root. If we have n observations, 
  this plot has n-1 numbers."
  
  all_results = list(
    plot1 = plot1,
    Line = Line,
    text1 = text1,
    text2 = text2,
    text3 = text3
  )
  
}