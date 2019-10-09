
**************************************************************************
*
* Program to try out power and sample size for FACT project
*
* this is the "shell" program for FACTorial.do 
*
*
* Author: Susanne May
* Date: 07/05/2019 
*
*
* this program requires input parameters, NOTE input parameter do not seem to work, directly code the values instead
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
* run this file once as 
*  
*    do FACTorial
*
* before running runlots.do
*
**************************************************************************

    display "Simulation started  $S_DATE   $S_TIME"
    
    clear
    use one
    replace nummer=1 in 1
    save,replace
    clear

    simulate     totaln=r(totaln)  ///
         mean120b=r(mean120b) ///
         sd120b=r(sd120b) ///
         mean110b=r(mean110b) ///
         sd110b=r(sd110b) ///
         mean100b=r(mean100b) ///
         sd100b=r(sd100b) ///
         mean120i=r(mean120i) ///
         sd120i=r(sd120i) ///
         mean110i=r(mean110i) ///
         sd110i=r(sd110i) ///
         mean100i=r(mean100i) ///
         sd100i=r(sd100i) ///
         meanb=r(meanb) ///
         meani=r(meani) ///
         mean100=r(mean100) ///
         mean110=r(mean110) ///
         mean120=r(mean120) ///
         glmbinb0=r(glmbinb0) ///
         glmbinbigel=r(glmbinbigel) ///
         glmbinb100=r(glmbinb100) ///
         glmbinb110=r(glmbinb110) ///
         glmbinbigelp=r(glmbinbigelp) ///
         glmbinb100p=r(glmbinb100p) ///
         glmbinb110p=r(glmbinb110p) ///
         glmbinb100110p=r(glmbinb100110p) ///
         glmbinbigelp05=r(glmbinbigelp05) ///
         glmbinb100p05=r(glmbinb100p05) ///
         glmbinb110p05=r(glmbinb110p05) ///
         glmbinb100110p05=r(glmbinb100110p05) ///
         mixb0=r(mixb0) ///
         mixbigel=r(mixbigel) ///
         mixb100=r(mixb100) ///
         mixb110=r(mixb110) ///
         mixbigelp=r(mixbigelp) ///
         mixb100p=r(mixb100p) ///
         mixb110p=r(mixb110p) ///
         mixb100110p=r(mixb100110p) ///
         mixbigelp05=r(mixbigelp05) ///
         mixb100p05=r(mixb100p05) ///
         mixb110p05=r(mixb110p05) ///
         mixb100110p05=r(mixb100110p05) ///
         geebinb0=r(geebinb0) ///
         geebinbigel=r(geebinbigel) ///
         geebinb100=r(geebinb100) ///
         geebinb110=r(geebinb110) ///
         geebinbigelp=r(geebinbigelp) ///
         geebinb100p=r(geebinb100p) ///
         geebinb110p=r(geebinb110p) ///
         geebinb100110p=r(geebinb100110p) ///
         geebinbigelp05=r(geebinbigelp05) ///
         geebinb100p05=r(geebinb100p05) ///
         geebinb110p05=r(geebinb110p05) ///
         geebinb100110p05=r(geebinb100110p05) ///
         geelinb0=r(geelinb0) ///
         geelinbigel=r(geelinbigel) ///
         geelinb100=r(geelinb100) ///
         geelinb110=r(geelinb110) ///
         geelinbigelp=r(geelinbigelp) ///
         geelinb100p=r(geelinb100p) ///
         geelinb110p=r(geelinb110p) ///
         geelinb100110p=r(geelinb100110p) ///
         geelinbigelp05=r(geelinbigelp05) ///
         geelinb100p05=r(geelinb100p05) ///
         geelinb110p05=r(geelinb110p05) ///
         geelinb100110p05=r(geelinb100110p05) ///
         regb0=r(regb0) ///
         regbigel=r(regbigel) ///
         regb100=r(regb100) ///
         regb110=r(regb110) ///
         regbigelp=r(regbigelp) ///
         regb100p=r(regb100p) ///
         regb110p=r(regb110p) ///
         regb100110p=r(regb100110p) ///
         regbigelp05=r(regbigelp05) ///
         regb100p05=r(regb100p05) ///
         regb110p05=r(regb110p05) ///
         regb100110p05=r(regb100110p05) ///
         logitb0=r(logitb0) ///
         logitbigel=r(logitbigel) ///
         logitb100=r(logitb100) ///
         logitb110=r(logitb110) ///
         logitbigelp=r(logitbigelp) ///
         logitb100p=r(logitb100p) ///
         logitb110p=r(logitb110p) ///
         logitb100110p=r(logitb100110p) ///
         logitbigelp05=r(logitbigelp05) ///
         logitb100p05=r(logitb100p05) ///
         logitb110p05=r(logitb110p05) ///
         logitb100110p05=r(logitb100110p05) ///
         glmmixigeldiff=r(glmmixigeldiff) ///
         glmgeebinigeldiff=r(glmgeebinigeldiff) ///
         glmmgeelinigeldiff=r(glmmgeelinigeldiff) ///
         glmregigeldiff=r(glmregigeldiff) ///
	    , reps(`14'): simula, nperp(`1') na(`2') add(`3') betaigel(`4') betarate(`5') ///
            betab120(`6') betab110(`7') betab100(`8')  betai120(`9') betai110(`10') betai100(`11') sigma1(`12')  ///
            seed(`13')

***
    display "Program was run as: do FACTorialshell `*'"
    display "with arguments: nperp na add betaigel betarate betab120 beatb110 betab100 beai120 betai110 betai100 sigma1 seed"
    sum totaln mean120b mean110b mean100b mean120i mean110i mean100i  sd120b sd110b sd100b sd120i sd110i sd100i
    sum glmbinb0-glmbinb100110p05
    sum mixb0-mixb100110p05
    sum geebinb0-geebinb100110p05
    sum geelinb0-geelinb100110p05
    sum regb0-regb100110p05
    sum logitb0-logitb100110p05
    sum glmmixigeldiff-glmregigeldiff
    sum glmbinbigel mixbigel geebinbigel geelinbigel regbigel
    sum meanb meani mean100 mean110 mean120
    sum glmbinb100110p05 mixb100110p05 geebinb100110p05 geelinb100110p05 regb100110p05 logitb100110p05
    sum glmbinbigelp05 mixbigelp05 geebinbigelp05 geelinbigelp05 regbigelp05 logitbigelp05
    
    capture save results.dta, replace

    display "Simulation ended  $S_DATE   $S_TIME"
    
    



