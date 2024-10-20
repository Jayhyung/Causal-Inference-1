* selection example

clear
capture log close

set seed 1500
set obs 10000

gen y0 = rnormal(3,3) // y0 will have a mean of 5 and std dev. of 2

gen y1 = rnormal(3,3) // y1 will have a mean of 3 and a std dev of 3

gen delta = y1-y0

su delta
gen ate=`r(mean)'
su

* Selection on y0. If a person's y0 is above 6.3, they get treated

gen d=(y0>=6.3) // treatment assignment mechanism based on y0

su delta if d==1 // ATT
gen att = `r(mean)'

su delta if d==0 // ATU
gen atu = `r(mean)'

su y0 if d==1 // E[Y0|D=1]
gen ey01 = `r(mean)'
su ey01

su y0 if d==0 // E[Y0|D=0]
gen ey00 = `r(mean)'
su ey00

gen selection_bias = ey01 - ey00
su ey01 ey00 selection_bias

su d
gen pi = `r(mean)'

gen y=d*y1 + (1-d)*y0 // switching equation which selects one of the potential outcomes based on d

gen sdo  = ate + selection_bias + (1-pi)*(att-atu)

reg y d

gen bias = sdo-ate
su ate sdo bias

drop d att atu sdo ey00 ey01 pi selection_bias y bias

* Selection on y1.  If a person's y1 is above 1, they get treated

gen d = (y1>=1) // treatment assignment mechanism based on y1 (and a threshold value)

su delta if d==1 // ATT
gen att = `r(mean)'

su delta if d==0 // ATU
gen atu = `r(mean)'

su y0 if d==1 // E[Y0|D=1]
gen ey01 = `r(mean)'
su ey01

su y0 if d==0 // E[Y0|D=0]
gen ey00 = `r(mean)'
su ey00

gen selection_bias = ey01 - ey00
su ey01 ey00 selection_bias

su d
gen pi = `r(mean)'

gen y=d*y1 + (1-d)*y0 // switching equation which selects one of the potential outcomes based on d

gen sdo  = ate + selection_bias + (1-pi)*(att-atu)

reg y d // same thing as sdo -> -1.98

gen bias = sdo-ate
su ate sdo bias

drop d att atu sdo ey00 ey01 pi selection_bias y bias


* Selection on gains. Gain is y1-y0. So if treatment effects are positive, they'll get treated

gen d = (delta>0)

su delta if d==1 // ATT
gen att = `r(mean)'

su delta if d==0 // ATU
gen atu = `r(mean)'

su y0 if d==1 // E[Y0|D=1]
gen ey01 = `r(mean)'
su ey01

su y0 if d==0 // E[Y0|D=0]
gen ey00 = `r(mean)'
su ey00

gen selection_bias = ey01 - ey00
su ey01 ey00 selection_bias

su d
gen pi = `r(mean)'

gen y=d*y1 + (1-d)*y0 // switching equation which selects one of the potential outcomes based on d

gen sdo  = ate + selection_bias + (1-pi)*(att-atu)

reg y d

gen bias = sdo-ate
su ate sdo bias

drop d att atu sdo ey00 ey01 pi selection_bias y bias


* What about independence?  (y0,y1) _||_ d . How do I draw this? This IMPLIES that:

/*
If y0 is independent of d, then:

E[Y0|D=1] = E[Y0|D=0]

And if y1 is independent of d, then:

E[Y1|D=1] = E[Y1|D=0]

Independence implies in the large sample (i.e., the population) that the variables are uncorrelated and have the same distribution

*/



gen error=runiform(0,1)
gen d = (error>=0.2)

su delta if d==1 // ATT
gen att = `r(mean)'

su delta if d==0 // ATU
gen atu = `r(mean)'

su y0 if d==1 // E[Y0|D=1]
gen ey01 = `r(mean)'
su ey01

su y0 if d==0 // E[Y0|D=0]
gen ey00 = `r(mean)'
su ey00

gen selection_bias = ey01 - ey00
su ey01 ey00 selection_bias

su d
gen pi = `r(mean)'

gen y=d*y1 + (1-d)*y0 // switching equation which selects one of the potential outcomes based on d

gen sdo  = ate + selection_bias + (1-pi)*(att-atu)

reg y d

gen bias = sdo-ate
su ate sdo bias

drop d att atu sdo ey00 ey01 pi selection_bias y bias


 
