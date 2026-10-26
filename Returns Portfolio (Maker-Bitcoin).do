// -----------------------------    
// Professor Stephen Snudden     
// -----------------------------    

//* EC665 - Returns to Trading Strategies from Forecasting Bitcoin & Maker Token Prices *//

// ***************************
// Intro 
// ***************************

clear all

capture drop _all
set more off
timer on 1

// Log file
capture log close
capture log using results.log, replace

// ***************************
// Import **Daily** Data
clear all
import delimited "Bloomberg Data.csv", clear varnames(1)  // **Updated file to daily data**
generate time=td(1jan2017) + _n - 1  // **Changed to daily format**
format %td time
tsset time, daily  // **Set time series to daily frequency**

foreach var in mkr btc  {
    replace `var' = "." if `var' == "#N/A"
    destring `var', replace
}
drop if mkr==.
drop if btc==.

 
 
 replace time =_n
 format %td time
tsset time, daily  // **Set time series to daily frequency**
// ***************************
// Transform Data

// Compute log levels and returns
gen lmkr = ln(mkr)  // Log of Maker spot price
gen dmkr = 100 * ln(mkr / l.mkr)  // % change in Maker spot price

gen lbtc = ln(btc)  // Log of Bitcoin spot price
gen dbtc = 100 * ln(btc / l.btc)  // % change in Bitcoin spot price

sum dmkr dbtc

// Create a summary statistics table for Maker and Bitcoin daily returns
/*
gen lbtcf = ln(btcf)  // Log of Bitcoin futures price
gen dbtcf = 100 * ln(btcf / l.btcf)  // % change in Bitcoin futures price


	
// ***************************
// Stationarity Tests (I(1) vs. I(0))
// ***************************

// ADF-GLS (H0: I(1) / HA: Stationary I(0))
// Tests for unit roots in log-levels and returns

dfgls lmkr, notrend      // Maker log price
dfgls dmkr, notrend      // Maker return

dfgls lbtc, notrend      // Bitcoin log price
dfgls dbtc, notrend      // Bitcoin return

// KPSS Test (H0: I(0) / HA: Not I(0))
// Tests for stationarity in log-levels and returns

kpss lmkr, maxlag(12) notrend   // Maker log price
kpss dmkr, maxlag(12) notrend   // Maker return

kpss lbtc, maxlag(12) notrend   // Bitcoin log price
kpss dbtc, maxlag(12) notrend   // Bitcoin return

*/
// ***************************
// Choose Models
// ***************************
// 1️⃣ Select Optimal Lag Length for Bitcoin & Maker Data
/*
sum mkr
varsoc dmkr dbtc, maxlag(10)  // Ensure Maker price shocks are tested first

// 2️⃣ Estimate VAR Model with Lag 5
qui var dmkr dbtc, lags(1/4)

// 3️⃣ Run Granger Causality Test
vargranger
*/
// 4️⃣ Generate Lagged Variables
gen ldmkr = l.dmkr
gen ldbtc = l.dbtc


/*
// 5️⃣ Run ARDL Model to Analyze Short & Long-run Effects
ssc install ardl
ardl dbtc ldmkr, maxlags(10) aic  // ARDL Model with AIC-selected lags
*/
// ***************************

// Define dataset range

di "`start_obs'"
di "`end_obs'"
 
scalar start=1781      //2024
local start0 =start		//Counter for period
local startd =start+1	//Counter for period+1
local end =2146-1		//End of forecast evaluation sample

/* 
scalar start=1416      //2023
local start0 =start		//Counter for period
local startd =start+1	//Counter for period+1
local end =2146-1		//End of forecast evaluation sample
*/

/*
scalar start=1416      //2023
local start0 =start		//Counter for period
local startd =start+1	//Counter for period+1
local end =1781-1		//End of forecast evaluation sample
*/
    /*
scalar start=688      //2022
local start0 =start		//Counter for period
local startd =start+1	//Counter for period+1
local end =1416-1		//End of forecast evaluation sample
*/
/*
scalar start=1598      //6 months extension (pre) 2024 
local start0 =start		//Counter for period
local startd =start+1	//Counter for period+1
local end =2146-1		//End of forecast evaluation sample
*/

/*
scalar start=1053      //6 months extension (pre) 2024 
local start0 =start		//Counter for period
local startd =start+1	//Counter for period+1
local end =2146-1		//End of forecast evaluation sample
*/

// For saving forecasts
gen for_mod0=. in `startd'/`end' 
gen for_mod1=. in `startd'/`end' 
gen for_mod2=. in `startd'/`end'
gen for_mod3=. in `startd'/`end'


// Loop from start to end
while  `start0'<=`end' {
	display "Forecasting: `start0'"	
	// Random walk with drift
	qui reg dbtc in 1/`start0'				 
	qui predict f_y	 			    					 
	qui replace for_mod0=f_y in `startd'/`startd'        
	drop f_y
	// Model 1 
	qui reg dbtc l(1/4).dbtc in 1/`start0'		  // Estimate MLE model
	qui predict f_y in `startd'/`startd' 			  // Forecast
	qui replace for_mod1=f_y in `startd'/`startd'     // Save forecast 
	drop f_y
	// Model 2 
	qui reg dbtc l(1/4).dmkr in 1/`start0'				 
	qui predict f_y	 			    					 
	qui replace for_mod2=f_y in `startd'/`startd'        
	drop f_y	
	// Model 3 
	qui reg dbtc l(1/4).dbtc l(1/4).dmkr in 1/`start0'
	qui predict f_y	 			    					 
	qui replace for_mod3=f_y in `startd'/`startd'        
	drop f_y
	// Update period by one
	local start0=`start0'+1
	local startd=`startd'+1

}

// ************************
// Summarize Forecast Precision

local start = `start'+1   		// Start of forecast evaluation sample  (+1 because of one-step-ahead) 
local end = `end' +1 	     			// End of forecast estimation sample 

gen y= dbtc								// Forecast Target Return

// Forecast error in terms of returns
forvalues i = 0(1)3{
	gen error_mod`i'=y-for_mod`i' in `start'/`end'
}
gen error_rw=y-0 in `start'/`end'			// random walk

// MSFE of RW NC Forecasts
gen error_rwsq=error_rw^2
qui summarize error_rwsq
scalar msfe_rw = r(mean)
display "MSFE RW: " msfe_rw

forvalues i = 0(1)3{
	// (Root) Mean Squared Forecast Error, (R)MSFEs
	qui gen error_mod`i'sq=error_mod`i'^2
	qui summarize error_mod`i'sq
	qui scalar obs = r(N)
	scalar msfe_`i' = r(mean)
	*display "MSFE Model `i': " msfe_`i'		
	display "MSFE Ratio Model `i': " round(msfe_`i'/msfe_rw,0.001)
	// Test MSFE of Forecasts
	qui gen d`i' =  error_rw^2-error_mod`i'^2
	local nlags = round(4*(obs/100)^(2/9)) 
	// Model 1 - Null of equivalent forecasts
	qui newey d`i', lag(`nlags')
	matrix M=r(table)
	scalar teststat=M[3,1]
	scalar pvalue`i'=1-normal(teststat)
	matrix drop M
	display "DM p-value          " round(pvalue`i',0.001)
}

// ************************
// Summarize Forecast Directional Accuracy (DA)

// Sign of y
gen signy=0 in `start'/`end'
qui replace signy=1 if y >0  in `start'/`end'
  
forvalues i = 0(1)3{
	// DA of Forecast 1
	gen da`i'=0 in `start'/`end'
	gen sign`i'=0 in `start'/`end'
	// Note we need to use real-time data on right 
	qui replace da`i'=1 if y >0 & for_mod`i' >0 in `start'/`end'
	qui replace da`i'=1 if y <0 & for_mod`i' <0 in `start'/`end'
	qui replace sign`i'=1 if for_mod`i' >0  in `start'/`end'
	//Success Ratios 
	qui summarize da`i'
	qui scalar mda`i' = r(mean)
	qui scalar obs = r(N)
	display "Success Ratio Model `i': " round(mda`i',0.001)
	// Test MDA using Pesaran Timmermann (1992/2009)
	local nlags = round(4*(obs/100)^(2/9))
	qui newey signy sign`i', lag(`nlags')
	matrix M=r(table)
	scalar beta= M[1,1]
	scalar nwerr= M[2,1]
	scalar teststat=beta/nwerr
	scalar pvsr`i'=1-normal(teststat)
	matrix drop M
	display "PT p-value             " round(pvsr`i',0.001)
}


// ************************
// Profits based on trading strategies
display "first return in " `start' 
display "last return in " `end'	 	

// Buy and hold 
gen ret0=y in `start'/`end'
gen totret0=sum(ret0) in `start'/`end'
qui sum ret`i'
scalar sd0=r(sd)
qui gen radjret0 = ret0/sd0
display "Returns from buy and hold: " round(totret0[`end'],0.01)
display "Risk Adjusted Returns from buy and hold: " round(totret0[`end'],0.01)/sd0
// Verify if correct
*display 100*ln(mkr[`end']/mkr[`start'-1])

// Buy only if price is forecasted to go up, short if forecasted to fall
forvalues i = 1(1)3{
	gen ret`i'=y in `start'/`end'
	replace ret`i'=-1*ret`i' if for_mod`i'<0
	gen totret`i'=sum(ret`i') in `start'/`end'
	qui sum ret`i'
	scalar sd`i'=r(sd)
	qui gen radjret`i' = ret`i'/r(sd)
	display "Returns from strategy `i': " round(totret`i'[`end'],0.01)
	display "Risk Adjusted Returns from strategy `i': " round(totret`i'[`end'],0.01)/sd`i'
}

// ************************
// Test of Excess Profitability

// difference in returns
forvalues i = 1(1)3{
	capture drop difret`i'
	capture drop diftret`i'
	qui gen difret`i'=ret`i'-ret0 in `start'/`end'
	qui gen diftret`i'=radjret`i'-radjret0 in `start'/`end'
}

forvalues i = 1(1)3{
	qui summarize difret`i'
	scalar obs = r(N)
	local nlags = round(4*(obs/100)^(2/9)) 
	// Test difference in returns relative to buy and hold
	qui newey difret`i', lag(`nlags')
	matrix M=r(table)
	scalar teststat=M[3,1] 
	scalar pvalue`i'=(1-normal(teststat))
	matrix drop M
	// Test difference in returns relative to BTC baseline
	qui newey diftret`i', lag(`nlags')
	matrix M=r(table)
	scalar teststat=M[3,1] 
	scalar ptvalue`i'=(1-normal(teststat))
	matrix drop M
	display "  " 
	display "Return and p-value rel to buy and hold " `i'
	display "Long-short:    " round(totret`i'[`end'], 0.01)
	display "p-value:       " round(pvalue`i', 0.001)
	display "Risk Adj:      " round(totret`i'[`end']/sd`i', 0.01)
	display "p-value:       " round(ptvalue`i', 0.001)
}


//***************************
*tsline totret0 totret2 if time >= 1781 
*tsline totret0 totret2 if time >= 1416 
tsline totret0 totret2 if time >= 1053
*tsline totret0 totret2 if time >= 1598
/*
twoway (tsline dmkr, lcolor(blue) lpattern(solid)) /// Maker daily returns
       (tsline dbtc, lcolor(red) lpattern(dash) yaxis(2)), /// Bitcoin daily returns
       title("Daily Percentage Change: Maker vs. Bitcoin") ///
       ytitle("Maker Daily Returns (%)") ///
       ytitle("Bitcoin Daily Returns (%)", axis(2)) ///
       xtitle("Date") ///
       legend(position(6) bmargin(small) nobox ///
              region(lstyle(none) lcolor(white)) ///
              order(1 "Maker Returns" 2 "Bitcoin Returns")) ///
       graphregion(color(white))
	   
	   
twoway (tsline dmkr if time >= 1781 & time <= 2146, lcolor(blue) lpattern(solid)) /// Maker daily returns
       (tsline dbtc if time >= 1781 & time <= 2146, lcolor(red) lpattern(dash) yaxis(2)), /// Bitcoin daily returns
       title("Daily Percentage Change: Maker vs. Bitcoin Spot") ///
       ytitle("Maker Daily Returns (%)") ///
       ytitle("Bitcoin Daily Returns (%)", axis(2)) ///
       xtitle("Time") ///
       legend(position(6) bmargin(small) nobox ///
              region(lstyle(none) lcolor(white)) ///
              order(1 "Maker Returns" 2 "Bitcoin Returns")) ///
       graphregion(color(white))
	   
	   
	   twoway (tsline dmkr if time >= 1053 & time <= 2146, lcolor(blue) lpattern(solid)) /// Maker daily returns
       (tsline dbtc if time >= 1053 & time <= 2146, lcolor(red) lpattern(dash) yaxis(2)), /// Bitcoin daily returns
       title("Daily Percentage Change: Maker vs. Bitcoin Spot") ///
       ytitle("Maker Daily Returns (%)") ///
       ytitle("Bitcoin Daily Returns (%)", axis(2)) ///
       xtitle("Time") ///
       legend(position(6) bmargin(small) nobox ///
              region(lstyle(none) lcolor(white)) ///
              order(1 "Maker Returns" 2 "Bitcoin Returns")) ///
       graphregion(color(white))
	   */
/*	   
// Assume the risk-free rate is 0 (can be adjusted if needed)
scalar rf = 0 

forvalues i = 0/3 {
    qui summarize ret`i'
    scalar avg_ret`i' = r(mean)  // Mean return of strategy `i`
    scalar sd_ret`i' = r(sd)      // Standard deviation of strategy `i`

    // Calculate Sharpe Ratio
    scalar sharpe`i' = (avg_ret`i' - rf) / sd_ret`i'

    // Display the result
    display "Sharpe Ratio for Strategy `i': " round(sharpe`i', 0.003)
}
*/
// Overall directional accuracy
sum da1

// Directional accuracy when actual Bitcoin return is negative
sum da1 if signy == 0

// Directional accuracy when actual Bitcoin return is positive
sum da1 if signy == 1

// Change in Maker token returns (optional, if you're using first differences)
gen change = dmkr - l.dmkr
sum change
scalar sd=r(sd)
display sd
sum da1
sum da1 if change>sd
sum da1 if change<=sd

sum da1 if btc>0
sum da1 if btc <= 0

crash
// Generate 5-day ahead Bitcoin return

// Scatter plot: Maker returns today vs. Bitcoin returns 5 days later
twoway (scatter dbtc dmkr if inrange(_n, 1781, 2141), mcolor(navy) msize(small)) ///
       (lfit dbtc dmkr if inrange(_n, 1781, 2141), lcolor(red)), ///
       title("2024: Maker Returns vs. 5-Day Ahead Bitcoin Returns") ///
       xtitle("Maker Daily Returns (%)") ///
       ytitle("5-Day Ahead Bitcoin Returns (%)") ///
       graphregion(color(white))
gen dbtc_5ahead = 100 * (ln(f5.btc) - ln(btc))
	   
twoway (scatter dbtc_5ahead dmkr if inrange(_n, 1781, 2141), mcolor(navy) msize(small)) ///
       (lfit dbtc_5ahead dmkr if inrange(_n, 1781, 2141), lcolor(red)), ///
       title("2024: Maker Returns vs. 5-Day Ahead Bitcoin Returns") ///
       xtitle("Maker Daily Returns (%)") ///
       ytitle("5-Day Ahead Bitcoin Returns (%)") ///
       graphregion(color(white))
	   
	   corr dbtc_5ahead dmkr

gen dbtc_2ahead = 100 * (ln(f2.btc) - ln(btc))
twoway (scatter dbtc dmkr if inrange(_n, 1781, 2141), mcolor(navy) msize(small)) ///
       (lfit dbtc dmkr if inrange(_n, 1781, 2141), lcolor(red)), ///
       title("2024: Maker Returns vs. 5-Day Ahead Bitcoin Returns") ///
       xtitle("Maker Daily Returns (%)") ///
       ytitle("5-Day Ahead Bitcoin Returns (%)") ///
       graphregion(color(white))
	   
	   gen dbtc_2ahead = 100 * (ln(f2.btc) - ln(btc))
twoway (scatter dbtc_2ahead dmkr if inrange(_n, 1781, 2141), mcolor(navy) msize(small)) ///
       (lfit dbtc_2ahead dmkr if inrange(_n, 1781, 2141), lcolor(red)), ///
       title("2024: Maker Returns vs. 5-Day Ahead Bitcoin Returns") ///
       xtitle("Maker Daily Returns (%)") ///
       ytitle("5-Day Ahead Bitcoin Returns (%)") ///
       graphregion(color(white))

	   	   gen dbtc_4ahead = 100 * (ln(f4.btc) - ln(btc))
twoway (scatter dbtc_4ahead dmkr if inrange(_n, 1781, 2141), mcolor(navy) msize(small)) ///
       (lfit dbtc_4ahead dmkr if inrange(_n, 1781, 2141), lcolor(red)), ///
       title("2024: Maker Returns vs. 5-Day Ahead Bitcoin Returns") ///
       xtitle("Maker Daily Returns (%)") ///
       ytitle("5-Day Ahead Bitcoin Returns (%)") ///
       graphregion(color(white))
