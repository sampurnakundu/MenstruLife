*ABCD Data Prep*
use "C:\Users\sk1014\OneDrive - University of Exeter\Sharp, Gemma's files - Shared\Data\ABCD\dataset_20260601\abcd_merged.dta"
//Long format data
**Starting with count of unique participants
egen pid = group(participant_id)
distinct participant_id //11,868
* Keep females only
tab ab_g_stc_cohort_sex
keep if ab_g_stc_cohort_sex == 2 
*Check again
distinct participant_id //5,675

* Menstrual pain indicator
label variable ph_y_pds_f_002_10 "Menstrual pain intensity (0-10 scale)"

*Menstrual Pain
gen mp = .
replace mp = 1 if ph_y_pds_f_002_10 >=6 & ph_y_pds_f_002_10 <=10
replace mp = 0 if ph_y_pds_f_002_10 <6 & ph_y_pds_f_002_10 < .

* Bleeding flow
gen bleeding_flow = .
replace bleeding_flow = 0 if ph_y_pds_f_002_09 == 0
replace bleeding_flow = 1 if ph_y_pds_f_002_09 == 1
replace bleeding_flow = 2 if ph_y_pds_f_002_09 == 2
label variable bleeding_flow "Bleeding flow"
label define bleed_flow 0 "light" 1 "medium" 2 "heavy"
label values bleeding_flow bleed_flow

* Heavy menstrual bleeding
gen hmb = .
replace hmb = 0 if inlist(bleeding_flow,0,1)
replace hmb = 1 if (bleeding_flow == 2)
label variable hmb "Heavy menstrual bleeding"


* Combined HMB/MP outcome
gen hmb_mp = .
replace hmb_mp = 3 if hmb == 1 & mp == 1
replace hmb_mp = 2  if hmb == 0 & mp == 1
replace hmb_mp = 1 if hmb == 1 & mp == 0
replace hmb_mp = 0 if hmb == 0 & mp == 0
label variable hmb_mp "Combined outcome (hmb & mp categories)"
label define hmb_mp 0 "neither" 1 "hmb only" 2 "mp only" 3 "hmb & mp both"
label values hmb_mp hmb_mp


* Age at menarche
rename ph_y_pds_f_002_01 age_menarche
replace age_menarche= . if (age_menarche==0 | age_menarche==2021 | age_menarche==2020)
replace age_menarche= 11 if (age_menarche==.11 | age_menarche==110)
replace age_menarche= 11.7 if age_menarche==117
label variable age_menarche "Age at menarche (years)"

* Interview age
rename ab_g_dyn_visit_age interview_age_years
label variable interview_age_years "Age at interview (years)"


********************************************************
***SES HAMONISATION***
********************************************************
*Ethnicity
recode ab_g_stc_cohort_ethnrace_leg (2 = 1 "White")(3 = 2 "Black")(4 = 3 "Asian")(1 13 = 4 "Other"), gen(ethnicity_harmonised)
label variable ethnicity_harmonised "Harmonised ethnicity (ABCD)"
tab ethnicity_harmonised

*Household Income
//1= Less than $5,000; 2=$5,000 through $11,999; 3=$12,000 through $15,999; 4=$16,000 through $24,999; 5=$25,000 through $34,999; 6=$35,000 through $49,999; 7=$50,000 through $74,999; 8= $75,000 through $99,999; 9=$100,000 through $199,999; 10=$200,000 and greater. 999 = Don't know 
gen household_income = ab_p_demo_income_hhold_001
replace household_income = . if household_income == 999 | household_income== 777
label variable household_income "Household income"

gen income_harmonised = . 
replace income_harmonised = 1 if inrange(household_income,1,4)
replace income_harmonised = 2 if inrange(household_income,5,7)
replace income_harmonised = 3 if inrange(household_income,8,10)
label define ses 1 "Low" 2 "Middle" 3 "High"
label values income_harmonised ses
label variable income_harmonised "Harmonised household income (ABCD)"
tab income_harmonised

* Parental Education
/* What is the highest grade or level of school you have completed or the highest degree you have received?
0 = Never attended/Kindergarten only; 1 = 1st grade; 2 = 2nd grade; 3 = 3rd grade ; 4 = 4th grade; 5 = 5th grade; 6 = 6th grade; 7 = 7th grade; 8 = 8th grade; 9 = 9th grade; 10 = 10th grade; 11 = 11th grade; 12 = 12th grade;
13 = High school graduate ; 14 = GED or equivalent;
15 = Some college;
16 = Associate degree: Occupational; 17 = Associate degree: Academic Program;
18 = Bachelor's degree (ex. BA
19 = Master's degree (ex. MA; 20 = Professional School degree (ex. MD; 21 = Doctoral degree (ex. PhD) */
gen edu_parent_harmonised = .
replace edu_parent_harmonised = 1 if inrange(ab_p_demo_edu_slf_001,1,13)
replace edu_parent_harmonised = 2 if inrange(ab_p_demo_edu_slf_001,14,16)
replace edu_parent_harmonised = 3 if inrange(ab_p_demo_edu_slf_001,17,22) 
label values edu_parent_harmonised ses
label variable edu_parent_harmonised "Harmonised parent education (ABCD)"
tab edu_parent_harmonised

//Check ages at timepoints

tabstat interview_age_years, by(session_id)
tabstat interview_age_years, by(session_id) stats(n mean sd min max)

//Defining the ages at each timepoints
gen age_wave = .
replace age_wave = 10 if session_id == "ses-00A"
replace age_wave = 11 if session_id == "ses-01A"
replace age_wave = 12 if session_id == "ses-02A"
replace age_wave = 13 if session_id == "ses-03A"
replace age_wave = 14 if session_id == "ses-04A"
replace age_wave = 15 if session_id == "ses-05A"
replace age_wave = 16 if session_id == "ses-06A"
replace age_wave = 17 if session_id == "ses-07A"

drop if age_wave==.
duplicates report participant_id age_wave


********************************************************
* Convert long → wide 
********************************************************
* Keeping only variables needed for reshape
keep participant_id interview_age_years age_wave age_menarche edu_parent_harmonised income_harmonised ethnicity ethnicity_harmonised hmb mp hmb_mp ph_y_pds_f_002_10  bleeding_flow

distinct participant_id //5,675

bys participant_id: replace edu_parent_harmonised = edu_parent_harmonised[1]
bys participant_id: replace income_harmonised = income_harmonised[1]
bys participant_id: replace ethnicity_harmonised = ethnicity_harmonised[1]

* Reshape long → wide
reshape wide hmb mp hmb_mp ph_y_pds_f_002_10 bleeding_flow age_menarche interview_age_years, i(participant_id) j(age_wave)

* Age at menarche (taking the first time reported)
gen age_menarche = .
foreach v of varlist age_menarche* {
    replace age_menarche= `v' if missing(age_menarche) & !missing(`v')
}

* Time since menarche
foreach v of varlist interview_age_years* {
    local suffix = subinstr("`v'","interview_age_years","",.)
    gen ts_menarche`suffix' = `v' - age_menarche
}

*Rename variables to harmonised age format
*Rename combined outcome
foreach v of varlist hmb_mp* {
    local num = substr("`v'",7,.)
    rename `v' hmb_mp_age`num'
}

*Rename HMB variables
foreach v of varlist hmb* {
    if strpos("`v'","hmb_mp")==0 {
        local num = substr("`v'",4,.)
        rename `v' hmb_age`num'
    }
}
*Rename MP
foreach v of varlist mp* {
    local num = substr("`v'",3,.)
    rename `v' mp_age`num'
}
gen any_symptom = !missing(hmb_age10) | !missing(mp_age10) | !missing(hmb_age11) | !missing(mp_age11) | !missing(hmb_age12) | !missing(mp_age12) | !missing(hmb_age13) | !missing(mp_age13) | !missing(hmb_age14) | !missing(mp_age14) | !missing(hmb_age15) | !missing(mp_age15) | !missing(hmb_age16) | !missing(mp_age16) | !missing(hmb_age17) | !missing(mp_age17)
count if any_symptom==1
keep if any_symptom==1 //5,112

//Incidence
//Gyanecological age
preserve

*Keep required variables
keep participant_id interview_age_years13 interview_age_years14 interview_age_years15 interview_age_years16 interview_age_years17 age_menarche hmb_age13 hmb_age14 hmb_age15 hmb_age16 hmb_age17 mp_age13 mp_age14 mp_age15 mp_age16 mp_age17  ts_menarche13 ts_menarche14 ts_menarche15 ts_menarche16 ts_menarche17

*Wide -> long
reshape long hmb_age mp_age interview_age_years ts_menarche, i(participant_id) j(wave)

*Actual age in questionnaire
rename interview_age_years age

*Time since menarche
* Keep post-menarche observations
drop if missing(ts_menarche)
drop if ts_menarche < 0

*Sort observations
sort participant_id age

*6 month bins
gen ts_half = floor(ts_menarche*2)/2

drop if hmb_age==. | mp_age==.

replace ts_half = 8 if ts_half >= 8

format ts_half %4.1f

tab ts_half

*Duplicate check //72 surplus
duplicates report participant_id ts_half

//resolve duplicates
bysort participant_id ts_half: egen hmb_max = max(hmb_age)
bysort participant_id ts_half: egen mp_max  = max(mp_age)

by participant_id ts_half: keep if _n==_N

replace hmb_age = hmb_max
replace mp_age  = mp_max

drop hmb_max mp_max

sort participant_id ts_half age

*Previous symptom history
by participant_id: gen prev_hmb = sum(hmb_age == 1)
by participant_id: replace prev_hmb = prev_hmb - (hmb_age == 1)

by participant_id: gen prev_mp = sum(mp_age == 1)
by participant_id: replace prev_mp = prev_mp - (mp_age == 1)

*Risk sets
gen risk_hmb = (prev_hmb == 0 & !missing(hmb_age))
gen risk_mp  = (prev_mp  == 0 & !missing(mp_age))

*Incident cases
gen incident_hmb = (hmb_age == 1 & prev_hmb == 0)
gen incident_mp  = (mp_age  == 1 & prev_mp  == 0)


*Collapse by time since menarche
collapse (sum) incident_hmb incident_mp (sum) risk_hmb risk_mp (mean) ts_menarche, by(ts_half)

*Incidence estimates
gen hmb_incidence = incident_hmb / risk_hmb
gen mp_incidence  = incident_mp  / risk_mp

gen hmb_incidence_pct = hmb_incidence * 100
gen mp_incidence_pct  = mp_incidence * 100

*Check
list ts_half ts_menarche incident_hmb risk_hmb hmb_incidence_pct incident_mp risk_mp mp_incidence_pct, sep(0)

*Export
export excel using "C:\Users\sk1014\OneDrive - University of Exeter\Sharp, Gemma's files - Shared\Analysis plans\Analysis\Aim 1\abcd_incidence.xlsx", firstrow(variables) replace

restore

//Incidence by chronological age
preserve

*Keep required variables
keep participant_id interview_age_years13 interview_age_years14 interview_age_years15 interview_age_years16 interview_age_years17 age_menarche hmb_age13 hmb_age14 hmb_age15 hmb_age16 hmb_age17 mp_age13 mp_age14 mp_age15 mp_age16 mp_age17  ts_menarche13 ts_menarche14 ts_menarche15 ts_menarche16 ts_menarche17

*Wide -> long
reshape long hmb_age mp_age interview_age_years ts_menarche, i(participant_id) j(wave)

rename interview_age_years age

*Time since menarche
* Keep post-menarche observations
drop if missing(ts_menarche)
drop if ts_menarche<0

*Sort observations
sort participant_id age
 
*whole years
gen age_year = floor(age)

drop if hmb_age==. | mp_age==.

tab age_year

* Check duplicates //1217 surplus
duplicates report participant_id age_year

* Resolve duplicates
bysort participant_id age_year: egen hmb_max = max(hmb_age)
bysort participant_id age_year: egen mp_max  = max(mp_age)

by participant_id age_year: keep if _n==_N

replace hmb_age = hmb_max
replace mp_age  = mp_max

drop hmb_max mp_max

sort participant_id age_year age


*Previous symptom history
by participant_id: gen prev_hmb = sum(hmb_age == 1)
by participant_id: replace prev_hmb = prev_hmb - (hmb_age == 1)

by participant_id: gen prev_mp = sum(mp_age == 1)
by participant_id: replace prev_mp = prev_mp - (mp_age == 1)

*Risk sets
gen risk_hmb = (prev_hmb == 0 & !missing(hmb_age))
gen risk_mp  = (prev_mp  == 0 & !missing(mp_age))

*Incident cases
gen incident_hmb = (hmb_age == 1 & prev_hmb == 0)
gen incident_mp  = (mp_age  == 1 & prev_mp  == 0)

*Time-since-menarche groups
gen ts_year = floor(ts_menarche)

replace ts_year = 6 if ts_year >= 6
tab ts_year

*Collapse by time since menarche
collapse (sum) incident_hmb incident_mp (sum) risk_hmb risk_mp (mean) ts_menarche, by(age_year)

*Incidence estimates
gen hmb_incidence = incident_hmb / risk_hmb
gen mp_incidence  = incident_mp  / risk_mp

gen hmb_incidence_pct = hmb_incidence * 100
gen mp_incidence_pct  = mp_incidence * 100

*Check
list age_year ts_menarche incident_hmb risk_hmb hmb_incidence_pct incident_mp risk_mp mp_incidence_pct, sep(0)

*Export
export excel using "C:\Users\sk1014\OneDrive - University of Exeter\Sharp, Gemma's files - Shared\Analysis plans\Analysis\Aim 1\abcd_incidence_age.xlsx", firstrow(variables) replace

restore

//Prevalence check
egen hmb_ever = rowmax(hmb_age*)
egen mp_ever = rowmax(mp_age*)
egen hmb_or_mp_ever = rowmax(hmb_ever mp_ever)

gen hmb_mp_ever = .
replace hmb_mp_ever = 0 if hmb_ever==0 & mp_ever==0
replace hmb_mp_ever = 1 if hmb_ever==1 & mp_ever==0
replace hmb_mp_ever = 2 if hmb_ever==0 & mp_ever==1
replace hmb_mp_ever = 3 if hmb_ever==1 & mp_ever==1
