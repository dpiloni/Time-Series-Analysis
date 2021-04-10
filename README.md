# Time Series Analysis

## Project Overview
* Fitted ARMA and GARCH models to financial time series
* Identified Exponential GARCH(1,1) as the generation process of the series

## Introduction
The goal of this project is to capture different features of financial data, trying to find the time series generator process. In particular, I adapt ARMA and GARCH models to see if financial returns, represented by Lufthansa stocks historical performance, show that the conditional mean and the conditional variance depend on the past. Being able to identify the generator process can potentially be used for time series forecasting, in case we can assume stationarity.

![plots](https://user-images.githubusercontent.com/78954578/114269162-8150c400-9a05-11eb-872a-afd074848ce4.jpeg)

Please see the [Report](https://github.com/dpiloni/Time-Series-Analysis/blob/main/Report.pdf) for the complete analysis.

## Results
I found that Exponential GARCH(1,1) (EGARCH) model can be assumed as the generator process of Lufthansa returns series. No conditional mean dependence was found. 
The generator process of Lufthansa returns time series can be described by the following equations:

![](https://latex.codecogs.com/gif.latex?X_t%20%3D%20%5Csigma_t%5Cepsilon_t%2C%20%5C%5C%20%5Ctextrm%7Blog%7D%20%5Csigma%5E2_t%20%3D%20%5Calpha_0%20%281-%5Calpha_1%29%20&plus;%5Calpha_1%20%5Ctextrm%7B%20log%7D%5Csigma%5E2_%7Bt-1%7D%20&plus;%20f%28%5Cepsilon_%7Bt-1%7D%29%5C%5C%20%5Ctextrm%7Bwhere%20%7D%20f%28%5Cepsilon_t%29%20%3D%5Ctheta%20%5Cepsilon_t%20&plus;%20%5Cgamma%5B%7C%5Cepsilon_t%7C-E%28%7C%5Cepsilon_t%7C%29%5D%20%5Ctextrm%7B%20and%20%7D%20%5Cepsilon_t%20%5Csim%20std%280%2C1%29.)

We can visualize the estimated volatility series:

![final plot](https://user-images.githubusercontent.com/78954578/114269196-c5dc5f80-9a05-11eb-9a2a-6c0303db951b.jpeg)
