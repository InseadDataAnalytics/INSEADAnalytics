Clustering.data=read.csv(file.choose(), header=FALSE) 
#Examine the data 
str(Clustering.data)
summary(Clustering.data)

# This is a 2-dimensional data, so we can plot it
plot(Clustering.data)

# Create the k-means model and call it km.out
km.out<-kmeans(Clustering.data,centers=3,nstart=20,iter.max = 50)

print(km.out) # Print the km.out object

km.out$centers # Print averages for centeroids by variable

km.out$cluster # Print the cluster memberships

# Scatter plot of clusters
plot(Clustering.data, col=km.out$cluster, main="k-means with 3 clusters")

# Illustrate randomness in cluster creation
set.seed(77850)
par(mfrow = c(2, 3))
for(i in 1:6) {
  # Run kmeans() with three clusters and one start
  km.out <- kmeans(Clustering.data, centers=3, nstart=1, iter.max = 50)
  
  # Plot clusters
  plot(Clustering.data, col = km.out$cluster, 
       main = km.out$tot.withinss, 
       xlab = "", ylab = "")
}

###
### Hierarchical clustering
###

hclust.out<-hclust(d=dist(Clustering.data, method = "euclidean"), method="complete") #dist(Clustering.data, method = "manhattan")

# Plot the dendogram/tree and a cut
par(mfrow = c(1, 1))
plot(hclust.out)
abline(h=7, col="red")

# Cut by height
clusters_h_method<-cutree(hclust.out, h=7)
plot(Clustering.data, col=clusters_h_method, main="Hierarchical clustering by distance")

# Cut by number of clusters
clusters_k_method<-cutree(hclust.out, k=3)
plot(Clustering.data, col=clusters_k_method, main="Hierarchical clustering by number")

###
### Compare methods
###

# Re-create the k-means model with 3 clusters, for comparison
km.out<-kmeans(Clustering.data,centers=3,nstart=20,iter.max = 50)

table(km.out$cluster)
table(clusters_k_method)
table(km.out$cluster, clusters_k_method)

# Note, cluster labels (what is "cluser 1") are random, hence no easy way to match; see here for one method: https://www.r-bloggers.com/matching-clustering-solutions-using-the-hungarian-method/

par(mfrow = c(1, 2))
plot(Clustering.data, col=km.out$cluster, main="k-means with 3 clusters")
plot(Clustering.data, col=clusters_k_method, main="Hierarchical clustering by number")

###
### Elbow plot
###

# Initialize total within sum of squares error: wss
wss <- 0

# For 1 to 15 cluster centers
for (i in 1:15) {
  km.out <- kmeans(Clustering.data, centers=i, nstart=20, iter.max = 50)
  # Save total within sum of squares to wss variable
  wss[i] <- km.out$tot.withinss
}

# Plot total within sum of squares vs. number of clusters
par(mfrow = c(1, 1))
plot(1:15, wss, type = "b", 
     xlab = "Number of Clusters", 
     ylab = "Within groups sum of squares")

# Set number of clusters equal to the number of clusters corresponding to the elbow location. In our case (obviously, k=2)

###
### "Snake" plot of centroid averages
###

# Re-create the k-means model with 3 clusters, for comparison
km.out<-kmeans(Clustering.data,centers=3,nstart=20,iter.max = 50)

ul<-max(km.out$centers) # upper and lower limits for plotting
ll<-min(km.out$centers)

plot(km.out$centers[1,], type = "o", col="red", ylim=(c(ll,ul)), xlab=NA, xaxt="n", ylab="centroid means")
axis(1,at=1:ncol(Clustering.data), las=2, labels=c(colnames(Clustering.data)))
lines(km.out$centers[2,], type = "o", col="green")
lines(km.out$centers[3,], type = "o", col="black")
legend("bottomright", legend=c("cluster 1", "cluster 2","cluster 3"), col=c("red", "green", "black"), lty=1)

###
### Finish the analyses, write-out the results, map new datapoints
###

write.csv(km.out$centers, file="k-means_centers.csv")
write.csv(km.out$cluster, file="k-means_clusters.csv")

# check whith cluster a new datapoint maps to
newdata<-c(0,0) #these are the coordinates of the new datapoint
which.min(sapply(1:3, function(x) sum((newdata - km.out$centers[x,])^2))) # here 1:3 refers to comparison over k=3 clusters
