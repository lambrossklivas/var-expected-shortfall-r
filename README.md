# Value at Risk (VaR) & Expected Shortfall (ES) Estimation in R

This repository contains an R script that calculates and compares two fundamental market risk metrics—**Value at Risk (VaR)** and **Expected Shortfall (ES)** using three different methodologies. 

The purpose of this project is to demonstrate market risk modeling techniques and highlight the impact of "model risk" when underlying return distributions exhibit fat tails.

## Methodology

The script in R estimates the 99% VaR and 99% ES for a hypothetical €1,000,000 portfolio. The daily returns are simulated using a Student-t distribution with 5 degrees of freedom (df = 5) to capture in a better way the fat-tailed behavior observed in real financial markets.

The risk metrics are calculated using three approaches:
1. **Parametric Method (Variance-Covariance):** Assumes a Normal distribution.
2. **Historical Simulation:** A non-parametric approach relying entirely on the empirical quantiles of the dataset.
3. **Monte Carlo Simulation:** Generates 50,000 random paths based on the sample's mean and volatility (Normal assumption).

## Results

| Method | VaR (%) | ES (%) | VaR (EUR) | ES (EUR) |
| :--- | :--- | :--- | :--- | :--- |
| **Parametric (Normal)** | 4.67% | 5.33% | €46,728 | €53,277 |
| **Historical Simulation** | 5.16% | 5.77% | €51,576 | €57,656 |
| **Monte Carlo (Normal)** | 4.68% | 5.32% | €46,777 | €53,210 |

## Key Insights & Financial Analysis

* **Parametric vs. Monte Carlo:** The results from the Monte Carlo simulation (4.68% VaR) almost perfectly converge with the Parametric method (4.67% VaR). This validates the Monte Carlo method, as both methods assume a Normal distribution using the same $\mu$ and $\sigma$.
* **Capturing Fat-Tail Risk:** The Historical Simulation has significantly higher risk metrics (5.16% VaR / 5.77% ES). Because the underlying data was generated using a Student-t distribution, it contains extreme outlier returns (fat tails). The Historical method successfully captures this empirical reality, while the Normal-based Parametric and Monte Carlo methods underestimate the extreme tail risk.

## How to Run

The script requires zero external packages. Simply run the `var_expected_shortfall.R` file in any R environment.

Running the script will output the results table to the console and automatically generate a histogram visualizing the return distribution, alongside the 99% VaR and ES cutoff thresholds.
