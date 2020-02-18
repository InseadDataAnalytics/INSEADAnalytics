
Pokemon.data=read.csv(file.choose(), header=TRUE) 

Pokemon.data<-Pokemon.data[c(1:100),]

#Examine the data 
str(Pokemon.data)
Pokemon.data$Generation<-as.factor(Pokemon.data$Generation)

Pokemon.numerical.data<-Pokemon.data[,c(6:11)]

rownames(Pokemon.numerical.data)<-Pokemon.data$Name

###
### K-means clustering
###

# First we need to get an intuition about how many clusters ar there
# Initialize total within sum of squares error: wss
wss <- 0

# Look over 1 to 15 possible clusters
for (i in 1:15) {
  # Fit the model: km.out
  km.out <- kmeans(Pokemon.numerical.data, centers = i, nstart = 20, iter.max = 50)
  # Save the within cluster sum of squares
  wss[i] <- km.out$tot.withinss
}
par(mfrow = c(1, 1))
# Produce a scree plot
plot(1:15, wss, type = "b", 
     xlab = "Number of Clusters", 
     ylab = "Within groups sum of squares")

# Select number of clusters
k <- 3

# Build model with k clusters: km.pokemon
km.pokemon <- kmeans(Pokemon.numerical.data, centers = k, nstart = 20, iter.max = 50)

# View the resulting model
km.pokemon

# Visualize cluster membership, e.g., plot of Defense vs. Speed by cluster
plot(Pokemon.numerical.data[, c("Defense", "Speed")],
     col = km.pokemon$cluster,
     main = paste("k-means clustering of Pokemons with", k, "clusters"),
     xlab = "Defense", ylab = "Speed", pch=19)

# Visualize the "snake" plot of centroid means for different variable 
ul<-max(km.pokemon$centers)
ll<-min(km.pokemon$centers)

plot(km.pokemon$centers[1,], type = "o", col="red", ylim=(c(ll,ul)), xlab=NA, xaxt="n", ylab="centroid means")
axis(1,at=1:ncol(Pokemon.numerical.data), las=2, labels=c(colnames(Pokemon.numerical.data)))
lines(km.pokemon$centers[2,], type = "o", col="green")
lines(km.pokemon$centers[3,], type = "o", col="black")
legend("topleft", legend=c("cluster 1", "cluster 2","cluster 3"), col=c("red", "green", "black"), lty=1)

###
### Hierarchical clustering
###

# Create hierarchical clustering model: hclust.pokemon
hclust.pokemon<-hclust(dist(Pokemon.numerical.data), method="complete")

# Apply cutree() to hclust.pokemon: cut.pokemon
cut.pokemon<-cutree(hclust.pokemon, k=3)
plot(hclust.pokemon, main = "Complete")

# Compare methods
table(km.pokemon$cluster)
table(cut.pokemon)
table(km.pokemon$cluster, cut.pokemon)

# Plot of Defense vs. Speed by cluster membership
par(mfrow = c(1, 2))
# first, k-means
plot(Pokemon.numerical.data[, c("Defense", "Speed")],
     col = km.pokemon$cluster,
     main = paste("k-means clustering of Pokemons with", k, "clusters"),
     xlab = "Defense", ylab = "Speed", pch=19)

# second, hierarchical
plot(Pokemon.numerical.data[, c("Defense", "Speed")],
     col = cut.pokemon,
     main = paste("Hierarchical clustering of Pokemons with", k, "clusters"),
     xlab = "Defense", ylab = "Speed", pch=19)

###
### Scaling
###

# View column means
colMeans(Pokemon.numerical.data)

# View column standard deviations
apply(Pokemon.numerical.data, 2, sd)

# Scale the data
Pokemon.numerical.data.scaled<-scale(Pokemon.numerical.data)
colMeans(Pokemon.numerical.data.scaled)

# Build model with k clusters: km.pokemon
km.pokemon <- kmeans(Pokemon.numerical.data.scaled, centers = k, nstart = 20, iter.max = 50)


# Build hierarchical clustering model: hclust.pokemon
hclust.pokemon<-hclust(dist(Pokemon.numerical.data.scaled), method="complete")

# Apply cutree() to hclust.pokemon: cut.pokemon
cut.pokemon<-cutree(hclust.pokemon, k=3)

# Compare methods
table(km.pokemon$cluster)
table(cut.pokemon)
table(km.pokemon$cluster, cut.pokemon)

par(mfrow = c(1, 2))
# first, k-means
plot(Pokemon.numerical.data[, c("Defense", "Speed")],
     col = km.pokemon$cluster,
     main = paste("k-means clustering of Scaled Pokemons with", k, "clusters"),
     xlab = "Defense", ylab = "Speed", pch=19)

# second, hierarchical
plot(Pokemon.numerical.data[, c("Defense", "Speed")],
     col = cut.pokemon,
     main = paste("Hierarchical clustering of Scaled Pokemons with", k, "clusters"),
    xlab = "Defense", ylab = "Speed", pch=19)

###
### Dimensionality reduction: Principle Component Analyses, PCA
###

pr.out<-prcomp(Pokemon.numerical.data,scale=TRUE, center=TRUE) # Perform "scaled "base-case" PCA

summary(pr.out) # Inspect model output

pr.out$rotation # Inspect PCA factor loadings

# to be more visually appealing, remove loadings that are small (here, less than 0.3)
pr.out.factor.loadings<-pr.out$rotation
pr.out.factor.loadings[abs(pr.out.factor.loadings)<0.3]<-NA
pr.out.factor.loadings
# Plot variance explained for each principal component

pr.var <- pr.out$sdev^2 #calculate variance explained
pve <- pr.var / sum(pr.var) #calculate % variance explained 
par(mfrow = c(1, 2))
plot(pve, xlab = "Principal Component",
     ylab = "Proportion of Variance Explained",
     ylim = c(0, 1), type = "b")

# Plot cumulative proportion of variance explained
plot(cumsum(pve), xlab = "Principal Component",
     ylab = "Cumulative Proportion of Variance Explained",
     ylim = c(0, 1), type = "b")

# Plot variance explained, "eigenvalues"
par(mfrow = c(1, 1))
plot(pr.var, xlab = "Principal Component",
     ylab = "Eigenvalue (variance explained)", type = "b")
abline(1,0)

# Biplot of the first two components
biplot(pr.out) 

###
### Scaling in PCA
###

# PCA model with scaling: pr.with.scaling
pr.with.scaling<-prcomp(Pokemon.numerical.data, scale=TRUE)

# PCA model without scaling: pr.without.scaling
pr.without.scaling<-prcomp(Pokemon.numerical.data, scale=FALSE)

# Create biplots of both for comparison
par(mfrow=c(1,2))
biplot(pr.with.scaling)
biplot(pr.without.scaling)

# check clustering with and withour PCA
pokemon.data.PCA<-pr.with.scaling$x[,c(1:3)]
km.pokemon.PCA <- kmeans(pokemon.data.PCA, centers = k, nstart = 20, iter.max = 50)
table(km.pokemon$cluster, km.pokemon.PCA$cluster)

cut.pokemon.PCA<-cutree(hclust(dist(pokemon.data.PCA), method="complete"), k=3)
table(cut.pokemon, cut.pokemon.PCA)

###
### PCA with factors
###

combinerarecategories<-function(data_frame,mincount){ 
  for (i in 1 : ncol(data_frame)){
    a<-data_frame[,i]
    replace <- names(which(table(a) < mincount))
    levels(a)[levels(a) %in% replace] <-paste("Other",colnames(data_frame)[i],sep=".")
    data_frame[,i]<-a }
  return(data_frame) }

Pokemon.data<-combinerarecategories(Pokemon.data,5)

Pokemon.factors.onehot.encoding<-model.matrix(ID~Type.1 + Type.2, data=Pokemon.data)[,-1] #+ Generation   + Legendary
Pokemon.data.matrix<-cbind(Pokemon.numerical.data,Pokemon.factors.onehot.encoding)

pr.with.scaling.PCA<-prcomp(Pokemon.data.matrix, scale=TRUE, center=TRUE)

# lets look at the first 5 principle components and their respective loadings
PCA.factor.loadings<-pr.with.scaling.PCA$rotation[,c(1:5)]

# to be more visually appealing, remove loadings that are small (here, less than 0.3)
PCA.factor.loadings[abs(PCA.factor.loadings)<0.3]<-NA
PCA.factor.loadings

# now lets cluster with top 5 principle components
pokemon.data.PCA<-pr.with.scaling.PCA$x[,c(1:5)]
km.pokemon.PCA <- kmeans(pokemon.data.PCA, centers = k, nstart = 20, iter.max = 50)

# ... and see the differences, as a table:
table(km.pokemon$cluster, km.pokemon.PCA$cluster)

# ... and as a graph:
par(mfrow = c(1, 2))
plot(Pokemon.numerical.data[, c("Defense", "Speed")],
     col = km.pokemon$cluster,
     main = paste("k-means with", k, "clusters, numeric data"),
     xlab = "Defense", ylab = "Speed", pch=19)

plot(Pokemon.numerical.data[, c("Defense", "Speed")],
     col = km.pokemon.PCA$cluster,
     main = paste("k-means with", k, "clusters, numeric+factor data, top 5 PCs"),
     xlab = "Defense", ylab = "Speed", pch=19)

# Snake plot on top 5 PCAs

# Visualize the "snake" plot of centroid means for different variable 
ul<-max(km.pokemon.PCA$centers)
ll<-min(km.pokemon.PCA$centers)

par(mfrow = c(1, 1))
plot(km.pokemon.PCA$centers[1,], type = "o", col="red", ylim=(c(ll,ul)), xlab=NA, xaxt="n", ylab="centroid means")
axis(1,at=1:ncol(pokemon.data.PCA), las=2, labels=c(colnames(pokemon.data.PCA)))
lines(km.pokemon.PCA$centers[2,], type = "o", col="green")
lines(km.pokemon.PCA$centers[3,], type = "o", col="black")
legend("topright", legend=c("cluster 1", "cluster 2","cluster 3"), col=c("red", "green", "black"), lty=1)

###
### Finish the analyses, write-out the results
###

write.csv(pr.with.scaling.PCA$rotation, file="Pokemon_PCA_loadings.csv")
write.csv(km.pokemon.PCA$centers, file="Pokemon_PCA_k-means_centers.csv")
write.csv(km.pokemon.PCA$cluster, file="Pokemon_PCA_k-means_clusters.csv")

