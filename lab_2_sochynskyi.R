#http://www.economy-web.org/?p=478
library(xlsx)
library(ggpubr)
data1 <- read.xlsx("data.xlsx",sheetIndex = 1)
data1 <- data1[-c(1), ]
print(data1)
boxplot(data$salaries~data$employee_flow, 7,8, las=1)
#H0: Математичне споpдівання зарплати однаково для при будь-якому потоці кадрів
ANOVA1=aov(data$salaries~data$employee_flow) #дисперсійний аналіз
summary(ANOVA1)
ANOVA1$coefficients

d_w_r<-data1[,-c(1,7,8)]
plot(d_w_r$salaries,d_w_r$Income)
cor(d_w_r)

ggscatter(data1, x = "Income", y = "Production_vol", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Дохід підприємства", ylab = "Об'єм виробництва")

plot(d_w_r$Production_vol,d_w_r$int_pokaz_vykon_chasy_rob)
mod<-lm(d_w_r$int_pokaz_vykon_chasy_rob ~ d_w_r$Production_vol)
summary(mod)
abline(mod, col="red")
coef(model)