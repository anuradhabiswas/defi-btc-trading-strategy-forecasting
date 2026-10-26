
# Financial Market Forecasting & Predictive Analytics
### Bitcoin & DeFi | Econometric Modelling, Forecast Evaluation & Trading Strategy Analysis

![Stata](https://img.shields.io/badge/Stata-Econometrics-1F4E79)
![Excel](https://img.shields.io/badge/Excel-Data_Analysis-217346)
![Bloomberg](https://img.shields.io/badge/Bloomberg-Market_Data-F5A623)
![Research](https://img.shields.io/badge/Research-Master's_Project-6C63FF)

**Master's Research Project | Wilfrid Laurier University | 2025**

## Project Overview

Can historical market data improve financial forecasting and inform investment decisions?

This project investigates whether **Maker (MKR) token returns contain predictive information about Bitcoin spot and futures returns**.

Using daily Bloomberg data from **December 2018 to March 2025**, I developed an econometric forecasting framework to evaluate predictive relationships, benchmark forecasting models, and assess the economic value of model-generated trading signals.

The analysis integrates:

- Time-series econometrics
- Predictive modelling
- Statistical hypothesis testing
- Out-of-sample forecasting
- Model performance evaluation
- Trading strategy analysis
- Risk-adjusted performance assessment

## Research Objectives

1. Determine whether Maker returns contain information that helps predict Bitcoin returns.
2. Compare conventional forecasting benchmarks against models incorporating Maker data.
3. Evaluate whether predictive signals improve simulated trading outcomes.
4. Examine model robustness across different market conditions.

## Dataset

| Attribute | Description |
|---|---|
| Source | Bloomberg |
| Frequency | Daily |
| Full sample | December 2018 – March 2025 |
| Primary forecast window | January 2024 – January 2025 |
| Variables | Maker (MKR), Bitcoin Spot, Bitcoin Futures |
| Tools | Stata, Microsoft Excel |

> **Data availability:** Raw Bloomberg datasets are excluded from this repository due to licensing restrictions.

## Methodology

### 1. Data Preparation & Statistical Testing

- Transformed historical market prices into return series.
- Evaluated time-series stationarity.
- Applied Vector Autoregression (VAR).
- Conducted Granger causality tests to assess predictive relationships.

### 2. Forecasting Models

Four forecasting specifications were evaluated:

| Model | Description |
|---|---|
| M0 | Random Walk with Drift |
| M1 | Bitcoin Autoregressive Model — AR(5) |
| M2 | Maker-Driven Linear Regression |
| M3 | Combined Bitcoin–Maker VAR |

Models were re-estimated using historical information to generate one-step-ahead out-of-sample forecasts.

### 3. Model Evaluation

Forecast performance was assessed using:

- **MSFE Ratio:** Forecast accuracy relative to a no-change benchmark.
- **Directional Accuracy:** Percentage of correctly predicted return directions.
- **Cumulative Returns:** Simulated trading performance.
- **Risk-Adjusted Returns:** Performance relative to risk exposure.

### 4. Strategy Evaluation

Compared the benchmark against forecast-driven long/short trading rules.

The trading signal was based on the predicted direction of Bitcoin returns:

- Positive forecast: Long position
- Negative forecast: Short position

Performance was evaluated across spot and futures markets.

---

## Key Results

### Granger Causality

| Market | p-value | Result |
|---|---:|---|
| Bitcoin Spot | 0.002 | Significant predictive relationship |
| Bitcoin Futures | 0.203 | No statistically significant relationship |

Maker returns demonstrated in-sample predictive information for Bitcoin spot, but not Bitcoin futures.

### Out-of-Sample Forecasting

- Forecast MSFE ratios were below the no-change benchmark.
- Differences between models were relatively small.
- Directional accuracy was approximately 53% for the primary spot models.
- Out-of-sample forecasting improvements were not statistically significant.

### Trading Strategy Performance

**Bitcoin Spot | January 2024 – January 2025**

| Strategy | Cumulative Return |
|---|---:|
| Benchmark | 320.38% |
| Bitcoin AR(5) | 314.04% |
| Maker-Driven Model | **347.75%** |
| Bitcoin + Maker VAR | 347.58% |

**Key result:** The Maker-driven model generated a simulated cumulative return **27.37 percentage points above the benchmark** in the primary evaluation window.

However, this improvement was not statistically significant and should not be interpreted as guaranteed or consistently achievable investment performance.

## Robustness & Scenario Analysis

The research also assessed performance across alternative specifications and market environments.

Key observations:

- Results were examined using lag structures ranging from 3 to 7.
- Predictive performance varied across forecast windows.
- Conditional directional accuracy was stronger during rising markets.
- Larger Maker movements were associated with stronger conditional signals.
- Futures-market profitability gains were less consistent.

These results suggest that the usefulness of the predictive signal may depend on market conditions.

## Business & Analytical Applications

Although the research focuses on cryptocurrency markets, its analytical framework is transferable to broader financial and business applications.

| Analytical Competency | Practical Application |
|---|---|
| Predictive Analytics | Forecasting trends using historical data |
| Statistical Modelling | Identifying and evaluating predictive relationships |
| Model Benchmarking | Comparing alternative analytical approaches |
| Financial Analysis | Evaluating return and risk metrics |
| Scenario Analysis | Assessing outcomes under varying conditions |
| Model Validation | Testing performance beyond the training sample |
| Decision Support | Translating statistical evidence into actionable conclusions |

## Limitations

- Out-of-sample forecasting improvements were not statistically significant.
- Model performance varied across market conditions.
- Results reflect historical simulations rather than live trading.
- Trading costs and execution constraints may affect realized profitability.
- Granger causality does not establish structural or economic causation.

## Repository Structure

```text
financial-market-forecasting/
│
├── README.md
│
├── presentation/
│   └── Maker_Bitcoin_Final_Presentation.pdf
└── code/
    └── (to be uploaded)
```



## Skills Demonstrated

`Stata` `Excel` `Bloomberg` `Econometrics`
`Time-Series Analysis` `VAR` `Granger Causality`
`Predictive Analytics` `Forecasting` `Model Evaluation`
`Financial Analysis` `Statistical Testing` `Quantitative Research`

## Research Context

**Original Title:** *Can Maker Make Bank on Bitcoin? DeFi Dynamics & Trading Profitability*

**Degree:** Master of Business Economics

**Institution:** Wilfrid Laurier University

**Supervisor:** Dr. Stephen Snudden

**Year:** 2025

---

**Author:** Anuradha Biswas

*Developed as an independent graduate research project.*
