#PRÁCTICA IMPUTACIÓN Y MODELOS

#Genera df
x1=seq(100)+rnorm(100,mean = 0,sd=10)
x2=200+seq(100)+rnorm(100,mean = 2,sd=10)
p=(exp(5+0.8*x1-0.15*x2)/(1+exp(5+0.8*x1-0.15*x2)))+runif(n = 100,min = -0.5,max = 0.5) #construye razón de probabilidad
z=seq(length(p))

for (i in seq(length(p))) { #construye variable categórica
  if (p[i]>0.5){
    z[i]=1
  }else{
    z[i]=0
  }
}
y<-200+0.75*x1-1.5*x2+0.15*z +rnorm(100,mean = 0,sd=5) #la variable categórica z repercute en el valor de la Y (variable objetivo)

df= cbind(x1,x2,z,y)
df=as.data.frame(df)

#IMPUTACIÓN
#1) VARIABLE TARGET CATEGÓRICA

df_incompleto=df

df_incompleto$z[15]=NA
df_incompleto$z[25]=NA
df_incompleto$z[75]=NA

#MODELO NO CONDICIONAL (frecuencia, media, mediana)

dfnc=df_incompleto

frec=sum(dfnc$z,na.rm = TRUE)/length(df$z) #calculo frecuencia de los 1, como es > que 0.5, entonces les pongo a todos los NA un 1
input=0
if (frec>0.5){
  input=1
} else{
  input=0
}

dfnc$pred=input
dfnc[is.na(dfnc)]=input

#MODELO CONDICIONAL GLM (Generalized Linear Model)

dfc=df_incompleto

dfpred= dfc[is.na(dfc$z),] #valores NA a predecir
dftoprove= dfc[!is.na(dfc$z),] #valores con dato

#genera conjuntos train y test
dftoprove$id <- 1:nrow(dftoprove) #creo columna id para joinear
train <- dftoprove %>% dplyr::sample_frac(0.70) #70% como conjunto entrenamiento
test  <- dplyr::anti_join(dftoprove, train, by = 'id') #30% como conjunto prueba

#saco columna id
train=train[,(names(train)!="id")]
test=test[,(names(test)!="id")]

#genero modelo glm de Regresión Logística (para probabilidades)
logit=glm(z ~ x1 + x2 + y, family = binomial(link = "logit"), data=train)

summary(logit)

test$pred=predict(object = logit,type = "response",newdata = test)#crea columna en test con probabilidades de ser 1
test$predbin = (test$pred > 0.5) * 1 #crea columna en test con asignación de 1 o 0 según modelo

library(caret)
confusionMatrix(as.factor(test$predbin), as.factor(test$z)) #muestra errores de predicción en el test

which(is.na(dfc$z))
dfc[is.na(dfc)]=predict(object = logit,newdata = dfpred)#inputa en dff las probabilidades de ser 1 o 0 en la variable z
#asigno 1 o 0 dependiendo la probabilidad
dfc$z[dfc$z>0.5] = 1
dfc$z[dfc$z<=0.5] = 0

comparativa=data.frame(
  "termino" = c("dato_real","dato_modelo_nc","dato_modelo_c","dif real y nc","dif real y c"),
  "id_15" = c(df$z[15],dfnc[15,"z"],dfc[15,"z"],abs(df$z[15]-dfnc[15,"z"]),abs(df$z[15]-dfc[15,"z"])),  
  "id_25" = c(df$z[25],dfnc[25,"z"],dfc[25,"z"],abs(df$z[25]-dfnc[25,"z"]),abs(df$z[25]-dfc[25,"z"])), 
  "id_75" = c(df$z[75],dfnc[75,"z"],dfc[75,"z"],abs(df$z[75]-dfnc[75,"z"]),abs(df$z[75]-dfc[75,"z"])))
comparativa

#2) VARIABLE TARGET CONTINUA

df_incompleto=df

df_incompleto$y[5]=NA
df_incompleto$y[50]=NA
df_incompleto$y[100]=NA

#MODELO NO CONDICIONAL

dfnc=df_incompleto

media=mean(dfnc$y,na.rm=TRUE)
dfnc$pred=media
dfnc[is.na(dfnc)]=media

ECMnc = mean((dfnc$y - dfnc$pred)**2)
#CALCULAR R CUADRADO DEL MODELO NO CONDICIONAL

#MODELO CONDICIONAL LM (Linear Model)

dfc=df_incompleto

dfpred= dfc[is.na(dfc$y),]
dftoprove= dfc[!is.na(dfc$y),]

dftoprove$id <- 1:nrow(dftoprove) #creo columna id
train <- dftoprove %>% dplyr::sample_frac(0.70) #70% como conjunto entrenamiento
test  <- dplyr::anti_join(dftoprove, train, by = 'id') #30% como conjunto prueba

train=train[,(names(train)!="id")]
test=test[,(names(test)!="id")]

#crea modelo lm de Regresión Lineal (para valores continuos)
lmlogit=lm(y ~ x1 + x2 + z, data = train)
#es lo mismo que: logit=glm(z ~ x1 + x2 + y, family = gaussian, data=train)
summary(lmlogit) #muestra el R cuadrado del train

test$pred=predict(object = lmlogit,newdata = test) #crea variable en test con las predicciones del dato

res=sum((test$y-test$pred)**2)
stc=sum((test$y-mean(test$y))**2)
r_cuadrado=1-res/stc #genera R cuadrado del test

#NO LO ENSEÑÓ, pero habría que comparar los resultados de los R cuadrados para ver si lo que dio en el train fue estadísticamente significativo y, por lo tanto, el train predice lo del test
#Si es significativo, enconces:
which(is.na(dfc$y))
dfc[is.na(dfc)]=predict(object = lmlogit,newdata = dfpred)#imputa los NA en dfc con las predicciones de Y

dfc$pred = predict(object = lmlogit,dfc)
ECMc = mean((dfc$y - dfc$pred)**2)
#El ECM mejora considerablemente

comparativa=data.frame(
  "termino" = c("dato_real","dato_modelo_nc","dato_modelo_c","dif real y nc","dif real y c"),
  "id_5" = c(df$y[5],dfnc[5,"y"],dfc[5,"y"],abs(df$y[5]-dfnc[5,"y"]),abs(df$y[5]-dfc[5,"y"])),  
  "id_50" = c(df$y[50],dfnc[5,"y"],dfc[50,"y"],abs(df$y[50]-dfnc[50,"y"]),abs(df$y[50]-dfc[50,"y"])), 
  "id_100" = c(df$y[100],dfnc[5,"y"],dfc[100,"y"],abs(df$y[100]-dfnc[100,"y"]),abs(df$y[100]-dfc[100,"y"])))
comparativa

