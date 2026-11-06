# =====================================================================
#VaR & Expected Shortfall (ES) - 3 Methods in R
# =====================================================================
set.seed(42) #For reproducibility

# 1. SETUP & GENERATE SAMPLE DATA (or load CSV: data <- read.csv("prices.csv"))

#sample size of historical daily observations
N <- 500

#we generate N=500 synthetic daily stock returns that behave like real financial markets 
#by using a fat-tailed Student t distribution
#rt simulates random draws from the t-distribution
#expected daily return (mu)=0.0005
#volatility(sigma)=0.015
returns <- rt(N, df = 5) * 0.015 + 0.0005

#portfolio value: 1,000,000 euros
portfolio_value <- 1000000

#a=99% confidence level, so tail probability 1-a=0.01
alpha <- 0.99


# ---------------------------------------------------------------------
# METHOD 1: PARAMETRIC METHOD (Using Normal Distribution)
# ---------------------------------------------------------------------

#We assume returns follow a Normal distribution R~N(μ,σ^2) or a student-t distribution
#if we want heavier tails.


#sample mean of the returns
mu <- mean(returns)

#sample standard deviation of the returns
sigma <- sd(returns)

#z-score for 99% confidence (2.3263)
z_alpha <- qnorm(alpha)

#Parametric VaR (as positive loss %)
VaR_param_per <- -mu + z_alpha * sigma

#Parametric ES (as positive loss %)
ES_param_per <- -mu + sigma * (dnorm(z_alpha) / (1 - alpha))

#convert the percentages to euros
#we multiply the percentage loss metrics by the 1,000,000 portfolio value
VaR_param_eur <- portfolio_value * VaR_param_per
ES_param_eur <- portfolio_value * ES_param_per


#---------------------------------------------------------------------
# METHOD 2: HISTORICAL SIMULATION (Non-Parametric)
#---------------------------------------------------------------------

#we compute the empirical samle quantile at probability 1-a=0.01 to find VaR
cutoff_hist <- quantile(returns, probs = 1 - alpha)

#VaR is the positive loss value of that cutoff
VaR_hist_per <- -as.numeric(cutoff_hist)

#ES is the average of all returns strictly worse than or equal to the cutoff
tail_returns_hist <- returns[returns <= cutoff_hist]
ES_hist_per <- -mean(tail_returns_hist)

#convert the percentages to euros
#we multiply the percentage loss metrics by the 1,000,000 portfolio value
VaR_hist_eur <- portfolio_value * VaR_hist_per
ES_hist_eur <- portfolio_value * ES_hist_per


# ---------------------------------------------------------------------
#METHOD 3: MONTE CARLO SIMULATION
# ---------------------------------------------------------------------

#Number of Monte Carlo simulations
M<-50000

#Simulate M=50,000 random daily returns from Normal(mu, sigma)
sim_returns <- rnorm(M, mean = mu, sd = sigma)

#Find the (1 - alpha) quantile of simulated returns
cutoff_mc <- quantile(sim_returns, probs = 1 - alpha)

VaR_mc_per <- -as.numeric(cutoff_mc)

#Average of simulated returns in the worst 1% tail in order to compute the ES
tail_returns_mc <- sim_returns[sim_returns <= cutoff_mc]
ES_mc_per <- -mean(tail_returns_mc)

##convert the percentages to euros
#we multiply the percentage loss metrics by the 1,000,000 portfolio value
VaR_mc_eur <- portfolio_value * VaR_mc_per
ES_mc_eur <- portfolio_value * ES_mc_per


# ---------------------------------------------------------------------
# 4. SUMMARY TABLE OF RESULTS
# ---------------------------------------------------------------------
results <- data.frame(
  Method = c("Parametric (Normal)", "Historical Simulation", "Monte Carlo (Normal)"),
  VaR_per = round(c(VaR_param_per, VaR_hist_per, VaR_mc_per) * 100, 2),
  ES_per = round(c(ES_param_per, ES_hist_per, ES_mc_per) * 100, 2),
  VaR_EUR = round(c(VaR_param_eur, VaR_hist_eur, VaR_mc_eur), 0),
  ES_EUR = round(c(ES_param_eur, ES_hist_eur, ES_mc_eur), 0))
print(results)

# ---------------------------------------------------------------------
#Return Distribution Histogram
# ---------------------------------------------------------------------
hist(returns, breaks = 40, main = "Return Distribution with 99% VaR and ES (Historical)",
     xlab = "Daily Returns", col = "lightgray", border = "white")
     abline(v = -VaR_hist_per, col = "blue", lwd = 2, lty = 2)
     abline(v = -ES_hist_per,  col = "red",  lwd = 2, lty = 1)
     legend("topleft", legend = c("99% VaR", "99% ES"),
     col = c("blue", "red"), lty = c(2, 1), lwd = 2)
     