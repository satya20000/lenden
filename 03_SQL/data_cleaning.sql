-- Source transformations are reproducible in 04_Python. These SQL controls execute on the derived model.
-- name: duplicate_keys
SELECT loan_id,COUNT(*) copies FROM fact_loan GROUP BY loan_id HAVING COUNT(*)>1;

-- name: null_keys
SELECT COUNT(*) invalid_rows FROM fact_loan WHERE loan_id IS NULL;

