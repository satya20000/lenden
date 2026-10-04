# Power BI build package

No Power BI Desktop was run. No .pbix or Power BI screenshot is claimed. Python previews are labeled explicitly.

## Import and types
Create a text parameter `DataFolder` pointing to 02_Cleaned_Data. Create function `LoadTable` from power_query.m. For every cleaned CSV create a query `LoadTable("fact_lead")`, replacing the table name. All CSVs are final cleaned exports, not raw data; major transformations live in Python. Apply types from column_types.json; parse dates with locale en-US. Hide row keys. Set numerical attributes to Do not summarize unless measures are used. Mark dim_date as date table.

## Relationships
Use relationships.csv. Single-direction filters only. Verify one-side uniqueness before activation.

FICO not available: include a text note rather than an empty FICO chart. Vintage charts require a loan-term slicer and unresolved-share tooltip. Net return proxy is cumulative cash divided by resolved original funding, not annualized performance.

## Layout and interactions
Each page is 1280 x 720, white background, 24 px margins. Header at y=20, page title 24 pt. At most 5 KPI cards in a 96 px row. Use two or three charts below; axes 11 pt minimum. Synced slicers on left for dates and relevant dimension. Add denominator and coverage tooltips to rates. Chart selections cross-filter charts on the same page. Provide reset filters bookmark and accessible alt text. No red/green-only encoding. Use Top N 15 plus detail drillthrough rather than overcrowded bars.

## Page and visual specifications

### Portfolio Overview

| Visual | DAX measures | Business question | Source/axis |
|---|---|---|---|
| KPI cards | Total Loans; Funded Amount; Average Interest Rate; Default Rate; Payments Received | What is the historical portfolio scale and loss rate? | fact_loan |
| Bar | Funded Amount | How is funding split across grades? | dim_grade[grade] |
| Bar | Total Loans | How many outcomes remain unresolved? | fact_loan[loan_status] |

### Credit Risk

| Visual | DAX measures | Business question | Source/axis |
|---|---|---|---|
| Bar | Default Rate | Which grade has more realized losses? | dim_grade[grade] |
| Bar | Default Rate | Which DTI segments require review? | fact_loan[dti_band] |
| Matrix | Default Rate; Resolved Loans | How do term and purpose differ? | fact_loan[term_months,purpose] |

### Risk versus Return

| Visual | DAX measures | Business question | Source/axis |
|---|---|---|---|
| Scatter | Default Rate; Net Return Proxy; Funded Amount | How do historical grade risk and cash return trade off? | dim_grade[grade] |
| Matrix | Average Interest Rate; Default Rate; Net Return Proxy | Does a higher coupon coincide with better observed cash return? | dim_grade[grade] |
| Bar | Recovery Rate | How much default exposure was recovered? | dim_grade[grade] |

### Portfolio Trends

| Visual | DAX measures | Business question | Source/axis |
|---|---|---|---|
| Line | Funded Amount; Total Loans | How did originations grow? | dim_date[year] |
| Line | Default Rate; Current Share | How do matched-term vintage outcomes differ? | fact_loan[issue_year,term_months] |
| Stacked column | Funded Amount | How did the grade mix change? | dim_grade[grade] |

## Acceptance checks
Match all unfiltered cards to 03_SQL/results/portfolio_kpis.csv (KKBOX uses monthly_subscription.csv). Test a single dimension, two combined filters and an empty selection. Verify rates recalculate from numerator/denominator, rather than mean of group rates. For CX compare distinct orders before/after bridge selection. For loans active outcomes must stay out of default denominators. Drillthrough to underlying rows and reset filters. DAX and Power Query assets have not been executed in Power BI Desktop.
