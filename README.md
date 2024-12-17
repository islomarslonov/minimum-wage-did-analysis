# Minimum Wage Impact Analysis using Difference-in-Differences (DiD)

## Overview  
This project analyzes the effect of a minimum wage increase in New Jersey on employment in the fast-food industry. The analysis uses a Difference-in-Differences (DiD) approach to compare New Jersey (treatment group) and Pennsylvania (control group) before and after the policy change.  

## Data  
The dataset is based on the 1993 study by David Card and Alan Krueger.  
It includes:  
- Employment data for fast-food restaurants.  
- State indicators:  
   - 0 = Pennsylvania (control)  
   - 1 = New Jersey (treatment).  
- Time periods:  
   - February (before the increase)  
   - November (after the increase).  

## Key Steps  
1. Setup: Load the data and create key variables (e.g., indicators for time and treatment).  
2. Difference-in-Differences (DiD) Model:  
   - Estimate the treatment effect using the interaction between time and state.  
   - Add restaurant fixed effects to improve accuracy.  
3. Non-Parametric Analysis:  
   - Apply matching methods to estimate the effect without assuming a model.  
4. Hypothesis Testing:  
   - Test if the treatment effect is statistically different from values like 0 or 5.  

## Results  
- The DiD estimate shows the impact of the minimum wage increase on employment.  
- Adding restaurant fixed effects provides cleaner estimates.  
- Non-parametric methods confirm the findings through direct comparisons.

## Conclusion  
The analysis uses the DiD approach to estimate the effect of New Jersey's minimum wage increase, ensuring accuracy with fixed effects and non-parametric checks.
