fp <- read.csv("/Users/coreylucero/Desktop/Syracuse/IST565/Week 4 - Cluster Analysis/fedPapers85.csv")

str(fp)
View(fp)

#Perform kmeans cluster analysis with k=4 removing author labels
fpkcluster <- kmeans(fp[,3:72], 4, nstart=30)
fpkcluster

#Append the cluster assignment to the original dataset
fp <- data.frame(fp, fpkcluster$cluster)

#plot the dataset to visually determine which author wrote the disputed papers
plot(fp$author, fp$fpkcluster.cluster)

#table to see numeric values of cluster assignments
table(fp$author, fp$fpkcluster.cluster)

#Perform hierarchical cluster analysis
d=dist(as.matrix(fp[,3:72]))
fphcluster=hclust(d)

#Visualize dendrogram
plot(fphcluster)

clusterCut <- cutree(fphcluster, 4)

#View table
clust <- table(clusterCut, fp$author)
clust 

#Show visually
plot(clust)
