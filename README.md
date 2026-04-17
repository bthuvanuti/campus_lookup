# campus_lookup

Fetches the CSU COSAR campus endpoint and converts its fixed-width records to CSV.

Usage:

```powershell
python fetch_campuses.py
```

This writes `campuses.csv` in the repo root by default.

Notes:

- The live endpoint currently returns 80-character records.
- The observed record layout is:
  - `1-2`: `campus_code`
  - `3-57`: `cosar_long_name`
  - `58`: `term_type`
  - `59-76`: `cosar_short_name`
  - `77-80`: trailing code in source data, ignored in the CSV output
