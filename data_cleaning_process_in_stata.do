encode year, gen(year_)
encode dai, gen(dai_)
encode dai_business, gen(dai_busines)
encode dai_people, gen(dai_peopl)
encode dai_government, gen(dai_governmen)

drop year dai dai_business dai_people dai_government

rename (year_ dai_ dai_busines dai_peopl dai_governmen) (year dai dai_business dai_people dai_government)

clear
cd "Data"

rename (A B C D E) (country adult_pop year num_of_new_busi new_busi_dens_rate)
bysort country: drop if country="Economy"
bysort country: drop if country=="*** For China, only the data for Beijing and Shanghai were included"

encode adult_pop, gen(adult_pop_)
encode year, gen(year_)
encode num_of_new_busi, gen(num_of_new_busi_)
encode new_busi_dens_rate, gen(new_busi_dens_rate_)

drop year adult_pop num_of_new_busi new_busi_dens_rate

rename (year_ adult_pop_ new_busi_dens_rate_ num_of_new_busi_) (adult_pop year num_of_new_busi new_busi_dens_rate)

rename (adult_pop year num_of_new_busi new_busi_dens_rate) (year adult_pop new_busi_dens_rate num_of_new_busi)

browse



by country: drop if year ==.
by country: drop if dai ==.
bysort year: drop if year == 2014

*New Data
cd "/Users/jumaabdi/Desktop/G_P/Quntitative_Research_Methods/Project Proposal/Data2"

rename (A B C D E F) (country year dai dai_business dai_people dai_government)
encode year, gen(year_)
encode dai, gen(dai_)
encode dai_business, gen(dai_busines)
encode dai_people, gen(dai_peopl)
encode dai_government, gen(dai_governmen)

drop year dai dai_business dai_people dai_government

rename (year_ dai_ dai_busines dai_peopl dai_governmen) (year dai dai_business dai_people dai_government)

rename (A B C D E) (country adult_pop year num_of_new_busi new_busi_dens_rate)
encode adult_pop, gen(adult_pop_)
encode year, gen(year_)
encode num_of_new_busi, gen(num_of_new_busi_)
encode new_busi_dens_rate, gen(new_busi_dens_rate_)

drop year adult_pop num_of_new_busi new_busi_dens_rate

rename (adult_pop_ year_ num_of_new_busi_ new_busi_dens_rate_) (adult_pop year num_of_new_busi new_busi_dens_rate)

merge 1:m country using new_busi.dta

bysort country: drop if dai ==.
bysort country: drop if adult_pop==.
tab _merge
browse
drop _merge

merge 1:m country using gdp.dta
bysort country: drop if year==.
drop year
drop _merge

encode gdppc, gen(gdppc_)
encode trade_gdp, gen(trade_gdp_)
encode poverty_rate, gen(poverty_rate_)

drop gdppc  trade_gdp poverty_rate

rename (gdppc_  trade_gdp_ poverty_rate_) (gdppc  trade_gdp poverty_rate)

reg new_busi_dens_rate adult_pop

recast int dai dai_business dai_people dai_government
replace dai = 1 if dai > 0.5

recast int num_of_new_busi adult_pop


scatter num_of_new_busi adult_pop || lfit num_of_new_busi adult_pop


bysort dai: gen upper_dai=1 if dai>0.5
bysort num_of_new_busi: gen asd =1 if num_of_new_busi<1000

reg num_of_new_busi gdppc trade_gdp dai

outreg2 using "/Users/jumaabdi/Desktop/G_P/Quntitative_Research_Methods/Project Proposal/Data2/my_proj_reg.doc", replace ctitle(Number of new businesses)

reg num_of_new_busi dai dai_people adult_pop poverty_rate

outreg2 using "/Users/jumaabdi/Desktop/G_P/Quntitative_Research_Methods/Project Proposal/Data2/my_proj_reg.doc", append ctitle(Number of new businesses)

reg num_of_new_busi dai adult_pop poverty_rate trade_gdp new_busi_dens_rate

outreg2 using "/Users/jumaabdi/Desktop/G_P/Quntitative_Research_Methods/Project Proposal/Data2/my_proj_reg.doc", append ctitle(Number of new businesses)

reg num_of_new_busi dai adult_pop poverty_rate trade_gdp new_busi_dens_rate

outreg2 using "/Users/jumaabdi/Desktop/G_P/Quntitative_Research_Methods/Project Proposal/Data2/my_proj_reg.doc", append ctitle(Number of new businesses)



reg num_of_new_busi dai adult_pop poverty_rate trade_gdp new_busi_dens_rate

outreg2 using "/Users/jumaabdi/Desktop/G_P/Quntitative_Research_Methods/Project Proposal/Data2/my_proj_reg.doc", append ctitle(Number of new businesses)


scatter num_of_new_busi adult_pop || lfit num_of_new_busi adult_pop, name(Business_Regression, replace) 
graph export Business_Regression.jpeg, replace


drop L M N O P


*Create integers from string variables /Command (real)
gen L_ = real(L)
gen M_ = real(M)

drop L M

rename (L_ M_) (L M)


rename (A B C D E F G H I L M) (country dai dai_business dai_people dai_government adult_pop num_of_new_bus new_bus_rate gdppc trade_share_gdp pverty_rate)

tabstat poverty_rate, statistic (n mean min max sd)

sort country
drop poverty_rate

*Merging data on freedom of expression, time for opening a new business, average years of education

merge 1:m country using time_required_to_open_business.dta

merge 1:m country using time_required_to_open_business.dta

drop _merge

merge 1:m country using average_years_of_schooling.dta

drop _merge


*Merging data with the main dataset


merge 1:m country using freedom_schooling_businesstime.dta

drop _merge

browse

bysort country: drop if dai ==.

rename timerequiredtostartabusinessdays time_for_new_business

rename averagetotalyearsofschoolingfora years_of_schooling

rename freeexpr_vdem_owid freedom_of_expression

*cleaning the dataset

bysort country: drop if trade_share_gdp ==.

bysort country: drop if freedom_of_expression ==.

*creation of dummy variables based on the statistics of the variables

tabstat dai, statistic (n mean min max sd)
by country: gen dai_low=1 if dai<0.6
replace dai_low=0 if dai_low==.

by country: gen dai_high=1 if dai>0.6
replace dai_high=0 if dai_high==.
*generate dummy variabe for DAI business sector
tabstat dai_business, statistic (n mean min max sd)

by country: gen dai_business_low=1 if dai<0.6
replace dai_business_low=0 if dai_business_low==.

by country: gen dai_business_high=1 if dai>0.6
replace dai_business_high=0 if dai_business_high==.

reg new_bus_rate dai_low


*generate dummy variabe for GDP share of trade

tabstat trade_share_gdp, statistic (n mean median min max sd)

by country: gen trade_share_high=1 if trade_share_gdp>80
replace trade_share_high=0 if trade_share_high==.

by country: gen trade_share_low=1 if trade_share_gdp<80
replace trade_share_low=0 if trade_share_low==.

*generate logarithmical variabe for the population share

gen log_adult_pop = log(adult_pop)

*generate dummy variable for the time to open new business


tabstat time_for_new_business, statistic (n mean min max sd)
bysort country: gen new_bus_time_low =1 if time_for_new_business<10
replace new_bus_time_low = 0 if new_bus_time_low ==.

bysort country: gen new_bus_time_hihg =1 if time_for_new_business>10

replace new_bus_time_high = 0 if new_bus_time_high ==.

*generate dummy variable for GDP per capita low, middle and high

bysort country: gen gdppc_low=1 if gdppc<1025
replace gdppc_low = 0 if gdppc_low == .

bysort country: 	gen gdppc_middle = 1 if gdppc > 1025 & gdppc < 12475
replace gdppc_middle=0 if gdppc_middle == .

bysort country: gen gdppc_high = 1 if gdppc>12475
replace gdppc_high=0 if gdppc_high== .

*dummy variable for freedom of expression

bysort country: 	gen freexpr_low = 1 if freedom_of_expression < 0.5
replace freexpr_low=0 if freexpr_low == .

bysort country: 	gen freexpr_high = 1 if freedom_of_expression > 0.5
replace freexpr_high=0 if freexpr_high == .

*dummy for years of schooling

bysort country: gen schooling_low = 1 if years_of_schooling < 8
replace schooling_low=0 if schooling_low == .

bysort country: gen schooling_high = 1 if years_of_schooling >= 8
replace schooling_high=0 if schooling_high == .

*regression

reg new_bus_rate dai_business_high log_adult_pop

outreg2 using "/Users/jumaabdi/Desktop/G_P/Quntitative_Research_Methods/Project Proposal/Final Merged Data/my_proj_reg.doc", replace ctitle(New businesses rate)

reg new_bus_rate dai_business_high log_adult_pop schooling_high

outreg2 using "/Users/jumaabdi/Desktop/G_P/Quntitative_Research_Methods/Project Proposal/Final Merged Data/my_proj_reg.doc", append ctitle(New businesses rate)

reg new_bus_rate dai_business_high log_adult_pop schooling_high freexpr_high

outreg2 using "/Users/jumaabdi/Desktop/G_P/Quntitative_Research_Methods/Project Proposal/Final Merged Data/my_proj_reg.doc", append ctitle(New businesses rate)

reg new_bus_rate dai_business_high log_adult_pop schooling_high freexpr_high new_bus_time_low

outreg2 using "/Users/jumaabdi/Desktop/G_P/Quntitative_Research_Methods/Project Proposal/Final Merged Data/my_proj_reg.doc", append ctitle(New businesses rate)

reg new_bus_rate dai_business_high log_adult_pop schooling_high freexpr_high new_bus_time_low trade_share_high 

outreg2 using "/Users/jumaabdi/Desktop/G_P/Quntitative_Research_Methods/Project Proposal/Final Merged Data/my_proj_reg.doc", append ctitle(New businesses rate)


tabstat dai_business new_bus_rate adult_pop years_of_schooling freedom_of_expression trade_share_gdp time_for_new_business, statistic (n mean min max sd)

scatter years_of_schooling gdppc || lfit years_of_schooling gdppc
