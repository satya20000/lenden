# Relationship map

```mermaid
erDiagram
 dim_grade ||--o{ fact_loan : "grade to grade"
 dim_date ||--o{ fact_loan : "date to issue_date"
```

Use 06_PowerBI/relationships.csv for implementation. Logical keys are checked in the loader and duplicate_keys SQL controls. ISO date-only keys relate to dim_date[date].
