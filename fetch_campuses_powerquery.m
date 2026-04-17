let
    SourceUrl = "https://cmsgwprd.cmsdc.calstate.edu/csu/rest/cosar/v1/campus",

    Lookup = (mapping as record, key as nullable text, optional defaultValue as nullable text) as nullable text =>
        if key = null then
            defaultValue
        else
            try Record.Field(mapping, key) otherwise defaultValue,

    BusinessUnitByCode = [
        #"01" = "COCSU", #"05" = "HW001", #"06" = "MB000", #"07" = "MACMP", #"10" = "POCMP",
        #"15" = "SLCMP", #"20" = "CHICO", #"25" = "FRSNO", #"30" = "HMCMP", #"35" = "BKCMP",
        #"40" = "LBCMP", #"45" = "CSULA", #"50" = "FLCMP", #"55" = "DHCMP", #"60" = "SACST",
        #"63" = "SBCMP", #"65" = "SDCMP", #"66" = "SDCMP", #"68" = "SMCMP", #"70" = "NRCMP",
        #"73" = "CICMP", #"75" = "SFCMP", #"80" = "SJ000", #"85" = "SOCMP", #"90" = "STCMP",
        #"94" = "SJ000"
    ],

    AthenaAbbrevByCode = [
        #"01" = "lb", #"05" = "eb", #"06" = "mb", #"07" = "ma", #"10" = "po", #"15" = "sl",
        #"20" = "ch", #"25" = "fr", #"30" = "hm", #"35" = "bk", #"40" = "lb", #"45" = "la",
        #"50" = "fl", #"55" = "dh", #"60" = "sa", #"63" = "sb", #"65" = "sd", #"66" = "sd",
        #"68" = "sm", #"70" = "nr", #"73" = "ci", #"75" = "sf", #"80" = "sj", #"85" = "so",
        #"90" = "st", #"94" = "sj"
    ],

    BaseHrDatabaseNameByCode = [
        #"01" = "hlbprd", #"05" = "hebprd", #"15" = "hsloprd", #"25" = "hfrprd", #"30" = "hhumprd",
        #"40" = "hlbprd", #"45" = "hlaprd", #"65" = "hsdprd", #"66" = "hsdprd", #"70" = "hnrprd",
        #"75" = "hsfprd", #"80" = "hsjprd", #"85" = "hsonprd", #"94" = "hsjprd"
    ],

    ChrsCompanyByCode = [
        #"06" = "MBY", #"07" = "CMA", #"10" = "CPP", #"20" = "CHI", #"35" = "BAK", #"50" = "FUL",
        #"55" = "DOM", #"60" = "SAC", #"63" = "SBU", #"68" = "CSM", #"73" = "CIS", #"90" = "STA"
    ],

    CsDatabaseNameByCode = [
        #"01" = "clbprd", #"05" = "cebprd", #"06" = "cmbprd", #"07" = "cmaprd", #"10" = "cpomprd",
        #"15" = "csloprd", #"20" = "cchiprd", #"25" = "cfrprd", #"30" = "chumprd", #"35" = "cbakprd",
        #"40" = "clbprd", #"45" = "claprd", #"50" = "cfulprd", #"55" = "cdhprd", #"60" = "csacprd",
        #"63" = "csbprd", #"65" = "csdprd", #"66" = "csdprd", #"68" = "csmprd", #"70" = "cnrprd",
        #"73" = "cciprd", #"75" = "csfprd", #"80" = "csjprd", #"85" = "csonprd", #"90" = "cstaprd",
        #"94" = "csjprd"
    ],

    CirsCampusCodeByCode = [
        #"01" = "40", #"05" = "05", #"06" = "06", #"07" = "07", #"10" = "10", #"15" = "15",
        #"20" = "20", #"25" = "25", #"30" = "30", #"35" = "35", #"40" = "40", #"45" = "45",
        #"50" = "50", #"55" = "55", #"60" = "60", #"63" = "63", #"65" = "65", #"66" = "65",
        #"68" = "68", #"70" = "70", #"73" = "72", #"75" = "75", #"80" = "80", #"85" = "85",
        #"90" = "90", #"94" = "80"
    ],

    CirsAlphaCodeByCode = [
        #"01" = "A", #"05" = "B", #"06" = "V", #"07" = "W", #"10" = "C", #"15" = "D", #"20" = "E",
        #"25" = "F", #"30" = "G", #"35" = "H", #"40" = "I", #"45" = "J", #"50" = "K", #"55" = "L",
        #"60" = "M", #"63" = "N", #"65" = "O", #"66" = "O", #"68" = "U", #"70" = "P", #"73" = "Y",
        #"75" = "Q", #"80" = "R", #"85" = "S", #"90" = "T", #"94" = "R"
    ],

    FirmsStateAgencyCodeByCode = [
        #"01" = "6620", #"05" = "6720", #"06" = "6756", #"07" = "6752", #"10" = "6770", #"15" = "6820",
        #"20" = "6680", #"25" = "6700", #"30" = "6730", #"35" = "6650", #"40" = "6740", #"45" = "6750",
        #"50" = "6710", #"55" = "6690", #"60" = "6780", #"63" = "6660", #"65" = "6790", #"68" = "6840",
        #"70" = "6760", #"73" = "6850", #"75" = "6800", #"80" = "6810", #"85" = "6830", #"90" = "6670",
        #"95" = "6620", #"99" = "9999"
    ],

    FirmsCampusIdByCode = [
        #"01" = "CO", #"05" = "EB", #"06" = "MB", #"07" = "MA", #"10" = "PO", #"15" = "SL",
        #"20" = "CH", #"25" = "FR", #"30" = "HM", #"35" = "BK", #"40" = "LB", #"45" = "LA",
        #"50" = "FL", #"55" = "DH", #"60" = "SA", #"63" = "SB", #"65" = "SD", #"68" = "SM",
        #"70" = "NR", #"73" = "CI", #"75" = "SF", #"80" = "SJ", #"85" = "SO", #"90" = "ST",
        #"95" = "CW", #"99" = "CB"
    ],

    CirsCampusNameByCode = [
        #"01" = "CHNCLR OFF", #"05" = "EAST BAY", #"06" = "MONTEREY", #"07" = "MARITIME",
        #"10" = "POMONA", #"15" = "SLO", #"20" = "CHICO", #"25" = "FRESNO", #"30" = "HUMBOLDT",
        #"35" = "BKERSFIELD", #"40" = "LONG BEACH", #"45" = "LA", #"50" = "FULLERTON",
        #"55" = "DOMINGUEZ", #"60" = "SACRAMENTO", #"63" = "SAN BERN", #"65" = "SAN DIEGO",
        #"68" = "SAN MARCOS", #"70" = "NORTHRIDGE", #"73" = "CHANNEL IS", #"75" = "SAN FRAN",
        #"80" = "SAN JOSE", #"85" = "SONOMA", #"90" = "STNISLAUS"
    ],

    ChrsCutoverDateByCode = [
        #"06" = "2026-03-22", #"07" = "2023-11-12", #"10" = "2026-03-22", #"20" = "2025-03-23",
        #"35" = "2026-03-22", #"50" = "2023-11-12", #"55" = "2026-03-22", #"60" = "2025-03-23",
        #"63" = "2025-03-23", #"68" = "2026-03-22", #"73" = "2023-11-12", #"90" = "2023-11-12"
    ],

    CampusOnlyFlagByCode = [
        #"05" = "true", #"06" = "true", #"07" = "true", #"10" = "true", #"15" = "true", #"20" = "true",
        #"25" = "true", #"30" = "true", #"35" = "true", #"40" = "true", #"45" = "true", #"50" = "true",
        #"55" = "true", #"60" = "true", #"63" = "true", #"65" = "true", #"68" = "true", #"70" = "true",
        #"73" = "true", #"75" = "true", #"80" = "true", #"85" = "true", #"90" = "true"
    ],

    CampusAndCoFlagByCode = [
        #"01" = "true", #"05" = "true", #"06" = "true", #"07" = "true", #"10" = "true", #"15" = "true",
        #"20" = "true", #"25" = "true", #"30" = "true", #"35" = "true", #"40" = "true", #"45" = "true",
        #"50" = "true", #"55" = "true", #"60" = "true", #"63" = "true", #"65" = "true", #"68" = "true",
        #"70" = "true", #"73" = "true", #"75" = "true", #"80" = "true", #"85" = "true", #"90" = "true"
    ],

    ApdbCampusFlagByCode = [
        #"05" = "true", #"06" = "true", #"07" = "true", #"10" = "true", #"15" = "true", #"20" = "true",
        #"25" = "true", #"30" = "true", #"35" = "true", #"40" = "true", #"45" = "true", #"50" = "true",
        #"55" = "true", #"60" = "true", #"63" = "true", #"65" = "true", #"66" = "true", #"68" = "true",
        #"70" = "true", #"73" = "true", #"75" = "true", #"80" = "true", #"85" = "true", #"90" = "true",
        #"94" = "true"
    ],

    SourceText = Text.FromBinary(Web.Contents(SourceUrl), TextEncoding.Utf8),
    RawLines = Lines.FromText(SourceText),
    NonBlankLines = List.Select(RawLines, each Text.Length(Text.Trim(_)) > 0),

    ParsedRecords = List.Transform(
        NonBlankLines,
        each [
            campus_code = Text.Trim(Text.Range(_, 0, 2)),
            cosar_campus_name_long = Text.TrimEnd(Text.Range(_, 2, 55)),
            cosar_academic_term = Text.Trim(Text.Range(_, 57, 1)),
            cosar_campus_name_abbrev = Text.TrimEnd(Text.Range(_, 58, 18))
        ]
    ),

    BaseTable = Table.FromRecords(ParsedRecords),
    OverrideCoShortName = Table.TransformColumns(
        BaseTable,
        {
            {
                "cosar_campus_name_abbrev",
                each if BaseTable{List.PositionOf(BaseTable[campus_code], "01")}?[cosar_campus_name_abbrev] <> null and _ <> null then _ else _,
                type text
            }
        }
    ),
    CoShortNameFixed = Table.ReplaceValue(
        OverrideCoShortName,
        each [cosar_campus_name_abbrev],
        each if [campus_code] = "01" then "Chancellor's Office" else [cosar_campus_name_abbrev],
        Replacer.ReplaceValue,
        {"cosar_campus_name_abbrev"}
    ),

    WithBusinessUnit = Table.AddColumn(CoShortNameFixed, "business_unit", each Lookup(BusinessUnitByCode, [campus_code], ""), type text),
    WithAthena = Table.AddColumn(WithBusinessUnit, "athena_abbrev", each Lookup(AthenaAbbrevByCode, [campus_code], ""), type text),
    WithHrBase = Table.AddColumn(WithAthena, "hr_database_name", each Lookup(BaseHrDatabaseNameByCode, [campus_code], ""), type text),
    WithChrsCompany = Table.AddColumn(WithHrBase, "chrs_company", each Lookup(ChrsCompanyByCode, [campus_code], ""), type text),
    FixedHrDatabase = Table.ReplaceValue(
        WithChrsCompany,
        each [hr_database_name],
        each if [chrs_company] <> "" then "hchrprd" else [hr_database_name],
        Replacer.ReplaceValue,
        {"hr_database_name"}
    ),
    WithCirsCampusCode = Table.AddColumn(FixedHrDatabase, "cirs_campus_code", each Lookup(CirsCampusCodeByCode, [campus_code], ""), type text),
    WithCirsAlphaCode = Table.AddColumn(WithCirsCampusCode, "cirs_alpha_code", each Lookup(CirsAlphaCodeByCode, [campus_code], ""), type text),
    WithStateAgency = Table.AddColumn(WithCirsAlphaCode, "firms_state_agency_code", each Lookup(FirmsStateAgencyCodeByCode, [campus_code], ""), type text),
    WithFirmsCampusId = Table.AddColumn(WithStateAgency, "firms_campus_id", each Lookup(FirmsCampusIdByCode, [campus_code], ""), type text),
    WithCampusOnlyFlag = Table.AddColumn(WithFirmsCampusId, "campus_only_flag", each Lookup(CampusOnlyFlagByCode, [campus_code], "false"), type text),
    WithCampusAndCoFlag = Table.AddColumn(WithCampusOnlyFlag, "campus_and_co_flag", each Lookup(CampusAndCoFlagByCode, [campus_code], "false"), type text),
    WithApdbFlag = Table.AddColumn(WithCampusAndCoFlag, "apdb_campus_flag", each Lookup(ApdbCampusFlagByCode, [campus_code], "false"), type text),
    WithCsDatabase = Table.AddColumn(WithApdbFlag, "cs_database_name", each Lookup(CsDatabaseNameByCode, [campus_code], ""), type text),
    WithCirsName = Table.AddColumn(WithCsDatabase, "cirs_campus_name", each Lookup(CirsCampusNameByCode, [campus_code], ""), type text),
    WithCutoverDate = Table.AddColumn(WithCirsName, "chrs_cutover_date", each Lookup(ChrsCutoverDateByCode, [campus_code], ""), type text),
    WithCirsFlag = Table.AddColumn(WithCutoverDate, "cirs_flag", each if [cirs_campus_name] <> "" then "true" else "false", type text),

    HumboldtBase = Table.First(Table.SelectRows(WithCirsFlag, each [campus_code] = "30")),
    ExtraHumboldt = Record.TransformFields(
        HumboldtBase,
        {
            {"campus_only_flag", each "false"},
            {"campus_and_co_flag", each "false"},
            {"apdb_campus_flag", each "false"}
        }
    ),
    PolytechniRow = Record.TransformFields(ExtraHumboldt, {{"cirs_campus_name", each "POLYTECHNI"}}),
    ExtraRows = Table.FromRecords({ExtraHumboldt, PolytechniRow}),
    ExtraRowsWithFlag = Table.AddColumn(ExtraRows, "cirs_flag", each if [cirs_campus_name] <> "" then "true" else "false", type text),

    Combined = Table.Combine({WithCirsFlag, ExtraRowsWithFlag}),

    WithSortCampusAndCo = Table.AddColumn(Combined, "sort_campus_and_co", each if [campus_and_co_flag] = "true" then 0 else 1, Int64.Type),
    WithSortCampusOnly = Table.AddColumn(WithSortCampusAndCo, "sort_campus_only", each if [campus_only_flag] = "true" then 0 else 1, Int64.Type),
    WithSortHumboldt = Table.AddColumn(WithSortCampusOnly, "sort_humboldt", each if [cirs_campus_name] = "HUMBOLDT" then 0 else 1, Int64.Type),

    Sorted = Table.Sort(
        WithSortHumboldt,
        {
            {"sort_campus_and_co", Order.Ascending},
            {"cosar_campus_name_abbrev", Order.Ascending},
            {"sort_campus_only", Order.Ascending},
            {"sort_humboldt", Order.Ascending},
            {"cirs_campus_name", Order.Ascending},
            {"campus_code", Order.Ascending}
        }
    ),

    Final = Table.SelectColumns(
        Sorted,
        {
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
        }
    )
in
    Final
