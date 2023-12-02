#PRÁCTICA RELACIÓN ENTRE VARIABLES

dt = read_csv('spotify.csv')

#A) Medidas de tendencia central (media,mediana,moda), variacion o frecuencia.
mean(dt$duration_ms)
median(dt$duration_ms)
moda <- function(vector) {                 
  valores_unicos <- unique(vector)
  cant_repeticiones <- tabulate(match(vector, valores_unicos))
  return(valores_unicos[cant_repeticiones == max(cant_repeticiones)])
}
moda(dt$genre)
sd(dt$duration_ms)
frec=function(vector){
  unicos=unique(vector)
  return(tabulate(match(vector,unicos)))
}
frec(dt$genre)

#B) Incorporar al menos 2 visualizaciones (con ggplot o no)
ggplot(dt,aes(dt$loudness,dt$energy))+geom_point() + geom_smooth(method="lm")
ggplot(dt)+geom_point(aes(dt$liveness,dt$duration_ms))

#C) Establecer una pregunta que vincule dos variables numericas, determinar el test adecuado, ejecutarlo e interpretarlo
#Pregunta: Determinar si un nivel mayor de ruido repercute en un mayor nivel de energía
ggplot(dt,aes(dt$loudness,dt$energy))+geom_point() + geom_smooth(method="lm")
#A partir del gráfico, parece haber relación entre el ruido y la energía
#El test apropiado es el test de correlación
cor.test(dt$loudness,dt$energy)
#Como el p-valor es menor al alfa=0.05, hay suficiente evidencia estadística para afirmar que hay correlación positiva entre las variables 

#D) Establecer una pregunta que vincule dos variables categoricas, determinar el test adecuado, ejecutarlo e interpretarlo 
#Pregunta: Evaluar si existe independencia entre las variables mode y esplicit
plot(table(dt$explicit,dt$mode))
dt %>%
  filter(!is.na(explicit)) %>%
  group_by(explicit,mode) %>%
  count() %>%
  ggplot(aes(x=explicit,y=n,fill=as.factor(mode))) +
  geom_bar(stat="identity",position="fill") #no evalúa el dato, sino su proporción

#Gráficamente parece que las variables son independientes entre sí
#El test adecuado es el de Chi Cuadrado para evaluar la independencia entre las dos varibles categóricas
chisq.test(dt$explicit,dt$mode)
#Como el p-valor es mayor que el alfa 0.05, entonces no hay suficiente evidencia estadística para afirmar que las variables no son independientes
           
#E) Establecer una pregunta que vincule una variable categoricas y una numerica, determinar el test adecuado, ejecutarlo e interpretarlo 
#Pregunta: La diferencia en Loudness varía significativamente dependiendo si la canción es explicit o no?

dt %>% filter(!is.na(explicit)) %>% ggplot(aes(x=loudness, color=explicit)) + geom_density()
dt %>% filter(explicit) %>% select(loudness)
#El test adecuado es el t test para evaluar la diferencia de medias entre las dos categorías
t.test(dt %>% filter(explicit) %>% select(loudness), dt %>% filter(!explicit) %>% select(loudness))
#Como el p-valor es menor al alfa=0.05, hay suficiente evidencia estadística para afirmar que existe diferencia significativa entre la media de loudness para ambas categorías
#(PARA MÚLTIPLES CATEGORÍAS HAY QUE REALIZAR aov() y TukeyHSD() PARA EVALUAR LA DIF DE MEDIAS)