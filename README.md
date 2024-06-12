# Trends in Educational Attainment in the US

These Stata files create graphs displaying educational attainment of the U.S. population across cohorts born 1915- 1997 for men and women using data from the U.S. Census and the American Community Survey (ACS). Four levels of educational attainment are distinguished: Some college, two years of college or an Associate's Degree, Bachelor's degree (college degree), and Graduate Degree. 

# Detailed Information about the Graphs
Source: U.S. Census and ACS samples downloaded from IPUMS USA. U.S. Census samples include 1940-1970 (1%) and 1980-2000 (5%). ACS samples include 2006-2022 (1-year samples). ACS samples 2001-2005 are excluded because they did not include persons living in group quarters. 

Variables measuring educational attainment are operationalized somewhat differently across years due to changes in the U.S. Census and ACS questionnaire. 

*Some college*: Defined as a person having attended at least some college at age 19. For 1940-1950 samples, we used a person’s highest grade of school attended (higraded) and whether they were in school (school). A person is coded as having attended some college if their highest grade was greater than or equal to “didn’t finish 1st year of college,” or their highest grade was equal to 12th grade and they were in school at the time of the interview. For 1960-1980 samples, we used a person’s highest grade of school attended (higraded) and their current grade (gradeatt). A person is coded as having some college if their highest grade was greater than or equal to “didn’t finish 1st year of college” or if they were “attending college” at the time of interview. For 1990-2022 samples, we used a person’s educational attainment (educd), whether they are currently in school (school), and their current grade (gradeattd). A person is coded as having attended some college if their educational attainment was greater than or equal to some college (including less than 1 year), if their educational attainment was at least 12th grade and they were in school at the time of the interview, or if their recent grade level was at least “college undergraduate.”

*2 years of college or an Associate’s degree*: Defined as a person having an associate’s degree (occupational or academic) or having completed at least two years of college at age 23, using the simplified variable for educational attainment (educd). For 1940 to 1980 (birth cohorts 1917 to 1957), this is measured based on number of years of school. For 1990 to 2022, respondents were asked specifically about whether they had obtained associate’s degrees.

*College/Bachelor's Degree*: Defined as a person having a college degree (i.e., a bachelor’s degree) at age 25. For 1940-1980, we used a person’s highest grade (higraded). A person is coded as having a college degree if their highest grade is greater than or equal to their 4th year of college. For 1990-2022, we use a person’s educational attainment (educd). A person is coded as having a college degree if they have completed a bachelor’s degree or more. 

*Graduate degree*: Defined as a person having a graduate or professional degree at age 30. This is only measured as part of their educational attainment in 1990-2022 (educd), as 1940-1980 questions about graduate-level educational attainment were substantively distinct. A person is coded as having a graduate degree if their educational attainment was a master’s, professional, or doctoral degree. 

*Weights*: Estimates of the proportion of each birth cohort with some college, college, or graduate degrees use Census weights. Person weights were used for all years except 1950, in which we used sample-line weights.


## Contents

- [`educ_attainment_by_gender.do`](educ_attainment_by_gender.do): Stata script to generate graphs of educational attainment.
- `README.md`: This file.

## Getting Started

To use these scripts, you will need Stata installed on your machine. Follow the instructions below to get started.

### Prerequisites

- Stata software
- Access to the U.S. Census and ACS data ([IPUMS USA](https://usa.ipums.org/usa/))
- Extract the following variables from Census and ACS datasets: (1) Variables containing information about the survey: *year* (year of the Census or ACS sample), *sample* (IPUMS sample identifier), *pernum* (person number in sample unit), *perwt* (person weight), *slwt* (sample-line weight). Variables containing information about the survey participants: *sex* (person’s self-reported biological sex), *age* (continuous age), *race* and *raced* (general and detailed versions of race), *hispan* and *hispand* (general and detailed version of Hispanic origin), *bpl* and *bpld* (general and detailed versions of birthplace), *school* (school attendance), *higrade* and *higraded* (general and detailed versions of highest grade of schooling), *educ* and *educd* (general and detailed versions of educational attainment), *gradeatt* and *gradeattd* (general and detailed versions of current grade level attending.

### Running the Script

1. **Create Graphs**: Run [`educ_attainment_by_gender.do`](educ_attainment_by_gender.do) to generate graphs displaying educational attainment across different birth cohorts.

## Contributing

If you would like to contribute to this project, please fork the repository and submit a pull request with your changes. 

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Acknowledgements

Stata code created by Claire Daviss, PhD candidate in Sociology, Stanford University ([cdaviss@sanford.edu](mailto:cdaviss@stanford.edu)), ([Webpage](http://clairedaviss.com)).
