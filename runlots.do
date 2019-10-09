* call FACTorialshell multiple times (which calls FACTorial.do) and requires input parameters
*
*        1 = nperp number of observations per period (we assume 6 periods for each agency)
*            e.g. with 28 agencies, 6 periods and 25 observations per period the total is 4200
*        2 = na number of agencies
*        3 = add indicator for additive effect (1 yes, 0 no) 
*        4 = betaigel effect if igel if additive
*        5 = betarate effect of compression rate if additive
*        6 = betab120 background rate for anticipated lowest survival group (referent)
*        7 = betab110 survival rate for BVM with rate 110 if not additive
*        8 = betab100 survival rate for BVM with rate 100 if not additive
*        9 = betai120 survival rate for igel with rate 120 if not additive
*       10 = betai110 survival rate for igel with rate 110 if not additive
*       11 = betai100 survival rate for igel with rate 100 if not additive
*       12 = sigma1 variance for normally distributed random effect of cluster / agency
*       13 = random number seed
*       14 = number of replications 
*
*       . do FACTorial 25 28 1 0.038 0.02 0.13 0.15 0.17 0.168 0.188 0.208 0.03 539083 10000
*

capture log close
log using runlots.log, replace

* do FACTorialshell 25 28 1 0.030 0.025 0.13 0.15 0.17 0.168 0.188 0.208 0.02 339985 1000

* do FACTorialshell 25 28 1 0.0325 0.024 0.13 0.15 0.17 0.168 0.188 0.208 0.02 3999067 1000

*do FACTorialshell 25 28 1 0.033 0.021 0.13 0.15 0.17 0.168 0.188 0.208 0.02 1098266 1000

*do FACTorialshell 25 28 1 0.033 0.022 0.13 0.15 0.17 0.168 0.188 0.208 0.02 3900674 1000

*do FACTorialshell 25 28 1 0.0325 0.023 0.13 0.15 0.17 0.168 0.188 0.208 0.02 5522551 1000

*do FACTorialshell 25 28 1 0.034 0.022 0.13 0.15 0.17 0.168 0.188 0.208 0.02 3647508 1000

*do FACTorialshell 25 28 1 0.035 0.023 0.13 0.15 0.17 0.168 0.188 0.208 0.02 115462 1000

*do FACTorialshell 25 28 1 0.035 0.024 0.127 0.151 0.175 0.168 0.188 0.208 0.02 663091 1000

do FACTorialshell 25 28 1 0.036 0.025 0.126 0.151 0.175 0.168 0.188 0.208 0.02 488765 1000

do FACTorialshell 25 28 1 0.037 0.026 0.125 0.151 0.175 0.168 0.188 0.208 0.02 334001 1000


log close
