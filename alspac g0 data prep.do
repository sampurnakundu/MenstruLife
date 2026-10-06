**G0 prep
use "C:\Users\sk1014\OneDrive - University of Exeter\Sharp, Gemma's files - Shared\Data\ALSPAC\truncated_paper1_g0.dta"
**Starting - 15,746
*Drop pregnancies not enrolled 
drop if preg_enrol_status==3 // 15,645 
*Drop duplicate pregnancies
drop if mz005l==1 // 15,236
*Drop second births 
drop if qlet=="B" // 15,039
*Drop if not alive at 1
drop if kz011b==2 // 14,514

//Age calculations
*age 32 timepoint
ta h992
drop if h992==78 //14,513
gen age_age32=h992
gen child_age_tp32=h991a/12 //Child's age in years

*age 33 timepoint
gen age_age33 = floor(h992 + (j914 - child_age_tp32)) //previous timepoint age plus the different in child's age

*age 34 timepoint
ta k9996a
gen age_age34=k9996a

*age 35 timepoint 
ta l9996a
gen age_age35=l9996a

*age 38 timepoint
ta p9996a
gen age_age38=p9996a

*age 41 timepoint
ta s9996a
gen age_age41=s9996a

*age 48 timepoint
ta t9994
gen age_age48=t9994

*age 51 timepoint
ta V9996
gen age_age51=V9996


********************************************************
*HEAVY MENSTRUAL BLEEDING (HMB)
********************************************************

tab1 h110 j141 k1290 l3350 p1260 s1260 t4835 V4835

* AGE 32
gen hmb_age32 = .
replace hmb_age32 = 1 if inlist(h110,1,2)
replace hmb_age32 = 0 if inlist(h110,3,4)

* AGE 33
gen hmb_age33 = .
replace hmb_age33 = 1 if inlist(j141,1,2)
replace hmb_age33 = 0 if inlist(j141,3,4)

* AGE 34
gen hmb_age34 = .
replace hmb_age34 = 1 if inlist(k1290,1,2)
replace hmb_age34 = 0 if inlist(k1290,3,4)

* AGE 35
gen hmb_age35 = .
replace hmb_age35 = 1 if inlist(l3350,1,2)
replace hmb_age35 = 0 if inlist(l3350,3,4)

* AGE 38
gen hmb_age38 = .
replace hmb_age38 = 1 if inlist(p1260,1,2)
replace hmb_age38 = 0 if inlist(p1260,3,4)

* AGE 41
gen hmb_age41 = .
replace hmb_age41 = 1 if inlist(s1260,1,2)
replace hmb_age41 = 0 if inlist(s1260,3,4)

* AGE 48
gen hmb_age48 = .
replace hmb_age48 = 1 if inlist(t4835,1,2)
replace hmb_age48 = 0 if inlist(t4835,3,4)

* AGE 51
gen hmb_age51 = .
replace hmb_age51 = 1 if inlist(V4835,1,2)
replace hmb_age51 = 0 if inlist(V4835,3,4)

********************************************************
*MENSTRUAL PAIN (MP)
********************************************************

tab1 h111 j142 k1291 l3351 p1261 s1261 t4836 V4836

* AGE 32
gen mp_age32 = 1 if (h111==1 | h111==2)
replace mp_age32=0 if (h111==3 | h111==4)

* AGE 33
gen mp_age33 = 1 if (j142==1 | j142==2)
replace mp_age33=0 if (j142==3 | j142==4)

* AGE 34
gen mp_age34 = 1 if (k1291==1 | k1291==2)
replace mp_age34=0 if (k1291==3 | k1291==4)

* AGE 35
gen mp_age35 = 1 if (l3351==1 | l3351==2)
replace mp_age35=0 if (l3351==3 | l3351==4)

* AGE 38
gen mp_age38 = 1 if (p1261==1 | p1261==2)
replace mp_age38=0 if (p1261==3 | p1261==4)

* AGE 41
gen mp_age41 = 1 if (s1261==1 | s1261==2)
replace mp_age41=0 if (s1261==3 | s1261==4)

* AGE 48
gen mp_age48= 1 if (t4836==1 | t4836==2)
replace mp_age48=0 if (t4836==3 | t4836==4)

* AGE 51
gen mp_age51= 1 if (V4836==1 | V4836==2)
replace mp_age51=0 if (V4836==3 | V4836==4)

//Tabulate 
tab1 hmb_age32 hmb_age33 hmb_age34 hmb_age35 hmb_age38 hmb_age41 hmb_age48 hmb_age51
tab1 mp_age32 mp_age33 mp_age34 mp_age35 mp_age38 mp_age41 mp_age48 mp_age51


*Combined HMB & MP*

*Age 32
gen hmb_mp_age32=.
replace hmb_mp_age32=1 if hmb_age32==1 & mp_age32==0
replace hmb_mp_age32=2 if mp_age32==1 & hmb_age32==0
replace hmb_mp_age32=3 if hmb_age32==1 & mp_age32==1
label values hmb_mp_age32 hmb_mp

*Age 33
gen hmb_mp_age33=.
replace hmb_mp_age33=1 if hmb_age33==1 & mp_age33==0
replace hmb_mp_age33=2 if mp_age33==1 & hmb_age33==0
replace hmb_mp_age33=3 if hmb_age33==1 & mp_age33==1
label values hmb_mp_age33 hmb_mp

*Age 34
gen hmb_mp_age34=.
replace hmb_mp_age34=0 if hmb_age34==0 & mp_age34==0
replace hmb_mp_age34=1 if hmb_age34==1 & mp_age34==0
replace hmb_mp_age34=2 if mp_age34==1 & hmb_age34==0
replace hmb_mp_age34=3 if hmb_age34==1 & mp_age34==1
label values hmb_mp_age34 hmb_mp

*Age 35
gen hmb_mp_age35=.
replace hmb_mp_age35=0 if hmb_age35==0 & mp_age35==0
replace hmb_mp_age35=1 if hmb_age35==1 & mp_age35==0
replace hmb_mp_age35=2 if mp_age35==1 & hmb_age35==0
replace hmb_mp_age35=3 if hmb_age35==1 & mp_age35==1
label values hmb_mp_age35 hmb_mp

*Age 38
gen hmb_mp_age38=.
replace hmb_mp_age38=0 if hmb_age38==0 & mp_age38==0
replace hmb_mp_age38=1 if hmb_age38==1 & mp_age38==0
replace hmb_mp_age38=2 if mp_age38==1 & hmb_age38==0
replace hmb_mp_age38=3 if hmb_age38==1 & mp_age38==1
label values hmb_mp_age38 hmb_mp

*Age 41
gen hmb_mp_age41=.
replace hmb_mp_age41=0 if hmb_age41==0 & mp_age41==0
replace hmb_mp_age41=1 if hmb_age41==1 & mp_age41==0
replace hmb_mp_age41=2 if mp_age41==1 & hmb_age41==0
replace hmb_mp_age41=3 if hmb_age41==1 & mp_age41==1
label values hmb_mp_age41 hmb_mp

*Age 48
gen hmb_mp_age48=.
replace hmb_mp_age48=0 if hmb_age48==0 & mp_age48==0
replace hmb_mp_age48=1 if hmb_age48==1 & mp_age48==0
replace hmb_mp_age48=2 if mp_age48==1 & hmb_age48==0
replace hmb_mp_age48=3 if hmb_age48==1 & mp_age48==1
label values hmb_mp_age48 hmb_mp

*Age 51
gen hmb_mp_age51=.
replace hmb_mp_age51=0 if hmb_age51==0 & mp_age51==0
replace hmb_mp_age51=1 if hmb_age51==1 & mp_age51==0
replace hmb_mp_age51=2 if mp_age51==1 & hmb_age51==0
replace hmb_mp_age51=3 if hmb_age51==1 & mp_age51==1
label values hmb_mp_age51 hmb_mp

* Restrict age 48 and age 51 to participants menstruating (accounting for menopause)

replace hmb_age48 = . if t4800 == 2
replace mp_age48  = . if t4800 == 2
replace hmb_mp_age48 = . if t4800 == 2

replace hmb_age51 = . if V4800 == 2
replace mp_age51  = . if V4800 == 2
replace hmb_mp_age51 = . if V4800 == 2

*Keep participants answered any symptom data
gen any_symptom = ///
    !missing(hmb_age32) | !missing(mp_age32) | ///
    !missing(hmb_age33) | !missing(mp_age33) | ///
    !missing(hmb_age34) | !missing(mp_age34) | ///
    !missing(hmb_age35) | !missing(mp_age35) | ///
    !missing(hmb_age38) | !missing(mp_age38) | ///
    !missing(hmb_age41) | !missing(mp_age41) | ///
    !missing(hmb_age48) | !missing(mp_age48) | ///
    !missing(hmb_age51) | !missing(mp_age51)

count if any_symptom==1
keep if any_symptom==1 //11,072 (previously before not acounting for menopause= 11,110 ) 

//For age-specific estimates
reshape long hmb_age mp_age hmb_mp_age age_age, i(cidB4396) j(wave)

rename hmb_age hmb
rename mp_age mp
rename hmb_mp_age hmb_mp
rename age_age age

drop if missing(age)
drop if hmb==. & mp==.
tab age
*drop if 18 or 19
drop if age==18 | age==19
*combine 56+
replace age = 56 if inrange(age,57,60)

sort cidB4396 age wave

*Duplicates - 1373 surplus (2.89% of all observations)
duplicates report cidB4396 age

*Dropping duplicates - want to take the highest value of hmb and mp across the multiple records 
bysort cidB4396 age: egen hmb_max = max(hmb)
bysort cidB4396 age: egen mp_max = max(mp)

by cidB4396 age: keep if _n == _N //keep latest

replace hmb = hmb_max //replace original var with max value var
replace mp = mp_max

*Need to recalculate hmb_mp now
gen hmb_mp_new=.
replace hmb_mp_new=0 if hmb==0 & mp==0
replace hmb_mp_new=1 if hmb==1 & mp==0
replace hmb_mp_new=2 if mp==1 & hmb==0
replace hmb_mp_new=3 if hmb==1 & mp==1

replace hmb_mp = hmb_mp_new

*Tidy up
drop hmb_max mp_max hmb_mp_new

isid cidB4396 age
drop wave

reshape wide hmb mp hmb_mp, i(cidB4396) j(age)
 distinct cidB4396 //10,829
 
* Rename combined outcome
foreach v of varlist hmb_mp* {
    local num = substr("`v'",7,.)
    rename `v' hmb_mp_age`num'
}

* Rename HMB variables
foreach v of varlist hmb* {
    if strpos("`v'","hmb_mp")==0 & strpos("`v'","hmb_age")==0 {
        local num = substr("`v'",4,.)
        rename `v' hmb_age`num'
    }
}

* Rename MP variables
foreach v of varlist mp* {
    if strpos("`v'","mp_age")==0 {
        local num = substr("`v'",3,.)
        rename `v' mp_age`num'
    }
}

//Removing ages 18 and 19
drop hmb_age18 hmb_age19 mp_age18 mp_age19 hmb_mp_age18 hmb_mp_age19 

//Grouping 56+, anyone reported once will be counted
egen hmb_age56plus = rowfirst(hmb_age56 hmb_age57 hmb_age58 hmb_age59 hmb_age60 hmb_age61 hmb_age62 hmb_age63 hmb_age64 hmb_age65 hmb_age66)

egen mp_age56plus = rowfirst(mp_age56 mp_age57 mp_age58 mp_age59 mp_age60 mp_age61 mp_age62 mp_age63 mp_age64 mp_age65 mp_age66)

egen hmb_mp_age56plus = rowfirst(hmb_mp_age56 hmb_mp_age57 hmb_mp_age58 hmb_mp_age59 hmb_mp_age60 hmb_mp_age61 hmb_mp_age62 hmb_mp_age63 hmb_mp_age64 hmb_mp_age65 hmb_mp_age66)

drop hmb_age56 hmb_age57 hmb_age58 hmb_age59 hmb_age60 hmb_age61 hmb_age62 hmb_age63 hmb_age64 hmb_age65 hmb_age66
drop mp_age56 mp_age57 mp_age58 mp_age59 mp_age60 mp_age61 mp_age62 mp_age63 mp_age64 mp_age65 mp_age66
drop hmb_mp_age56 hmb_mp_age57 hmb_mp_age58 hmb_mp_age59 hmb_mp_age60 hmb_mp_age61 hmb_mp_age62 hmb_mp_age63 hmb_mp_age64 hmb_mp_age65 hmb_mp_age66

rename hmb_age56plus hmb_age56
rename mp_age56plus mp_age56
rename hmb_mp_age56plus hmb_mp_age56


***************************************
***SES HARMONISATION***
***************************************

//Ethnicity
ta c800
gen ethnicity_harmonised = .
replace ethnicity_harmonised = 1 if c800 == 1   // White
replace ethnicity_harmonised = 2 if inrange(c800,2,9)   // Non-white
replace ethnicity_harmonised = . if c804 == -1  // Missing
label define eth_alspac 1 "White" 2 "Non-white"
label values ethnicity_harmonised eth_alspac
label variable ethnicity_harmonised "Harmonised ethnicity (ALSPAC, binary)"
tab ethnicity_harmonised


//Education
*Mother's Education
gen edu_mother_harmonised = .
replace edu_mother_harmonised = 1 if inrange(c686a, 1, 2)  // Low: CSE/vocational
replace edu_mother_harmonised = 2 if inrange(c686a, 3, 4)  // Middle: O/A level
replace edu_mother_harmonised = 3 if c686a == 5            // High: degree+
label define ses 1 "Low" 2 "Middle" 3 "High"
label values edu_mother_harmonised ses
label variable edu_mother_harmonised "Harmonised mother's education (ALSPAC)"
tab edu_mother_harmonised

*Father's Education
gen edu_father_harmonised = .
replace edu_father_harmonised = 1 if inrange(c706a, 1, 2)  // Low
replace edu_father_harmonised = 2 if inrange(c706a, 3, 4)  // Middle
replace edu_father_harmonised = 3 if c706a == 5            // High
label values edu_father_harmonised ses
label variable edu_father_harmonised "Harmonised father's education (ALSPAC)"
tab edu_father_harmonised


//Mother's occupation
gen occ_mother_harmonised = .
replace occ_mother_harmonised = 1 if inrange(c_sc_mgm, 1, 2)  // High: I+II
replace occ_mother_harmonised = 2 if inrange(c_sc_mgm, 3, 4)         // Middle: III
replace occ_mother_harmonised = 3 if inrange(c_sc_mgm, 5, 6)  // Low: IV+V
label define occ_h 1 "High (I+II)" 2 "Middle (III)" 3 "Low (IV+V)"
label values occ_mother_harmonised occ_h
label variable occ_mother_harmonised "Harmonised mother's occupation"
tab occ_mother_harmonised

//Father's occupation
gen occ_father_harmonised = .
replace occ_father_harmonised = 1 if inrange(c_sc_mgf, 1, 2)  // High: I+II
replace occ_father_harmonised = 2 if inrange(c_sc_mgf, 3, 4)         // Middle: III
replace occ_father_harmonised = 3 if inrange(c_sc_mgf, 5, 6)  // Low: IV+V
label values occ_father_harmonised occ_h
label variable occ_father_harmonised "Harmonised father's occupation"
tab occ_father_harmonised
