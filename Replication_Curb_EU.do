/* replication files for Curb EU Enthusiasm: 
*/

cd "DIR"  /* adjust the WD as needed*/

use "DIR\Curb_EU_dt.dta", clear  /*loaad the data*/


** set plotting scheme
set scheme plotplain  

* model 1 - no interation effect

eststo m1: fracreg logit NEW_LR_Proposal_Probability c.MS_support_2lag  ///
				c.MS_mobiliz_lag  ///
				MS_polariz_lag  ///
				MS_salience_lag  ///
				Interinst_conflict ///
				amending  ///
				i.form_num ///
				nofterms_in_eurovoc ///  
				competence_length  ///
				i.Country_num,  vce(cluster cod)
* margins	
margins, at(MS_support_2lag=(0(1)100)) plot(recast(line) level(90) ///
	recastci(rarea) ciopts(fcolor(%30) lwidth(vvvthin) lpattern(tight_dot))  ///
	ytitle(Pred. Pr. of EU authority expansion) ///
	ytitle(, size(medsmall)) xtitle("% Public Support (t-2)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") )

graph export "h1_main.png", as(png) replace	
	
				
				
* Model 2 -- interaction with Salience
				
eststo m2: fracreg logit NEW_LR_Proposal_Probability  ///
						c.MS_support_2lag##c.MS_salience_lag  ///
						MS_polariz_lag  ///
						c.MS_mobiliz_lag   ///
						Interinst_conflict ///
						amending  ///
						i.form_num ///
						nofterms_in_eurovoc  ///
						competence_length ///
						i.Country_num, vce(cluster cod)
						
* plot predicted probabilities
margins , at( MS_support =(0(1)100) MS_salience_lag =( 30  100))  ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%30) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
	ytitle(Pred. Pr. of EU authority expansion)  ytitle(, size(medsmall)) ///
	xtitle("% Public Support (t-2)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") ///
	legend(order(1 "%Salience (t-1)=0" 2 "%Salience (t-1)=100") rows(1) position(6))) 
	
 
 ******plot  by level****

margins , at( MS_support =(0(1)100) MS_salience_lag =( 25, 50, 75 , 100))    level(90)

 
marginsplot, by(MS_salience_lag) recast(line) plotopts(lwidth(vthin)) byopts(rows(1) )  level(90) ///
		 recastci(rarea) ciopts(fcolor(%20)  lcolor(none) lwidth(none)  xsize(10) ysize(4) ///
		  lpattern(dot)) xtitle("% Public Support (t-2)" )  ytitle("Pred. Pr. of EU authority expansion") ///
		
 
 
graph export "h2_main_l.png", as(png) replace	
	
	
 
 
 
 **** Plot AME and include into the appedix ****

margins , dydx(MS_support)  at(MS_salience_lag =( 0 (1)  100))  ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
	ytitle("Marginal effect of public" "opinion on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
	xtitle("%Salience (t-1)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0)) 
			 	

graph export "H2_AME.png", as(png) replace	
								
						
						
*Model 3 -- interaction with polarization
						
eststo m3: fracreg logit NEW_LR_Proposal_Probability ///
						c.MS_support_2lag##c.MS_polariz_lag  ///
						MS_salience_lag    ///
						c.MS_mobiliz_lag ///
						Interinst_conflict  ///
						amending  ///
						i.form_num ///
						nofterms_in_eurovoc  ///
						competence_length ///
						i.Country_num, vce(cluster cod)

* plot predicted probabilities
margins , at( MS_support =(20(10)100)MS_polariz_lag =( 0 , .3,.5,.7,  1))  ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
	ytitle(Pred. Pr. of EU authority expansion)  ytitle(, size(medsmall)) ///
	xtitle("% Public Support (t-2)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") ///
	legend(order(1 "Public Polarization (t-1)=0" 2 "Public Polarization (t-1)=1") rows(1) position(6))) 
	
 
marginsplot, level(90) by(MS_polariz_lag) recast(line) plotopts(lwidth(vthin))  ///
 recastci(rarea) ciopts(fcolor(%20)  lcolor(none) lwidth(none)   ///
    lpattern(dot)) xtitle("% Public Support (t-2) for EU engagement in policy domain" )

 
 
 
graph export "h3_main.png", as(png) replace	
							


 ******plot  by level****

margins , at( MS_support =(0(1)100) MS_polariz_lag =( 0, .35, .65 , 1))    level(90)

 
marginsplot, by(MS_polariz_lag) recast(line) plotopts(lwidth(vthin)) byopts(rows(1) )  level(90) ///
		 recastci(rarea) ciopts(fcolor(%20)  lcolor(none) lwidth(none)  xsize(10) ysize(4) ///
		  lpattern(dot)) xtitle("% Public Support (t-2)" , size(large)) ///
		  ytitle("Pred. Pr. of EU authority expansion" , size(large) )  ///
		
 
 
 
graph export "h3_main_l.png", as(png) replace	
								
							
							
							
							
							
							
 **** Plot AME and include into the appedix ****

margins , dydx(MS_support)  at(MS_polariz_lag =( 0 (.1)  1))  ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
	ytitle("Marginal effect of public" "opinion on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
	xtitle("Public Polarization (t-1)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0)) 
			 	

	
	
	
graph export "H3_AME.png", as(png) replace	
								
						
						
						
** Model 4 -- interaction with mobilization

eststo m4: fracreg logit NEW_LR_Proposal_Probability  ///
						c.MS_support_2lag##c.MS_mobiliz_lag ///
						MS_salience_lag  ///
						c.MS_polariz_lag  ///
						Interinst_conflict ///
						amending  ///
						i.form_num ///
						nofterms_in_eurovoc ///
						competence_length  ///
						i.Country_num, vce(cluster cod)
						
margins , at( MS_support =(0(1)100) MS_mobiliz_lag =( 0  ,  14)) ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
	ytitle(Pred. Pr. of EU authority expansion)  ytitle(, size(medsmall)) ///
	xtitle("% Public Support (t-2)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") ///
	legend(order(1 "Actor Mobilization (t-1)=0" 2 "Actor mobilization (t-1)=14") rows(1) position(6))) 
	

graph export "h4_main.png", as(png) replace	
	
**** plotby level of mobiliz

margins , at( MS_support =(0(1)100) MS_mobiliz_lag =( 0 , 4, 9, 14)) 	
	

*marginsplot, level(90) by(MS_mobiliz_lag) recast(line) plotopts(lwidth(vthin))  ///
 *%recastci(rarea) ciopts(fcolor(%20)  lcolor(none) lwidth(none)   ///
  *  lpattern(dot)) xtitle("% Public Support (t-2) for EU engagement in policy domain" )
	


marginsplot, by(MS_mobiliz_lag) recast(line) plotopts(lwidth(vthin)) byopts(rows(1) )  level(90) ///
		 recastci(rarea) ciopts(fcolor(%20)  lcolor(none) lwidth(none)  xsize(10) ysize(4) ///
		  lpattern(dot)) xtitle("% Public Support (t-2)" , size(large)) ///
		  ytitle("Pred. Pr. of EU authority expansion" , size(large) )  ///
		
 	

graph export "h4_main_l.png", as(png) replace	
		
	

 **** Plot AME and include into the appedix ****
	
margins , dydx(MS_support)  at(MS_mobiliz_lag =( 0 (1)  15)) level (90) ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
	ytitle("Marginal effect of public" "opinion on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
	xtitle("Actor Mobilization (t-1)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0)) 
			 	

graph export "H4_AME.png", as(png) replace	
								
						
						
						
* export model in stata and eyeball
 estout m1 m2  m3 m4, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels
				 
				 

esttab m1 m2  m3 m4 using "regression1_main.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
 								
								

********************************************************************								
******************* Robustness checks*******************************
********************************************************************
** retest using HHI
* model 1 - no interation effect
eststo m1_hhi: fracreg logit NEW_LR_Proposal_Probability c.MS_support_2lag  ///
				c.Lagged_all_hhi_cntr_y_cap  ///
				MS_polariz_lag  ///
				MS_salience_lag  ///
				Interinst_conflict ///
				amending  ///
				i.form_num ///
				nofterms_in_eurovoc ///  
				competence_length  ///
				i.Country_num,  vce(cluster cod)
* margins	
margins, at(MS_support_2lag=(0(1)100)) plot(level(90) recast(line) ///
	recastci(rarea) ciopts(fcolor(%30) lwidth(vvvthin) lpattern(tight_dot))  ///
	ytitle(Pred. Pr. of EU authority expansion) ///
	ytitle(, size(medsmall)) xtitle("% Public Support (t-2)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") )

graph export "h1_hhi.png", as(png) replace	
	
				
				
* Model 2 -- interaction with Salience
				
eststo m2_hhi: fracreg logit NEW_LR_Proposal_Probability  ///
						c.MS_support_2lag##c.MS_salience_lag  ///
						MS_polariz_lag  ///
						c.Lagged_all_hhi_cntr_y_cap   ///
						Interinst_conflict ///
						amending  ///
						i.form_num ///
						nofterms_in_eurovoc  ///
						competence_length ///
						i.Country_num, vce(cluster cod)
						
* plot predicted probabilities
margins , at( MS_support =(0(1)100) MS_salience_lag =( 0  100))  ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%30) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
	ytitle(Pred. Pr. of EU authority expansion)  ytitle(, size(medsmall)) ///
	xtitle("% Public Support (t-2)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") ///
	legend(order(1 "%Salience (t-1)=0" 2 "%Salience (t-1)=100") rows(1) position(6))) 
	
 
graph export "h2_hhi.png", as(png) replace	
	

				
*Model 3 -- interaction with polarization
						
eststo m3_hhi: fracreg logit NEW_LR_Proposal_Probability ///
						c.MS_support_2lag##c.MS_polariz_lag  ///
						MS_salience_lag    ///
						c.Lagged_all_hhi_cntr_y_cap  ///
						Interinst_conflict  ///
						amending  ///
						i.form_num ///
						nofterms_in_eurovoc  ///
						competence_length ///
						i.Country_num, vce(cluster cod)

* plot predicted probabilities
margins , at( MS_support =(0(1)100)MS_polariz_lag =( 0 1))  ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
	ytitle(Pred. Pr. of EU authority expansion)  ytitle(, size(medsmall)) ///
	xtitle("% Public Support (t-2)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") ///
	legend(order(1 "Public Polarization (t-1)=0" 2 "Public Polarization (t-1)=1") rows(1) position(6))) 
	
 
graph export "h3_hhi.png", as(png) replace						
											
						
** Model 4 -- interaction with mobilization

eststo m4_hhi: fracreg logit NEW_LR_Proposal_Probability  ///
						c.MS_support_2lag##c.Lagged_no_trade_hhi_cntr_y_cap   ///
						MS_salience_lag  ///
						c.MS_polariz_lag  ///
						Interinst_conflict ///
						amending  ///
						i.form_num ///
						nofterms_in_eurovoc ///
						competence_length  ///
						i.Country_num, vce(cluster cod)
						
margins , at( MS_support =(0(1)100) c.Lagged_no_trade_hhi_cntr_y_cap   =( 0  .7))  ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
	ytitle(Pred. Pr. of EU authority expansion)  ytitle(, size(medsmall)) ///
	xtitle("% Public Support (t-2)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") ///
	legend(order(1 "Domestic HHI (t-1)=0" 2 "Domestic HHI (t-1)=.7") rows(1) position(6))) 
	

graph export "h4_hhi.png", as(png) replace	

estout m1_hhi m2_hhi  m3_hhi m4_hhi, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels
				 
				 

esttab m1_hhi m2_hhi  m3_hhi m4_hhi using "hhi_main.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
 
 
 *****************************************************************************
 *****************************************************************************
** retest using all actors mobilized	

* m1_ all organizations
eststo m1_all: fracreg logit NEW_LR_Proposal_Probability c.MS_support_2lag  ///
				Lagged_all_n_of_organiz_register ///
				MS_polariz_lag  ///
				MS_salience_lag  ///
				Interinst_conflict ///
				amending  ///
				i.form_num ///
				nofterms_in_eurovoc ///  
				competence_length  ///
				i.Country_num,  vce(cluster cod)

*m2- all organizations							
	
eststo m2_all: fracreg logit NEW_LR_Proposal_Probability  ///
						c.MS_support_2lag##c.MS_salience_lag  ///
						MS_polariz_lag  ///
						Lagged_all_n_of_organiz_register  ///
						Interinst_conflict ///
						amending  ///
						i.form_num ///
						nofterms_in_eurovoc  ///
						competence_length ///
						i.Country_num, vce(cluster cod)
						
*m3 -- all organzitions
					
eststo m3_all: fracreg logit NEW_LR_Proposal_Probability ///
						c.MS_support_2lag##c.MS_polariz_lag  ///
						MS_salience_lag    ///
						Lagged_all_n_of_organiz_register ///
						Interinst_conflict  ///
						amending  ///
						i.form_num ///
						nofterms_in_eurovoc  ///
						competence_length ///
						i.Country_num, vce(cluster cod)

*m4-- all organizations						

eststo m4_all: fracreg logit NEW_LR_Proposal_Probability  ///
						c.MS_support_2lag##c.Lagged_all_n_of_organiz_register  ///
						MS_salience_lag  ///
						c.MS_polariz_lag  ///
						Interinst_conflict ///
						amending  ///
						i.form_num ///
						nofterms_in_eurovoc ///
						competence_length  ///
						i.Country_num, vce(cluster cod)
						
********** export tables
					
						
* export model in stata and eyeball
 estout m1_all m2_all  m3_all m4_all, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels
				 
				 

esttab m1_all m2_all  m3_all m4_all using "all_orgs_main.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
 										
						
						
						
****************************************************************************
****************************************************************************							
**retest using Voting weights of the countries

* m1 - no interacions  but with country weight
eststo m1_weights: fracreg logit NEW_LR_Proposal_Probability c.MS_support_2lag  ///
				c.MS_mobiliz_lag ///
				MS_polariz_lag  ///
				MS_salience_lag  ///
				Council_weights ///
				Interinst_conflict ///
				amending  ///
				i.form_num ///
				nofterms_in_eurovoc ///  
				competence_length  ///
				i.Country_num,  vce(cluster cod)
				
				
* m2 - interations with salience 
eststo m2_weights: fracreg logit NEW_LR_Proposal_Probability ///
				c.MS_support_2lag##c.MS_salience_lag  ///
				c.MS_mobiliz_lag ///
				MS_polariz_lag  ///
				Council_weights ///
				Interinst_conflict ///
				amending  ///
				i.form_num ///
				nofterms_in_eurovoc ///  
				competence_length  ///
				i.Country_num,  vce(cluster cod)
				

margins , dydx(MS_support)  at(MS_salience_lag =( 0 (1)  100))  ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
	ytitle("Marginal effect of public" "opinion on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
	xtitle("Public Salience (t-1)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0)) 
			 	

graph export "h2_weight.png", as(png) replace					

*m3- interaction wih polarization				
eststo m3_weights: fracreg logit NEW_LR_Proposal_Probability ///
				c.MS_support_2lag##c.MS_polariz_lag  ///
				c.MS_mobiliz_lag ///
				 MS_salience_lag  ///
				Council_weights ///
				Interinst_conflict ///
				amending  ///
				i.form_num ///
				nofterms_in_eurovoc ///  
				competence_length  ///
				i.Country_num,  vce(cluster cod)			

*AME

margins , dydx(MS_support)  at(MS_polariz_lag =( 0 (.1)  1))  ///
 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
	ytitle("Marginal effect of public" "opinion on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
	xtitle("Public Polarization (t-1)") ///
	xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0)) 
			 	

	 
graph export "h3_weight.png", as(png) replace	
												
				
*interaction with mobiliz
eststo m4_weights: fracreg logit NEW_LR_Proposal_Probability ///
			c.MS_support_2lag##c.MS_mobiliz_lag ///
				MS_polariz_lag  ///
				MS_salience_lag  ///
				Council_weights ///
				Interinst_conflict ///
				amending  ///
				i.form_num ///
				nofterms_in_eurovoc ///  
				competence_length  ///
				i.Country_num,  vce(cluster cod)
				
* AME 

	margins , dydx(MS_support)  at(MS_mobiliz_lag =( 0 (1)  15)) level (90) ///
	 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
		ytitle("Marginal effect of public" "opinion on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
		xtitle("Actor Mobilization (t-1)") ///
		xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0)) 
		


graph export "h4_weight.png", as(png) replace	

				
* export model in stata and eyeball
 estout m1_weights m2_weights m3_weights m4_weights, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels
				 

esttab  m1_weights m2_weights m3_weights m4_weights  using "weights_main.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})
 										

**retest using different lag: support= 1year lag; politicization =0 lag

eststo m1_lag: fracreg logit NEW_LR_Proposal_Probability  ///
				lagged_wmean_support_cntr_cap_ye ///
				no_trade_n_of_organiz_registered ///
				cntr_polarization  ///
				wmean_Salience_DK_cntr_cap_year ///
				Interinst_conflict ///
				amending  i.form_num ///
				nofterms_in_eurovoc ///  
				competence_length  ///
				i.Country_num,  vce(cluster cod)

								
margins , dydx(lagged_wmean_support_cntr_cap_ye)  at(lagged_wmean_support_cntr_cap_ye =( 0 (.1)  1)) level (90) ///
	 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
		ytitle("Marginal effect of public" "opinion on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
		xtitle("Public Support (t-1)") ///
		xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0)) 			
	

graph export "h1_lag.png", as(png) replace	
				
				

eststo m2_lag: fracreg logit NEW_LR_Proposal_Probability  ///
				c.lagged_wmean_support_cntr_cap_ye##c.wmean_Salience_DK_cntr_cap_year ///
				no_trade_n_of_organiz_registered ///
				cntr_polarization  ///
				Interinst_conflict ///
				amending  i.form_num ///
				nofterms_in_eurovoc ///  
				competence_length  ///
				i.Country_num,  vce(cluster cod)
				
				
margins , dydx(lagged_wmean_support_cntr_cap_ye)  at(wmean_Salience_DK_cntr_cap_year =( 0 (.1)  1)) level (90) ///
	 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
		ytitle("Marginal effect of public" "opinion on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
		xtitle("salience (t)") ///
		xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0)) 			
	

graph export "h2_lag.png", as(png) replace	
				
								

eststo m3_lag: fracreg logit NEW_LR_Proposal_Probability  ///
				c.lagged_wmean_support_cntr_cap_ye##c.cntr_polarization ///
				wmean_Salience_DK_cntr_cap_year ///
				no_trade_n_of_organiz_registered ///
				Interinst_conflict ///
				amending  i.form_num ///
				nofterms_in_eurovoc ///  
				competence_length  ///
				i.Country_num,  vce(cluster cod)
	
margins , dydx(lagged_wmean_support_cntr_cap_ye)  at(cntr_polarization =( 0 (.1)  1)) level (90) ///
	 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
		ytitle("Marginal effect of public" "opinion on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
		xtitle("polarization (t)") ///
		xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0)) 			


graph export "h3_lag.png", as(png) replace	
				
						
		
eststo m4_lag: fracreg logit NEW_LR_Proposal_Probability  ///
				c.lagged_wmean_support_cntr_cap_ye##c.no_trade_n_of_organiz_registered ///
				c.wmean_Salience_DK_cntr_cap_year ///
				no_trade_n_of_organiz_registered ///
				cntr_polarization  ///
				Interinst_conflict ///
				amending  i.form_num ///
				nofterms_in_eurovoc ///  
				competence_length  ///
				i.Country_num,  vce(cluster cod)
				

margins , dydx(lagged_wmean_support_cntr_cap_ye)  at(no_trade_n_of_organiz_registered =( 0 (1)  15)) level (90) ///
	 plot(recast(line) recastci(rarea) ciopts(fcolor(%20) lwidth(vvvthin) lpattern(tight_dot)) level(90) ///
		ytitle("Marginal effect of public" "opinion on Pr. of EU authoirty expansion")  ytitle(, size(medsmall)) ///
		xtitle("Actor Mobilization (t)") ///
		xtitle(, size(medsmal)) xmtick(, labels)  title("") yline(0)) 
		


graph export "h4_lag.png", as(png) replace	
				
								
				
estout m1_lag m2_lag  m3_lag m4_lag, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels

				
				

**retest without legal instrument	

* m1-- no legal instrument
eststo m1_noform: fracreg logit NEW_LR_Proposal_Probability c.MS_support_2lag  ///
				c.MS_mobiliz_lag ///
				MS_polariz_lag  ///
				MS_salience_lag  ///
				Interinst_conflict ///
				amending  ///
				nofterms_in_eurovoc ///  
				competence_length  ///
				i.Country_num,  vce(cluster cod)

*m2--no legal instrument						
	
eststo m2_noform: fracreg logit NEW_LR_Proposal_Probability  ///
						c.MS_support_2lag##c.MS_salience_lag  ///
						MS_polariz_lag  ///
						c.MS_mobiliz_lag   ///
						Interinst_conflict ///
						amending  ///
						nofterms_in_eurovoc  ///
						competence_length ///
						i.Country_num, vce(cluster cod)
						
*m3 -- no legal instrument
					
eststo m3_noform: fracreg logit NEW_LR_Proposal_Probability ///
						c.MS_support_2lag##c.MS_polariz_lag  ///
						MS_salience_lag    ///
						c.MS_mobiliz_lag  ///
						Interinst_conflict  ///
						amending  ///
						nofterms_in_eurovoc  ///
						competence_length ///
						i.Country_num, vce(cluster cod)

*m4-- no legal instrument					

eststo m4_noform: fracreg logit NEW_LR_Proposal_Probability  ///
						c.MS_support_2lag##c.c.MS_mobiliz_lag   ///
						MS_salience_lag  ///
						c.MS_polariz_lag  ///
						Interinst_conflict ///
						amending  ///
						nofterms_in_eurovoc ///
						competence_length  ///
						i.Country_num, vce(cluster cod)
						
********** export tables						
* export model in stata and eyeball
 estout m1_noform m2_noform  m3_noform m4_noform, cells(b (star fmt(%9.3f)) p(par))  ///
  starlevels( * 0.10 ** 0.05 *** 0.010) stats( N, fmt(%9.3f %9.0g)) ///
  legend  label collabels(none) varlabels(_cons Constant) nobaselevels
				 
				 
esttab m1_noform m2_noform  m3_noform m4_noform using "No_form_main.tex", replace f  ///
 b(3) p(3) scalars(ll chi2)   nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1})

 
 
 
 



						
********************************************************************************								
************************** Summary Stats tables ********************************
********************************************************************************								
** descriptive 

 estpost tabstat NEW_LR_Proposal_Probability  MS_support_2lag  ///
      MS_salience_lag MS_polariz_lag ///
	 MS_mobiliz_lag   form_num    Interinst_conflict    ///
	 nofterms_in_eurovoc  competence_length amending   ///
	 Country_num , c(stat) stat(sum mean sd min max n)
	 


esttab  d using "desriptives.tex", replace ////
 cells("sum(fmt(%6.0fc)) mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count")   nonumber ///
  nomtitle nonote noobs label booktabs ///
  collabels("Sum" "Mean" "SD" "Min" "Max" "N")  ///
  title("Descriptive statistics \label{table1stata}")		
  
  
 * correlation table
 corrtex  NEW_LR_Proposal_Probability  MS_support_2lag  ///
     MS_salience_lag MS_polariz_lag ///
	 MS_mobiliz_lag   form_num    Interinst_conflict    ///
	 nofterms_in_eurovoc  competence_length amending ,  ///
	 file ("correlation.tex") replace
	 
	 
	 
	 
 
						
