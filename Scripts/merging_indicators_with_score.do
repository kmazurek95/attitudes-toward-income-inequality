clear
	clear matrix
	set more off
	set seed 20082013
	cap log close
	set scheme s2mono
	
	
global path "C:/Users/kaleb/OneDrive/Desktop/attitudes-toward-income-inequality/Data"

*import SCORE dataset that has been cleaned
insheet using "C:/Users/kaleb/OneDrive/Desktop/attitudes-toward-income-inequality/Data/processed_score_data/score_prepped.csv", comma clear


*merge with buurt indicators
merge m:m buurt_code_eight_digits using "$path\prepped_indicators_buurt.dta", generate(buurt_match) 



*Merge the score dataset that contains buurt indicators with the WIJK indicators
merge m:m wijk_code_six_digits using "$path\prepped_indicators_wijk.dta", generate(wijk_match)


*Merge the score dataset that contains buurt & indicators with the gemeente indicators
merge m:m gemeente_code_four_digits using "$path\prepped_indicators_gemeente.dta", generate(gemeente_match)




* WHEN TRYING TO MERGE WITH THE GEMEENTE INDICATORS WE GET THE FOLLOWING MESSAGE:

* key variable gemeente_code_four_digits is float in master but str4 in using data
*    Each key variable -- the variables on which observations are matched -- must be of the same generic type in the master and using
*    datasets.  Same generic type means both numeric or both string.

* I TRIED TO FIX THIS WITH THE CODE BELOW, BUT IT DOES NOT WORK:

tostring gemeente_code_four_digits, generate(gemeente_code_four_digits2) 


*Merge the score dataset that contains buurt & indicators with the gemeente indicators
merge m:m gemeente_code_four_digits2 using "$path\prepped_indicators_gemeente.dta", generate(gemeente_match)




	