##################################################
# ECON 418-518 Exam 3
# Islombek Arslonov
# The University of Arizona
# islomarslonov@arizona.edu 
# 16 December 2024
###################################################


#####################
# Preliminaries
#####################

# Clear environment, console, and plot pane
rm(list = ls())
cat("\014")
graphics.off()

# Turn off scientific notation
options(scipen = 999)

# Load packages
pacman::p_load(data.table)

# Set sead
set.seed(418518)

library(dplyr)
library(ggplot2)

#####################
# Problem 3
#####################

# Load the data
df <- read.csv("../downloads/ECON_418-518_Exam_3_Data.csv")

#################
# Question (i)
#################

# The best model to use for this problem is the Difference-in-Differences (DiD) model. This model helps compare 
# the change in employment in New Jersey (where the minimum wage increased) to the change in Pennsylvania (where the minimum
# wage stayed the same). No, this model does not include state fixed effects because the state variable (state) already accounts
# for differences between New Jersey and Pennsylvania. Adding state fixed effects would be redundant since there are only two states.

#################
# Question (ii)
#################

# Create indicators for "Nov" and "New Jersey"
df$time_nov <- ifelse(df$time_period == "Nov", 1, 0)
df$state_nj <- ifelse(df$state == 1, 1, 0)

# Calculate mean total employment by state and time period
mean_employment <- aggregate(total_emp ~ state + time_period, data = df, FUN = mean)

# Print results
print(mean_employment)

# In Pennsylvania, the mean total employment was 23.38 in February and decreased to 21.10 in November.
# In New Jersey, the mean total employment was 20.43 in February and increased to 25.90 in November.

#################
# Question (iii)
#################

# Sample means from the data
mean_PA_Feb <- 23.38
mean_PA_Nov <- 21.10  

mean_NJ_Feb <- 20.43
mean_NJ_Nov <- 25.90 

# Calculate the differences within each group
diff_PA <- mean_PA_Nov - mean_PA_Feb 
diff_NJ <- mean_NJ_Nov - mean_NJ_Feb

# Calculate the Difference-in-Differences (DiD)
DiD_estimate <- diff_NJ - diff_PA

# Print results
cat("Difference in Pennsylvania (Control):", round(diff_PA, 2), "\n")
cat("Difference in New Jersey (Treatment):", round(diff_NJ, 2), "\n")
cat("Difference-in-Differences (DiD) Estimate:", round(DiD_estimate, 2), "\n")

# The Difference-in-Differences (DiD) estimate is 7.75. This means employment in New Jersey increased by 7.75 more 
# compared to Pennsylvania after the minimum wage increase.
# The formal name for this result is the Average Treatment Effect on the Treated (ATT). It measures the impact of
# the minimum wage policy on New Jersey’s employment relative to Pennsylvania.

# Create the data frame with mean employment
plot_data <- data.frame(
  state = rep(c("Pennsylvania", "New Jersey"), each = 2),
  time = rep(c("Before", "After"), 2),
  employment = c(23.38, 21.10, 20.43, 25.90)
)

plot_data$time <- factor(plot_data$time, levels = c("Before", "After"))

# Minimal Difference-in-Differences plot
ggplot(plot_data, aes(x = time, y = employment, group = state, color = state)) +
  geom_line() +                        
  geom_point() +                  
  labs(
    title = "Difference-in-Differences Plot",
    x = "Time Period",
    y = "Mean Employment",
    color = "State"
  )

#################
# Question (iv)
#################

# Create the variables needed for the DiD model
df$post <- ifelse(df$time_period == "Nov", 1, 0)    
df$state_nj <- ifelse(df$state == 1, 1, 0)

# DiD regression
model <- lm(total_emp ~ post + state_nj + post:state_nj, data = df)

# Summarize the model
summary(model)

# Extract coefficient and standard error for interaction term
coef_estimate <- coef(summary(model))["post:state_nj", "Estimate"]
se <- coef(summary(model))["post:state_nj", "Std. Error"]

# Calculate the 95% Confidence Interval
lower_ci <- coef_estimate - 1.96 * se
upper_ci <- coef_estimate + 1.96 * se

# Print the results
cat("95% Confidence Interval for ATT: [", round(lower_ci, 2), ",", round(upper_ci, 2), "]\n")

# We estimated the model using lm() and found that the average treatment effect on the treated (ATT) is 7.75 with a standard error of 1.73.
# To construct the 95% confidence interval, we calculate: 7.75 ± 1.96 x 1.73
# This gives a confidence interval of [4.36, 11.14].
# For the hypothesis test:
#  If ATT = 5: Since 5 is inside the confidence interval, we cannot reject the null hypothesis.
#  If ATT = 0: Since 0 is outside the confidence interval, we reject the null hypothesis.
# In conclusion, the wage increase had a positive and significant effect on employment in New Jersey.

#################
# Question (v)
#################

# If I had data before February 1992, I could test the parallel trends assumption. This means checking if employment 
# trends in New Jersey and Pennsylvania were moving in the same direction before the policy change. If the trends are 
# similar, the DiD model is valid. If not, the results could be biased.

#################
# Question (vi)
#################

# This is an example of an external shock. It could affect the DiD estimate because the study might
# reduce fast-food demand and employment. If this happens in both states equally, the impact is small.
# But if one state is affected more, the estimate could be biased.

#################
# Question (vii)
#################

# Add restaurant fixed effects to the model
model_fe <- lm(total_emp ~ post + state_nj + post:state_nj + factor(restaurant_id), data = df)

# Summarize the new model
summary(model_fe)

# After adding restaurant fixed effects, the DiD estimate changes because the model now controls 
# for differences between restaurants that do not change over time, like location or size. This makes the 
# estimate more accurate by focusing only on changes within each restaurant. If the estimate changes, it means
# those differences were affecting the original result.

#################
# Question (viii)
#################

# I trust the estimate if the parallel trends assumption holds, meaning both states had similar employment
# trends before the wage increase. If not, other factors like external shocks or different local conditions
# could affect the results. To fix this, I would check for parallel trends using earlier data and add controls 
# for other factors like local demand.

#################
# Question (ix)
#################

# We can use matching methods to estimate the effect without assuming a specific model. This means we 
# compare similar restaurants in New Jersey and Pennsylvania based on things like size or pre-treatment employment. 
# The results are unique because they rely on direct comparisons, not a model’s assumptions.






