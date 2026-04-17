* Campus lookup build from CSU COSAR endpoint.
* Writes the expanded campus lookup CSV using SPSS syntax plus a short Python download step.
* Requires IBM SPSS Statistics with Python integration enabled.

BEGIN PROGRAM Python3.
import urllib.request

source_url = "https://cmsgwprd.cmsdc.calstate.edu/csu/rest/cosar/v1/campus"
target_path = r"C:\staging\campus_lookup\campus_raw.txt"

with urllib.request.urlopen(source_url) as response:
    content = response.read().decode("utf-8")

with open(target_path, "w", encoding="utf-8", newline="\n") as handle:
    handle.write(content)
END PROGRAM.

DATA LIST FIXED FILE="C:\staging\campus_lookup\campus_raw.txt"
 /campus_code (A2) 1-2
  cosar_campus_name_long (A55) 3-57
  cosar_academic_term (A1) 58
  cosar_campus_name_abbrev (A18) 59-76.

STRING
 business_unit (A8)
 hr_database_name (A8)
 chrs_company (A3)
 athena_abbrev (A2)
 cirs_campus_code (A2)
 cirs_alpha_code (A1)
 firms_state_agency_code (A4)
 firms_campus_id (A2)
 campus_only_flag (A5)
 campus_and_co_flag (A5)
 apdb_campus_flag (A5)
 cs_database_name (A8)
 cirs_campus_name (A10)
 chrs_cutover_date (A10)
 cirs_flag (A5).

COMPUTE business_unit = "".
COMPUTE hr_database_name = "".
COMPUTE chrs_company = "".
COMPUTE athena_abbrev = "".
COMPUTE cirs_campus_code = "".
COMPUTE cirs_alpha_code = "".
COMPUTE firms_state_agency_code = "".
COMPUTE firms_campus_id = "".
COMPUTE campus_only_flag = "false".
COMPUTE campus_and_co_flag = "false".
COMPUTE apdb_campus_flag = "false".
COMPUTE cs_database_name = "".
COMPUTE cirs_campus_name = "".
COMPUTE chrs_cutover_date = "".
COMPUTE cirs_flag = "false".

DO IF campus_code = "01".
  COMPUTE cosar_campus_name_abbrev = "Chancellor's Office".
END IF.

DO REPEAT code = "01" "05" "06" "07" "10" "15" "20" "25" "30" "35" "40" "45" "50" "55" "60" "63" "65" "66" "68" "70" "73" "75" "80" "85" "90" "94"
 /value = "COCSU" "HW001" "MB000" "MACMP" "POCMP" "SLCMP" "CHICO" "FRSNO" "HMCMP" "BKCMP" "LBCMP" "CSULA" "FLCMP" "DHCMP" "SACST" "SBCMP" "SDCMP" "SDCMP" "SMCMP" "NRCMP" "CICMP" "SFCMP" "SJ000" "SOCMP" "STCMP" "SJ000".
  IF campus_code = code business_unit = value.
END REPEAT.

DO REPEAT code = "01" "05" "06" "07" "10" "15" "20" "25" "30" "35" "40" "45" "50" "55" "60" "63" "65" "66" "68" "70" "73" "75" "80" "85" "90" "94"
 /value = "lb" "eb" "mb" "ma" "po" "sl" "ch" "fr" "hm" "bk" "lb" "la" "fl" "dh" "sa" "sb" "sd" "sd" "sm" "nr" "ci" "sf" "sj" "so" "st" "sj".
  IF campus_code = code athena_abbrev = value.
END REPEAT.

DO REPEAT code = "01" "05" "15" "25" "30" "40" "45" "65" "66" "70" "75" "80" "85" "94"
 /value = "hlbprd" "hebprd" "hsloprd" "hfrprd" "hhumprd" "hlbprd" "hlaprd" "hsdprd" "hsdprd" "hnrprd" "hsfprd" "hsjprd" "hsonprd" "hsjprd".
  IF campus_code = code hr_database_name = value.
END REPEAT.

DO REPEAT code = "06" "07" "10" "20" "35" "50" "55" "60" "63" "68" "73" "90"
 /value = "MBY" "CMA" "CPP" "CHI" "BAK" "FUL" "DOM" "SAC" "SBU" "CSM" "CIS" "STA".
  IF campus_code = code chrs_company = value.
END REPEAT.

IF chrs_company <> "" hr_database_name = "hchrprd".

DO REPEAT code = "01" "05" "06" "07" "10" "15" "20" "25" "30" "35" "40" "45" "50" "55" "60" "63" "65" "66" "68" "70" "73" "75" "80" "85" "90" "94"
 /value = "clbprd" "cebprd" "cmbprd" "cmaprd" "cpomprd" "csloprd" "cchiprd" "cfrprd" "chumprd" "cbakprd" "clbprd" "claprd" "cfulprd" "cdhprd" "csacprd" "csbprd" "csdprd" "csdprd" "csmprd" "cnrprd" "cciprd" "csfprd" "csjprd" "csonprd" "cstaprd" "csjprd".
  IF campus_code = code cs_database_name = value.
END REPEAT.

DO REPEAT code = "01" "05" "06" "07" "10" "15" "20" "25" "30" "35" "40" "45" "50" "55" "60" "63" "65" "66" "68" "70" "73" "75" "80" "85" "90" "94"
 /value = "40" "05" "06" "07" "10" "15" "20" "25" "30" "35" "40" "45" "50" "55" "60" "63" "65" "65" "68" "70" "72" "75" "80" "85" "90" "80".
  IF campus_code = code cirs_campus_code = value.
END REPEAT.

DO REPEAT code = "01" "05" "06" "07" "10" "15" "20" "25" "30" "35" "40" "45" "50" "55" "60" "63" "65" "66" "68" "70" "73" "75" "80" "85" "90" "94"
 /value = "A" "B" "V" "W" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "O" "U" "P" "Y" "Q" "R" "S" "T" "R".
  IF campus_code = code cirs_alpha_code = value.
END REPEAT.

DO REPEAT code = "01" "05" "06" "07" "10" "15" "20" "25" "30" "35" "40" "45" "50" "55" "60" "63" "65" "68" "70" "73" "75" "80" "85" "90" "95" "99"
 /value = "6620" "6720" "6756" "6752" "6770" "6820" "6680" "6700" "6730" "6650" "6740" "6750" "6710" "6690" "6780" "6660" "6790" "6840" "6760" "6850" "6800" "6810" "6830" "6670" "6620" "9999".
  IF campus_code = code firms_state_agency_code = value.
END REPEAT.

DO REPEAT code = "01" "05" "06" "07" "10" "15" "20" "25" "30" "35" "40" "45" "50" "55" "60" "63" "65" "68" "70" "73" "75" "80" "85" "90" "95" "99"
 /value = "CO" "EB" "MB" "MA" "PO" "SL" "CH" "FR" "HM" "BK" "LB" "LA" "FL" "DH" "SA" "SB" "SD" "SM" "NR" "CI" "SF" "SJ" "SO" "ST" "CW" "CB".
  IF campus_code = code firms_campus_id = value.
END REPEAT.

DO REPEAT code = "01" "05" "06" "07" "10" "15" "20" "25" "30" "35" "40" "45" "50" "55" "60" "63" "65" "68" "70" "73" "75" "80" "85" "90"
 /value = "CHNCLR OFF" "EAST BAY" "MONTEREY" "MARITIME" "POMONA" "SLO" "CHICO" "FRESNO" "HUMBOLDT" "BKERSFIELD" "LONG BEACH" "LA" "FULLERTON" "DOMINGUEZ" "SACRAMENTO" "SAN BERN" "SAN DIEGO" "SAN MARCOS" "NORTHRIDGE" "CHANNEL IS" "SAN FRAN" "SAN JOSE" "SONOMA" "STNISLAUS".
  IF campus_code = code cirs_campus_name = value.
END REPEAT.

DO REPEAT code = "06" "07" "10" "20" "35" "50" "55" "60" "63" "68" "73" "90"
 /value = "2026-03-22" "2023-11-12" "2026-03-22" "2025-03-23" "2026-03-22" "2023-11-12" "2026-03-22" "2025-03-23" "2025-03-23" "2026-03-22" "2023-11-12" "2023-11-12".
  IF campus_code = code chrs_cutover_date = value.
END REPEAT.

DO REPEAT code = "05" "06" "07" "10" "15" "20" "25" "30" "35" "40" "45" "50" "55" "60" "63" "65" "68" "70" "73" "75" "80" "85" "90".
  IF campus_code = code campus_only_flag = "true".
END REPEAT.

DO REPEAT code = "01" "05" "06" "07" "10" "15" "20" "25" "30" "35" "40" "45" "50" "55" "60" "63" "65" "68" "70" "73" "75" "80" "85" "90".
  IF campus_code = code campus_and_co_flag = "true".
END REPEAT.

DO REPEAT code = "05" "06" "07" "10" "15" "20" "25" "30" "35" "40" "45" "50" "55" "60" "63" "65" "66" "68" "70" "73" "75" "80" "85" "90" "94".
  IF campus_code = code apdb_campus_flag = "true".
END REPEAT.

IF cirs_campus_name <> "" cirs_flag = "true".
EXECUTE.

DATASET NAME BaseCampusRows.

DATASET DECLARE ExtraRows.
DATASET ACTIVATE BaseCampusRows.
DATASET COPY ExtraRows.
DATASET ACTIVATE ExtraRows.
SELECT IF campus_code = "30".
SORT CASES BY campus_code.
SELECT IF $CASENUM = 1.
COMPUTE campus_only_flag = "false".
COMPUTE campus_and_co_flag = "false".
COMPUTE apdb_campus_flag = "false".
DATASET COPY PolytechniRow.

DATASET ACTIVATE PolytechniRow.
COMPUTE cirs_campus_name = "POLYTECHNI".
EXECUTE.

DATASET ACTIVATE ExtraRows.
ADD FILES /FILE=* /FILE=PolytechniRow.
EXECUTE.

DATASET ACTIVATE BaseCampusRows.
ADD FILES /FILE=* /FILE=ExtraRows.
EXECUTE.

IF cirs_campus_name <> "" cirs_flag = "true".
EXECUTE.

COMPUTE campus_and_co_sort = (campus_and_co_flag = "true").
COMPUTE campus_only_sort = (campus_only_flag = "true").
COMPUTE humboldt_sort = (cirs_campus_name = "HUMBOLDT").
SORT CASES BY campus_and_co_sort (D) cosar_campus_name_abbrev (A) campus_only_sort (D) humboldt_sort (D) cirs_campus_name (A) campus_code (A).

DELETE VARIABLES campus_and_co_sort campus_only_sort humboldt_sort.

SAVE TRANSLATE
 /TYPE=CSV
 /OUTFILE="C:\staging\campus_lookup\campuses.csv"
 /REPLACE
 /FIELDNAMES
 /CELLS=VALUES.
