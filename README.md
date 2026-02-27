# Can Maker Make Bank on Bitcoin?
## DeFi Token Signals, Out-of-Sample Forecasting, and Trading Profitability

This project studies whether **Maker (MKR) token activity contains predictive information about Bitcoin returns** — and whether that information can be used in a **real-time trading strategy**.

The core intuition comes from how many users interact with crypto markets today: users often enter through wallets and swap routes, buying intermediary tokens before purchasing Bitcoin. If demand shocks appear first in token activity (such as Maker), Bitcoin prices may adjust with a lag. If that lag is systematic, it may create a **predictable and potentially arbitrageable signal**.

---

## Research Motivation

Most crypto market inefficiency research focuses on **Bitcoin markets themselves** (spot, futures, exchanges, microstructure frictions, etc.).  
But **DeFi tokens** remain relatively underexplored in this context.

This project asks whether a DeFi token (Maker) can act as an **early signal** of Bitcoin demand and whether that signal survives:

- **out-of-sample forecast evaluation**, and
- **profitability testing in implementable trading rules**

This directly connects to the **Efficient Market Hypothesis (EMH)**:
- If prices adjust instantly, Maker should not systematically predict Bitcoin.
- If Maker leads Bitcoin with a lag, that suggests **market inefficiency** and a possible arbitrage opportunity.

---

## Research Question

**Do Maker token purchases have a predictable influence on Bitcoin prices that can be arbitraged?**

---

## Project Scope

- Built an empirical forecasting framework using **daily crypto market data**
- Tested **in-sample predictability** using a **bivariate VAR / Granger causality**
- Generated **real-time out-of-sample one-step-ahead forecasts** (re-estimated daily)
- Compared forecast performance across benchmark and Maker-based models
- Evaluated whether forecast signals produce **economic gains** through trading strategies
- Assessed robustness across lag structures and alternative forecast windows

---

## Data

- **Source:** Bloomberg
- **Frequency:** Daily
- **Assets:**
  - Maker (MKR)
  - Bitcoin Spot
  - Bitcoin Futures
- **Full Sample:** Dec 2018 – Mar 2025
- **Main Forecast Evaluation Window:** 2024 (real-time rolling forecasts)

### Why include Bitcoin futures?
Futures prices reflect market expectations of Bitcoin at a future delivery date, so comparing spot vs futures helps test whether any signal is stronger where markets may be less vs more informationally efficient.

---

## Methodology

## 1) In-Sample Predictability (Granger Causality)
I estimate a **bivariate VAR** to test whether lagged Maker returns help predict Bitcoin returns.

- **Null hypothesis (H₀):** Maker does not help predict Bitcoin
- **Alternative (H₁):** Maker helps predict Bitcoin

This establishes whether the predictive relationship exists **within the sample** before moving to real-time forecasting.

---

## 2) Real-Time Out-of-Sample Forecasting
I simulate how a trader would operate in practice:

- use only information available up to day *t*
- re-estimate the model each day
- generate a **one-step-ahead forecast** for day *t+1*

### Forecast models
- **Model 0:** Random Walk with Drift (benchmark)
- **Model 1:** Bitcoin AR(5)
- **Model 2:** Linear Regression Model (LRM) with Maker
- **Model 3:** VAR (Bitcoin + Maker lags)

---

## 3) Forecast Evaluation Metrics

### Statistical criteria
- **MSFE Ratio** (relative to a no-change benchmark)
- **Directional Accuracy / Success Ratio**
  - 50% = random guessing
  - >50% = directional forecasting ability

These are standard forecasting metrics, but they are not the final test of arbitrage value.

---

## 4) Trading Strategy Evaluation (Economic Significance)

Even if statistical gains are small, forecasts may still be valuable if they improve **trading profitability**.

### A) Buy-and-Hold (Benchmark)
Passive benchmark: buy Bitcoin at the start and hold through the forecast window.

### B) Long-and-Short Forecast Strategy
Use the **sign of the forecast**:
- Forecast > 0 → go **long**
- Forecast < 0 → go **short**

Daily strategy returns are computed from forecast sign × actual return and accumulated over the forecast window.

### Profitability metrics
- **Cumulative returns**
- **Risk-adjusted performance (Sharpe-style comparison)**

---

## Key Findings (Summary)

### In-sample
- Maker shows **predictive power for Bitcoin spot** in the Granger framework
- No comparable predictive effect for Bitcoin futures (consistent with stronger market efficiency)

### Out-of-sample forecasting
- Maker-based models do not produce large statistical improvements in standard forecast metrics
- Directional accuracy is only modestly above 50% in baseline comparisons

### Trading profitability (main result)
- Maker-based models (especially **LRM with Maker**, and also VAR) generate **higher cumulative and risk-adjusted returns** than benchmark strategies in the Bitcoin **spot** market over the main forecast window
- Comparable gains do **not** appear consistently in Bitcoin **futures**

### Robustness / asymmetry
Results suggest the signal is **state-dependent**:
- stronger during **up markets**
- stronger when **Maker moves are large** (e.g., demand-shock-like periods)
- weaker in falling or quiet markets

This supports the interpretation that Maker may capture **positive demand shocks into Bitcoin**, rather than a symmetric signal in all market conditions.

---

## Contribution

To my knowledge, this project is the **first (or among the first)** to test whether a **DeFi-token signal (Maker)** can be used to predict Bitcoin in a framework that combines:

- real-time out-of-sample forecasting,
- implementable long/short trading strategies, and
- profitability plus risk-adjusted performance evaluation.

This extends the discussion beyond in-sample predictability. In short, the contribution is not just that “Maker appears in a regression,” but whether the signal can support **real-world arbitrage-style evidence** under a trader-feasible forecasting setup.

---

## Repository Contents

- `presentation/` — Final project presentation (PDF)
- `code/` — Data prep, forecasting, and trading strategy scripts *(if shareable)*
- `outputs/` — Tables/figures for forecast and trading results
- `README.md` — Project overview, methods, findings, and interpretation

---

## My Role

I designed and presented the research question, developed the forecasting and trading evaluation framework, interpreted the empirical results, and translated the analysis into a finance-focused research presentation.



---

## Tools Used
- Excel, Stata 
- Bloomberg (data source)


---

## Data & Reproducibility Note

Raw Bloomberg data may not be publicly redistributable due to licensing restrictions.

This repository may therefore include:
- methodology description,
- code (where permitted),
- output tables/figures,
- and the presentation,

while excluding proprietary raw price data.

---

## Academic Context
Final project presentation (Winter 2025)  
Supervisor: Dr. Stephen Snudden
