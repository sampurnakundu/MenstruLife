***Data Dictionary used for Menstrual Variables: https://www.fhi.no/contentassets/1016188d845f4c5f8fa57266c454ad8c/id_20ar_versjonab.pdf ***

*SAMPLE RESTRICTION
count 
 
* Sex assigned at birth
tab TG119
tab TG119, nol

* KEEP: females only (CHECK coding: 2 = female)
count if TG119 == 2 //We need the number for this for the sample table
keep if TG119 == 2


* Started menstruation
tab TG276
tab TG276, nol

/*
TG276 codes (from data dictionary):
- Numeric age categories
- 18 = Do not remember
- 19 = Have not had it yet

We EXCLUDE:
- Not started menstruation
- Missing / don't know
*/

drop if TG276 == 19 | TG276 == .   // not started or missing


*MENSTRUAL PAIN (MP)

* Variables (from Q25.2):
* TG140 = pain in lower abdomen during menstruation
ta TG140 
gen mp_age20 = .
replace mp_age20 = 1 if TG140 == 1
replace mp_age20 = 0 if TG140 == 0
label variable mp_age20 "Menstrual pain (MP) at age 20"

* NOTE: confirm coding (1 = yes, 0 = no)


* HEAVY MENSTRUAL BLEEDING (HMB)

/*
Variables (Q25.1.3 and Q25.1.2):
TG128-TG135 = heavy bleeding indicators
TG125 = duration of bleeding
*/


* Heavy flow indicators
ta TG128 //Change pads or tampons 6 to 9 times per day
ta TG129 //Need 9 or more pads or tampons on days on the heaviest days 
ta TG130 //Change pads or tampons every two hours
ta TG132 //Often bleed through pads or tampons
ta TG133 //Using both pads and tampons to avoid bleeding though
ta TG134 //Get up at night to change pads or tampons
ta TG135 //Often blood on bedding even If you use pads and tampons

gen heavy_flow = .
replace heavy_flow = 1 if (TG128==1 | TG129==1 | TG130==1 | TG132==1 | TG133==1 | TG134==1 | TG135==1)
replace heavy_flow = 0 if (TG128==0 & TG129==0 & TG130==0 & TG132==0 & TG133==0 & TG134==0 & TG135==0)

* Prolonged bleeding (>7 days)
ta TG125 //Duration of bleeding

gen prolonged_bleeding = .
replace prolonged_bleeding = 1 if TG125 == 3   
replace prolonged_bleeding = 0 if inlist(TG125,1,2)
replace prolonged_bleeding = . if inlist(TG125,4,5)


*Defining Heavy menstrual bleeding as heavy flow or heavy flow and prolonged bleeding
gen hmb_age20=.
replace hmb_age20=1 if (heavy_flow==1 |(heavy_flow==1 & prolonged_bleeding==1))
replace hmb_age20=0 if heavy_flow==0
label variable hmb_age20 "Heavy menstrual bleeding (HMB) at age 20"

* COMBINED VARIABLES

* Any symptom
gen hmb_mp_either = .
replace hmb_mp_either = 1 if hmb_age20 == 1 | mp_age20 == 1
replace hmb_mp_either = 0 if hmb_age20 == 0 & mp_age20 == 0


* 4-category variable
gen hmb_mp_age20 = .
replace hmb_mp_age20 = 0 if hmb_age20==0 & mp_age20==0
replace hmb_mp_age20 = 1 if hmb_age20==1 & mp_age20==0
replace hmb_mp_age20 = 2 if hmb_age20==0 & mp_age20==1
replace hmb_mp_age20 = 3 if hmb_age20==1 & mp_age20==1

label define hmb_mp 0 "Neither" 1 "HMB only" 2 "MP only" 3 "HMB & MP" 
label values hmb_mp_age20 hmb_mp 



* QUICK CHECKS
tab mp_age20
tab hmb_age20
tab hmb_mp_age20
* Cross-check
tab hmb_age20 mp_age20, row


*------------------------------------------------------
* SES VARIABLE HARMONISING
***Data dictionary used from: https://www.fhi.no/globalassets/dokumenterfiler/studier/den-norske-mor-far-og-barn--undersokelsenmoba/instrumentdokumentasjon/instrument-documentation-q1.pdf
*------------------------------------------------------

* MATERNAL EDUCATION (AA1124)
tab AA1124
ta AA1124, nol

gen edu_mother_harmonised = .
replace edu_mother_harmonised = 1 if (inlist(AA1124,1,2) |  inlist(AA1125,1,2)) // Low
replace edu_mother_harmonised = 2 if (inlist(AA1124,3,4,7) | inlist(AA1125,3,4,7))  // Medium
replace edu_mother_harmonised = 3 if (inlist(AA1124,5,6) |  inlist(AA1125,5,6)) // High

label define ses 1 "Low" 2 "Medium" 3 "High"
label values edu_mother_harmonised ses


* Father's Education (AA1126)
ta AA1126
ta AA1126, nol

gen edu_father_harmonised = .
replace edu_father_harmonised = 1 if (inlist(AA1126, 1, 2) | inlist(AA1127, 1, 2))
replace edu_father_harmonised = 2 if (inlist(AA1126, 3, 4, 7) | inlist(AA1127, 3, 4, 7))
replace edu_father_harmonised = 3 if (inlist(AA1126, 5, 6) | inlist(AA1127, 5, 6))

label values edu_father_harmonised ses
label variable edu_father_harmonised "Harmonised father's education (MoBa)"

ta edu_father_harmonised


* Household Income (AA1315 (mother) + AA1316 (father)
gen inc_mother = .
replace inc_mother = 0       if AA1315==1
replace inc_mother = 75000   if AA1315==2
replace inc_mother = 175000  if AA1315==3
replace inc_mother = 250000  if AA1315==4
replace inc_mother = 350000  if AA1315==5
replace inc_mother = 450000  if AA1315==6
replace inc_mother = 750000  if AA1315==7

gen inc_father = .
replace inc_father = 0       if AA1316==1
replace inc_father = 75000   if AA1316==2
replace inc_father = 175000  if AA1316==3
replace inc_father = 250000  if AA1316==4
replace inc_father = 350000  if AA1316==5
replace inc_father = 450000  if AA1316==6
replace inc_father = 750000  if AA1316==7

gen hh_income = inc_mother + inc_father

* Harmonised tertiles (low, medium, high)
gen income_harmonised = .
xtile income_harmonised = hh_income, n(3)

label values income_harmonised ses
label variable income_harmonised "Harmonised household income (MoBa)"

tab income_harmonised

**DESCRIPTIVE ANALYISIS**
**Prevalence estimate: Counts and percentages of hmb, mp, hmb only, mp only, hmb or mp, hmb & mp
tab1 hmb_age20 mp_age20 hmb_mp_either hmb_mp_age20 edu_mother_harmonised edu_father_harmonised income_harmonised 
**Stratified analysis**
**Counts and row percentages
ta edu_mother_harmonised hmb_age20, r 
ta edu_father_harmonised hmb_age20, r 
ta income_harmonised hmb_age20, r 

ta edu_mother_harmonised mp_age20, r 
ta edu_father_harmonised mp_age20, r 
ta income_harmonised mp_age20, r 

ta edu_mother_harmonised hmb_mp_either, r 
ta edu_father_harmonised hmb_mp_either, r 
ta income_harmonised hmb_mp_either, r 

ta edu_mother_harmonised hmb_mp_age20, r 
ta edu_father_harmonised hmb_mp_age20, r 
ta income_harmonised hmb_mp_age20, r 

