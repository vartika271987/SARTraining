
**Use the paddy cleaned national level file to extract information on paddy yields 

use "C:\Users\IIMA\Dropbox (IFPRI)\CACP DATA (1)\Data\State and national avg Paddy_fullyear.dta", clear

**Extracting average land rent for the year 2015 at 2005 prices
tab landrent_ind05 if year==2015

**Import values of rainfed land rent, irrigated land rents from calculation in excel sheet 
**production_irri is production in tonnes
replace mainproductqtls_irri = 0 if mainproductqtls_irri == . 
replace mainproductqtls_rain = 0 if mainproductqtls_rain == . 

*Shares of irrigated/rainfed production as part of production at state level
	gen prod_share_irri = (mainproductqtls_irri_india / mainproductqtls_india) if mainproductqtls_irri_india != 0 
	gen prod_share_rain = (mainproductqtls_rain_india / mainproductqtls_india) if mainproductqtls_rain_india != 0

	**Generating land rent by irrigation type 
	gen landrent_irri = landrent_ind05 * prod_share_irri
	gen landrent_rain = landrent_ind05 * prod_share_rain


*Total cost of production to be equated with factor costs should be in 2005 prices

gen cc_irri = totallabourrs_india_nom +  totalmachiners_india_nom +  totalanimalrs_india_nom + irrigationrs_india_nom + ///
				seedvaluers_india_nom + totalfertiliserrs_india_nom + manurers_india_nom + insecticidesrs_india_nom + ///
				 landrent_irri if irrigationrs != 0
*To get the cost in tonne/ha				 
gen cc_irri_tonne = (cc_irri/mainproductqtls_irri_india)*10
				
gen cc_rain = totallabourrs_india_nom +  totalmachiners_india_nom +  totalanimalrs_india_nom + irrigationrs_india_nom + ///
				seedvaluers_india_nom + totalfertiliserrs_india_nom + manurers_india_nom + insecticidesrs_india_nom + ///
				landrent_rain if (irrigationrs == 0 | irrigationrs == .)
				
gen cc_rain_tonne = (cc_rain/mainproductqtls_rain_india)*10
	
*Cost of irrigated production of paddy in 2005 prices in the year 2005 
tab cc_irri if year==2005 & crop2==16
tab cc_rain if year==2005 & crop2==16

*Converting into USD at 2005 exchange rate 
gen cc_irri_usd = cc_irri_tonne/43.5 
gen cc_rain_usd = cc_rain_tonne/43.5 

*Cost of production per tonne 


**This is the cost to produce mainproductqtls in qtls per hectare. So cost to produce in tonnes per hectare will be multiplied by 10
