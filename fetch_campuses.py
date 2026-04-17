from __future__ import annotations

import argparse
import csv
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable
from urllib.error import HTTPError, URLError
from urllib.request import urlopen


DEFAULT_URL = "https://cmsgwprd.cmsdc.calstate.edu/csu/rest/cosar/v1/campus"
DEFAULT_OUTPUT = "campuses.csv"


@dataclass(frozen=True)
class CampusRecord:
    campus_code: str
    cosar_long_name: str
    term_type: str
    cosar_short_name: str


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

    # The live endpoint returns 80-character records with a trailing 4-character code
    # at positions 77-80 that is not part of the requested CSV output.
    return CampusRecord(
        campus_code=line[0:2].strip(),
        cosar_long_name=line[2:57].rstrip(),
        term_type=line[57:58].strip(),
        cosar_short_name=line[58:76].rstrip(),
    )


def write_csv(records: Iterable[CampusRecord], output_path: Path) -> None:
    with output_path.open("w", newline="", encoding="utf-8") as csv_file:
        writer = csv.DictWriter(
            csv_file,
            fieldnames=[
                "campus_code",
                "cosar_long_name",
                "term_type",
                "cosar_short_name",
            ],
        )
        writer.writeheader()
        for record in records:
            writer.writerow(
                {
                    "campus_code": record.campus_code,
                    "cosar_long_name": record.cosar_long_name,
                    "term_type": record.term_type,
                    "cosar_short_name": record.cosar_short_name,
                }
            )


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Fetch the CSU COSAR campus endpoint and convert it to CSV."
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
    lines = fetch_lines(args.url)
    records = [parse_line(line) for line in lines]
    output_path = Path(args.output)
    write_csv(records, output_path)
    print(f"Wrote {len(records)} rows to {output_path}")


if __name__ == "__main__":
    main()
