#PRÁCTICA PCA (para numéricas)

pcadb=iris
pcadb_sin_species=pcadb %>% dplyr::select(-Species) #xq no es una variable que explique
library(corrplot)
corrplot(cor(pcadb_sin_species),method = "ellipse")

cp=prcomp(pcadb_sin_species,scale=T) #saca componentes principales
summary(cp)
#opciones para elegir cuántos componentes principales:
#1-tomo el primer componente porque es el único que tiene un autovalor>1 (sd)
#2-tomo solo el primer componente (índice) que explica el 72% de la variabilidad total
#3-tomo tantos componentes como variabilidad total quiera explicar (3 explican 99%)

#hace PCA
library(FactoMineR)
pca=PCA(X = pcadb_sin_species, scale.unit = TRUE, ncp = 2, graph = T)#el graph=T devuelve matriz de rotación y gráfico de componentes

#gráfico de componentes (por individuo/registro)
fviz_pca_ind(pca, geom.ind = "point", 
             col.ind = "#FC4E07", 
             axes = c(1, 2), 
             pointsize = 1.5) 

#gráfico de componentes (por individuo/registro) pero coloreado por cada cluster
pcadb=cbind(pcadb,pca$ind$coord)
pcadb %>% ggplot(aes(Dim.1,Dim.2,colour=as.factor(Species))) + geom_point()
# Parece que las Setosas tienen bajo Componente 1

#matriz de rotación
cp$rotation
#(agregar grafico rotacion)
#La matriz de rotación sirve para visualizar el nivel de afectación de cada variable a cada uno de los componentes principales

#Un uso de PCA podría ser calcular un índice
#este índice explica el 72% de la varianza total del dataset
pcadb2=pcadb_sin_species
summary(cp)
pca_1cp=PCA(X = pcadb2, scale.unit = TRUE, ncp = 1, graph = T)
pcadb2$indice=pca_1cp$ind$coord
pcadb2 %>% arrange(desc(indice))

#-------------------------------------------------------------------------
#PRÁCTICA MCA (para categóricas)

mask=read.csv("MaskBeliefs.csv")
mask_sup=mask %>% select(Gender)

#a) ¿Cuanto del segundo componente se explica por el Genero?
mca = MCA(mask,graph=T)
fviz_screeplot(mca)
mca$svd$vs #muestra autovalores de los componentes
round(mca$svd$vs**2/sum(mca$svd$vs**2),3) #muestra proporciones de explicación de la variablidad total de cada componente

#hace gráfico de variables
fviz_mca_var(mca, col.var = "cos2", #represents the quality of the representation for variables on the factor map
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE, # Avoid text overlapping
             ggtheme = theme_minimal())

#mca$svd$U --> toma por individuos
#mca$svd$V --> toma por variables

cp2 = mca$svd$U[,1:2] %>% as_tibble() #tomo los primeros 2 componentes
h2 = cbind(mask,cp2)

cp4 = mca$svd$U[,1:4] %>% as_tibble() #tomo los primeros 4 componentes
h4=cbind(mask,cp4)

lm(V2~Gender, h2) %>% summary()
lm(V2~Gender, h4) %>% summary()
#El género explica un 34.5% del segundo componente

#b) ¿Cuanto del primer componente se explica por creer que evita el contagio?
lm(V1~PreventSpread, h2) %>% summary()
lm(V1~PreventSpread, h4) %>% summary()
#Creer que evita el contagio explica un 51.59% del primer componente

#c) Analizando el segundo componente, ¿cual es el vinculo entre el genero y el motivo del uso del barbijo? (que categorías estan cercas unas de otras)
#hace gráfico de variables
fviz_mca_var(mca, col.var = "cos2", #represents the quality of the representation for variables on the factor map
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE, # Avoid text overlapping
             ggtheme = theme_minimal())

#Mirando el segundo componente, los hombres están más cerca de usar barbijo para protegerse de sí mismos, de no usarlo en espacios públicos y de usarlo solo porque están obligados.
#Por otro lado, las mujeres están mas cerca de usarlo para proteger tanto a sí mismas como a otros y de usarlo en espacios públicos.

#d) Caracterizar a la persona con un primer componente alto. 
#Una persona con un primer componente alto es una persona más propensa a no usarlo en espacios públicos, usarlo solo por obligación, no creer que previene el contagio y salir a cenar más de 3 veces a la semana.

#e) Estudiar los componentes extraidos a la luz de la variable Public
h2 %>% ggplot(aes(x=V1,y=V2,color=Public))+geom_point(alpha = 0.7)
#O si se quiere visualizar un solo componente principal con la variable
h2 %>% ggplot(aes(x=V1,y=0,color=Public))+geom_point(alpha = 0.7)

#-------------------------------------------------------------------------
#PRÁCTICA ANÁLISIS FACTORIAL

brand.ratings <- read.csv("http://goo.gl/IQl8nc") %>% as_tibble()
brand.nm = brand.ratings[,1:9] #saca la marca
r.mat = cor(brand.nm) #saca matriz de correlación

corrplot(r.mat)

#factores 
eigens <- eigen(r.mat) #muestra autovalores
eigens$values/sum(eigens$values) #muestra porcentaje de variabilidad que explica cada uno 

library(nFactors)
#Cantidad de Factores:
#1-Todos los test
nS = nScree(r.mat)
plotnScree(nS) #Prueba con todos los test. En este caso todos sugieren 3 factores.
#2-Scree Test
eigendf = enframe(eigens$values)
eigendf$random = eigens$values #tomo los factores con autovalores mayores a 1

nfactors=2 #tomo 2 factores para poder graficar

library(GPArotation)
#library(RColorBrewer)
#library(gplots)
library(semPlot)
fact2 = factanal(brand.nm, factors=nfactors, rotation = 'oblimin',scores="Bartlett")
semPaths(fact2, what="est", residuals=FALSE,
         cut=0.3, posCol=c("white", "darkgreen"), negCol=c("white", "red"),
         edge.label.cex=0.75, nCharNodes=7)


fact3 = factanal(brand.nm, factors=nfactors+1)
semPaths(fact3, what="est", residuals=FALSE,
         cut=0.3, posCol=c("white", "darkgreen"), negCol=c("white", "red"),
         edge.label.cex=0.75, nCharNodes=7)


fact2 = factanal(brand.nm, factors=nfactors, rotation = 'none',scores="Bartlett")
semPaths(fact2, what="est", residuals=FALSE,
         cut=0.3, posCol=c("white", "darkgreen"), negCol=c("white", "red"),
         edge.label.cex=0.75, nCharNodes=7)

#ROTATION puede ser: varimax, oblimin, none o default (no se pone el método)

#guarda valores de los factores
brand.scores = fact2$scores %>% as_tibble() #%>% ggplot(aes(Factor1,Factor2))+geom_point()

brand.scores["brand"] = brand.ratings[,"brand"] #vuelve a insertar la marca
brand.fa.mean <- aggregate(. ~ brand, data=brand.scores, mean) #agrupa por marca
names(brand.fa.mean)=c("brand","precio","calidad")
rownames(brand.fa.mean)=brand.fa.mean[, 1]

brand.fa.mean %>% ggplot(aes(precio,calidad,col=brand))+geom_point() #grafica cada marca con respecto a sus dos factores (en este caso se determinó que representaban precio y calidad)

brand.fa.mean <- brand.fa.mean[, -1]
heatmap.2(as.matrix(brand.fa.mean),
          col=brewer.pal(9, "GnBu"), trace="none", key=FALSE, dend="none",
          cexCol=1.2, main="\n\n\n\n\n\nMean factor score by brand")
