# Metric definitions and exclusions

- Selected older accepted-loan release covers 2007-2011, not the full 2018Q4 release. Outcomes are a historical snapshot, not current borrower status.
- Origination FICO fields are absent. FICO bands and average FICO are unavailable, not imputed.
- Current loans are unresolved. Default and return denominators include only Fully Paid and Charged Off/Default.
- Net cash return proxy is cumulative and funding-weighted, not annualized IRR or a volatility-adjusted ratio. Servicing fees, tax and dated cash-flow timing are unavailable.
- total_pymnt includes recoveries. Adding recoveries again would double-count cash. Collection recovery fees are subtracted.
- Grade, term and maturity differences confound vintage comparisons. No causal underwriting deterioration or investment recommendation is claimed.

Default = Charged Off or Default. Resolved = Fully Paid or Default/Charged Off. Default rate = default count / resolved count. Funded amount uses funded_amnt, not investor allocation. Net return proxy = sum(total_pymnt - collection_recovery_fee - funded_amnt) / sum(funded_amnt) on resolved loans only. total_pymnt already includes recoveries. Recovery rate = recoveries on defaults / max(funded_amnt - total_rec_prncp, 0) before recovery. Net unreturned principal = max(funded_amnt - total_rec_prncp - recoveries, 0) on defaults. Coupon average is an unweighted loan average. Missing FICO is not a score of zero.
