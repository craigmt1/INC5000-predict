# INC5000-predict
Using linear modeling in R to predict the fate of 2018's fastest growing startups in 2019

**What is included**

* company_train.csv contains scraped INC5000 data for the linear model.  By default it includes the years 2007 to 2018.
* company_test.csv is the same, but only contains the year 2018.
* script.r is the script which generates the prediction results.

**How it works**

script.r inputs company_train and company_test and to produce predicted results for companies listed in company_test.  Results are output into the file "company_output.csv" for predicted growth, revenue, workers, as well as standard error.

You may replace either file but they must have the following columns in exact order.  All 3 files must be located in the same directory.

year,rank,city,growth,workers,company,state,revenue,years_on_list,industry,metro,prev_revenue,prev_growth,prev_workers,prev_gdp,prev_cpi

**Column Description**
* year: The year in which the entry occurred.
* rank: The rank the company received for the given year.
* city: The city in which the company is located.
* growth: Percentage revenue growth over a 3-year period (as defined by INC).
* workers: Employee count of the company.
* company: The name of the company.
* state: The abbreviated state in which the company is located.
* revenue: The company's revenue (in USD) for the given year.
* industry: The category of industry in which the company operates (based on NAICS).
* metro: The metropolitan area in which the company is located.
* prev_revenue: The previous year of revenue (in USD) for the given company.
* prev_growth: Previous year growth rate.
* prev_workers: Previous year employee count.
* prev_gdp: The US GDP growth rate of the previous year.
* prev_cpi: The US CPI growth rate of the previous year.

**Credit**

Developed with the assistance of Lisa Wade, Ross Litman, Katharine Sullivan, and Adam Freshman

All data was originally downloaded from data.world (credit to Aurielle Perlmann)

https://data.world/aurielle/inc-5000-2018
https://data.world/aurielle/inc-5000-10-years
