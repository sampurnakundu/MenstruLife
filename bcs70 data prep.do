set maxvar 32000
use "C:\Users\sk1014\OneDrive - University of Exeter\Sharp, Gemma's files - Shared\Data\BCS1970\bcs_raw_dat.dta"

count //18,643

* Keep live births only
ta b1_a0376
keep if b1_a0376==3 //16,769

* Sex of cohort member
ta b1_a0255 // 8,100
ta b11_b11sex //3,929
* Restrict to females (most complete sweep)
keep if b11_b11sex==2 //3,929

*Mother's highest education level* 
recode b2_e189a (-3/-1=.) (1=1 "No Quals")(2=2 "Vocational Qual")(3=3 "0 Level or Equivalent")(4=4 "A Level or Equivalent")(5/7=5 "Degree/Certification/Higher") (8=.) ,gen(mother_highest_edulevel)

*Father's highest education level*
recode b2_e189b (-3/-1=.) (1=1 "No Quals") (2=2 "Vocational Qual")(3=3 "0 Level or Equivalent")(4=4 "A Level or Equivalent")(5/7=5 "Degree/Certification/Higher") (8=.),gen(father_highest_edulevel)

//Occupation
*Parents*
recode b1_bd1psoc (min/0=0 "NA")(8=1 " I Professional")(7=2 " II Managerial/technical")(5 6=3 "III Skilled non-manual or manual")(4=4 "IV Partly skilled")(3=5 "V Unskilled")(else=6 "Others"),gen(occupation_father_atbirth)

recode b4_t11_9 (min/0=0 "NA")(8=0)(1=1 " I Professional")(2=2 " II Managerial/technical")(3 4=3 "III Skilled non-manual or manual")(5=4 "IV Partly skilled")(6=5 "V Unskilled")(else=6 "Others"),gen(occupation_mother_age16)

*Household income*
recode b3_bd3inc (-1 8=0 "NA")(6=1 "under £35")(5=2 "£35 - £49")(4=3 "£50 - £99")(3=4 "£100 - £149")(2=5 "£150 - £199")(1=6 "£200 - £249")(0=7 "£250 +"),gen(hh_income_age10)

************************************************************
* SES HARMONISATION
************************************************************
*Mother's Education
gen edu_mother_harmonised = .
replace edu_mother_harmonised = 1 if inrange(mother_highest_edulevel, 1, 2)  // Low: no quals/vocational 
replace edu_mother_harmonised = 2 if inrange(mother_highest_edulevel, 3, 4)  // Middle: O/A level
replace edu_mother_harmonised = 3 if mother_highest_edulevel == 5            // High: degree+
label define edu_h 1 "Low" 2 "Middle" 3 "High"
label values edu_mother_harmonised edu_h
label variable edu_mother_harmonised "Harmonised mother's education (BCS70)"
tab edu_mother_harmonised

*Father's Education
gen edu_father_harmonised = .
replace edu_father_harmonised = 1 if inrange(father_highest_edulevel, 1, 2)  // Low 
replace edu_father_harmonised = 2 if inrange(father_highest_edulevel, 3, 4)  // Middle
replace edu_father_harmonised = 3 if father_highest_edulevel == 5            // High
label values edu_father_harmonised edu_h
label variable edu_father_harmonised "Harmonised father's education (BCS70)"
tab edu_father_harmonised

*Mother's Occupation at birth
gen occ_mother_harmonised = .
replace occ_mother_harmonised = 1 if inrange(occupation_mother_age16, 1, 2)  // High: I+II
replace occ_mother_harmonised = 2 if occupation_mother_age16 == 3            // Middle: III
replace occ_mother_harmonised = 3 if inrange(occupation_mother_age16, 4, 5)  // Low: IV+V
replace occ_mother_harmonised = . if occupation_mother_age16 == 0            // NA
replace occ_mother_harmonised = . if occupation_mother_age16 == 6            // Others
label define occ_h 1 "High (I+II)" 2 "Middle (III)" 3 "Low (IV+V)"
label values occ_mother_harmonised occ_h
label variable occ_mother_harmonised "Harmonised mother's occupation (BCS70, age 16)"
tab occ_mother_harmonised

*Father's Occupation at birth
gen occ_father_harmonised = .
replace occ_father_harmonised = 1 if inrange(occupation_father_atbirth, 1, 2)  // High
replace occ_father_harmonised = 2 if occupation_father_atbirth == 3            // Middle
replace occ_father_harmonised = 3 if inrange(occupation_father_atbirth, 4, 5)  // Low
replace occ_father_harmonised = . if occupation_father_atbirth == 0            // NA
replace occ_father_harmonised = . if occupation_father_atbirth == 6            // Others
label values occ_father_harmonised occ_h
label variable occ_father_harmonised "Harmonised father's occupation at birth (BCS70)"
tab occ_father_harmonised

*Household Income (age 10)
gen income_harmonised = .
replace income_harmonised = 1 if inrange(hh_income_age10, 1, 3)  // Low: under £99/week
replace income_harmonised = 2 if inrange(hh_income_age10, 4, 5)  // Middle: £100-199/week
replace income_harmonised = 3 if inrange(hh_income_age10, 6, 7)  // High: £200+/week
replace income_harmonised = . if hh_income_age10 == 0            // NA
label define inc_h 1 "Low" 2 "Middle" 3 "High"
label values income_harmonised inc_h
label variable income_harmonised "Harmonised household income (BCS70, age 10)"
tab income_harmonised

*Ethnicity
gen ethnicity_harmonised = .
replace ethnicity_harmonised = 1 if inrange(b2_e245, 1, 2)          // White
replace ethnicity_harmonised = 2 if inrange(b2_e245, 3, 7) // Non-white (Asian + African/Other)
replace ethnicity_harmonised = . if (b2_e245<0)        // NA/NK to missing
label define eth_h2 1 "White" 2 "Non-white"
label values ethnicity_harmonised eth_h2
label variable ethnicity_harmonised "Harmonised ethnicity (BCS70, binary)"
tab ethnicity_harmonised

//HMB
gen hmb_age38 = .
replace hmb_age38 = 1 if b8_b8gynd01==1
replace hmb_age38 = 0 if b8_b8gynd01==2

gen hmb_age42 = .
replace hmb_age42 = 1 if b9_b9gynp01==1
replace hmb_age42 = 0 if b9_b9gynp01==0

gen hmb_age46 = .
replace hmb_age46 = 1 if b10_b10gynp01==1
replace hmb_age46 = 0 if b10_b10gynp01==2

gen hmb_age51 = .
replace hmb_age51 = 1 if b11_b11gynprbhp==1
replace hmb_age51 = 0 if b11_b11gynprbhp==2

//MP
gen mp_age42 = .
replace mp_age42 = 1 if b9_b9gynp02==1
replace mp_age42 = 0 if b9_b9gynp02==0

gen mp_age46 = .
replace mp_age46 = 1 if b10_b10gynp02==1
replace mp_age46 = 0 if b10_b10gynp02==2

gen mp_age51 = .
replace mp_age51 = 1 if b11_b11gynprbpp==1
replace mp_age51 = 0 if b11_b11gynprbpp==2

//Combined
gen hmb_mp_age38 = .
replace hmb_mp_age38 = 0 if hmb_age38==0
replace hmb_mp_age38 = 1 if hmb_age38==1
label define hmb_mp 0 "Neither" 1 "HMB" 2 "MP" 3 "HMB & MP" 
label values hmb_mp_age38 hmb_mp 

gen hmb_mp_age42 = .
replace hmb_mp_age42 = 0 if hmb_age42==0 & mp_age42==0
replace hmb_mp_age42 = 1 if hmb_age42==1 & mp_age42==0
replace hmb_mp_age42 = 2 if hmb_age42==0 & mp_age42==1
replace hmb_mp_age42 = 3 if hmb_age42==1 & mp_age42==1
label values hmb_mp_age42 hmb_mp 

gen hmb_mp_age46 = .
replace hmb_mp_age46 = 0 if hmb_age46==0 & mp_age46==0
replace hmb_mp_age46 = 1 if hmb_age46==1 & mp_age46==0
replace hmb_mp_age46 = 2 if hmb_age46==0 & mp_age46==1
replace hmb_mp_age46 = 3 if hmb_age46==1 & mp_age46==1
label values hmb_mp_age46 hmb_mp 

gen hmb_mp_age51 = .
replace hmb_mp_age51 = 0 if hmb_age51==0 & mp_age51==0
replace hmb_mp_age51 = 1 if hmb_age51==1 & mp_age51==0
replace hmb_mp_age51 = 2 if hmb_age51==0 & mp_age51==1
replace hmb_mp_age51 = 3 if hmb_age51==1 & mp_age51==1
label values hmb_mp_age51 hmb_mp 

//Keeping only if people reported symptoms at least once in lifetime
gen any_symptom = !missing(hmb_age38) | !missing(hmb_age42) | !missing(mp_age42) | !missing(hmb_age46) | !missing(mp_age46) |!missing(hmb_age51) | !missing(mp_age51)

count if any_symptom==1 //3,808
keep if any_symptom==1


egen hmb_ever = rowmax(hmb_age*)
egen mp_ever = rowmax(mp_age*)
egen hmb_or_mp_ever = rowmax(hmb_ever mp_ever)

gen hmb_mp_ever = .
replace hmb_mp_ever = 0 if hmb_ever==0 & mp_ever==0
replace hmb_mp_ever = 1 if hmb_ever==1 & mp_ever==0
replace hmb_mp_ever = 2 if hmb_ever==0 & mp_ever==1
replace hmb_mp_ever = 3 if hmb_ever==1 & mp_ever==1










