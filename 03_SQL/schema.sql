-- SQLite 3.25+; populated by pipeline.py, CSV dates are ISO strings.
CREATE TABLE "fact_loan" (
 "loan_id" INTEGER,
 "loan_amnt" INTEGER,
 "funded_amnt" INTEGER,
 "int_rate" REAL,
 "annual_inc" REAL,
 "dti" REAL,
 "total_pymnt" REAL,
 "total_rec_prncp" REAL,
 "total_rec_int" REAL,
 "recoveries" REAL,
 "collection_recovery_fee" REAL,
 "revol_util" REAL,
 "out_prncp" REAL,
 "installment" REAL,
 "delinq_2yrs" INTEGER,
 "inq_last_6mths" INTEGER,
 "open_acc" INTEGER,
 "revol_bal" INTEGER,
 "total_acc" INTEGER,
 "grade" TEXT,
 "sub_grade" TEXT,
 "emp_length" TEXT,
 "home_ownership" TEXT,
 "verification_status" TEXT,
 "purpose" TEXT,
 "issue_d" TEXT,
 "issue_date" TEXT,
 "last_pymnt_d" TEXT,
 "loan_status" TEXT,
 "resolved" INTEGER,
 "default_flag" REAL,
 "fully_paid" INTEGER,
 "current" INTEGER,
 "term_months" INTEGER,
 "issue_year" INTEGER,
 "issue_month" TEXT,
 "dti_band" TEXT,
 "income_band" TEXT,
 "interest_band" TEXT,
 "fico" REAL,
 "fico_band" TEXT,
 "net_cash" REAL,
 "unreturned_principal" REAL,
 "pre_recovery_exposure" REAL
);

CREATE TABLE "dim_grade" (
 "grade" TEXT
);

CREATE TABLE "dim_date" (
 "date" TEXT,
 "year" INTEGER,
 "month" TEXT,
 "quarter" INTEGER,
 "month_number" INTEGER
);