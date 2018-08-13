

SELECT DISTINCT  *
FROM 
(
  SELECT co_loc_i, co_loc_ref_i, tot_ocup_sqft_q, tot_stk_sqft_q, gr_sell_sqft_q, str_vol_clas_c
  FROM prod.brck_mrtr_dim AS str -- BRCK_MRTR_STR_DIM_V
  WHERE str.co_loc_clos_d > current_date
  AND co_loc_open_d <= current_date
  AND str.co_loc_ref_i <> 1899
  AND gr_sell_sqft_q > 0
  --ORDER BY STR.CO_LOC_REF_I
) AS STR
,
(
-- ALIGNS THE DATE TIME SERIES IN ORDER FUTURE AD-AD WEEKS
SELECT CAL_1.acct_yr_i,
	CAL_1.acct_wk_end_d, CAL_1.acct_wk_i, 	
	COALESCE(CAL_2.pryr_acct_wk_end_d, CAL_1.acct_wk_end_d) AS ts_acct_wk_end_d,
	COALESCE(CAL_2.acct_wk_i, CAL_1.acct_wk_i) AS ts_acct_wk_i
	

FROM prod.cal_wk_dim AS CAL_1
LEFT JOIN prod.cal_wk_dim AS CAL_2
 ON CAL_1.acct_wk_end_d = CAL_2.pryr_ad_wk_end_d
 
WHERE CAL_1.ACCT_YR_I >= 2015
AND COALESCE(CAL_2.acct_wk_i, CAL_1.acct_wk_i) <> 53
-- ORDER BY CAL_1.ACCT_WK_END_D
) AS CAL
ORDER BY  STR.CO_LOC_I, CAL.ACCT_WK_END_D
