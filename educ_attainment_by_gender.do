/* Data downloaded from IPUMS, 3/8/24
* XXXX information about data XXXXXX
*/

* Global file folder
global directory "directoryname"

* Load data
use "$directoryname/datasetname.dta", clear
describe

* Create birth year variable
sum year
gen birth_year = year - age

* Keeping only ages needed
keep if age == 19 | age == 23 | age == 25 | age == 30

* Keeping only persons born in 50 states and D.C. (not territories)
keep if bpl <= 56

* Keeping only years that included persons in group quarters
drop if year >= 2001 & year <= 2005

* Creating weights
* SLWT for Census 1950, PERWT for all other years
gen wt = .
replace wt = perwt if year != 1950
replace wt = slwt if year == 1950

* Variables and availability
label list SEX
tab sex

label list HIGRADED
tab higraded year

label list GRADEATT
tab gradeatt year

label list GRADEATTD
tab gradeattd year

label list EDUCD
tab educd year
tab educd year, col nofreq

label list SCHOOL
tab school year

* Creating dummy for some college
gen some_college = .

* 1940-1980: Has attended or is enrolled in college
	
	* 1. Highest grade of school attended includes college
		replace some_college = 0 if higraded > 0 & higraded <= 150 & ///
			year >= 1940 & year <= 1980 
			// 12th grade or less, treat n/a (0) as missing
		replace some_college = 1 if higraded >= 151 & higraded < 999 & ///
			year >= 1940 & year <= 1980
			// didn't finish 1st year of college - 8th year or more of college
	
	* 2. Enrolled in college+ now
		replace some_college = 1 if higraded >= 150 & school == 2 & year ///
			>= 1940 & year <= 1950 // 1940-1950, more than HS, in school now
		replace some_college = 1 if gradeatt >= 6 & gradeattd != . & year ///
			>= 1960 & year <= 1980 // 1960-1980: attending college

* 1990 - 2022: Has "some college" or is enrolled in college

	* 1. "Some college"
		replace some_college = 0 if educd > 1 & educd <= 64 & year >= 1990
			// n/a as missing
		replace some_college = 1 if educd >= 65 & educd <= 116 & ///
			year >= 1990 // some college (incl. <1 year)
	* 2. Enrolled in college+ now
		replace some_college = 1 if educ >= 6 & school == 2 & year >= 1990 
			// Educational attainment at least grade 12 and in school now
		replace some_college = 1 if gradeattd >= 60 & gradeattd != . & year ///
			>= 2000
			// note: gradeatt not available in 1990

/* Check
	tabstat some_college if age==19, s(mean) by(birth_year)
	tabstat some_college if age==19 [aw=wt], s(mean) by(birth_year) */
	
* Creating dummy for 2 years of college or associate's degree
gen associate = .

* 0 value if has educational information (any years)
	replace associate = 0 if educd > 1 & educd < 999

* 1940-1980: 2 years of college (educd = 80)
* 1990: Associate's degree: occupational or academic program (educd = 82 or 83)
* 2000-2022: Associate's degree, type not specified (educd = 81)
	replace associate = 1 if educd >= 80 & educd < 999
	
* Check
	tabstat associate if age==23 [aw=wt], s(mean) by(birth_year)

		
* Creating dummy for college
gen college = .

* 1940-1980: Has completed 16 years of schooling
	replace college = 0 if higraded > 0 & higraded <= 182 & year >= 1940 & year ///
		<= 1980 
		// attending 4th year of college or less, n/a (0) as missing
	replace college = 1 if higraded >= 190 & higraded < 999 & ///
		year >= 1940 & year <= 1980
		// 4th year of college or more
		
* 1990-2022: Has completed a BA or higher
	replace college = 0 if educd > 1 & educd < 101 & year >= 1990
		// n/a as missing
	replace college = 1 if educd >= 101 & educd <=116  & year ///
		>= 1990

	
* Creating dummy for grad
gen grad_degree = .
tab educd year
/* 1940-1980
* Note: Some estimates of graduate educational attainment in 1940-1980
* were attempted, but none of the cutpoints yielded values that made sense. There 
* doesn't seem to be a good way to estimate graduate education attainment in 
* a way that is comparable to 1990-2022 variables.
	replace grad_degree = 0 if educd > 1 & educd < 114 & year >= 1940 & year <= 1980
	replace grad_degree = 1 if educd >= 110 & educd < 999 & year >= 1940 & year <= 1980
		// 5+ years of college */
* 1990-2022
	replace grad_degree = 0 if educd > 1 & educd < 114 & year >= 1990 
		// n/a as missing
	replace grad_degree = 1 if educd >= 114 & educd < 999
		// master's, professional, or doctoral degrees, not missing
* Check
	tabstat grad_degree if age==30 [aw=wt], s(mean) by(birth_year)
		
* Obtaining estimates by birth cohort
collapse (mean) some_college (mean) associate (mean) college ///
	(mean) grad_degree [aw=wt], by(birth_year age sex)
	
* Sort
sort sex age birth_year


* Creating marker labels (hiding all ACS labels but first and last)
foreach v of varlist some_college associate college grad_degree {
	gen `v'_str =  string(`v', "%8.2f")
}
replace some_college_str = "" if age == 19 & birth_year > 1987 & birth_year < ///
	2003 
replace associate_str = "" if age == 23 & birth_year > 1983 & birth_year < 1999
replace college_str = "" if age == 25 & birth_year > 1981 & birth_year < 1997 
replace grad_degree_str = "" if age == 30 & birth_year > 1976 & birth_year < ///
	1992 

* Creating educational attainment figure for men, cohorts XXXX
graph twoway ///
	(connected some_college birth_year if age == 19 & sex == 1, ///
		mlabel(some_college_str) lcolor(cranberry) msymbol(i) mcolor(cranberry) ///
		mlabpos(5) mlabcolor(cranberry)) ///
	(connected associate birth_year if age == 23 & sex == 1, ///
		mlabel(associate_str) lcolor(orange) lpattern(longdash) msymbol(i) ///
		mcolor(orange) mlabpos(5) mlabcolor(orange)) ///
	(connected college birth_year if age == 25 & sex == 1, mlabel(college_str) ///
		lcolor(dkgreen) lpattern(dash_dot) msymbol(i) mcolor(dkgreen)  ///
		mlabpos(5) mlabcolor(dkgreen)) ///
	(connected grad_degree birth_year if age == 30 & birth_year >= 1960 & ///
		sex == 1, mlabel(grad_degree_str) lcolor(navy) lpattern(shortdash) ///
		msymbol(i) mcolor(navy) mlabpos(5) mlabcolor(navy)) /// only available starting 1990
	, ///
	ti("A. Men" " ", pos(11) color(black) size(small)) ///
	legend(order(1 "Some college completed, or currently in school" ///
		2 "2-years of college completed or Associate's degree" ///
		3 "College completed" ///
		4 "Graduate degree completed") pos(11) ring(0) col(1) ///
		region(lcolor(white)) size(small)) ///
	yti("Fraction of Birth Cohort", size(small)) ysc(range(0 1)) ylab(0(0.25)1, angle(0) ///
		format(%9.2f) labsize(small) nogrid) ///
	xti(" " "Year of Birth", size(small)) xsc(range(1900 2020)) xlab(1900(20)2020, ///
		labsize(small)) ///
	graphregion(color(white)) name(men, replace)
	
graph save "men" "$directory/fig2_men.gph", replace

* Creating figure for women
graph twoway ///
	(connected some_college birth_year if age == 19 & sex == 2, ///
		mlabel(some_college_str) lcolor(cranberry) msymbol(i) mcolor(cranberry) ///
		mlabpos(5) mlabcolor(cranberry)) ///
	(connected associate birth_year if age == 23 & sex == 2, ///
		mlabel(associate_str) lcolor(orange) lpattern(longdash) msymbol(i) ///
		mcolor(orange) mlabpos(5) mlabcolor(orange)) ///
	(connected college birth_year if age == 25 & sex == 2, mlabel(college_str) ///
		lcolor(dkgreen) lpattern(dash_dot) msymbol(i) mcolor(dkgreen)  ///
		mlabpos(5) mlabcolor(dkgreen)) ///
	(connected grad_degree birth_year if age == 30 & birth_year >= 1960 & ///
		sex == 2, mlabel(grad_degree_str) lcolor(navy) lpattern(shortdash) ///
		msymbol(i) mcolor(navy) mlabpos(5) mlabcolor(navy)) /// only available starting 1990
	, ///
	ti("B. Women" " ", pos(11) color(black) size(small)) ///
	legend(order(1 "Some college completed, or currently in school" ///
		2 "2-years of college completed or Associate's degree" ///
		3 "College completed" ///
		4 "Graduate degree completed") pos(11) ring(0) col(1) ///
		region(lcolor(white)) size(small)) ///
	yti("Fraction of Birth Cohort", size(small)) ysc(range(0 1)) ylab(0(0.25)1, angle(0) ///
		format(%9.2f) labsize(small) nogrid) ///
	xti(" " "Year of Birth", size(small)) xsc(range(1900 2020)) xlab(1900(20)2020, ///
		labsize(small)) ///
	graphregion(color(white)) name(women, replace)

	graph save "women" "$directoryname/fig2_women.gph", replace
	
grc1leg "$directoryname/fig2_men.gph" "$directoryname/fig2_women.gph"
	graph save "menwomen" "$directoryname/fig2_menwomen.gph", replace
	graph export "$directoryname/menwomen.png", as(png) replace

	
