-- CTEs, ranks, lag/lead and running totals.

-- name: loan_concentration
SELECT loan_id,funded_amnt,ROW_NUMBER() OVER(ORDER BY funded_amnt DESC,loan_id) loan_rank,SUM(funded_amnt) OVER(ORDER BY funded_amnt DESC,loan_id ROWS UNBOUNDED PRECEDING)/SUM(funded_amnt) OVER() cumulative_funding_share FROM fact_loan;

-- name: monthly_originations
WITH m AS (SELECT issue_month month,COUNT(*) loans,SUM(funded_amnt) funded_amount FROM fact_loan GROUP BY issue_month) SELECT *,LAG(funded_amount) OVER(ORDER BY month) prior_funding,SUM(funded_amount) OVER(ORDER BY month ROWS UNBOUNDED PRECEDING) cumulative_funding FROM m;

-- name: risk_return_rank
WITH g AS (SELECT grade,AVG(default_flag) default_rate,SUM(net_cash)/NULLIF(SUM(CASE WHEN resolved=1 THEN funded_amnt END),0) net_return_proxy FROM fact_loan GROUP BY grade) SELECT *,RANK() OVER(ORDER BY net_return_proxy DESC) return_rank,RANK() OVER(ORDER BY default_rate) risk_rank FROM g;

