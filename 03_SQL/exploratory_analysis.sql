-- name: row_count
SELECT COUNT(*) rows FROM fact_loan;

-- name: date_coverage
SELECT MIN(issue_d) first_date,MAX(issue_d) last_date FROM fact_loan;

