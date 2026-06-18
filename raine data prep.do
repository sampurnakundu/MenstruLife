*Raine data prep
use "C:\Users\sk1014\OneDrive - University of Exeter\Sharp, Gemma's files - Shared\Data\RAINE\RAINE data\raine_raw.dta"

count //2,868
isid ID
duplicates report ID

* Keep females only
keep if SEX == 1 
count //1,414

//Heavy menstrual bleeding 
*Age 14
gen hmb_age14=.
replace hmb_age14=1 if G214_MIT_PERHEAVY==1
replace hmb_age14=0 if G214_MIT_PERHEAVY==0

*Age 20
replace G220_PER8D = . if G220_PER8D == 88
gen hmb_age20 = .
replace hmb_age20 = 1 if (G220_PER8B==1 | G220_PER8C==1 | (G220_PER8A==1 & G220_PER8D >4))
replace hmb_age20 = 0 if (missing(hmb_age20) & (!missing(G220_PER8A) | !missing(G220_PER8B) | !missing(G220_PER8C) | !missing(G220_PER8D)))

*Age 22
replace G222_PER8D = . if G222_PER8D == 88
gen hmb_age22=.
replace hmb_age22 = 1 if (G222_PER8B==1 | G222_PER8C==1 | (G222_PER8A==1 & G222_PER8D >4))
replace hmb_age22 = 0 if (missing(hmb_age22) & (!missing(G222_PER8A) | !missing(G222_PER8B) | !missing(G222_PER8C) | !missing(G222_PER8D)))

*Age 27
replace G227_PER7 = . if inlist(G227_PER7,888,999)
replace G227_PER8 = . if inlist(G227_PER8,888,999)
gen hmb_age27 = .
replace hmb_age27 = 0 if !missing(G227_PER7) | !missing(G227_PER8)
replace hmb_age27 = 1 if (G227_PER7==3 | G227_PER7==4 | (G227_PER8>=2 & G227_PER8<=5 ))

//Menstrual pain
* Age 14
gen mp_age14 = .
replace mp_age14 = 0 if G214_MIT_PERPAIN==0
replace mp_age14 = 1 if G214_MIT_PERPAIN==1

* Age 20
replace G220_PER2 = . if inlist(G220_PER2,88,99)
gen mp_age20 = .
replace mp_age20 = 0 if (G220_PER2>=0 & G220_PER2<6)
replace mp_age20 = 1 if (G220_PER2 >= 6 & G220_PER2<=10)

* Age 22
replace G222_PER2 = . if inlist(G222_PER2,88,99)
gen mp_age22 = .
replace mp_age22 = 0 if (G222_PER2>=0 & G222_PER2<6)
replace mp_age22 = 1 if (G222_PER2 >= 6 & G222_PER2<=10)

*Age 27
replace G227_PER2 = . if G227_PER2==999
gen mp_age27 = .
replace mp_age27 = 0 if (G227_PER2>=0 & G227_PER2<6)
replace mp_age27 = 1 if (G227_PER2 >= 6 & G227_PER2<=10)

*Age 28
replace G228_PER2 = . if G228_PER2==99
gen mp_age28 = .
replace mp_age28 = 0 if (G228_PER2>=0 & G228_PER2<6) | G228_PER2==88
replace mp_age28 = 1 if (G228_PER2 >= 6 & G228_PER2<=10)


//Combined
gen hmb_mp_age14=.
replace hmb_mp_age14=0 if (hmb_age14==0 & mp_age14==0)
replace hmb_mp_age14=1 if (hmb_age14==1 & mp_age14==0)
replace hmb_mp_age14=2 if (mp_age14==1 & hmb_age14==0)
replace hmb_mp_age14=3 if (hmb_age14==1 & mp_age14==1)
label define hmb_mp 0 "Neither" 1 "HMB" 2 "MP" 3 "HMB & MP"
label values hmb_mp_age14 hmb_mp

gen hmb_mp_age20=.
replace hmb_mp_age20=0 if (hmb_age20==0 & mp_age20==0)
replace hmb_mp_age20=1 if (hmb_age20==1 & mp_age20==0)
replace hmb_mp_age20=2 if (mp_age20==1 & hmb_age20==0)
replace hmb_mp_age20=3 if (hmb_age20==1 & mp_age20==1)
label values hmb_mp_age20 hmb_mp

gen hmb_mp_age22=.
replace hmb_mp_age22=0 if (hmb_age22==0 & mp_age22==0)
replace hmb_mp_age22=1 if (hmb_age22==1 & mp_age22==0)
replace hmb_mp_age22=2 if (mp_age22==1 & hmb_age22==0)
replace hmb_mp_age22=3 if (hmb_age22==1 & mp_age22==1)
label values hmb_mp_age22 hmb_mp

gen hmb_mp_age27=.
replace hmb_mp_age27=0 if (hmb_age27==0 & mp_age27==0)
replace hmb_mp_age27=1 if (hmb_age27==1 & mp_age27==0)
replace hmb_mp_age27=2 if (mp_age27==1 & hmb_age27==0)
replace hmb_mp_age27=3 if (hmb_age27==1 & mp_age27==1)
label values hmb_mp_age27 hmb_mp

gen hmb_mp_age28=.
replace hmb_mp_age28=0 if mp_age28==0
replace hmb_mp_age28=2 if mp_age28==1
label values hmb_mp_age28 hmb_mp

//Keeping only if people reported symptoms at least once in lifetime
gen any_symptom = !missing(hmb_age14) | !missing(mp_age14) | !missing(hmb_age20) | !missing(mp_age20) | !missing(hmb_age22) | !missing(mp_age22) | !missing(hmb_age27) | !missing(mp_age27) | !missing(mp_age28)

count if any_symptom==1

keep if any_symptom==1 //842

*Age at menarche 
gen age_menarche=G214_MENARCHE_AGE
replace age_menarche=G214_MIT_MENARAGE if age_menarche==.

*Years since menarche 
gen years_since_menarche_age14= G214_MIT_SINCEMENARCHE_YEARS

* Household Income (Age 10)
gen household_income_age10 = G210_MON1_3
replace household_income_age10 = . if G210_MON1_3 == -99

label define income10 0 "$1 to $8,000" 1 "$8,001 to $16,000" 2 "$16,001 to $25,000" 3 "$25,001 to $30,000" 4 "$30,001 to $35,000" 5 "$35,001 to $40,000" 6 "$40,001 to $50,000" 7 "$50,001 to $60,000" 8 "$60,001 to $70,000"  9 "$70,001 or more"

label values household_income_age10 income10

gen income_harmonised = .
replace income_harmonised = 1 if inrange(household_income_age10, 1, 2)  // Low: under $25k AUD
replace income_harmonised = 2 if inrange(household_income_age10, 3, 6) // Middle: $25-50k AUD
replace income_harmonised = 3 if inrange(household_income_age10, 7, 9) // High: $50k+ AUD
label define ses 1 "Low" 2 "Middle" 3 "High" 
label values income_harmonised ses
label variable income_harmonised "Harmonised household income (Raine, age 10)"
tab income_harmonised

*Parent's highest level of education*

gen mother_highest_edulevel= G208_ED15
replace mother_highest_edulevel=. if G208_ED15==99
label define edu 0 "No qualificaton" 1 "Tee or equivalent" 2 "Trade/apprenticeship" 3 "Certificate from college, tafe" 4 "Diploma (beyond year 12)" 5 "Bachelor's degree" 6 "Postgraduate diploma / higher degree" 7 "Other"
label values mother_highest_edulevel edu

gen father_highest_edulevel= G208_ED13
replace father_highest_edulevel=. if G208_ED13==99
label values father_highest_edulevel edu

*Mother's Education
gen edu_mother_harmonised = .
replace edu_mother_harmonised = 1 if inrange(mother_highest_edulevel, 0, 2)  // Low: no qual/trade
replace edu_mother_harmonised = 2 if inrange(mother_highest_edulevel, 3, 4)  // Middle: certificate/diploma
replace edu_mother_harmonised = 3 if inrange(mother_highest_edulevel, 5, 6)  // High: degree+
replace edu_mother_harmonised = . if mother_highest_edulevel == 7            // Other to missing
label values edu_mother_harmonised ses
label variable edu_mother_harmonised "Harmonised mother's education (Raine)"
tab edu_mother_harmonised

*Father's Education
gen edu_father_harmonised = .
replace edu_father_harmonised = 1 if inrange(father_highest_edulevel, 0, 2)  // Low
replace edu_father_harmonised = 2 if inrange(father_highest_edulevel, 3, 4)  // Middle
replace edu_father_harmonised = 3 if inrange(father_highest_edulevel, 5, 6)  // High
replace edu_father_harmonised = . if father_highest_edulevel == 7            // Other
label values edu_father_harmonised ses
label variable edu_father_harmonised "Harmonised father's education (Raine)"
tab edu_father_harmonised

*Ethnicity
gen ethnicity_harmonised = .
replace ethnicity_harmonised = 1 if M_RACE == 1 & F_RACE == 1
replace ethnicity_harmonised = 2 if inlist(M_RACE,2,3,4,5,6,7) | inlist(F_RACE,2,3,4,5,6,8)
replace ethnicity_harmonised = . if M_RACE == 9 | F_RACE == 9

label define eth_h 1 "White" 2 "Non-white", replace
label values ethnicity_harmonised eth_h
label variable ethnicity_harmonised "Harmonised ethnicity (Raine, binary)"

tab ethnicity_harmonised

//Prevalence check
egen hmb_ever = rowmax(hmb_age*)
egen mp_ever = rowmax(mp_age*)
egen hmb_or_mp_ever = rowmax(hmb_ever mp_ever)

gen hmb_mp_ever = .
replace hmb_mp_ever = 0 if hmb_ever==0 & mp_ever==0
replace hmb_mp_ever = 1 if hmb_ever==1 & mp_ever==0
replace hmb_mp_ever = 2 if hmb_ever==0 & mp_ever==1
replace hmb_mp_ever = 3 if hmb_ever==1 & mp_ever==1
