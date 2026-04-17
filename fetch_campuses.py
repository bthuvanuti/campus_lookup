from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.request import urlopen


DEFAULT_URL = "https://cmsgwprd.cmsdc.calstate.edu/csu/rest/cosar/v1/campus"
DEFAULT_OUTPUT = "campuses.csv"
OUTPUT_FIELDS = [
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
    "cirs_flag",
]


@dataclass(frozen=True)
class CampusRecord:
    campus_code: str
    cosar_campus_name_long: str
    cosar_academic_term: str
    cosar_campus_name_abbrev: str


BUSINESS_UNIT_BY_CODE = {
    "01": "COCSU",
    "05": "HW001",
    "06": "MB000",
    "07": "MACMP",
    "10": "POCMP",
    "15": "SLCMP",
    "20": "CHICO",
    "25": "FRSNO",
    "30": "HMCMP",
    "35": "BKCMP",
    "40": "LBCMP",
    "45": "CSULA",
    "50": "FLCMP",
    "55": "DHCMP",
    "60": "SACST",
    "63": "SBCMP",
    "65": "SDCMP",
    "66": "SDCMP",
    "68": "SMCMP",
    "70": "NRCMP",
    "73": "CICMP",
    "75": "SFCMP",
    "80": "SJ000",
    "85": "SOCMP",
    "90": "STCMP",
    "94": "SJ000",
}

ATHENA_ABBREV_BY_CODE = {
    "01": "lb",
    "05": "eb",
    "06": "mb",
    "07": "ma",
    "10": "po",
    "15": "sl",
    "20": "ch",
    "25": "fr",
    "30": "hm",
    "35": "bk",
    "40": "lb",
    "45": "la",
    "50": "fl",
    "55": "dh",
    "60": "sa",
    "63": "sb",
    "65": "sd",
    "66": "sd",
    "68": "sm",
    "70": "nr",
    "73": "ci",
    "75": "sf",
    "80": "sj",
    "85": "so",
    "90": "st",
    "94": "sj",
}

BASE_HR_DATABASE_NAME_BY_CODE = {
    "01": "hlbprd",
    "05": "hebprd",
    "15": "hsloprd",
    "25": "hfrprd",
    "30": "hhumprd",
    "40": "hlbprd",
    "45": "hlaprd",
    "65": "hsdprd",
    "66": "hsdprd",
    "70": "hnrprd",
    "75": "hsfprd",
    "80": "hsjprd",
    "85": "hsonprd",
    "94": "hsjprd",
}

CHRS_COMPANY_BY_CODE = {
    "06": "MBY",
    "07": "CMA",
    "10": "CPP",
    "20": "CHI",
    "35": "BAK",
    "50": "FUL",
    "55": "DOM",
    "60": "SAC",
    "63": "SBU",
    "68": "CSM",
    "73": "CIS",
    "90": "STA",
}

CS_DATABASE_NAME_BY_CODE = {
    "01": "clbprd",
    "05": "cebprd",
    "06": "cmbprd",
    "07": "cmaprd",
    "10": "cpomprd",
    "15": "csloprd",
    "20": "cchiprd",
    "25": "cfrprd",
    "30": "chumprd",
    "35": "cbakprd",
    "40": "clbprd",
    "45": "claprd",
    "50": "cfulprd",
    "55": "cdhprd",
    "60": "csacprd",
    "63": "csbprd",
    "65": "csdprd",
    "66": "csdprd",
    "68": "csmprd",
    "70": "cnrprd",
    "73": "cciprd",
    "75": "csfprd",
    "80": "csjprd",
    "85": "csonprd",
    "90": "cstaprd",
    "94": "csjprd",
}

CIRS_CAMPUS_CODE_BY_CODE = {
    "01": "40",
    "05": "05",
    "06": "06",
    "07": "07",
    "10": "10",
    "15": "15",
    "20": "20",
    "25": "25",
    "30": "30",
    "35": "35",
    "40": "40",
    "45": "45",
    "50": "50",
    "55": "55",
    "60": "60",
    "63": "63",
    "65": "65",
    "66": "65",
    "68": "68",
    "70": "70",
    "73": "72",
    "75": "75",
    "80": "80",
    "85": "85",
    "90": "90",
    "94": "80",
}

CIRS_ALPHA_CODE_BY_CODE = {
    "01": "A",
    "05": "B",
    "06": "V",
    "07": "W",
    "10": "C",
    "15": "D",
    "20": "E",
    "25": "F",
    "30": "G",
    "35": "H",
    "40": "I",
    "45": "J",
    "50": "K",
    "55": "L",
    "60": "M",
    "63": "N",
    "65": "O",
    "66": "O",
    "68": "U",
    "70": "P",
    "73": "Y",
    "75": "Q",
    "80": "R",
    "85": "S",
    "90": "T",
    "94": "R",
}

FIRMS_STATE_AGENCY_CODE_BY_CODE = {
    "01": "6620",
    "05": "6720",
    "06": "6756",
    "07": "6752",
    "10": "6770",
    "15": "6820",
    "20": "6680",
    "25": "6700",
    "30": "6730",
    "35": "6650",
    "40": "6740",
    "45": "6750",
    "50": "6710",
    "55": "6690",
    "60": "6780",
    "63": "6660",
    "65": "6790",
    "68": "6840",
    "70": "6760",
    "73": "6850",
    "75": "6800",
    "80": "6810",
    "85": "6830",
    "90": "6670",
    "95": "6620",
    "99": "9999",
}

FIRMS_CAMPUS_ID_BY_CODE = {
    "01": "CO",
    "05": "EB",
    "06": "MB",
    "07": "MA",
    "10": "PO",
    "15": "SL",
    "20": "CH",
    "25": "FR",
    "30": "HM",
    "35": "BK",
    "40": "LB",
    "45": "LA",
    "50": "FL",
    "55": "DH",
    "60": "SA",
    "63": "SB",
    "65": "SD",
    "68": "SM",
    "70": "NR",
    "73": "CI",
    "75": "SF",
    "80": "SJ",
    "85": "SO",
    "90": "ST",
    "95": "CW",
    "99": "CB",
}

CIRS_CAMPUS_NAME_BY_CODE = {
    "01": "CHNCLR OFF",
    "05": "EAST BAY",
    "06": "MONTEREY",
    "07": "MARITIME",
    "10": "POMONA",
    "15": "SLO",
    "20": "CHICO",
    "25": "FRESNO",
    "30": "HUMBOLDT",
    "35": "BKERSFIELD",
    "40": "LONG BEACH",
    "45": "LA",
    "50": "FULLERTON",
    "55": "DOMINGUEZ",
    "60": "SACRAMENTO",
    "63": "SAN BERN",
    "65": "SAN DIEGO",
    "68": "SAN MARCOS",
    "70": "NORTHRIDGE",
    "73": "CHANNEL IS",
    "75": "SAN FRAN",
    "80": "SAN JOSE",
    "85": "SONOMA",
    "90": "STNISLAUS",
}

CHRS_CUTOVER_DATE_BY_CODE = {
    "06": "2026-03-22",
    "07": "2023-11-12",
    "10": "2026-03-22",
    "20": "2025-03-23",
    "35": "2026-03-22",
    "50": "2023-11-12",
    "55": "2026-03-22",
    "60": "2025-03-23",
    "63": "2025-03-23",
    "68": "2026-03-22",
    "73": "2023-11-12",
    "90": "2023-11-12",
}

CAMPUS_ONLY_FLAG_BY_CODE = {
    "05": "true",
    "06": "true",
    "07": "true",
    "10": "true",
    "15": "true",
    "20": "true",
    "25": "true",
    "30": "true",
    "35": "true",
    "40": "true",
    "45": "true",
    "50": "true",
    "55": "true",
    "60": "true",
    "63": "true",
    "65": "true",
    "68": "true",
    "70": "true",
    "73": "true",
    "75": "true",
    "80": "true",
    "85": "true",
    "90": "true",
}

CAMPUS_AND_CO_FLAG_BY_CODE = {
    "01": "true",
    "05": "true",
    "06": "true",
    "07": "true",
    "10": "true",
    "15": "true",
    "20": "true",
    "25": "true",
    "30": "true",
    "35": "true",
    "40": "true",
    "45": "true",
    "50": "true",
    "55": "true",
    "60": "true",
    "63": "true",
    "65": "true",
    "68": "true",
    "70": "true",
    "73": "true",
    "75": "true",
    "80": "true",
    "85": "true",
    "90": "true",
}

APDB_CAMPUS_FLAG_BY_CODE = {
    "05": "true",
    "06": "true",
    "07": "true",
    "10": "true",
    "15": "true",
    "20": "true",
    "25": "true",
    "30": "true",
    "35": "true",
    "40": "true",
    "45": "true",
    "50": "true",
    "55": "true",
    "60": "true",
    "63": "true",
    "65": "true",
    "66": "true",
    "68": "true",
    "70": "true",
    "73": "true",
    "75": "true",
    "80": "true",
    "85": "true",
    "90": "true",
    "94": "true",
}

def fetch_lines(url: str) -> list[str]:
    try:
        with urlopen(url) as response:
            payload = response.read().decode("utf-8")
    except HTTPError as exc:
        raise SystemExit(f"HTTP error fetching {url}: {exc.code} {exc.reason}") from exc
    except URLError as exc:
        raise SystemExit(f"Network error fetching {url}: {exc.reason}") from exc

    return [line.rstrip("\r") for line in payload.splitlines() if line.strip()]


def parse_line(line: str) -> CampusRecord:
    if len(line) < 76:
        raise ValueError(f"Line is too short to parse: {line!r}")

    return CampusRecord(
        campus_code=line[0:2].strip(),
        cosar_campus_name_long=line[2:57].rstrip(),
        cosar_academic_term=line[57:58].strip(),
        cosar_campus_name_abbrev=line[58:76].rstrip(),
    )


def base_row(record: CampusRecord) -> dict[str, str]:
    row = {field: "" for field in OUTPUT_FIELDS}
    row["campus_code"] = record.campus_code
    row["cosar_campus_name_long"] = record.cosar_campus_name_long
    row["cosar_academic_term"] = record.cosar_academic_term
    row["cosar_campus_name_abbrev"] = record.cosar_campus_name_abbrev
    if record.campus_code == "01":
        row["cosar_campus_name_abbrev"] = "Chancellor's Office"
    return row


def mutate_column_from_code(
    rows: list[dict[str, str]], column: str, mapping: dict[str, str]
) -> None:
    for row in rows:
        row[column] = mapping.get(row["campus_code"], row[column])


def mutate_chrs_company(rows: list[dict[str, str]]) -> None:
    for row in rows:
        campus_code = row["campus_code"]
        row["chrs_company"] = CHRS_COMPANY_BY_CODE.get(campus_code, "")


def mutate_hr_database_name(rows: list[dict[str, str]]) -> None:
    for row in rows:
        campus_code = row["campus_code"]
        row["hr_database_name"] = BASE_HR_DATABASE_NAME_BY_CODE.get(
            campus_code, row["hr_database_name"]
        )
        if row["chrs_company"]:
            row["hr_database_name"] = "hchrprd"


def mutate_cs_database_name(rows: list[dict[str, str]]) -> None:
    for row in rows:
        campus_code = row["campus_code"]
        row["cs_database_name"] = CS_DATABASE_NAME_BY_CODE.get(campus_code, "")


def mutate_cirs_campus_name(rows: list[dict[str, str]]) -> None:
    for row in rows:
        row["cirs_campus_name"] = CIRS_CAMPUS_NAME_BY_CODE.get(row["campus_code"], "")


def mutate_chrs_cutover_date(rows: list[dict[str, str]]) -> None:
    for row in rows:
        row["chrs_cutover_date"] = CHRS_CUTOVER_DATE_BY_CODE.get(
            row["campus_code"], ""
        )


def append_special_rows(rows: list[dict[str, str]]) -> None:
    humboldt_row = next(row for row in rows if row["campus_code"] == "30")

    extra_humboldt = humboldt_row.copy()
    extra_humboldt["campus_only_flag"] = "false"
    extra_humboldt["campus_and_co_flag"] = "false"
    extra_humboldt["apdb_campus_flag"] = "false"

    polytechni_row = extra_humboldt.copy()
    polytechni_row["cirs_campus_name"] = "POLYTECHNI"

    rows.extend([extra_humboldt, polytechni_row])


def finalize_rows(rows: list[dict[str, str]]) -> None:
    for row in rows:
        row["cirs_flag"] = "true" if row["cirs_campus_name"] else "false"

        for flag_column in ("campus_only_flag", "campus_and_co_flag", "apdb_campus_flag"):
            if not row[flag_column]:
                row[flag_column] = "false"


def sort_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    return sorted(
        rows,
        key=lambda row: (
            0 if row["campus_and_co_flag"] == "true" else 1,
            row["cosar_campus_name_abbrev"].casefold(),
            0 if row["campus_only_flag"] == "true" else 1,
            0 if row["cirs_campus_name"] == "HUMBOLDT" else 1,
            row["cirs_campus_name"],
            row["campus_code"],
        ),
    )


def build_output_rows(source_records: list[CampusRecord]) -> list[dict[str, str]]:
    rows = [base_row(record) for record in source_records]

    mutate_column_from_code(rows, "business_unit", BUSINESS_UNIT_BY_CODE)
    mutate_column_from_code(rows, "athena_abbrev", ATHENA_ABBREV_BY_CODE)
    mutate_column_from_code(rows, "cirs_campus_code", CIRS_CAMPUS_CODE_BY_CODE)
    mutate_column_from_code(rows, "cirs_alpha_code", CIRS_ALPHA_CODE_BY_CODE)
    mutate_column_from_code(rows, "firms_state_agency_code", FIRMS_STATE_AGENCY_CODE_BY_CODE)
    mutate_column_from_code(rows, "firms_campus_id", FIRMS_CAMPUS_ID_BY_CODE)
    mutate_column_from_code(rows, "campus_only_flag", CAMPUS_ONLY_FLAG_BY_CODE)
    mutate_column_from_code(rows, "campus_and_co_flag", CAMPUS_AND_CO_FLAG_BY_CODE)
    mutate_column_from_code(rows, "apdb_campus_flag", APDB_CAMPUS_FLAG_BY_CODE)

    mutate_chrs_company(rows)
    mutate_hr_database_name(rows)
    mutate_cs_database_name(rows)
    mutate_cirs_campus_name(rows)
    mutate_chrs_cutover_date(rows)
    append_special_rows(rows)
    finalize_rows(rows)
    return sort_rows(rows)


def format_csv_cell(value: str) -> str:
    if value == "":
        return ""
    return f'"{value.replace("\"", "\"\"")}"'


def write_csv(rows: list[dict[str, str]], output_path: Path) -> None:
    lines = [",".join(f'"{field}"' for field in OUTPUT_FIELDS)]
    for row in rows:
        lines.append(",".join(format_csv_cell(row[field]) for field in OUTPUT_FIELDS))
    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Fetch the CSU COSAR campus endpoint and write the expanded campus lookup CSV."
    )
    parser.add_argument(
        "--url",
        default=DEFAULT_URL,
        help=f"Endpoint URL to fetch. Defaults to {DEFAULT_URL}.",
    )
    parser.add_argument(
        "--output",
        default=DEFAULT_OUTPUT,
        help=f"CSV file to write. Defaults to {DEFAULT_OUTPUT}.",
    )
    return parser


def main() -> None:
    args = build_parser().parse_args()
    records = [parse_line(line) for line in fetch_lines(args.url)]
    rows = build_output_rows(records)
    write_csv(rows, Path(args.output))
    print(f"Wrote {len(rows)} rows to {args.output}")


if __name__ == "__main__":
    main()
