# URLs
cnf("DCP_URL", "https://osf.io/vb3xn/download")

# Intermediates
cnf("DCP_TGZ", pjoin(WORK, "dcp.tar.gz"))
cnf("DCP_RAW", pjoin(WORK, "dutch-vocabtest-20131203-cleaned-native.lang.nl"))
DCP_CSVS = dict(
    profiles = pjoin(DCP_RAW, "profiles.csv"),
    decisions = pjoin(DCP_RAW, "lexical-decision.csv"),
    sessions = pjoin(DCP_RAW, "sessions.csv")
)
DCP_SESSIONS_FILTERED = pjoin(DCP_RAW, "sessions_filtered.csv")

# Outputs
cnf("DCP_DB", pjoin(WORK, "dcp.duckdb"))
cnf("DCP_DF", pjoin(WORK, "dcp.inventory.parquet"))
cnf("DCP_ENRICHED_DF", pjoin(WORK, "dcp.inventory.enriched.parquet"))


rule download_dcp:
    output:
        DCP_TGZ
    shell:
        "wget -nv " + DCP_URL + " -O {output}"

rule extract_dcp:
    input:
        DCP_TGZ
    output:
        **DCP_CSVS
    shell:
        "input=$(realpath {input}) " +
        " && cd " + DCP_RAW + "/.." +
        " && tar -xzf $input"

rule import_dcp:
    input:
        **DCP_CSVS
    output:
        DCP_DB
    params:
        filtered_sessions = DCP_SESSIONS_FILTERED
    shell:
        "sed -e 's/0000-00-00 00:00:00//g' {input.sessions}"
        " > {params.filtered_sessions}"
        " && python -m vocabaqdata.importers.dcp"
        " {input.profiles} {input.decisions} {params.filtered_sessions} {output}"
        " && rm -f {params.filtered_sessions}"


rule dcp_inventory:
    input:
        DCP_DB
    output:
        df = DCP_DF,
        df_enriched = DCP_ENRICHED_DF
    params:
        fmt = "dcp",
        lang = "nl"
    script:
        "../scripts/enrich.py"
