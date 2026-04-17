# campus_lookup

`fetch_campuses.py` fetches the CSU COSAR campus endpoint and builds an expanded campus lookup CSV from it.

Usage:

```powershell
python fetch_campuses.py
```

This writes `campuses.csv` in the repo root by default.

Endpoint:

- Source URL: `https://cmsgwprd.cmsdc.calstate.edu/csu/rest/cosar/v1/campus`
- The endpoint returns fixed-width records.
- Observed record layout:
  - `1-2`: `campus_code`
  - `3-57`: `cosar_campus_name_long`
  - `58`: `cosar_academic_term`
  - `59-76`: `cosar_campus_name_abbrev`
  - `77-80`: trailing source value, ignored by the script

What The Script Builds:

- The API is the source of truth for the base COSAR fields:
  - `campus_code`
  - `cosar_campus_name_long`
  - `cosar_academic_term`
  - `cosar_campus_name_abbrev`
- The script derives the remaining fields by `campus_code` in Python.

How Rows Are Derived:

- The script starts with one row per campus returned by the endpoint.
- It applies column-by-column campus code mappings, rather than loading a full static lookup table row set.
- It appends two additional Humboldt rows after the base campus row:
  - one duplicate non-campus/non-CO/non-APDB row with `cirs_campus_name = HUMBOLDT`
  - one duplicate non-campus/non-CO/non-APDB row with `cirs_campus_name = POLYTECHNI`
- It sets `cirs_flag` based on whether `cirs_campus_name` is populated.

Column Context:

- The CSU Appendix I campus code table is the reference point for the relationship between campus full name, abbreviated campus name, campus alpha code, and campus numeric code.
- In the CSU Data Element Dictionary, `Campus Name, Abbreviated` is defined as the abbreviated campus name that corresponds to the campus alpha code and campus numeric code.
- `firms_state_agency_code` represents the State Agency Code used for state-facing financial reporting and reconciliation.
- `cs_database_name` and `hr_database_name` are the Campus Solutions and HR/CHRS production database names.
- `athena_abbrev`, `business_unit`, and `chrs_company` are PeopleSoft-based identifiers.

Columns:

- `campus_code`: CSU campus numeric code from the COSAR endpoint.
- `business_unit`: PeopleSoft business unit identifier.
- `hr_database_name`: HR / CHRS production database name.
- `chrs_company`: PeopleSoft company code.
- `athena_abbrev`: short PeopleSoft / Athena campus abbreviation.
- `cirs_campus_code`: CIRS campus numeric code.
- `cirs_alpha_code`: CIRS campus alpha code.
- `firms_state_agency_code`: State Agency Code used for state financial reporting and reconciliation.
- `firms_campus_id`: FIRMS campus identifier.
- `cosar_campus_name_long`: long campus name from COSAR.
- `cosar_academic_term`: academic term type from COSAR.
- `cosar_campus_name_abbrev`: abbreviated campus name from COSAR, with script overrides where needed.
- `campus_only_flag`: membership flag for campus-only rows.
- `campus_and_co_flag`: membership flag for rows included in the campus-and-Chancellor's-Office set.
- `apdb_campus_flag`: membership flag for APDB campus rows.
- `cs_database_name`: Campus Solutions production database name.
- `cirs_campus_name`: CIRS campus name / abbreviation.
- `chrs_cutover_date`: CHRS cutover date when applicable.
- `cirs_flag`: membership flag indicating whether the row participates in the CIRS naming set.

Flags:

- `campus_only_flag`: `true` when the row is part of the campus-only membership set.
- `campus_and_co_flag`: `true` when the row is part of the campus plus Chancellor's Office membership set.
- `apdb_campus_flag`: `true` when the row is part of the APDB membership set.
- `cirs_flag`: `true` when the row has a `cirs_campus_name` and should be treated as part of the CIRS membership set.

Current Output:

- Rows are sorted with `campus_and_co_flag = true` first, then by `cosar_campus_name_abbrev`.
- The output file is `campuses.csv`.
