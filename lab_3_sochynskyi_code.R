library(party)
library(xlsx)
library(ggpubr)
library(rpart)
library(rpart.plot)
data1 <- read.xlsx("data.xlsx",sheetIndex = 1)
data1 <- data1[-c(1),-c(1) ]
print(data1)
#output.tree <- ctree(
 # salaries ~ Income + group+level.of.automation, 
 # data = data1)
#plot(output.tree)
ml<-rpart(Income ~., data=data1, method="anova")
rpart.plot(ml, type = 2, digits = 3, fallen.leaves = TRUE)
ml<-rpart(Income ~., data=data1, method="anova")
rpart.plot(ml, type = 3, digits = 3, fallen.leaves = TRUE)
#ml<-rpart(salaries ~., data=data1, method="class")
#> rpart.plot(ml, type = 3, digits = 3, fallen.leaves = TRUE)
ml<-rpart(employee_flow ~., data=data1, method="class")
rpart.plot(ml, type = 4, digits = 3, fallen.leaves = TRUE)

#ml<-rpart(level.of.automation ~., data=data1, method="class")
#rpart.plot(ml, type = 4, digits = 3, fallen.leaves = TRUE)

#ml<-rpart(int_pokaz_vykon_chasy_rob ~., data=data1, method="anova")
#rpart.plot(ml, type = 4, digits = 3, fallen.leaves = TRUE)

#ml<-rpart(Production_vol ~., data=data1, method="anova")
#rpart.plot(ml, type = 4, digits = 3, fallen.leaves = TRUE)

