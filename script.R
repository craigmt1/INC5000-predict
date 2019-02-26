library(readr, xlsx)
options(max.print=999999)

#clear env
rm(list=ls())

#set file paths for data
train_name = "company_train.csv"
test_name = "company_test.csv"
out_name = "company_output.csv"

#function for loading data from training and testing sheets (so i dont have to write it twice)
load_company_data <- function(fname,npar=TRUE,print=TRUE){
    return(read_csv(fname, col_types =
        cols(prev_growth = col_double(),
        prev_revenue = col_double(),
        prev_workers = col_double(), 
        rank = col_integer(),
        workers = col_integer(), 
        year = col_integer(),
        years_on_list = col_integer()), 
        na = "empty"))
}

#IMPORT DATA
train_data = load_company_data(train_name)
test_data = load_company_data(test_name)

#GENERATE GROWTH PREDICTIONS, WRITE SUMMARY TO FILE
growth_model = lm(log(growth) ~ year + scale(years_on_list) + log(prev_revenue) + log(prev_growth) + log(prev_workers) + prev_gdp_growth + prev_cpi + factor(industry) + factor(state) + factor(metro), data = train_data)
writeLines(capture.output(summary(growth_model)), "growth_model_summary.txt")
growth_predict <- predict(growth_model, test_data, se.fit = TRUE)

#REVENUE PREDICTIONS
revenue_model = lm(log(revenue) ~ year + scale(years_on_list) + log(prev_revenue) + log(prev_growth) + log(prev_workers) + prev_gdp_growth + prev_cpi + factor(industry) + factor(state) + factor(metro), data = train_data)
writeLines(capture.output(summary(revenue_model)), "revenue_model_summary.txt")
revenue_predict <- predict(revenue_model, test_data, se.fit = TRUE)

#WORKERS PREDICTIONS
workers_model = lm(log(workers) ~ year + scale(years_on_list) + log(prev_revenue) + log(prev_growth) + log(prev_workers) + prev_gdp_growth + prev_cpi + factor(industry) + factor(state) + factor(metro), data = train_data)
writeLines(capture.output(summary(workers_model)), "workers_model_summary.txt")
workers_predict <- predict(workers_model, test_data, se.fit = TRUE)

#GENERATE OUTPUT RESULTS
out_data = test_data
out_data$prev_cpi = NULL
out_data$prev_gdp_growth = NULL

#ADD PREDICTIONS
out_data$growth = exp(growth_predict$fit)
out_data$revenue = exp(revenue_predict$fit)
out_data$workers = as.integer(exp(workers_predict$fit) + 0.5)

#CHANGE IN WORKERS
out_data$change_workers = out_data$workers - out_data$prev_workers

#ANNUALIZE 3-YEAR GROWTH NUMBER (using anonymous functions :) )
out_data$growth_annualized = (function(x) ((((x / 100) + 1) ^ (1/3) ) - 1) * 100)(out_data$growth)

#CALCULATE GROWTH USING ALTERNATE REVENUE PREDICTION MODEL
out_data$growth_revenue = (function(x,y) (x-y)/ y * 100)(out_data$revenue, out_data$prev_revenue)

#COMPARE GROWTH PREDICTION DIRECTLY AGAINST REVENUE PREDICTION
#USING ABSOLUTE VALUE OF ARITHMETIC MEAN. IE LOWER NUMBER IS BETTER
out_data$AVAM = (function(x,y) abs((x-y) / ((x+y)/2)))(out_data$growth_annualized,out_data$growth_revenue)

#GENERATE STANDARD ERRORS FOR GROWTH AND REVENUE MODEL
out_data$SE_G = growth_predict$se.fit
out_data$SE_R = revenue_predict$se.fit

#MOVING LAST YEAR'S RANK AND GENERATING THIS YEAR'S
out_data$rank = seq.int(nrow(out_data))
names(out_data)[2]<-"oldrank"
out_data = out_data[order(-out_data$growth),]

#WRITE TO FILE
write.csv(na.omit(out_data), file = out_name)
