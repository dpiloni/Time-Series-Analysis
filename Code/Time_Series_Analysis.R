######################
#Time Series Analysis#
######################

#clean, set the directory and load data (text file)
setwd("C:\\Users\\Daniele\\Desktop\\Analisi e progetti\\Analisi di serie storiche")
dir()
data <- read.table(file="Luftansa.dat", header=F)	
str(data)
p <- as.vector(data$V1)
head(p)
r <- diff(log(p))
head(r)

#graphical representation
par(mfrow=(c(2,1)))	
plot(p, main ="Lufthansa Prices", xlab="Time", ylab="Prices", type="l") 
plot(r,  main ="Lufthansa Returns", xlab="Time", ylab="Returns", type="l")  

#basic stats 
library(fBasics)
basicStats(r)

#Jarque-Bera test
normalTest(r,method='jb')

dev.new(x11)

dev.set(2)	

xx=seq(min(r),max(r),0.001)	# create a sequence from min(x) to max(x) with step of 0.001
y=dnorm(xx,mean(r),sd(r))	# Create normal prob. density function

hist(r, 50, main ="Lufthansa returns distribution", xlab="returns", ylab="distribution", freq = FALSE) # histogram 
		# breaks= n. of bins
		
lines(xx,y,lty=1, col="red")

###############################
# 	  Mean Structure     	#
###############################
par(mfrow=(c(2,1))) 				
acf(r,30, main ="ACF Lufthansa returns",ylim=c(-0.1,0.1))		# ACF  
pacf(r,30, main ="PACF Lufthansa returns")		# PACF 

###############################
#   Volatility Structure      #
###############################
#ACF & PACF on squared rets (if arma model, must be done on squared residuals)
par(mfrow=(c(2,1))) 				
acf(r^2,50, main ="ACF Lufthansa Squared Returns",ylim=c(-0.1,0.2))		
pacf(r^2,50, main ="PACF Lufthansa Squared Returns")		


#############GARCH(p,q)
library(fGarch)
garch11 <- garchFit(formula = ~ garch(1,1), data = r, include.mean = F, cond.dist = "norm") 
		# include.mean = F sets E(X_t)= 0
		# cond.dist = "norm" assumes normal distr. for w.n. ("std" for t di student)

summary(garch11)
library(FinTS)

#calculate residuals, standardized because of volatility structure
sdres <- residuals(garch11, standardize = TRUE) # std residuals

#Engle's archtestArchTest(sdres, 3)
ArchTest(sdres, 5)
ArchTest(sdres, 7)
ArchTest(sdres, 9)


#qqplot
# q-q plot normal
qqnorm(sdres) 
qqline(sdres, col = "red")	# add red line 

#re-estimate GARCH with wn ->student's t
garch11t <- garchFit(formula = ~ garch(1,1), data = r, include.mean = F, cond.dist = "std") 
summary(garch11t)


#check standardized residuals
sdres <- residuals(garch11t, standardize = TRUE) 

#arch test on residuals
ArchTest(sdres, 9)


#df = degrees of freedom; copy it from summary(garch) in "shape", under coeff
# q-q plot student's t with df=8.5703e+00
sdrest <- residuals(garch11t, standardize = TRUE)

qqplot(qt(ppoints(length(sdrest)), df = 8.5703e+00), sdrest,
       main = expression("Q-Q plot for" ~~ {t}[nu == 8.5703e+00]), xlab="Theoretical Quantile", ylab="Sample Quantile")

qqline(sdrest, distribution=function(p) qt(p, df = 8.5703e+00), 
       prob=c(0.1, 0.6), col="red") 


###########################
## 	LEVERAGE EFFECT    ##
###########################

#Sign Bias Test
source("SignBiasTest.R")
sign <- SignBiasTest(r,sdrest)
summary(sign)

#########try egarch(1,1)
library(rugarch)
# ugarchspec specify model 
# distribution.model = "norm" or "std" fot the w.n.

spec_egarch <- ugarchspec(variance.model = list(model = "eGARCH", garchOrder = c(1,1), 
submodel = NULL, external.regressors = NULL, variance.targeting = FALSE), 
mean.model = list(armaOrder = c(0,0), external.regressors = NULL), 
distribution.model = "std",  fixed.pars=list(), start.pars = list())

egarch <- ugarchfit(spec=spec_egarch,data=r,solver.control=list(trace=0))
egarch

regarch <- residuals(egarch,standardize=T)
regarch <- as.vector(regarch)

# q-q plot student t  df=8.856333
qqplot(qt(ppoints(length(regarch)), df =8.856333 ), regarch,
       main = expression("Q-Q plot"), xlab="Theoretical Quantile", ylab="Sample Quantile")

qqline(regarch, distribution=function(p) qt(p, df =8.856333), prob=c(0.1, 0.6), col="red") 

### volatility estimate
csigma <- sigma(egarch)			
csigma <- as.vector(csigma)
cvar <- csigma^2		#volatility

#final plot 
par(mfrow=(c(2,1)))	
plot(r, main ="Lufthansa Returns", xlab="time", ylab="returns", type="l") 
plot(cvar,  main ="Lufthansa Estimated Volatility", xlab="time", ylab="volatility", type="l") 

