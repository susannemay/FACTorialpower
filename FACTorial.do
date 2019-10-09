**************************************************************************
*
* program to simulate binary outcome data and analyze with GEE, GLM and linear regression robust SE
*
* Author: Susanne May
* Date: 07/05/2019
*
*
* this program requires input parameters, which need to be supplied
*
* These input parameters are: 
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
/*
*** for singlerun
  local nperp=20
  local na=5
  local add=1

  local betaigel=0.038
  local betarate=0.02
  
  local betab120=0.13
  local betab110=0.15
  local betab100=0.17

  local betai120=0.168
  local betai110=0.188
  local betai100=0.208
  
  local sigma1=0.03 
  
  local seed=389201
  local reps=1
*  local no=01
  
  set more off
  set seed `seed'

*** end for singlerun
*/
clear

capture log close
*** for single run use next line
*capture log using sims_onerun.log, replace

*** comment out next few lines for single run
capture program drop simula
program define simula, rclass

        version 16.0
        
        *----------------
        syntax [, nperp(integer 1) na(integer 1) add(integer 1) betaigel (real 1) betarate(real 1) betab120(real 1) betab110(real 1) betab100(real 1) ///
                betai120(real 1) betai110(real 1) betai100(real 1) sigma1(real 1) seed(integer 1) ]
        *----------------
        drop _all
        
        display "nperp="`nperp' "  na=" `na' "  add=="`add' "  betaigel=" `betaigel' "  betarate=" `betarate'
        display "betab120=" `betab120' "  betab110=" `betab110' "  betab100=" `betab100' 
        display "betai120=" `betai120' "  betai110=" `betai110' "  betai100=" `betai100' 
        display "sigma1=" `sigma1' "  seed=" `seed'
        
        * create counter for potentially looking at individual simulated data sets
        use one
        local nummerin=nummer[1]
        local nummerout=`nummerin'+1
        replace nummer=`nummerout' in 1
        save,replace
        clear

        local nn=`na'*`nperp'*6
        * assumes 6 periods for each agency
        
        
        * create a separate files with period treatment assignments (rate 100, 110 or 120 and BVM or igel)
        use igelrate288
        gen uni=uniform()
        sort uni
        keep ix1 ix2 ix3 ix4 ix5 ix6
        drop if _n>`na'
        gen agas=_n
        reshape long ix, i(agas) j(noj)
        expand `nperp'
        sort agas noj
        gen no=_n
        save tempassignment, replace
        clear
                
        * create data set with simulated outcome data by treatment assignment
        set obs `na'
        gen int agency=_n
        expand 6
        sort agency
        gen int period=_n
        expand `nperp'
        sort agency period
        gen int no=_n
        count
                
        
        merge 1:1 no using tempassignment
        gen rate=floor(ix/10)
        gen igel=mod(ix,10)
        
        sort agency no
        
        by agency: gen first_ag=(_n==1)
        
        gen double randb=.
        replace randb=rnormal(0,`sigma1') if first_ag==1
        * same random effect (intercept) within agency) 
        by agency: replace randb=randb[1]                    
        
        gen yorig=.
        replace yorig=randb+`betab120'                              if rate==120 & igel==0
        replace yorig=randb+`betab120'+`betaigel'                   if rate==120 & igel==1

        replace yorig=randb+`add'*(`betab120'+`betarate')+(1-`add')*(`betab110') if rate==110 & igel==0
        replace yorig=randb+`add'*(`betab120'+`betarate'+`betaigel')+(1-`add')*(`betai110') if rate==110 & igel==1

        replace yorig=randb+`add'*(`betab120'+2*`betarate')+(1-`add')*(`betab100') if rate==100 & igel==0
        replace yorig=randb+`add'*(`betab120'+2*`betarate'+`betaigel')+(1-`add')*(`betai100') if rate==100 & igel==1

        gen outcome=rbinomial(1,yorig)
        
        gen rate100=(rate==100)
        gen rate110=(rate==110)
        

        save temp, replace
        
        **** end of generating data

        *** begin analyzing data

        count
        local totaln=r(N)
        sum outcome if rate==120 & igel==0
        local mean120b=r(mean)
        local sd120b=r(sd)
        
        sum outcome if rate==110 & igel==0
        local mean110b=r(mean)
        local sd110b=r(sd)
        
        sum outcome if rate==100 & igel==0
        local mean100b=r(mean)
        local sd100b=r(sd)
        
        sum outcome if rate==120 & igel==1
        local mean120i=r(mean)
        local sd120i=r(sd)
        
        sum outcome if rate==110 & igel==1
        local mean110i=r(mean)
        local sd110i=r(sd)
        
        sum outcome if rate==100 & igel==1
        local mean100i=r(mean)
        local sd100i=r(sd)
        
        sum outcome if igel==0
        local meanb=r(mean)
        local sdb=r(sd)
        
        sum outcome if igel==1
        local meani=r(mean)
        local sdi=r(sd)
        
        sum outcome if rate==100
        local mean100=r(mean)
        local sd100=r(sd)
        
        sum outcome if rate==110
        local mean110=r(mean)
        local sd110=r(sd)
        
        sum outcome if rate==120
        local mean120=r(mean)
        local sd120=r(sd)
        
       
        
        glm outcome igel rate100 rate110, family(binomial) link(identity) cluster(agency)
        local glmbinb0=_b[_cons]
        local glmbinbigel=_b[igel]
        local glmbinb100=_b[rate100]
        local glmbinb110=_b[rate110]
        test igel 
        local glmbinbigelp=r(p)
        test rate100
        local glmbinb100p=r(p)
        test rate110
        local glmbinb110p=r(p)
        test rate100 rate110
        local glmbinb100110p=r(p)
        
        local glmbinbigelp05=(`glmbinbigelp'<=0.05)
        local glmbinb100p05=(`glmbinb100p'<=0.05)
        local glmbinb110p05=(`glmbinb110p'<=0.05)
        local glmbinb100110p05=(`glmbinb100110p'<=0.05)
        
        *** note: don't use the mixed outcomes as some runs might not have converged
        *** but to enable that others run maximum iteration was set to 20
        mixed outcome igel rate100 rate110 || agency: , vce(robust) cov(exch) iterate(20)
        local mixb0=_b[_cons]
        local mixbigel=_b[igel]
        local mixb100=_b[rate100]
        local mixb110=_b[rate110]
        test igel 
        local mixbigelp=r(p)
        test rate100
        local mixb100p=r(p)
        test rate110
        local mixb110p=r(p)
        test rate100 rate110
        local mixb100110p=r(p)
        
        local mixbigelp05=(`mixbigelp'<=0.05)
        local mixb100p05=(`mixb100p'<=0.05)
        local mixb110p05=(`mixb110p'<=0.05)
        local mixb100110p05=(`mixb100110p'<=0.05)
        display `mixb100110p05'
        
        
        xtgee outcome igel rate100 rate110, family(binomial) link(identity) i(agency) 
        local geebinb0=_b[_cons]
        local geebinbigel=_b[igel]
        local geebinb100=_b[rate100]
        local geebinb110=_b[rate110]
        test igel 
        local geebinbigelp=r(p)
        test rate100
        local geebinb100p=r(p)
        test rate110
        local geebinb110p=r(p)
        test rate100 rate110
        local geebinb100110p=r(p)
        display `geebinb100110p05'
        
        local geebinbigelp05=(`geebinbigelp'<=0.05)
        local geebinb100p05=(`geebinb100p'<=0.05)
        local geebinb110p05=(`geebinb110p'<=0.05)
        local geebinb100110p05=(`geebinb100110p'<=0.05)

        
        xtgee outcome igel rate100 rate110, i(agency) corr(exch) robust
        local geelinb0=_b[_cons]
        local geelinbigel=_b[igel]
        local geelinb100=_b[rate100]
        local geelinb110=_b[rate110]
        test igel 
        local geelinbigelp=r(p)
        test rate100
        local geelinb100p=r(p)
        test rate110
        local geelinb110p=r(p)
        test rate100 rate110
        local geelinb100110p=r(p)
        display `geelinb100110p05'
        
        local geelinbigelp05=(`geelinbigelp'<=0.05)
        local geelinb100p05=(`geelinb100p'<=0.05)
        local geelinb110p05=(`geelinb110p'<=0.05)
        local geelinb100110p05=(`geelinb100110p'<=0.05)


        regress outcome igel rate100 rate110, robust
        local regb0=_b[_cons]
        local regbigel=_b[igel]
        local regb100=_b[rate100]
        local regb110=_b[rate110]
        test igel 
        local regbigelp=r(p)
        test rate100
        local regb100p=r(p)
        test rate110
        local regb110p=r(p)
        test rate100 rate110
        local regb100110p=r(p)
        display `regb100110p05'
        
        local regbigelp05=(`regbigelp'<=0.05)
        local regb100p05=(`regb100p'<=0.05)
        local regb110p05=(`regb110p'<=0.05)
        local regb100110p05=(`regb100110p'<=0.05)



        xtlogit outcome igel rate100 rate110, i(agency) re or
        local logitb0=_b[_cons]
        local logitbigel=_b[igel]
        local logitb100=_b[rate100]
        local logitb110=_b[rate110]
        test igel 
        local logitbigelp=r(p)
        test rate100
        local logitb100p=r(p)
        test rate110
        local logitb110p=r(p)
        test rate100 rate110
        local logitb100110p=r(p)
        display `logitb100110p05'
        
        local logitbigelp05=(`logitbigelp'<=0.05)
        local logitb100p05=(`logitb100p'<=0.05)
        local logitb110p05=(`logitb110p'<=0.05)
        local logitb100110p05=(`logitb100110p'<=0.05)
        
        local glmmixigeldiff=`glmbinbigel'-`mixbigel'
        local glmgeebinigeldiff=`glmbinbigel'-`geebinbigel'
        local glmmgeelinigeldiff=`glmbinbigel'-`geelinbigel'
        local glmregigeldiff=`glmbinbigel'-`regbigel'

*       *** for testing
*        if `nummerin'==44 {
*         capture save data`nummerin', replace
*        }
       
        return scalar totaln=`totaln'
        return scalar mean120b=`mean120b'
        return scalar sd120b=`sd120b'
        return scalar mean110b=`mean110b'
        return scalar sd110b=`sd110b'
        return scalar mean100b=`mean100b'
        return scalar sd100b=`sd100b'
        return scalar mean120i=`mean120i'
        return scalar sd120i=`sd120i'
        return scalar mean110i=`mean110i'
        return scalar sd110i=`sd110i'
        return scalar mean100i=`mean100i'
        return scalar sd100i=`sd100i'
        return scalar meanb=`meanb'
        return scalar meani=`meani'
        return scalar mean100=`mean100'
        return scalar mean110=`mean110'
        return scalar mean120=`mean120'
        return scalar glmbinb0=`glmbinb0'
        return scalar glmbinbigel=`glmbinbigel'
        return scalar glmbinb100=`glmbinb100'
        return scalar glmbinb110=`glmbinb110'
        return scalar glmbinbigelp=`glmbinbigelp'
        return scalar glmbinb100p=`glmbinb100p'
        return scalar glmbinb110p=`glmbinb110p'
        return scalar glmbinb100110p=`glmbinb100110p'
        return scalar glmbinbigelp05=`glmbinbigelp05'
        return scalar glmbinb100p05=`glmbinb100p05'
        return scalar glmbinb110p05=`glmbinb110p05'
        return scalar glmbinb100110p05=`glmbinb100110p05'
        return scalar mixb0=`mixb0'
        return scalar mixbigel=`mixbigel'
        return scalar mixb100=`mixb100'
        return scalar mixb110=`mixb110'
        return scalar mixbigelp=`mixbigelp'
        return scalar mixb100p=`mixb100p'
        return scalar mixb110p=`mixb110p'
        return scalar mixb100110p=`mixb100110p'
        return scalar mixbigelp05=`mixbigelp05'
        return scalar mixb100p05=`mixb100p05'
        return scalar mixb110p05=`mixb110p05'
        return scalar mixb100110p05=`mixb100110p05'
        return scalar geebinb0=`geebinb0'
        return scalar geebinbigel=`geebinbigel'
        return scalar geebinb100=`geebinb100'
        return scalar geebinb110=`geebinb110'
        return scalar geebinbigelp=`geebinbigelp'
        return scalar geebinb100p=`geebinb100p'
        return scalar geebinb110p=`geebinb110p'
        return scalar geebinb100110p=`geebinb100110p'
        return scalar geebinbigelp05=`geebinbigelp05'
        return scalar geebinb100p05=`geebinb100p05'
        return scalar geebinb110p05=`geebinb110p05'
        return scalar geebinb100110p05=`geebinb100110p05'
        return scalar geelinb0=`geelinb0'
        return scalar geelinbigel=`geelinbigel'
        return scalar geelinb100=`geelinb100'
        return scalar geelinb110=`geelinb110'
        return scalar geelinbigelp=`geelinbigelp'
        return scalar geelinb100p=`geelinb100p'
        return scalar geelinb110p=`geelinb110p'
        return scalar geelinb100110p=`geelinb100110p'
        return scalar geelinbigelp05=`geelinbigelp05'
        return scalar geelinb100p05=`geelinb100p05'
        return scalar geelinb110p05=`geelinb110p05'
        return scalar geelinb100110p05=`geelinb100110p05'
        return scalar regb0=`regb0'
        return scalar regbigel=`regbigel'
        return scalar regb100=`regb100'
        return scalar regb110=`regb110'
        return scalar regbigelp=`regbigelp'
        return scalar regb100p=`regb100p'
        return scalar regb110p=`regb110p'
        return scalar regb100110p=`regb100110p'
        return scalar regbigelp05=`regbigelp05'
        return scalar regb100p05=`regb100p05'
        return scalar regb110p05=`regb110p05'
        return scalar regb100110p05=`regb100110p05'
        return scalar logitb0=`logitb0'
        return scalar logitbigel=`logitbigel'
        return scalar logitb100=`logitb100'
        return scalar logitb110=`logitb110'
        return scalar logitbigelp=`logitbigelp'
        return scalar logitb100p=`logitb100p'
        return scalar logitb110p=`logitb110p'
        return scalar logitb100110p=`logitb100110p'
        return scalar logitbigelp05=`logitbigelp05'
        return scalar logitb100p05=`logitb100p05'
        return scalar logitb110p05=`logitb110p05'
        return scalar logitb100110p05=`logitb100110p05'

        return scalar glmmixigeldiff=`glmmixigeldiff'
        return scalar glmgeebinigeldiff=`glmgeebinigeldiff'
        return scalar glmmgeelinigeldiff=`glmmgeelinigeldiff'
        return scalar glmregigeldiff=`glmregigeldiff'
        


    end        

* see FACTorialshell for how this program is called

