library('ggplot2')
library('forecast')
library('tseries')
library(xlsx)

daily_data = read.csv('day.csv', header=TRUE, stringsAsFactors=FALSE)
daily_data$Date = as.Date(daily_data$dteday)

#daily_data$Date = as.Date(daily_data$dteday)

ggplot(daily_data, aes(Date, cnt)) + geom_line() + scale_x_date('Місяці')  + ylab("К-ть велосипедів") +
  xlab("")

#tsclean() - згладжує статистичні викиди

count_ts = ts(daily_data[, c('cnt')])

daily_data$clean_cnt = tsclean(count_ts)

ggplot() +
  geom_line(data = daily_data, aes(x = Date, y = clean_cnt)) + ylab('Очищені дані')

daily_data$cnt_ma = ma(daily_data$clean_cnt, order=7) 
daily_data$cnt_ma30 = ma(daily_data$clean_cnt, order=30)

ggplot() +
       geom_line(data = daily_data, aes(x = Date, y = clean_cnt, colour = "Значення")) +
       geom_line(data = daily_data, aes(x = Date, y = cnt_ma,   colour = "Тижнева ковзка середня"))  +
       geom_line(data = daily_data, aes(x = Date, y = cnt_ma30, colour = "Ковзка середня за місяць"))  +
       ylab('Кількість велосипедів')+ xlab('Час')

count_ma = ts(na.omit(daily_data$cnt_ma), frequency=30)
#allow.multiplicative.trend=TRUE
decomp = stl(count_ma, s.window="periodic")
deseasonal_cnt <- seasadj(decomp)
plot(decomp)

adf.test(count_ma, alternative = "stationary")

count_d1 = diff(deseasonal_cnt, differences = 1)
plot(count_d1)
adf.test(count_d1, alternative = "stationary")

Acf(count_d1, main='ACF for Differenced Series')
Pacf(count_d1, main='PACF for Differenced Series')

fit_w_seasonality = auto.arima(deseasonal_cnt, seasonal=TRUE)
seas_fcast <- forecast(fit_w_seasonality, h=30)
plot(seas_fcast)
tsdisplay(residuals(fit_w_seasonality), lag.max=45, main='(2,1,2) Model Residuals')
#the model incorporates differencing of degree 1, and uses an autoregressive term of first lag and a moving average model of order 1: