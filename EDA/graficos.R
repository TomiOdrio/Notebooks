#PRÁCTICA GRAFICOS
setwd("G:/Mi unidad/Notebooks_Repo/data")

df=read.csv("bike_buyersorig.csv")
df_clean = na.omit(df)

#barras
counts = table(df_clean$Cars, df_clean$Gender)
barplot(counts, main = '',
        xlab="Number of Gears",
        legend = rownames(counts))

#scatter plot
plot(df_clean$Income, type= "p")

#histograma
library(ggplot2)
ggplot(df_clean, aes(x = Age)) + geom_histogram()

#dot plot
ggplot(df_clean, aes(y = Age, x = Income)) + geom_point()

#density plot
plot(density(df_clean$Income), main='Income Density Spread')

#trend plot
ggplot(df_clean, aes(x = Age, y = Occupation)) + geom_line(aes(color = Age))

#boxplot
boxplot(df_clean$Income, main = 'Income Boxplot')
boxplot(df_clean[,c(1,4)], main='Multiple Box plots')
OutVals = boxplot(df_clean$Income)$out #outliers
which(df_clean$Income %in% OutVals) #valores de esos outliers

#frecuencia con librería funModeling
funModeling::freq(iris)

#PRÁCTICA 1
#1) Realizar un scatterplot de la base de datos de mtcars para
#comparar el peso (wt) y la acelearación (qsec)
ggplot(mtcars,aes(x=wt,y=qsec)) + geom_point()

#2) Al plot anterior, agregar la linea de tendencia
ggplot(mtcars,aes(x=wt,y=qsec)) + geom_point() + geom_smooth(method=lm)

#3) Realizar un histograma de la potencia (hp), divido por color de acuerdo a la cilindrada (cyl)
library(dplyr)
mtcars %>% ggplot(aes(x=hp, fill=as.factor(cyl))) + geom_histogram()

#4) De la base de datos nycflights13::flights, realizar un analisis
#grafico de la cantidad de vuelos según destinos.
install.packages("nycflights13")

nycflights13::flights %>% group_by(dest) %>% summarise(N=n()) %>% 
  arrange(-N) %>% head(10) %>%
  ggplot(aes(x= reorder(dest, -N), y = N))+geom_bar(stat="identity")

#5) Realizar el gráfico de variables numericas usando funModeling para la base nycflights13::flights
funModeling::plot_num(iris)

#PRÁCTICA 2
library(tidyverse)
zprop = read_csv('znorte_properati.csv')
zprop = zprop %>% filter(!is.na(rooms))
colnames(zprop)

#1) Graficar la relacion entre la cantidad de habitaciones y el
#precio en usd. Si tiene dudas incorpore escalas logaritmicas
#a) Con puntos (geom_point())
#b) Con lineas (geom_smooth(method='lm))
ggplot(zprop,aes(x=rooms,y=price_aprox_usd)) + geom_point()
ggplot(zprop,aes(x=rooms,y=price_aprox_usd)) + geom_smooth(methd=lm)

#2) Realice un grafico de barras para visualizar la cantidad de registros por 
#tipo de propiedad
ggplot(zprop,aes(x=property_type)) + geom_bar(stat="count")

#3) Realice un gr?fico de barras que permita visualizar la proporcion de habitaciones 
#por cada tipo de propiedad
zprop %>% group_by(property_type,rooms) %>% count() %>%
  ggplot(aes(fill=as.factor(rooms),y=n,x=property_type)) +
  geom_bar(position="fill",stat="identity")

#4) Realice un analisis grafico de la distribucion del precio
#a) Con un histograma
ggplot(zprop,aes(x=price)) + geom_histogram() + scale_x_log10()
#b) Con un boxplot
boxplot(zprop$price)
#c) Realice la apertura de las distribuciones por "property_type",
#?cual geom de distribucion es mas conveniente para esta apertura?
#?necesita alterar las escalas de los ejes?
zprop %>% count(rooms)# %>% unique()
zprop %>% ggplot(aes(x= price_aprox_usd, y = property_type))+geom_boxplot()+
  scale_x_log10()
