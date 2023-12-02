#PRÁCTICA CLUSTERING

# KMeans
clusterdb=USArrests
summary(clusterdb) #tienen diferentes escalas entonces requiere escalar
escalable=clusterdb
escalable=scale(escalable)

library(NbClust)
#determinar k:
#Hace todos los métodos
NbClust(escalable,min.nc = 2,max.nc = 10,method = "complete",index = "all")
#según los 4 métodos, el número óptimo de clusters es K=4

library(factoextra)
#Hace método del codo (elbow)
fviz_nbclust(escalable, kmeans, method = "wss")+geom_vline(xintercept = 4, linetype = 2)+
  labs(subtitle = "Elbow method")

res_km=kmeans(escalable,4,nstart = 25)
fviz_cluster(res_km,clusterdb,frame.type="convex") #para graficarlo hace PCA

clusterdb$cluster=res_km$cluster
agrupaciones = clusterdb %>% group_by(cluster) %>% summarise(murder=mean(Murder),asaltos=mean(Assault),poblacion_urbana=mean(UrbanPop),rape=mean(Rape))
agrupaciones #análisis por grupo

#CONCLUSIÓN:
#1-Los que tienen un cluster de 2 y 4 son los estados más peligrosos a nivel general.
#2-Los de grupo 1 son Estados urbanos con poca criminalidad y los del 4 son urbanos con mucha criminalidad.
#Los del 2 son rurales con mucha criminalidad y los del 3 son rurales con poca criminalidad.
