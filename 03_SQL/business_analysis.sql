-- Grain-safe SQLite business queries. Monetary values are source currencies.

-- name: portfolio_kpis
SELECT COUNT(*) loans,SUM(funded_amnt) funded_amount,AVG(loan_amnt) loan_amount,AVG(int_rate)/100 interest_rate,SUM(resolved) resolved_loans,SUM(default_flag) defaults,AVG(default_flag) default_rate,SUM(fully_paid)*1.0/NULLIF(SUM(resolved),0) fully_paid_rate,AVG(current*1.0) current_share,SUM(total_rec_int) interest_received,SUM(total_pymnt) payments_received,AVG(dti) dti,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan;

-- name: grade_risk_return
SELECT grade,COUNT(*) loans,SUM(resolved) resolved_loans,SUM(funded_amnt) funded_amount,AVG(default_flag) default_rate,AVG(int_rate)/100 coupon_rate,SUM(total_rec_int) interest_received,SUM(CASE WHEN default_flag=1 THEN recoveries END)/NULLIF(SUM(pre_recovery_exposure),0) recovery_rate,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan GROUP BY grade;

-- name: subgrade_risk
SELECT sub_grade,COUNT(*) loans,SUM(resolved) resolved_loans,AVG(default_flag) default_rate,SUM(funded_amnt) funded_amount,AVG(int_rate)/100 coupon_rate,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan GROUP BY sub_grade HAVING SUM(resolved)>=100;

-- name: fico_risk
SELECT fico_band,COUNT(*) loans,SUM(resolved) resolved_loans,AVG(default_flag) default_rate,SUM(funded_amnt) funded_amount,AVG(int_rate)/100 coupon_rate,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan GROUP BY fico_band HAVING SUM(resolved)>=100;

-- name: dti_risk
SELECT dti_band,COUNT(*) loans,SUM(resolved) resolved_loans,AVG(default_flag) default_rate,SUM(funded_amnt) funded_amount,AVG(int_rate)/100 coupon_rate,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan GROUP BY dti_band HAVING SUM(resolved)>=100;

-- name: income_risk
SELECT income_band,COUNT(*) loans,SUM(resolved) resolved_loans,AVG(default_flag) default_rate,SUM(funded_amnt) funded_amount,AVG(int_rate)/100 coupon_rate,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan GROUP BY income_band HAVING SUM(resolved)>=100;

-- name: purpose_risk
SELECT purpose,COUNT(*) loans,SUM(resolved) resolved_loans,AVG(default_flag) default_rate,SUM(funded_amnt) funded_amount,AVG(int_rate)/100 coupon_rate,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan GROUP BY purpose HAVING SUM(resolved)>=100;

-- name: term_risk
SELECT term_months,COUNT(*) loans,SUM(resolved) resolved_loans,AVG(default_flag) default_rate,SUM(funded_amnt) funded_amount,AVG(int_rate)/100 coupon_rate,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan GROUP BY term_months HAVING SUM(resolved)>=100;

-- name: employment_risk
SELECT emp_length,COUNT(*) loans,SUM(resolved) resolved_loans,AVG(default_flag) default_rate,SUM(funded_amnt) funded_amount,AVG(int_rate)/100 coupon_rate,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan GROUP BY emp_length HAVING SUM(resolved)>=100;

-- name: home_risk
SELECT home_ownership,COUNT(*) loans,SUM(resolved) resolved_loans,AVG(default_flag) default_rate,SUM(funded_amnt) funded_amount,AVG(int_rate)/100 coupon_rate,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan GROUP BY home_ownership HAVING SUM(resolved)>=100;

-- name: verification_risk
SELECT verification_status,COUNT(*) loans,SUM(resolved) resolved_loans,AVG(default_flag) default_rate,SUM(funded_amnt) funded_amount,AVG(int_rate)/100 coupon_rate,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan GROUP BY verification_status HAVING SUM(resolved)>=100;

-- name: interest_risk
SELECT interest_band,COUNT(*) loans,SUM(resolved) resolved_loans,AVG(default_flag) default_rate,SUM(funded_amnt) funded_amount,AVG(int_rate)/100 coupon_rate,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan GROUP BY interest_band HAVING SUM(resolved)>=100;

-- name: vintage
SELECT issue_year,term_months,COUNT(*) loans,SUM(resolved) resolved_loans,AVG(current*1.0) current_share,AVG(default_flag) default_rate,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan GROUP BY issue_year,term_months;

-- name: status_mix
SELECT loan_status,COUNT(*) loans,SUM(funded_amnt) funded_amount FROM fact_loan GROUP BY loan_status;

-- name: recovery
SELECT grade,SUM(recoveries) recovery_cash,SUM(collection_recovery_fee) recovery_fees,SUM(pre_recovery_exposure) pre_recovery_exposure,SUM(recoveries)/NULLIF(SUM(pre_recovery_exposure),0) recovery_rate,SUM(unreturned_principal) unreturned_principal FROM fact_loan WHERE default_flag=1 GROUP BY grade;

-- name: grade_mix
SELECT issue_year,grade,COUNT(*) loans,SUM(funded_amnt) funded_amount FROM fact_loan GROUP BY issue_year,grade;

-- name: borrower_trend
SELECT issue_year,AVG(annual_inc) income,AVG(dti) dti,AVG(int_rate)/100 interest_rate,AVG(loan_amnt) amount FROM fact_loan GROUP BY issue_year;

-- name: worst_segments
SELECT grade,dti_band,term_months,COUNT(*) loans,SUM(resolved) resolved_loans,AVG(default_flag) default_rate,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan GROUP BY grade,dti_band,term_months HAVING SUM(resolved)>=100 ORDER BY default_rate DESC;

