default_url <- "https://cmsgwprd.cmsdc.calstate.edu/csu/rest/cosar/v1/campus"
default_output <- "campuses.csv"

output_fields <- c(
  "campus_code",
  "business_unit",
  "hr_database_name",
  "chrs_company",
  "athena_abbrev",
  "cirs_campus_code",
  "cirs_alpha_code",
  "firms_state_agency_code",
  "firms_campus_id",
  "cosar_campus_name_long",
  "cosar_academic_term",
  "cosar_campus_name_abbrev",
  "campus_only_flag",
  "campus_and_co_flag",
  "apdb_campus_flag",
  "cs_database_name",
  "cirs_campus_name",
  "chrs_cutover_date",
  "cirs_flag"
)

business_unit_by_code <- c(
  "01" = "COCSU", "05" = "HW001", "06" = "MB000", "07" = "MACMP", "10" = "POCMP",
  "15" = "SLCMP", "20" = "CHICO", "25" = "FRSNO", "30" = "HMCMP", "35" = "BKCMP",
  "40" = "LBCMP", "45" = "CSULA", "50" = "FLCMP", "55" = "DHCMP", "60" = "SACST",
  "63" = "SBCMP", "65" = "SDCMP", "66" = "SDCMP", "68" = "SMCMP", "70" = "NRCMP",
  "73" = "CICMP", "75" = "SFCMP", "80" = "SJ000", "85" = "SOCMP", "90" = "STCMP",
  "94" = "SJ000"
)

athena_abbrev_by_code <- c(
  "01" = "lb", "05" = "eb", "06" = "mb", "07" = "ma", "10" = "po", "15" = "sl",
  "20" = "ch", "25" = "fr", "30" = "hm", "35" = "bk", "40" = "lb", "45" = "la",
  "50" = "fl", "55" = "dh", "60" = "sa", "63" = "sb", "65" = "sd", "66" = "sd",
  "68" = "sm", "70" = "nr", "73" = "ci", "75" = "sf", "80" = "sj", "85" = "so",
  "90" = "st", "94" = "sj"
)

base_hr_database_name_by_code <- c(
  "01" = "hlbprd", "05" = "hebprd", "15" = "hsloprd", "25" = "hfrprd", "30" = "hhumprd",
  "40" = "hlbprd", "45" = "hlaprd", "65" = "hsdprd", "66" = "hsdprd", "70" = "hnrprd",
  "75" = "hsfprd", "80" = "hsjprd", "85" = "hsonprd", "94" = "hsjprd"
)

chrs_company_by_code <- c(
  "06" = "MBY", "07" = "CMA", "10" = "CPP", "20" = "CHI", "35" = "BAK", "50" = "FUL",
  "55" = "DOM", "60" = "SAC", "63" = "SBU", "68" = "CSM", "73" = "CIS", "90" = "STA"
)

cs_database_name_by_code <- c(
  "01" = "clbprd", "05" = "cebprd", "06" = "cmbprd", "07" = "cmaprd", "10" = "cpomprd",
  "15" = "csloprd", "20" = "cchiprd", "25" = "cfrprd", "30" = "chumprd", "35" = "cbakprd",
  "40" = "clbprd", "45" = "claprd", "50" = "cfulprd", "55" = "cdhprd", "60" = "csacprd",
  "63" = "csbprd", "65" = "csdprd", "66" = "csdprd", "68" = "csmprd", "70" = "cnrprd",
  "73" = "cciprd", "75" = "csfprd", "80" = "csjprd", "85" = "csonprd", "90" = "cstaprd",
  "94" = "csjprd"
)

cirs_campus_code_by_code <- c(
  "01" = "40", "05" = "05", "06" = "06", "07" = "07", "10" = "10", "15" = "15",
  "20" = "20", "25" = "25", "30" = "30", "35" = "35", "40" = "40", "45" = "45",
  "50" = "50", "55" = "55", "60" = "60", "63" = "63", "65" = "65", "66" = "65",
  "68" = "68", "70" = "70", "73" = "72", "75" = "75", "80" = "80", "85" = "85",
  "90" = "90", "94" = "80"
)

cirs_alpha_code_by_code <- c(
  "01" = "A", "05" = "B", "06" = "V", "07" = "W", "10" = "C", "15" = "D", "20" = "E",
  "25" = "F", "30" = "G", "35" = "H", "40" = "I", "45" = "J", "50" = "K", "55" = "L",
  "60" = "M", "63" = "N", "65" = "O", "66" = "O", "68" = "U", "70" = "P", "73" = "Y",
  "75" = "Q", "80" = "R", "85" = "S", "90" = "T", "94" = "R"
)

firms_state_agency_code_by_code <- c(
  "01" = "6620", "05" = "6720", "06" = "6756", "07" = "6752", "10" = "6770", "15" = "6820",
  "20" = "6680", "25" = "6700", "30" = "6730", "35" = "6650", "40" = "6740", "45" = "6750",
  "50" = "6710", "55" = "6690", "60" = "6780", "63" = "6660", "65" = "6790", "68" = "6840",
  "70" = "6760", "73" = "6850", "75" = "6800", "80" = "6810", "85" = "6830", "90" = "6670",
  "95" = "6620", "99" = "9999"
)

firms_campus_id_by_code <- c(
  "01" = "CO", "05" = "EB", "06" = "MB", "07" = "MA", "10" = "PO", "15" = "SL",
  "20" = "CH", "25" = "FR", "30" = "HM", "35" = "BK", "40" = "LB", "45" = "LA",
  "50" = "FL", "55" = "DH", "60" = "SA", "63" = "SB", "65" = "SD", "68" = "SM",
  "70" = "NR", "73" = "CI", "75" = "SF", "80" = "SJ", "85" = "SO", "90" = "ST",
  "95" = "CW", "99" = "CB"
)

cirs_campus_name_by_code <- c(
  "01" = "CHNCLR OFF", "05" = "EAST BAY", "06" = "MONTEREY", "07" = "MARITIME",
  "10" = "POMONA", "15" = "SLO", "20" = "CHICO", "25" = "FRESNO", "30" = "HUMBOLDT",
  "35" = "BKERSFIELD", "40" = "LONG BEACH", "45" = "LA", "50" = "FULLERTON",
  "55" = "DOMINGUEZ", "60" = "SACRAMENTO", "63" = "SAN BERN", "65" = "SAN DIEGO",
  "68" = "SAN MARCOS", "70" = "NORTHRIDGE", "73" = "CHANNEL IS", "75" = "SAN FRAN",
  "80" = "SAN JOSE", "85" = "SONOMA", "90" = "STNISLAUS"
)

chrs_cutover_date_by_code <- c(
  "06" = "2026-03-22", "07" = "2023-11-12", "10" = "2026-03-22", "20" = "2025-03-23",
  "35" = "2026-03-22", "50" = "2023-11-12", "55" = "2026-03-22", "60" = "2025-03-23",
  "63" = "2025-03-23", "68" = "2026-03-22", "73" = "2023-11-12", "90" = "2023-11-12"
)

campus_only_flag_by_code <- c(
  "05" = "true", "06" = "true", "07" = "true", "10" = "true", "15" = "true", "20" = "true",
  "25" = "true", "30" = "true", "35" = "true", "40" = "true", "45" = "true", "50" = "true",
  "55" = "true", "60" = "true", "63" = "true", "65" = "true", "68" = "true", "70" = "true",
  "73" = "true", "75" = "true", "80" = "true", "85" = "true", "90" = "true"
)

campus_and_co_flag_by_code <- c(
  "01" = "true", "05" = "true", "06" = "true", "07" = "true", "10" = "true", "15" = "true",
  "20" = "true", "25" = "true", "30" = "true", "35" = "true", "40" = "true", "45" = "true",
  "50" = "true", "55" = "true", "60" = "true", "63" = "true", "65" = "true", "68" = "true",
  "70" = "true", "73" = "true", "75" = "true", "80" = "true", "85" = "true", "90" = "true"
)

apdb_campus_flag_by_code <- c(
  "05" = "true", "06" = "true", "07" = "true", "10" = "true", "15" = "true", "20" = "true",
  "25" = "true", "30" = "true", "35" = "true", "40" = "true", "45" = "true", "50" = "true",
  "55" = "true", "60" = "true", "63" = "true", "65" = "true", "66" = "true", "68" = "true",
  "70" = "true", "73" = "true", "75" = "true", "80" = "true", "85" = "true", "90" = "true",
  "94" = "true"
)

map_by_code <- function(campus_codes, mapping) {
  values <- unname(mapping[campus_codes])
  values[is.na(values)] <- ""
  values
}

fetch_lines <- function(url) {
  connection <- url(url, open = "rb")
  on.exit(close(connection), add = TRUE)
  lines <- readLines(connection, warn = FALSE, encoding = "UTF-8")
  lines[nzchar(trimws(lines))]
}

parse_lines <- function(lines) {
  data.frame(
    campus_code = trimws(substr(lines, 1L, 2L)),
    cosar_campus_name_long = sub("\\s+$", "", substr(lines, 3L, 57L)),
    cosar_academic_term = trimws(substr(lines, 58L, 58L)),
    cosar_campus_name_abbrev = sub("\\s+$", "", substr(lines, 59L, 76L)),
    stringsAsFactors = FALSE
  )
}

build_base_rows <- function(records) {
  rows <- as.data.frame(setNames(replicate(length(output_fields), rep("", nrow(records)), simplify = FALSE), output_fields), stringsAsFactors = FALSE)
  rows$campus_code <- records$campus_code
  rows$cosar_campus_name_long <- records$cosar_campus_name_long
  rows$cosar_academic_term <- records$cosar_academic_term
  rows$cosar_campus_name_abbrev <- records$cosar_campus_name_abbrev
  rows$cosar_campus_name_abbrev[rows$campus_code == "01"] <- "Chancellor's Office"
  rows
}

append_special_rows <- function(rows) {
  humboldt_row <- rows[rows$campus_code == "30", , drop = FALSE][1, , drop = FALSE]
  extra_humboldt <- humboldt_row
  extra_humboldt$campus_only_flag <- "false"
  extra_humboldt$campus_and_co_flag <- "false"
  extra_humboldt$apdb_campus_flag <- "false"

  polytechni_row <- extra_humboldt
  polytechni_row$cirs_campus_name <- "POLYTECHNI"

  rbind(rows, extra_humboldt, polytechni_row)
}

finalize_rows <- function(rows) {
  rows$cirs_flag <- ifelse(nzchar(rows$cirs_campus_name), "true", "false")

  for (flag_column in c("campus_only_flag", "campus_and_co_flag", "apdb_campus_flag")) {
    rows[[flag_column]][!nzchar(rows[[flag_column]])] <- "false"
  }

  rows
}

sort_rows <- function(rows) {
  rows[
    order(
      ifelse(rows$campus_and_co_flag == "true", 0L, 1L),
      tolower(rows$cosar_campus_name_abbrev),
      ifelse(rows$campus_only_flag == "true", 0L, 1L),
      ifelse(rows$cirs_campus_name == "HUMBOLDT", 0L, 1L),
      rows$cirs_campus_name,
      rows$campus_code
    ),
    ,
    drop = FALSE
  ]
}

build_output_rows <- function(records) {
  rows <- build_base_rows(records)

  rows$business_unit <- map_by_code(rows$campus_code, business_unit_by_code)
  rows$athena_abbrev <- map_by_code(rows$campus_code, athena_abbrev_by_code)
  rows$cirs_campus_code <- map_by_code(rows$campus_code, cirs_campus_code_by_code)
  rows$cirs_alpha_code <- map_by_code(rows$campus_code, cirs_alpha_code_by_code)
  rows$firms_state_agency_code <- map_by_code(rows$campus_code, firms_state_agency_code_by_code)
  rows$firms_campus_id <- map_by_code(rows$campus_code, firms_campus_id_by_code)
  rows$campus_only_flag <- map_by_code(rows$campus_code, campus_only_flag_by_code)
  rows$campus_and_co_flag <- map_by_code(rows$campus_code, campus_and_co_flag_by_code)
  rows$apdb_campus_flag <- map_by_code(rows$campus_code, apdb_campus_flag_by_code)

  rows$chrs_company <- map_by_code(rows$campus_code, chrs_company_by_code)
  rows$hr_database_name <- map_by_code(rows$campus_code, base_hr_database_name_by_code)
  rows$hr_database_name[nzchar(rows$chrs_company)] <- "hchrprd"
  rows$cs_database_name <- map_by_code(rows$campus_code, cs_database_name_by_code)
  rows$cirs_campus_name <- map_by_code(rows$campus_code, cirs_campus_name_by_code)
  rows$chrs_cutover_date <- map_by_code(rows$campus_code, chrs_cutover_date_by_code)

  rows <- append_special_rows(rows)
  rows <- finalize_rows(rows)
  sort_rows(rows)
}

format_csv_cell <- function(value) {
  if (!nzchar(value)) {
    return("")
  }

  escaped <- gsub('"', '""', value, fixed = TRUE)
  paste0('"', escaped, '"')
}

write_csv_custom <- function(rows, output_path) {
  header_line <- paste(sprintf('"%s"', output_fields), collapse = ",")
  row_lines <- apply(rows[, output_fields, drop = FALSE], 1L, function(row) {
    paste(vapply(row, format_csv_cell, character(1L)), collapse = ",")
  })

  writeLines(c(header_line, row_lines), output_path, useBytes = TRUE)
}

args <- commandArgs(trailingOnly = TRUE)
url <- default_url
output <- default_output

if (length(args) >= 1L) {
  url <- args[[1L]]
}

if (length(args) >= 2L) {
  output <- args[[2L]]
}

records <- parse_lines(fetch_lines(url))
rows <- build_output_rows(records)
write_csv_custom(rows, output)
cat(sprintf("Wrote %d rows to %s\n", nrow(rows), output))
