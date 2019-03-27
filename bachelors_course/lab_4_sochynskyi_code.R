library(xlsx)
library(e1071)
library(caret)
library("psych")
library(class)
data1 <- read.xlsx("data1.xlsx",sheetIndex = 1)
#data_test <- read.xlsx("data2.xlsx",sheetIndex = 1)
#plot(data1)

wb.raw <- data.frame(data1$Age,data1$WorkCompYears,data1$WorkPositionYears,data1$YearIncome, data1$Debt.thousands,data1$AnotherDebt)
pairs.panels(wb.raw)

w <- table(data1$PrevDebts, data1$Education)
barplot(w,beside=T, legend.text = c("Не брав кредит","Брав кредит"), xlab = "Рівень освіти", las=1, col=c(2,3))
boxplot(DebtSIncome ~ Education, data = data1, xlab = "Рівень освіти",
        ylab = "Відношення боргу до доходів", main = "")
#plot(w, main="Наявність попереднього кридиту")

data_w_1 <- data1[-c(16),]
wb.raw1 <- data.frame(data_w_1$Age,data_w_1$WorkCompYears,
                      data_w_1$WorkPositionYears,
                      data_w_1$YearIncome, 
                      data_w_1$Debt.thousands,
                      data_w_1$AnotherDebt)
pairs.panels(wb.raw1)
#Баєсівська класифікація
inc<-ifelse(data1$YearIncome < 40, "Low Income",
            ifelse(data1$YearIncome < 65, "Middle Income", "High Income"))
new_d <- data.frame(
                    data1$WorkCompYears,
                    data1$WorkPositionYears,
                    inc, 
                    data1$Debt.thousands,
                    data1$AnotherDebt)

new_d_2 <- data.frame(data1$Age,
                    data1$WorkCompYears,
                    data1$WorkPositionYears,
                    inc, 
                    data1$Debt.thousands,
                    data1$AnotherDebt)

set.seed(2016)
new_d.size <-length(data1$YearIncome)
new_d.train.size <- round(new_d.size * 0.7)
new_d.validation.size <- new_d.size - new_d.train.size
new_d.train.idx <- sample(seq(1:new_d.size), new_d.train.size)
new_d.train.sample <- new_d[new_d.train.idx,]
new_d.validation.sample <-new_d[-new_d.train.idx,]

classf <- naiveBayes(
  subset(new_d.train.sample, select = -inc),
  new_d.train.sample$inc, laplace = 1)
classf

preds<- predict(classf, subset(new_d.validation.sample, select = -inc))
table(preds,new_d.validation.sample$inc)
#точність
confusionMatrix(table(preds, new_d.validation.sample$inc))
#точність ручками
#round(sum(preds==new_d.validation.sample$inc, na.rm=TRUE) / 
        #length(new_d.validation.sample$inc), digits = 2)
#KNN метод
preds2<-knn(
  subset(new_d.train.sample, select = -inc),
  subset(new_d.validation.sample, select = -inc),
  factor(new_d.train.sample$inc),
  k = 4, prob = TRUE, use.all = TRUE)
confusionMatrix(table(preds2, new_d.validation.sample$inc))