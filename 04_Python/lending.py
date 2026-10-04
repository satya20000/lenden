import pandas as pd
import numpy as np
from common import Context,date_dimension,rate

def lending(root):
    c=Context(root)
    nums=['loan_amnt','funded_amnt','int_rate','annual_inc','dti','total_pymnt','total_rec_prncp','total_rec_int','recoveries','collection_recovery_fee','revol_util','out_prncp','installment','delinq_2yrs','inq_last_6mths','open_acc','revol_bal','total_acc']
    f=c.read('loan.csv','id',numeric=nums);f=f.rename(columns={'id':'loan_id'})
    for col in ['issue_d','last_pymnt_d']:
        if col in f:f[col]=pd.to_datetime(f[col],format='%b-%y',errors='coerce')
    c.check('Issue dates parse',f.issue_d.notna().all());c.check('Funded amount positive',f.funded_amnt.gt(0).all());c.check('Interest plausible',f.int_rate.between(0,100).all())
    f['resolved']=f.loan_status.isin(['Fully Paid','Charged Off','Default']).astype(int)
    f['default_flag']=np.where(f.resolved==1,f.loan_status.isin(['Charged Off','Default']).astype(int),np.nan)
    f['fully_paid']=(f.loan_status=='Fully Paid').astype(int);f['current']=(f.loan_status=='Current').astype(int)
    f['term_months']=pd.to_numeric(f.term.str.extract(r'(\d+)')[0],errors='coerce');f['issue_year']=f.issue_d.dt.year;f['issue_month']=f.issue_d.dt.strftime('%Y-%m')
    f['issue_date']=f.issue_d.dt.strftime('%Y-%m-%d')
    f['dti_band']=pd.cut(f.dti,[-np.inf,10,20,30,np.inf],labels=['<=10','10-20','20-30','>30']).astype('object').fillna('Unknown')
    f['income_band']=pd.cut(f.annual_inc,[-np.inf,40000,80000,120000,np.inf],labels=['<=40k','40-80k','80-120k','>120k']).astype('object').fillna('Unknown')
    f['interest_band']=pd.cut(f.int_rate,[-np.inf,8,12,16,20,np.inf],labels=['<=8%','8-12%','12-16%','16-20%','>20%']).astype('object').fillna('Unknown')
    if {'fico_range_low','fico_range_high'}.issubset(f.columns):
        f['fico']=(pd.to_numeric(f.fico_range_low,errors='coerce')+pd.to_numeric(f.fico_range_high,errors='coerce'))/2;f['fico_band']=pd.cut(f.fico,[0,640,680,720,760,850],labels=['<=640','640-680','680-720','720-760','760-850']).astype('object').fillna('Unknown')
    else:f['fico']=np.nan;f['fico_band']='Unavailable in release'
    # total_pymnt already includes recoveries. Never add recoveries a second time.
    f['net_cash']=(f.total_pymnt-f.collection_recovery_fee.fillna(0)-f.funded_amnt).where(f.resolved==1)
    f['unreturned_principal']=(f.funded_amnt-f.total_rec_prncp-f.recoveries).clip(lower=0).where(f.default_flag==1)
    # Recovery denominator is pre-recovery unrepaid principal, not total originated default principal.
    f['pre_recovery_exposure']=(f.funded_amnt-f.total_rec_prncp).clip(lower=0).where(f.default_flag==1)
    keep=['loan_id']+[x for x in nums if x in f]+['grade','sub_grade','emp_length','home_ownership','verification_status','purpose','issue_d','issue_date','last_pymnt_d','loan_status','resolved','default_flag','fully_paid','current','term_months','issue_year','issue_month','dti_band','income_band','interest_band','fico','fico_band','net_cash','unreturned_principal','pre_recovery_exposure']
    c.add('fact_loan',f[keep]);c.add('dim_grade',pd.DataFrame({'grade':sorted(f.grade.unique())}));c.add('dim_date',date_dimension(f.issue_d.min(),f.issue_d.max()))
    c.run_sql();resolved=f[f.resolved==1];grade=c.results['grade_risk_return'];best=grade.sort_values('net_return_proxy',ascending=False).iloc[0]
    c.findings=[f'{len(f):,} loans in the {f.issue_year.min()}-{f.issue_year.max()} release funded USD {f.funded_amnt.sum():,.0f}.',f'{len(resolved):,} resolved loans had {int(resolved.default_flag.sum()):,} charged-off outcomes ({resolved.default_flag.mean():.2%}).',f'{f.current.sum():,} current loans ({f.current.mean():.2%}) were excluded from resolved-outcome default and return rates.',f'Grade {best.grade} had the highest observed resolved-loan net cash return proxy ({best.net_return_proxy:.2%}); this is cumulative and not annualized.',f'Resolved net cash return proxy was {rate(resolved.net_cash.sum(),resolved.funded_amnt.sum()):.2%} before servicing fees, tax and time value.',f'Origination FICO is absent in this release. FICO analysis and average FICO are explicitly unavailable.']
    c.recommendations=['Use the grade risk-return table to design diversification limits, then calculate dated cash-flow IRR and fees before making allocation decisions.','Investigate high-default purpose and DTI segments only after controlling for grade, term and vintage.','Compare vintages within matched loan terms and maturity windows; snapshot outcomes alone cannot establish underwriting improvement.','Add a release containing origination FICO and loan payment schedules to complete credit-score and annualized return analysis.']
    f[['loan_amnt','int_rate','dti','annual_inc','revol_util']].corr(method='spearman').to_csv(c.root/'08_Documentation/spearman_correlations.csv')
    c.bar(grade,'grade','default_rate','Resolved-loan default rate by grade','grade_default.png');c.bar(grade,'grade','net_return_proxy','Resolved cumulative net cash return proxy; not IRR','grade_return.png');c.bar(c.results['vintage'],'issue_year','default_rate','Snapshot resolved default rate by origination year','vintage.png');c.bar(c.results['purpose_risk'].sort_values('default_rate',ascending=False),'purpose','default_rate','Resolved default rate by purpose; minimum 100 outcomes','purpose_risk.png');c.export_audit();return c
