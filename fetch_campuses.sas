%let source_url=https://cmsgwprd.cmsdc.calstate.edu/csu/rest/cosar/v1/campus;
%let raw_file=C:\staging\campus_lookup\campus_raw.txt;
%let output_csv=C:\staging\campus_lookup\campuses.csv;

filename campusraw "&raw_file.";

proc http
  url="&source_url."
  method="GET"
  out=campusraw;
run;

data campus_base;
  infile campusraw lrecl=256 truncover;
  length
    campus_code $2
    business_unit $8
    hr_database_name $8
    chrs_company $3
    athena_abbrev $2
    cirs_campus_code $2
    cirs_alpha_code $1
    firms_state_agency_code $4
    firms_campus_id $2
    cosar_campus_name_long $55
    cosar_academic_term $1
    cosar_campus_name_abbrev $20
    campus_only_flag $5
    campus_and_co_flag $5
    apdb_campus_flag $5
    cs_database_name $8
    cirs_campus_name $10
    chrs_cutover_date $10
    cirs_flag $5
  ;

  input
    @1 campus_code $2.
    @3 cosar_campus_name_long $55.
    @58 cosar_academic_term $1.
    @59 cosar_campus_name_abbrev $18.
  ;

  cosar_campus_name_long = strip(cosar_campus_name_long);
  cosar_academic_term = strip(cosar_academic_term);
  cosar_campus_name_abbrev = strip(cosar_campus_name_abbrev);

  business_unit = "";
  hr_database_name = "";
  chrs_company = "";
  athena_abbrev = "";
  cirs_campus_code = "";
  cirs_alpha_code = "";
  firms_state_agency_code = "";
  firms_campus_id = "";
  campus_only_flag = "false";
  campus_and_co_flag = "false";
  apdb_campus_flag = "false";
  cs_database_name = "";
  cirs_campus_name = "";
  chrs_cutover_date = "";
  cirs_flag = "false";

  if campus_code = "01" then cosar_campus_name_abbrev = "Chancellor's Office";

  select (campus_code);
    when ("01") business_unit = "COCSU";
    when ("05") business_unit = "HW001";
    when ("06") business_unit = "MB000";
    when ("07") business_unit = "MACMP";
    when ("10") business_unit = "POCMP";
    when ("15") business_unit = "SLCMP";
    when ("20") business_unit = "CHICO";
    when ("25") business_unit = "FRSNO";
    when ("30") business_unit = "HMCMP";
    when ("35") business_unit = "BKCMP";
    when ("40") business_unit = "LBCMP";
    when ("45") business_unit = "CSULA";
    when ("50") business_unit = "FLCMP";
    when ("55") business_unit = "DHCMP";
    when ("60") business_unit = "SACST";
    when ("63") business_unit = "SBCMP";
    when ("65") business_unit = "SDCMP";
    when ("66") business_unit = "SDCMP";
    when ("68") business_unit = "SMCMP";
    when ("70") business_unit = "NRCMP";
    when ("73") business_unit = "CICMP";
    when ("75") business_unit = "SFCMP";
    when ("80") business_unit = "SJ000";
    when ("85") business_unit = "SOCMP";
    when ("90") business_unit = "STCMP";
    when ("94") business_unit = "SJ000";
    otherwise;
  end;

  select (campus_code);
    when ("01") athena_abbrev = "lb";
    when ("05") athena_abbrev = "eb";
    when ("06") athena_abbrev = "mb";
    when ("07") athena_abbrev = "ma";
    when ("10") athena_abbrev = "po";
    when ("15") athena_abbrev = "sl";
    when ("20") athena_abbrev = "ch";
    when ("25") athena_abbrev = "fr";
    when ("30") athena_abbrev = "hm";
    when ("35") athena_abbrev = "bk";
    when ("40") athena_abbrev = "lb";
    when ("45") athena_abbrev = "la";
    when ("50") athena_abbrev = "fl";
    when ("55") athena_abbrev = "dh";
    when ("60") athena_abbrev = "sa";
    when ("63") athena_abbrev = "sb";
    when ("65") athena_abbrev = "sd";
    when ("66") athena_abbrev = "sd";
    when ("68") athena_abbrev = "sm";
    when ("70") athena_abbrev = "nr";
    when ("73") athena_abbrev = "ci";
    when ("75") athena_abbrev = "sf";
    when ("80") athena_abbrev = "sj";
    when ("85") athena_abbrev = "so";
    when ("90") athena_abbrev = "st";
    when ("94") athena_abbrev = "sj";
    otherwise;
  end;

  select (campus_code);
    when ("01") hr_database_name = "hlbprd";
    when ("05") hr_database_name = "hebprd";
    when ("15") hr_database_name = "hsloprd";
    when ("25") hr_database_name = "hfrprd";
    when ("30") hr_database_name = "hhumprd";
    when ("40") hr_database_name = "hlbprd";
    when ("45") hr_database_name = "hlaprd";
    when ("65") hr_database_name = "hsdprd";
    when ("66") hr_database_name = "hsdprd";
    when ("70") hr_database_name = "hnrprd";
    when ("75") hr_database_name = "hsfprd";
    when ("80") hr_database_name = "hsjprd";
    when ("85") hr_database_name = "hsonprd";
    when ("94") hr_database_name = "hsjprd";
    otherwise;
  end;

  select (campus_code);
    when ("06") chrs_company = "MBY";
    when ("07") chrs_company = "CMA";
    when ("10") chrs_company = "CPP";
    when ("20") chrs_company = "CHI";
    when ("35") chrs_company = "BAK";
    when ("50") chrs_company = "FUL";
    when ("55") chrs_company = "DOM";
    when ("60") chrs_company = "SAC";
    when ("63") chrs_company = "SBU";
    when ("68") chrs_company = "CSM";
    when ("73") chrs_company = "CIS";
    when ("90") chrs_company = "STA";
    otherwise;
  end;

  if chrs_company ne "" then hr_database_name = "hchrprd";

  select (campus_code);
    when ("01") cs_database_name = "clbprd";
    when ("05") cs_database_name = "cebprd";
    when ("06") cs_database_name = "cmbprd";
    when ("07") cs_database_name = "cmaprd";
    when ("10") cs_database_name = "cpomprd";
    when ("15") cs_database_name = "csloprd";
    when ("20") cs_database_name = "cchiprd";
    when ("25") cs_database_name = "cfrprd";
    when ("30") cs_database_name = "chumprd";
    when ("35") cs_database_name = "cbakprd";
    when ("40") cs_database_name = "clbprd";
    when ("45") cs_database_name = "claprd";
    when ("50") cs_database_name = "cfulprd";
    when ("55") cs_database_name = "cdhprd";
    when ("60") cs_database_name = "csacprd";
    when ("63") cs_database_name = "csbprd";
    when ("65") cs_database_name = "csdprd";
    when ("66") cs_database_name = "csdprd";
    when ("68") cs_database_name = "csmprd";
    when ("70") cs_database_name = "cnrprd";
    when ("73") cs_database_name = "cciprd";
    when ("75") cs_database_name = "csfprd";
    when ("80") cs_database_name = "csjprd";
    when ("85") cs_database_name = "csonprd";
    when ("90") cs_database_name = "cstaprd";
    when ("94") cs_database_name = "csjprd";
    otherwise;
  end;

  select (campus_code);
    when ("01") cirs_campus_code = "40";
    when ("05") cirs_campus_code = "05";
    when ("06") cirs_campus_code = "06";
    when ("07") cirs_campus_code = "07";
    when ("10") cirs_campus_code = "10";
    when ("15") cirs_campus_code = "15";
    when ("20") cirs_campus_code = "20";
    when ("25") cirs_campus_code = "25";
    when ("30") cirs_campus_code = "30";
    when ("35") cirs_campus_code = "35";
    when ("40") cirs_campus_code = "40";
    when ("45") cirs_campus_code = "45";
    when ("50") cirs_campus_code = "50";
    when ("55") cirs_campus_code = "55";
    when ("60") cirs_campus_code = "60";
    when ("63") cirs_campus_code = "63";
    when ("65") cirs_campus_code = "65";
    when ("66") cirs_campus_code = "65";
    when ("68") cirs_campus_code = "68";
    when ("70") cirs_campus_code = "70";
    when ("73") cirs_campus_code = "72";
    when ("75") cirs_campus_code = "75";
    when ("80") cirs_campus_code = "80";
    when ("85") cirs_campus_code = "85";
    when ("90") cirs_campus_code = "90";
    when ("94") cirs_campus_code = "80";
    otherwise;
  end;

  select (campus_code);
    when ("01") cirs_alpha_code = "A";
    when ("05") cirs_alpha_code = "B";
    when ("06") cirs_alpha_code = "V";
    when ("07") cirs_alpha_code = "W";
    when ("10") cirs_alpha_code = "C";
    when ("15") cirs_alpha_code = "D";
    when ("20") cirs_alpha_code = "E";
    when ("25") cirs_alpha_code = "F";
    when ("30") cirs_alpha_code = "G";
    when ("35") cirs_alpha_code = "H";
    when ("40") cirs_alpha_code = "I";
    when ("45") cirs_alpha_code = "J";
    when ("50") cirs_alpha_code = "K";
    when ("55") cirs_alpha_code = "L";
    when ("60") cirs_alpha_code = "M";
    when ("63") cirs_alpha_code = "N";
    when ("65") cirs_alpha_code = "O";
    when ("66") cirs_alpha_code = "O";
    when ("68") cirs_alpha_code = "U";
    when ("70") cirs_alpha_code = "P";
    when ("73") cirs_alpha_code = "Y";
    when ("75") cirs_alpha_code = "Q";
    when ("80") cirs_alpha_code = "R";
    when ("85") cirs_alpha_code = "S";
    when ("90") cirs_alpha_code = "T";
    when ("94") cirs_alpha_code = "R";
    otherwise;
  end;

  select (campus_code);
    when ("01") firms_state_agency_code = "6620";
    when ("05") firms_state_agency_code = "6720";
    when ("06") firms_state_agency_code = "6756";
    when ("07") firms_state_agency_code = "6752";
    when ("10") firms_state_agency_code = "6770";
    when ("15") firms_state_agency_code = "6820";
    when ("20") firms_state_agency_code = "6680";
    when ("25") firms_state_agency_code = "6700";
    when ("30") firms_state_agency_code = "6730";
    when ("35") firms_state_agency_code = "6650";
    when ("40") firms_state_agency_code = "6740";
    when ("45") firms_state_agency_code = "6750";
    when ("50") firms_state_agency_code = "6710";
    when ("55") firms_state_agency_code = "6690";
    when ("60") firms_state_agency_code = "6780";
    when ("63") firms_state_agency_code = "6660";
    when ("65") firms_state_agency_code = "6790";
    when ("68") firms_state_agency_code = "6840";
    when ("70") firms_state_agency_code = "6760";
    when ("73") firms_state_agency_code = "6850";
    when ("75") firms_state_agency_code = "6800";
    when ("80") firms_state_agency_code = "6810";
    when ("85") firms_state_agency_code = "6830";
    when ("90") firms_state_agency_code = "6670";
    when ("95") firms_state_agency_code = "6620";
    when ("99") firms_state_agency_code = "9999";
    otherwise;
  end;

  select (campus_code);
    when ("01") firms_campus_id = "CO";
    when ("05") firms_campus_id = "EB";
    when ("06") firms_campus_id = "MB";
    when ("07") firms_campus_id = "MA";
    when ("10") firms_campus_id = "PO";
    when ("15") firms_campus_id = "SL";
    when ("20") firms_campus_id = "CH";
    when ("25") firms_campus_id = "FR";
    when ("30") firms_campus_id = "HM";
    when ("35") firms_campus_id = "BK";
    when ("40") firms_campus_id = "LB";
    when ("45") firms_campus_id = "LA";
    when ("50") firms_campus_id = "FL";
    when ("55") firms_campus_id = "DH";
    when ("60") firms_campus_id = "SA";
    when ("63") firms_campus_id = "SB";
    when ("65") firms_campus_id = "SD";
    when ("68") firms_campus_id = "SM";
    when ("70") firms_campus_id = "NR";
    when ("73") firms_campus_id = "CI";
    when ("75") firms_campus_id = "SF";
    when ("80") firms_campus_id = "SJ";
    when ("85") firms_campus_id = "SO";
    when ("90") firms_campus_id = "ST";
    when ("95") firms_campus_id = "CW";
    when ("99") firms_campus_id = "CB";
    otherwise;
  end;

  select (campus_code);
    when ("01") cirs_campus_name = "CHNCLR OFF";
    when ("05") cirs_campus_name = "EAST BAY";
    when ("06") cirs_campus_name = "MONTEREY";
    when ("07") cirs_campus_name = "MARITIME";
    when ("10") cirs_campus_name = "POMONA";
    when ("15") cirs_campus_name = "SLO";
    when ("20") cirs_campus_name = "CHICO";
    when ("25") cirs_campus_name = "FRESNO";
    when ("30") cirs_campus_name = "HUMBOLDT";
    when ("35") cirs_campus_name = "BKERSFIELD";
    when ("40") cirs_campus_name = "LONG BEACH";
    when ("45") cirs_campus_name = "LA";
    when ("50") cirs_campus_name = "FULLERTON";
    when ("55") cirs_campus_name = "DOMINGUEZ";
    when ("60") cirs_campus_name = "SACRAMENTO";
    when ("63") cirs_campus_name = "SAN BERN";
    when ("65") cirs_campus_name = "SAN DIEGO";
    when ("68") cirs_campus_name = "SAN MARCOS";
    when ("70") cirs_campus_name = "NORTHRIDGE";
    when ("73") cirs_campus_name = "CHANNEL IS";
    when ("75") cirs_campus_name = "SAN FRAN";
    when ("80") cirs_campus_name = "SAN JOSE";
    when ("85") cirs_campus_name = "SONOMA";
    when ("90") cirs_campus_name = "STNISLAUS";
    otherwise;
  end;

  select (campus_code);
    when ("06") chrs_cutover_date = "2026-03-22";
    when ("07") chrs_cutover_date = "2023-11-12";
    when ("10") chrs_cutover_date = "2026-03-22";
    when ("20") chrs_cutover_date = "2025-03-23";
    when ("35") chrs_cutover_date = "2026-03-22";
    when ("50") chrs_cutover_date = "2023-11-12";
    when ("55") chrs_cutover_date = "2026-03-22";
    when ("60") chrs_cutover_date = "2025-03-23";
    when ("63") chrs_cutover_date = "2025-03-23";
    when ("68") chrs_cutover_date = "2026-03-22";
    when ("73") chrs_cutover_date = "2023-11-12";
    when ("90") chrs_cutover_date = "2023-11-12";
    otherwise;
  end;

  if campus_code in ("05","06","07","10","15","20","25","30","35","40","45","50","55","60","63","65","68","70","73","75","80","85","90")
    then campus_only_flag = "true";

  if campus_code in ("01","05","06","07","10","15","20","25","30","35","40","45","50","55","60","63","65","68","70","73","75","80","85","90")
    then campus_and_co_flag = "true";

  if campus_code in ("05","06","07","10","15","20","25","30","35","40","45","50","55","60","63","65","66","68","70","73","75","80","85","90","94")
    then apdb_campus_flag = "true";

  if cirs_campus_name ne "" then cirs_flag = "true";
run;

data campus_extra;
  set campus_base;
  where campus_code = "30";
  if _n_ = 1;

  campus_only_flag = "false";
  campus_and_co_flag = "false";
  apdb_campus_flag = "false";
  output;

  cirs_campus_name = "POLYTECHNI";
  cirs_flag = "true";
  output;
run;

data campus_lookup;
  set campus_base campus_extra;

  if cirs_campus_name ne "" then cirs_flag = "true";
  if campus_only_flag = "" then campus_only_flag = "false";
  if campus_and_co_flag = "" then campus_and_co_flag = "false";
  if apdb_campus_flag = "" then apdb_campus_flag = "false";

  campus_and_co_sort = (campus_and_co_flag = "true");
  campus_only_sort = (campus_only_flag = "true");
  humboldt_sort = (cirs_campus_name = "HUMBOLDT");
run;

proc sort data=campus_lookup;
  by descending campus_and_co_sort cosar_campus_name_abbrev descending campus_only_sort descending humboldt_sort cirs_campus_name campus_code;
run;

proc export
  data=campus_lookup(drop=campus_and_co_sort campus_only_sort humboldt_sort)
  outfile="&output_csv."
  dbms=csv
  replace;
run;
