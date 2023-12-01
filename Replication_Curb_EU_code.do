/* replication files for Curb EU Enthusiasm: 
*/


*cd "DIR"  /* adjust the WD as needed*/

cd "DIR\CurbEU\Data\Short"

use "Curb_EU_dt_short_raw.dta", clear  /*loaad the data*/

** set plotting scheme
set scheme plotplain  


* Descriptive statistics


  estpost tabstat NEW_LR_Proposal_Probability support_ms_mean  ///
				sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict ///
				competence_length  nofterms_in_eurovoc , c(stat) stat( mean sd min max n)

  esttab using "descriptive_short.tex", replace ///
 cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count(fmt(%6.0fc))") nonumber ///
  nomtitle nonote noobs label booktabs ///
  collabels("Mean" "SD" "Min" "Max" "N")

  eststo clear

estpost corr NEW_LR_Proposal_Probability support_ms_mean  ///
				sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict ///
				competence_length  nofterms_in_eurovoc , matrix listwise 

esttab using "correlations.tex",  unstack not noobs nostar compress replace 



**************************************
**** MAIN text analysis **************
**************************************

* Model 1 - no interation effect
eststo m1: fracreg logit NEW_LR_Proposal_Probability c.support_ms_mean  ///
				sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict ///
				competence_length  nofterms_in_eurovoc

margins, dydx(support_ms_mean)

 ******Main: AME plot for main text ****
margins, at(support_ms_mean=(27(10)97)) plot(recast(line) level(95) ///
	recastci(rarea) ciopts(fcolor(%30) lwidth(vvvthin) lpattern(tight_dot))  ///
	ytitle(Pred. Pr. of EU authority expansion) ///
	ytitle(, size(medsmall)) xtitle("% Public Support (t-2)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") ///
	 addplot(hist support_ms_mean if e(sample), xlabel(27(10)97) freq bfcolor(none) blcolor(gs10)  ///
			 yaxis(2) yscale(alt axis(2)) below legend(off)) saving(file3, replace)  ///
			 legend(off ) )
graph export "H1_short_raw.png", as(png) replace	
	
		
	
				
* Model 2 -- interaction with Salience
eststo m2: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc			
 
 ******Main: AME plot for main text ****
margins , dydx(support_ms_mean)  at(sal_ms_mean =(38 (10)98))  ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(95) ///
	ytitle("Marginal effect of public" "support on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
	xtitle("%Salience (t-1)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0) ///
	addplot(hist sal_ms_mean if e(sample), xlabel(38(10)98) freq bfcolor(none) blcolor(gs10)  ///
			 yaxis(2) yscale(alt axis(2)) below legend(off)) saving(file3, replace)  ///
			 legend(off )) 		 	
graph export "H2_AME_short_raw.png", as(png) replace	

 
  **** Appendix: Plot by level to include into new appedix with extra info on short data analysis ****
margins , at( support_ms_mean =(27(10)97) sal_ms_mean =(50, 70, 90))    level(95) 
marginsplot, by(sal_ms_mean) recast(line) plotopts(lwidth(vthin)) byopts(rows(1) )  level(95) ///
		 recastci(rarea) ciopts(fcolor(%20)  lcolor(none) lwidth(none)  xsize(10) ysize(4) ///
		  lpattern(dot)) xtitle("% Public Support (t-2)")  ytitle("Pred. Pr. of EU authority expansion")
graph export "H2_appendix_short_raw.png", as(png) replace	

		
		
		
*Model 3 -- interaction with polarization	
eststo m3: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.pol_ms_mean ///
				c.sal_ms_mean ///
				mob_ms_count ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc i.form_num

margins , dydx(support_ms_mean)  at(pol_ms_mean =( 0 (.01)  1))



				
 **** Main: AME plot for the main text ****
margins , dydx(support_ms_mean)  at(pol_ms_mean =( 0.08 (.1)  .88))  ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(95) ///
	ytitle("Marginal effect of public" "support on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
	xtitle("Public Polarization (t-1)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0) ///
	addplot(hist pol_ms_mean if e(sample), xlabel(0.08 (.1)  .88) freq bfcolor(none) blcolor(gs10)  ///
			 yaxis(2) yscale(alt axis(2)) below legend(off)) saving(file3, replace)  ///
			 legend(off )) 	 		
graph export "H3_AME_short_raw.png", as(png) replace								

 **** Appendix: Plot by level to include into new appedix with extra info on short data analysis ****
margins , at( support_ms_mean =(27(10)97) pol_ms_mean =(0.2, .5, .8))    level(95)
marginsplot, by(pol_ms_mean) recast(line) plotopts(lwidth(vthin)) byopts(rows(1) )  level(95) ///
		 recastci(rarea) ciopts(fcolor(%20)  lcolor(none) lwidth(none)  xsize(10) ysize(4) ///
		  lpattern(dot)) xtitle("% Public Support (t-2)" , size(large)) ///
		  ytitle("Pred. Pr. of EU authority expansion" , size(large) )  
graph export "H3_appendix_short_raw.png", as(png) replace	
																		
	
	
	
** Model 4 -- interaction with mobilization
eststo m4: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.mob_ms_count ///
				c.pol_ms_mean ///
				c.sal_ms_mean ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc

margins , dydx(support_ms_mean)  at(mob_ms_count = 0 )
margins , dydx(support_ms_mean)  at(mob_ms_count = 20 )



 **** Main --  AME plot to include into the main text ****
margins , dydx(support_ms_mean)  at(mob_ms_count =( 0 (2)  20)) level(95) ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(95) ///
	ytitle("Marginal effect of public" "support on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
	xtitle("Actor Mobilization (t-1)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0) ///
	addplot(hist mob_ms_count if e(sample), xlabel(0 (2) 20) freq bfcolor(none) blcolor(gs10)  ///
			 yaxis(2) yscale(alt axis(2)) below legend(off)) saving(file3, replace)  ///
			 legend(off )) 
graph export "H4_AME_short_raw.png", as(png) replace	


 **** Appendix: Plot by level to include into new appedix with extra info on short data analysis ****				
margins , at( support_ms_mean =(0(1)100) mob_ms_count =( 0 , 10, 20)) 		
marginsplot, by(mob_ms_count) recast(line) plotopts(lwidth(vthin)) byopts(rows(1) )  level(95) ///
		 recastci(rarea) ciopts(fcolor(%20)  lcolor(none) lwidth(none)  xsize(10) ysize(4) ///
		  lpattern(dot)) xtitle("% Public Support (t-2)" , size(large)) ///
		  ytitle("Pred. Pr. of EU authority expansion" , size(large) )  		
graph export "H4_appendix_short_raw.png", as(png) replace	

														
* export model in stata and eyeball
 estout m1 m2  m3 m4, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels
	
esttab m1 m2  m3 m4 using "regression1_main.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
 

 
 
 ************************************************************************************
 ************************************************************************************
 ************************************************************************************
 *********************
 *** Robustness checks for Appendices
  *********************
*************************************************************************************
 ************************************************************************************
 
 
 
***1)  Appendix 2.1 
*Retesting the models using the indicator for all mobilized actors

 eststo m1: fracreg logit NEW_LR_Proposal_Probability c.support_ms_mean  ///
				sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count_all_org ///
				interinst_conflict  ///
				competence_length nofterms_in_eurovoc 
				
* Model 2 -- interaction with Salience
eststo m2: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count_all_org ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc 
		
*Model 3 -- interaction with polarization	
eststo m3: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.pol_ms_mean ///
				c.sal_ms_mean ///
				mob_ms_count_all_org ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc  

** Model 4 -- interaction with mobilization
eststo m4: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.mob_ms_count_all_org ///
				c.pol_ms_mean ///
				c.sal_ms_mean ///
				interinst_conflict  ///
				competence_length nofterms_in_eurovoc  
 
 margins , dydx(support_ms_mean)  at(mob_ms_count_all_org =( 0 (5)  55)) level(95) ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(95) ///
	ytitle("Marginal effect of public" "support on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
	xtitle("Actor Mobilization (t-1)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0) ///
	addplot(hist mob_ms_count_all_org if e(sample), xlabel(0 (5) 55) freq bfcolor(none) blcolor(gs10)  ///
			 yaxis(2) yscale(alt axis(2)) below legend(off)) saving(file3, replace)  ///
			 legend(off )) 
graph export "H4_AME_short_raw_a_allactors.png", as(png) replace	

			 
 * export model in stata and eyeball
 estout m1 m2  m3 m4, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels
 
 
  esttab m1 m2  m3 m4 using "regression1_a_allators.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
 
 
 
 
 
 *** 2) Appendix 2.2
 *Assessing the effects of actor mobilisation using Herfindahl-Hirschman Index
 
 * Model 1 
 eststo m1: fracreg logit NEW_LR_Proposal_Probability c.support_ms_mean  ///
				sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_mean_hhi ///
				interinst_conflict  ///
				competence_length nofterms_in_eurovoc 

* Model 2 -- interaction with Salience
eststo m2: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_mean_hhi ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc 
		
*Model 3 -- interaction with polarization	
eststo m3: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.pol_ms_mean ///
				c.sal_ms_mean ///
				mob_ms_mean_hhi ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc  

** Model 4 -- interaction with mobilization
eststo m4: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.mob_ms_mean_hhi ///
				c.pol_ms_mean ///
				c.sal_ms_mean ///
				interinst_conflict  ///
				competence_length nofterms_in_eurovoc   
 
 margins , dydx(support_ms_mean)  at(mob_ms_mean_hhi =( 0 (.01)  0.1)) level(95) ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(95) ///
	ytitle("Marginal effect of public" "support on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
	xtitle("Actor Mobilization (t-1)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0) ///
	addplot(hist mob_ms_mean_hhi if e(sample), xlabel(0 (0.01) 0.1) freq bfcolor(none) blcolor(gs10)  ///
			 yaxis(2) yscale(alt axis(2)) below legend(off)) saving(file3, replace)  ///
			 legend(off )) 			 	
graph export "H4_AME_short_raw_a_hhi.png", as(png) replace	


 * export model in stata and eyeball
 estout m1 m2  m3 m4, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels
 
  esttab m1 m2  m3 m4 using "regression1_a_hhi.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
 
 
 
*** 3) Appendix 2.3
* Include control for legal instrument: 1=decision; 2=Directivel 3=Regulation 

* Model 1 - no interation effect
eststo m1: fracreg logit NEW_LR_Proposal_Probability c.support_ms_mean  ///
				sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict  ///
				competence_length nofterms_in_eurovoc i.form_num

* Model 2 -- interaction with Salience
eststo m2: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc i.form_num
		
*Model 3 -- interaction with polarization	
eststo m3: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.pol_ms_mean ///
				c.sal_ms_mean ///
				mob_ms_count ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc  i.form_num

** Model 4 -- interaction with mobilization
eststo m4: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.mob_ms_count ///
				c.pol_ms_mean ///
				c.sal_ms_mean ///
				interinst_conflict  ///
				competence_length nofterms_in_eurovoc   i.form_num
 
 * export model in stata and eyeball
 estout m1 m2  m3 m4, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels
 
  esttab m1 m2  m3 m4 using "regression1_a_control_instrument.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
 
 
 
 * 4a) Appendix 2.4
 ** dropping cases with more than 11 eurovoc descriptors, i.e. drop if complexity > mean+2ds == 6 proposals dropped
 
 * Model 1 - no interation effect
eststo m1: fracreg logit NEW_LR_Proposal_Probability c.support_ms_mean  ///
				sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict  ///
				competence_length nofterms_in_eurovoc if nofterms_in_eurovoc<11.77 // complexity <mean + 2sd

* Model 2 -- interaction with Salience
eststo m2: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc  if nofterms_in_eurovoc<11.77
		
*Model 3 -- interaction with polarization	
eststo m3: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.pol_ms_mean ///
				c.sal_ms_mean ///
				mob_ms_count ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc if nofterms_in_eurovoc<11.77

** Model 4 -- interaction with mobilization
eststo m4: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.mob_ms_count ///
				c.pol_ms_mean ///
				c.sal_ms_mean ///
				interinst_conflict  ///
				competence_length nofterms_in_eurovoc  if nofterms_in_eurovoc<11.77
				
				
* export model in stata and eyeball
 estout m1 m2  m3 m4, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels
 
 esttab m1 m2  m3 m4 using "regression1_a_dropcomplex2sd.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
 
 
 
  ** 4b) dropping cases with more than 9 eurovoc descriptors, i.e. drop if complexity > mean+1ds == 126 proposals dropped

 * Model 1 - no interation effect
eststo m1: fracreg logit NEW_LR_Proposal_Probability c.support_ms_mean  ///
				sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict  ///
				competence_length nofterms_in_eurovoc if nofterms_in_eurovoc<9.77 // complexity <mean + 2sd

* Model 2 -- interaction with Salience
eststo m2: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc  if nofterms_in_eurovoc<9.77
		
*Model 3 -- interaction with polarization	
eststo m3: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.pol_ms_mean ///
				c.sal_ms_mean ///
				mob_ms_count ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc if nofterms_in_eurovoc<9.77

** Model 4 -- interaction with mobilization
eststo m4: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.mob_ms_count ///
				c.pol_ms_mean ///
				c.sal_ms_mean ///
				interinst_conflict  ///
				competence_length nofterms_in_eurovoc  if nofterms_in_eurovoc<9.77

				
* export model in stata and eyeball
 estout m1 m2  m3 m4, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels
 
 
  esttab m1 m2  m3 m4 using "regression1_a_dropcomplex1sd.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
 
 

 ** 4c) dropping the control for Complexity ---> not included in Appendices

    * model 1 - no interation effect
eststo m1: fracreg logit NEW_LR_Proposal_Probability c.support_ms_mean  ///
				sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict  ///
				competence_length 

* Model 2 -- interaction with Salience
eststo m2: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict ///
				competence_length 
		
*Model 3 -- interaction with polarization	
eststo m3: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.pol_ms_mean ///
				c.sal_ms_mean ///
				mob_ms_count ///
				interinst_conflict ///
				competence_length 

** Model 4 -- interaction with mobilization
eststo m4: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.mob_ms_count ///
				c.pol_ms_mean ///
				c.sal_ms_mean ///
				interinst_conflict  ///
				competence_length 

				
* export model in stata and eyeball
 estout m1 m2  m3 m4, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels

 
  esttab m1 m2  m3 m4 using "regression1_nocomplexity.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
 
 

 
 
 * 5) Appendix 2.5
 * Different lags
  
* Model 1 - no interation effect
eststo m1: fracreg logit NEW_LR_Proposal_Probability c.support_ms_mean_lag1y  ///
				sal_ms_mean_no_lag ///
				pol_ms_mean_no_lag ////
				mob_ms_count_no_lag ///
				interinst_conflict  ///
				competence_length nofterms_in_eurovoc 			 
			 
* Model 2 -- interaction with Salience
eststo m2: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean_lag1y##c.sal_ms_mean_no_lag ///
				pol_ms_mean_no_lag ////
				mob_ms_count_no_lag ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc  
			 
*Model 3 -- interaction with polarization	
eststo m3: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean_lag1y##c.pol_ms_mean_no_lag ///
				c.sal_ms_mean_no_lag ///
				mob_ms_count_no_lag ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc 

margins , dydx(support_ms_mean)  at(pol_ms_mean_no_lag =( 0.05 (.1)  .85))  ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(95) ///
	ytitle("Marginal effect of public" "support on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
	xtitle("Public Polarization (t-1)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0) ///
	addplot(hist pol_ms_mean_no_lag if e(sample), xlabel(0.05 (.1)  .85) freq bfcolor(none) blcolor(gs10)  ///
			 yaxis(2) yscale(alt axis(2)) below legend(off)) saving(file3, replace)  ///
			 legend(off ))  	
graph export "H3_AME_short_raw_at_t.png", as(png) replace	
			 
			 
** Model 4 -- interaction with mobilization
eststo m4: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean_lag1y##c.mob_ms_count_no_lag ///
				c.pol_ms_mean_no_lag ///
				c.sal_ms_mean_no_lag ///
				interinst_conflict  ///
				competence_length nofterms_in_eurovoc 

margins , dydx(support_ms_mean)  at(mob_ms_count_no_lag =( 0 (2)  20)) level(95) ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(95) ///
	ytitle("Marginal effect of public" "support on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
	xtitle("Actor Mobilization (t-1)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0) ///
	addplot(hist mob_ms_count_no_lag if e(sample), xlabel(0 (2) 20) freq bfcolor(none) blcolor(gs10)  ///
			 yaxis(2) yscale(alt axis(2)) below legend(off)) saving(file3, replace)  ///
			 legend(off )) 

graph export "H4_AME_short_raw_at_t.png", as(png) replace	


estout m1 m2  m3 m4, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels
 
 
esttab m1 m2  m3 m4 using "regression1_a_at_tplus1.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
 
 

 
 
 *6)  Appendix 6
 *** CAP clustering
 
* Model 1 - no interation effect
eststo m1: fracreg logit NEW_LR_Proposal_Probability c.support_ms_mean  ///
				sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict ///
				competence_length  nofterms_in_eurovoc, vce(cluster cap_code) 
				
* Model 2 -- interaction with Salience
eststo m2: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc, vce(cluster cap_code) 

*Model 3 -- interaction with polarization	
eststo m3: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.pol_ms_mean ///
				c.sal_ms_mean ///
				mob_ms_count ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc, vce(cluster cap_code) 

* Model 4 -- interaction with mobilization
eststo m4: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.mob_ms_count ///
				c.pol_ms_mean ///
				c.sal_ms_mean ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc, vce(cluster cap_code) 

* export model in stata and eyeball
 estout m1 m2  m3 m4, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels		
				
  esttab m1 m2  m3 m4 using "regression1_a_cap_cluster.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
 
 
 

 * 7) Appendix 7
 *Control for EP term included
 

* Model 1 - no interation effect
eststo m1: fracreg logit NEW_LR_Proposal_Probability c.support_ms_mean  ///
				sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict ///
				competence_length  nofterms_in_eurovoc  i.ep_term_full
				
* Model 2 -- interaction with Salience
eststo m2: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc i.ep_term_full
				
*Model 3 -- interaction with polarization	
eststo m3: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.pol_ms_mean ///
				c.sal_ms_mean ///
				mob_ms_count ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc i.ep_term_full

* Model 4 -- interaction with mobilization
eststo m4: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_mean##c.mob_ms_count ///
				c.pol_ms_mean ///
				c.sal_ms_mean ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc i.ep_term_full

* export model in stata and eyeball
 estout m1 m2  m3 m4, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels		
				
  esttab m1 m2  m3 m4 using "regression1_a_epterm.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
 
 
 
 
 
 
 
 * 8) Appendix 8
 *Appendix with pivot based conflict on EU dimension 
 
 
 *** a)  interinstitutional conflict on EU dim using dist b/n EP (median national party delegatin in the median EPG) and furthers CN pivot government on EU dimension
 * OR distance b/n furthest pivots when the EP position is sutuated in between them

				
 * model 1 - no interation effect
 eststo m1: fracreg logit NEW_LR_Proposal_Probability c.support_ms_mean  ///
 				sal_ms_mean ///
 				pol_ms_mean ////
 				mob_ms_count ///
 				CH_conflict_med_party_epg    ///
 				competence_length nofterms_in_eurovoc 

 * model 2 -- interaction with salience
 eststo m2: fracreg logit NEW_LR_Proposal_Probability   ///
 				c.support_ms_mean##c.sal_ms_mean ///
 				pol_ms_mean ////
 				mob_ms_count ///
 				CH_conflict_med_party_epg   ///
 				competence_length nofterms_in_eurovoc 
		
 *model 3 -- interaction with polarization	
 eststo m3: fracreg logit NEW_LR_Proposal_Probability   ///
 				c.support_ms_mean##c.pol_ms_mean ///
 				c.sal_ms_mean ///
 				mob_ms_count ///
 				CH_conflict_med_party_epg   ///
 				competence_length nofterms_in_eurovoc

 ** model 4 -- interaction with mobilization
 eststo m4: fracreg logit NEW_LR_Proposal_Probability   ///
 				c.support_ms_mean##c.mob_ms_count ///
 				c.pol_ms_mean ///
 				c.sal_ms_mean ///
 				CH_conflict_med_party_epg   ///
 				competence_length nofterms_in_eurovoc 
				
* export model in stata and eyeball
 estout m1 m2  m3 m4, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels		
  
  
   esttab m1 m2  m3 m4 using "regression1_a_pivot.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
  
  
  
  
* 9) Appendix 9
  ** Different public support measure --  weighted averege using countries' voting weights in the Council

*Model 1
 eststo m1: fracreg logit NEW_LR_Proposal_Probability c.support_ms_w   ///
				sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict ///
				competence_length  nofterms_in_eurovoc
				
* Model 2 -- interaction with Salience
eststo m2: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_w##c.sal_ms_mean ///
				pol_ms_mean ////
				mob_ms_count ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc

*Model 3
eststo m3: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_w##c.pol_ms_mean ///
				c.sal_ms_mean ///
				mob_ms_count ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc

margins , dydx(support_ms_w)  at(pol_ms_mean =( 0. (.1)  .9))  ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(95) ///
	ytitle("Marginal effect of public" "support on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
	xtitle("Public Polarization (t-1)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0) ///
	addplot(hist pol_ms_mean if e(sample), xlabel(0 (.1)  .9) freq bfcolor(none) blcolor(gs10)  ///
			 yaxis(2) yscale(alt axis(2)) below legend(off)) saving(file3, replace)  ///
			 legend(off ))  
				
** Model 4 -- interaction with mobilization
eststo m4: fracreg logit NEW_LR_Proposal_Probability   ///
				c.support_ms_w##c.mob_ms_count ///
				c.pol_ms_mean ///
				c.sal_ms_mean ///
				interinst_conflict ///
				competence_length nofterms_in_eurovoc

margins , dydx(support_ms_w)  at(mob_ms_count =( 0 (2)  20)) level(95) ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(95) ///
	ytitle("Marginal effect of public" "support on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
	xtitle("Actor Mobilization (t-1)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0) ///
	addplot(hist mob_ms_count if e(sample), xlabel(0 (2) 20) freq bfcolor(none) blcolor(gs10)  ///
			 yaxis(2) yscale(alt axis(2)) below legend(off)) saving(file3, replace)  ///
			 legend(off )) 	
 
  * export model in stata and eyeball
  estout m1 m2  m3 m4, cells(b (star fmt(%9.3f)) p(par))  ///
   starlevels( * 0.10 ** 0.05 *** 0.010) stats( n, fmt(%9.3f %9.0g)) ///
   legend  label collabels(none) varlabels(_cons constant) nobaselevels

   esttab m1 m2  m3 m4 using "regression1_a_vweights.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
  
 

							
 

 
 
 
 
 
