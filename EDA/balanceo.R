#PRÁCTICA SMOTE

library(knitr)
library(readr)
set.seed(3)

credit_card_db=read.csv("creditcard.csv")

credit_card_db$Class<-as.factor(credit_card_db$Class) # convert class to factor
levels(credit_card_db$Class) <- c('Legitimate', 'Fraud') # names of factors
summary(credit_card_db$Class)

predictor_variables <- credit_card_db[,-31]
response_variable <- credit_card_db$Class

ggplot(data = credit_card_db, aes(x = V4, y = V7, colour = Class))+
  geom_point()+
  ggtitle("Original dataset")+
  xlab("V4")+
  ylab("V7")+
  geom_point() +
  xlim(-5, 15)+
  ylim(-50, 50)+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        legend.key=element_blank())

levels(response_variable) <- c('0', '1')

#1) Hacer SMOTE
smote_result = SMOTE(predictor_variables,target = response_variable, K = 3, dup_size = 5)
oversampled_smote=smote_result$data

ggplot(data = oversampled_smote, aes(fill = class)) +
  geom_bar(aes(x = class))+
  ggtitle("Number of samples in each class", subtitle = "Original dataset")+
  xlab("")+
  ylab("Samples")+
  scale_y_continuous(expand = c(0,0))+
  scale_x_discrete(expand = c(0,0))+
  theme(legend.position = "none", 
        legend.title = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank())

ggplot(data = oversampled_smote, aes(x = V4, y = V7, colour = class))+
  geom_point()+
  ggtitle("Original dataset")+
  xlab("V4")+
  ylab("V7")+
  geom_point() +
  xlim(-5, 15)+
  ylim(-50, 50)+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        legend.key=element_blank())

#2) Hacer ADASYN
ADASed <- ADAS(predictor_variables,response_variable,K = 3)
oversampled_ADAS <- ADASed$data  # extract only the balanced dataset
ADASed$class <- as.factor(ADASed$class)

ggplot(data = oversampled_ADAS, aes(x = V4, y = V7, colour = class))+
  geom_point()+
  ggtitle("Original dataset")+
  xlab("V4")+
  ylab("V7")+
  geom_point() +
  xlim(-5, 15)+
  ylim(-50, 50)+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        legend.key=element_blank())

#3) Hacer DBSMOTE
DBSMOTed <- DBSMOTE(predictor_variables,response_variable)
oversampled_DBSMOTE <- DBSMOTed$data # extract only the balanced dataset
DBSMOTed$class <- as.factor(DBSMOTed$class)

ggplot(data = oversampled_DBSMOTE, aes(x = V4, y = V7, colour = class))+
  geom_point()+
  ggtitle("Original dataset")+
  xlab("V4")+
  ylab("V7")+
  geom_point() +
  xlim(-5, 15)+
  ylim(-50, 50)+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        legend.key=element_blank())

#EJERCICIO:
#Hacer un SMOTE con 50 duplicaciones y probar diferencias con K=5 y K=10
smote_5 = SMOTE(predictor_variables,target = response_variable, K = 5, dup_size = 50)
res_5=smote_5$data

smote_10 = SMOTE(predictor_variables,target = response_variable, K = 10, dup_size = 50)
res_10=smote_10$data

plot_5=ggplot(data = res_5, aes(x = V4, y = V7, colour = class))+
  geom_point()+
  ggtitle("Original dataset")+
  xlab("V4")+
  ylab("V7")+
  geom_point() +
  xlim(-5, 15)+
  ylim(-50, 50)+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        legend.key=element_blank())

plot_10=ggplot(data = res_10, aes(x = V4, y = V7, colour = class))+
  geom_point()+
  ggtitle("Original dataset")+
  xlab("V4")+
  ylab("V7")+
  geom_point() +
  xlim(-5, 15)+
  ylim(-50, 50)+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        legend.key=element_blank())
