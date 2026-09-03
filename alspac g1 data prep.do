use "C:/Users/sk1014/OneDrive - University of Exeter/Sharp, Gemma's files - Shared/Data/ALSPAC/truncated_paper1_g1.dta", clear

**Starting - 15,746
*Drop pregnancies not enrolled 
drop if preg_enrol_status==3 // 15,645 
*Drop duplicate pregnancies
drop if mz005l==1 // 15,236
*Drop second births 
drop if qlet=="B" // 15,039
*Drop if not alive at 1
drop if kz011b==2 // 14,514
*Drop if male sex assigned at birth  
drop if kz021==1 //7,125

**Age at menarche
gen age_menarche=.
replace age_menarche= clon070
replace age_menarche=. if clon070<0

**Heavy menstrual bleeding
label define hmb_lbl 0 "No" 1 "Yes", replace
tab1 pub220 pub320 pub420 pub520 pub620 pub720 pub820 pub920

* Age 10
gen hmb_age10 = .
replace hmb_age10 = 1 if pub220 == 1
replace hmb_age10 = 0 if pub220 == 2
label values hmb_age10 hmb_lbl

* Age 11
gen hmb_age11 = .
replace hmb_age11 = 1 if pub320 == 1
replace hmb_age11 = 0 if pub320 == 2
label values hmb_age11 hmb_lbl

* Age 12
gen hmb_age12 = .
replace hmb_age12 = 1 if pub420 == 1
replace hmb_age12 = 0 if pub420 == 2
label values hmb_age12 hmb_lbl

* Age 13
gen hmb_age13 = .
replace hmb_age13 = 1 if pub520 == 1
replace hmb_age13 = 0 if pub520 == 2
label values hmb_age13 hmb_lbl

* Age 14
gen hmb_age14 = .
replace hmb_age14 = 1 if pub620 == 1
replace hmb_age14 = 0 if pub620 == 2
label values hmb_age14 hmb_lbl

* Age 15
gen hmb_age15 = .
replace hmb_age15 = 1 if pub720 == 1
replace hmb_age15 = 0 if pub720 == 2
label values hmb_age15 hmb_lbl

* Age 16
gen hmb_age16 = .
replace hmb_age16 = 1 if pub820 == 1
replace hmb_age16 = 0 if pub820 == 2
label values hmb_age16 hmb_lbl

* Age 17
gen hmb_age17 = .
replace hmb_age17 = 1 if pub920 == 1
replace hmb_age17 = 0 if pub920 == 2
label values hmb_age17 hmb_lbl

* Age 21 (Moderate to very heavy bleeding)
gen hmb_age21 = .
replace hmb_age21 = 1 if YPA7050 == 1 | YPA7050 == 2
replace hmb_age21 = 0 if YPA7050>=3 & YPA7050<=4
label values hmb_age21 hmb_lbl


tab1 hmb_age10 hmb_age11 hmb_age12 hmb_age13 hmb_age14 hmb_age15 hmb_age16 hmb_age17 hmb_age21, missing

egen hmb_ever = rowmax(hmb_age10 hmb_age11 hmb_age12 hmb_age13 hmb_age14 hmb_age15 hmb_age16 hmb_age17 hmb_age21)
label values hmb_ever hmb_lbl
tab hmb_ever

**Menstrual Pain
label define mp_lbl 0 "No pain" 1 "Pain", replace

* Age 10
gen mp_age10 = .
replace mp_age10 = 1 if pub222 == 1
replace mp_age10 = 0 if pub222 == 2
label values mp_age10 mp_lbl

* Age 11
gen mp_age11 = .
replace mp_age11 = 1 if pub322 == 1
replace mp_age11 = 0 if pub322 == 2
label values mp_age11 mp_lbl

* Age 12 
gen mp_age12 = .
replace mp_age12 = 1 if pub422 == 1
replace mp_age12 = 0 if pub422 == 2
label values mp_age12 mp_lbl


* Age 13 
gen mp_age13 = .
replace mp_age13 = 1 if pub522 == 1
replace mp_age13 = 0 if pub522 == 2
label values mp_age13 mp_lbl


* Age 14 
gen mp_age14 = .
replace mp_age14 = 1 if pub622 == 1
replace mp_age14 = 0 if pub622 == 2
label values mp_age14 mp_lbl


* Age 15
gen mp_age15 = .
replace mp_age15 = 1 if inrange(pub723, 2, 3)
replace mp_age15 = 0 if pub722 == 2 | pub723==1
label values mp_age15 mp_lbl


* Age 16
gen mp_age16 = .
replace mp_age16 = 1 if pub822 == 1
replace mp_age16 = 0 if pub822 == 2
label values mp_age16 mp_lbl

* Age 17
gen mp_age17 = .
replace mp_age17 = 1 if pub922 == 1
replace mp_age17 = 0 if pub922 == 2
label values mp_age17 mp_lbl

* Age 21
gen mp_age21 = .
replace mp_age21 = 1 if YPA7051 == 1 | YPA7051 == 2
replace mp_age21 = 0 if YPA7051>=3 & YPA7051<=4
label values mp_age21 mp_lbl


tab1 mp_age10 mp_age11 mp_age12 mp_age13 mp_age14 mp_age15 mp_age16 mp_age17 mp_age21, missing

egen mp_ever = rowmax(mp_age10 mp_age11 mp_age12 mp_age13 mp_age14 mp_age15 mp_age16 mp_age17 mp_age21)
label values mp_ever mp_lbl
tab mp_ever

**Combined variable
label define hmbmp_lbl 0 "Neither" 1 "HMB only" 2 "MP only" 3 "Both", replace

foreach a in 10 11 12 13 14 15 16 17 21 {

    gen hmb_mp_age`a' = .

    * HMB only
    replace hmb_mp_age`a' = 1 if hmb_age`a' == 1 & mp_age`a' == 0

    * MP only
    replace hmb_mp_age`a' = 2 if hmb_mp_age`a' == . & hmb_age`a' == 0 & mp_age`a' == 1

    * Both HMB and MP
    replace hmb_mp_age`a' = 3 if hmb_age`a' == 1 & mp_age`a' == 1
	
	*Neither
	replace hmb_mp_age`a' = 0 if hmb_age`a' == 0 & mp_age`a' == 0



    label values hmb_mp_age`a' hmbmp_lbl
}

tab1 hmb_mp_age10 hmb_mp_age11 hmb_mp_age12 hmb_mp_age13 hmb_mp_age14 hmb_mp_age15 hmb_mp_age16 hmb_mp_age17 hmb_mp_age21

gen any_symptom = ///
    !missing(hmb_age10) | !missing(mp_age10) | ///
    !missing(hmb_age11) | !missing(mp_age11) | ///
    !missing(hmb_age12) | !missing(mp_age12) | ///
    !missing(hmb_age13) | !missing(mp_age13) | ///
    !missing(hmb_age14) | !missing(mp_age14) | ///
    !missing(hmb_age15) | !missing(mp_age15) | ///
    !missing(hmb_age16) | !missing(mp_age16) | ///
    !missing(hmb_age17) | !missing(mp_age17) | ///
    !missing(hmb_age21) | !missing(mp_age21)

tab any_symptom
keep if any_symptom==1 //4,247

//Harmonising SES vars
*Mother's Education
gen edu_mother_harmonised = .
replace edu_mother_harmonised = 1 if inrange(c645a, 1, 2)  // Low: CSE/vocational
replace edu_mother_harmonised = 2 if inrange(c645a, 3, 4)  // Middle: O/A level
replace edu_mother_harmonised = 3 if c645a == 5            // High: degree+
label define ses 1 "Low" 2 "Middle" 3 "High"
label values edu_mother_harmonised ses
label variable edu_mother_harmonised "Harmonised mother's education (ALSPAC)"
tab edu_mother_harmonised

*Father's Education
gen edu_father_harmonised = .
replace edu_father_harmonised = 1 if inrange(c666a, 1, 2)  // Low
replace edu_father_harmonised = 2 if inrange(c666a, 3, 4)  // Middle
replace edu_father_harmonised = 3 if c666a == 5            // High
label values edu_father_harmonised ses
label variable edu_father_harmonised "Harmonised father's education (ALSPAC)"
tab edu_father_harmonised

*Mother's Occupation at birth
gen occ_mother_harmonised = .
replace occ_mother_harmonised = 1 if inrange(c755, 1, 2)  // High: professional/managerial
replace occ_mother_harmonised = 2 if c755 == 3            // Middle: skilled non-manual
replace occ_mother_harmonised = 3 if inrange(c755, 4, 6)  // Low: skilled manual/semi/unskilled
label values occ_mother_harmonised ses
label variable occ_mother_harmonised "Harmonised mother's occupation at birth (ALSPAC)"
tab occ_mother_harmonised

*Father's Occupation at birth
gen occ_father_harmonised = .
replace occ_father_harmonised = 1 if inrange(c765, 1, 2)  // High
replace occ_father_harmonised = 2 if c765 == 3            // Middle
replace occ_father_harmonised = 3 if inrange(c765, 4, 6)  // Low
label values occ_father_harmonised ses
label variable occ_father_harmonised "Harmonised father's occupation at birth (ALSPAC)"
tab occ_father_harmonised

* Ethnicity
gen ethnicity_harmonised = .
replace ethnicity_harmonised = 1 if c804 == 1   // White
replace ethnicity_harmonised = 2 if c804 == 2   // Non-white
replace ethnicity_harmonised = . if c804 == -1  // Missing
label define eth_alspac 1 "White" 2 "Non-white"
label values ethnicity_harmonised eth_alspac
label variable ethnicity_harmonised "Harmonised ethnicity (ALSPAC, binary)"
tab ethnicity_harmonised

//Prevalence check
egen hmb_or_mp_ever = rowmax(hmb_ever mp_ever)

gen hmb_mp_ever = .
replace hmb_mp_ever = 0 if hmb_ever==0 & mp_ever==0
replace hmb_mp_ever = 1 if hmb_ever==1 & mp_ever==0
replace hmb_mp_ever = 2 if hmb_ever==0 & mp_ever==1
replace hmb_mp_ever = 3 if hmb_ever==1 & mp_ever==1

********************************************************************************
*Incidence analysis
********************************************************************************
//Incidence by gynaecological age
preserve
keep cidB4396 age_menarche pub295 pub397a pub497a pub597a pub697a pub797a pub897a pub997a  hmb_age10-hmb_age17 mp_age10-mp_age17

rename pub295  age_month10
rename pub397a age_month11
rename pub497a age_month12
rename pub597a age_month13
rename pub697a age_month14
rename pub797a age_month15
rename pub897a age_month16
rename pub997a age_month17

reshape long hmb_age mp_age age_month, i(cidB4396) j(wave)

*Convert questionnaire age from months to years
gen age = age_month/12

*Time since menarche calculation
gen ts_menarche = age - age_menarche

drop if missing(ts_menarche)
drop if ts_menarche < 0

*Sort chronologically
sort cidB4396 age

*Create 6-month bins since menarche
gen ts_half = floor(ts_menarche*2)/2

* Collapse everything after 6 years
replace ts_half = 6 if ts_half>=6

tab ts_half
format ts_half %4.1f

drop if ts_half==.
drop if hmb_age==. & mp_age==.

tab ts_half

*Check duplicates (currently 185 surplus observations (1.4% of all obs) - dropping missing stuff first, this is actually 178 surplus (1.42% of all obs)
duplicates report cidB4396 ts_half

*Dropping duplicates - want to take the highest value of hmb and mp across the records 
bysort cidB4396 ts_half: egen hmb_max = max(hmb_age)
bysort cidB4396 ts_half: egen mp_max = max(mp_age)

//keep latest record
by cidB4396 ts_half: keep if _n == _N 

//replace original var with max value var
replace hmb_age = hmb_max 
replace mp_age = mp_max

*Tidy up
drop hmb_max mp_max

*Previous symptom history
by cidB4396: gen prev_hmb = sum(hmb_age==1)
by cidB4396: replace prev_hmb = prev_hmb - (hmb_age==1)

by cidB4396: gen prev_mp = sum(mp_age==1)
by cidB4396: replace prev_mp = prev_mp - (mp_age==1)

*Risk sets
gen risk_hmb = prev_hmb==0 & !missing(hmb_age)
gen risk_mp  = prev_mp==0  & !missing(mp_age)

*Incident cases
gen incident_hmb = hmb_age==1 & prev_hmb==0
gen incident_mp  = mp_age==1  & prev_mp==0

//Check before collapse
distinct cidB4396

*Collapse
collapse (sum) incident_hmb incident_mp (sum) risk_hmb risk_mp (mean) ts_menarche, by(ts_half)

*Incidence
gen hmb_incidence = incident_hmb/risk_hmb
gen mp_incidence  = incident_mp/risk_mp

gen hmb_incidence_pct = hmb_incidence*100
gen mp_incidence_pct  = mp_incidence*100

*Export
list

export excel using "C:\Users\sk1014\OneDrive - University of Exeter\Sharp, Gemma's files - Shared\Analysis plans\Analysis\Aim 1\alspac_g1_incidence.xlsx", firstrow(variables) replace

restore

//Incidence by chronological age
preserve

keep cidB4396 age_menarche pub295 pub397a pub497a pub597a pub697a pub797a pub897a pub997a  hmb_age10-hmb_age17 mp_age10-mp_age17

rename pub295  age_month10
rename pub397a age_month11
rename pub497a age_month12
rename pub597a age_month13
rename pub697a age_month14
rename pub797a age_month15
rename pub897a age_month16
rename pub997a age_month17

reshape long hmb_age mp_age age_month, i(cidB4396) j(wave)

*Age in years
gen age = age_month/12

*Time since menarche
gen ts_menarche = age-age_menarche

drop if missing(ts_menarche)
drop if ts_menarche<0

*Sort
sort cidB4396 age

*Create whole-year age groups

gen age_year = floor(age)

*Drop if no symptoms
drop if hmb_age==. & mp_age==.

* Collapse 9/10, 11/12,and 17/18 due to small Ns (<40)
replace age_year = 10 if age_year==9
replace age_year = 11 if age_year==12
replace age_year = 17 if age_year >= 17

tab age_year

*Check duplicates - 221 surplus (<2% of all obs)
duplicates report cidB4396 age_year

*Dropping duplicates - want to take the highest value of hmb and mp across the records 
bysort cidB4396 age_year: egen hmb_max = max(hmb_age)
bysort cidB4396 age_year: egen mp_max = max(mp_age)

//keep latest record
by cidB4396 age_year: keep if _n == _N 

//replace original var with max value var
replace hmb_age = hmb_max 
replace mp_age = mp_max

*Tidy up
drop hmb_max mp_max

*Previous history
by cidB4396: gen prev_hmb=sum(hmb_age==1)
by cidB4396: replace prev_hmb=prev_hmb-(hmb_age==1)

by cidB4396: gen prev_mp=sum(mp_age==1)
by cidB4396: replace prev_mp=prev_mp-(mp_age==1)

*Risk sets
gen risk_hmb=prev_hmb==0 & !missing(hmb_age)
gen risk_mp =prev_mp==0 & !missing(mp_age)

*Incident cases
gen incident_hmb=hmb_age==1 & prev_hmb==0
gen incident_mp =mp_age==1 & prev_mp==0

distinct cidB4396

*Collapse
collapse (sum) incident_hmb incident_mp (sum) risk_hmb risk_mp (mean) age ts_menarche, by(age_year)

*Incidence
gen hmb_incidence=incident_hmb/risk_hmb
gen mp_incidence =incident_mp/risk_mp

gen hmb_incidence_pct=hmb_incidence*100
gen mp_incidence_pct =mp_incidence*100

*Export
list

export excel using "C:\Users\sk1014\OneDrive - University of Exeter\Sharp, Gemma's files - Shared\Analysis plans\Analysis\Aim 1\alspac_g1_incidence_age.xlsx", firstrow(variables) replace

restore


