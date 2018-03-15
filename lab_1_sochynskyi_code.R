library(xlsx)
data2 <- read.xlsx("data.xlsx",sheetIndex = 1)
print(data2)
data2 <- data2[-c(1), ]
# png(file = "Обєм виробництва.png")
hist(data$Production_vol,,xlab = "Об`єм виробництва", col = "yellow", border = "purple")
#lines(density(X), col = "red", lwd = 2)
# dev.off()
# sappng(file = "barchart_vol_income.png")
# Plot the bar chart.
test<-data$Income
test2<-data$Production_vol
dataframe<-data.frame(test, test2)
sorted<-dataframe[order( dataframe[,1] ),]
barplot(sorted$test2,names.arg = sorted$test,xlab = "Доходи компаній",ylab = "Обсяг виробництва",col = "blue",
        main = "Обсяг виробництва і відповідний прибуток",border = "red")
# Save the file.
# dev.off()
test<-data[-c(1,2,7,8)]

summary(test)
cat_var<-data[-c(1:6)]
table(cat_var$level.of.automation)
table(cat_var$employee_flow)
table(cat_var$employee_flow)/length(cat_var$employee_flow)

gr<-table(data2$group,data2$level.of.automation)
barplot(gr,beside=T, legend.text = c("1 гр. підпр.","2 гр. підпр."), xlab = "Рівні автоматизації підприємств", las=1, col=c(13,14))

hist(data2$Income, prob=TRUE, main="", xlab = "Дохід підприємства")
curve(dnorm(x, mean=mean(data$Income), sd=sd(data2$Income)), add=TRUE)

skewness(data$Production_vol)
skewness(data$Income)
skewness(data$salaries)
skewness(data$int_pokaz_vykon_chasy_rob)
kurtosis(data$Production_vol)
kurtosis(data$Income)
kurtosis(data$salaries)
kurtosis(data$int_pokaz_vykon_chasy_rob)