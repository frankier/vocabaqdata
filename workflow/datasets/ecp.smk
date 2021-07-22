# URLs
cnf("ECP_URL", "https://osf.io/6n92h/download")

# Intermediates
cnf("ECP_TGZ", pjoin(WORK, "ecp-raw.tar.gz"))
cnf("ECP_RAW", pjoin(WORK, "english-vocabtest-20180919-native.lang.en"))
ECP_CSVS = dict(
    profiles = pjoin(ECP_RAW, "profiles.csv"),
    decisions = pjoin(ECP_RAW, "lexical-decision.csv"),
    sessions = pjoin(ECP_RAW, "sessions.csv")
)

# Outputs
cnf("ECP_DB", pjoin(WORK, "ecp.duckdb"))
cnf("ECP_DF", pjoin(WORK, "ecp.inventory.parquet"))
cnf("ECP_ENRICHED_DF", pjoin(WORK, "ecp.inventory.enriched.parquet"))


rule download_ecp:
    output:
        ECP_TGZ
    shell:
        "wget -nv " + ECP_URL + " -O {output}"

rule extract_ecp:
    input:
        ECP_TGZ
    output:
        **ECP_CSVS
    shell:
        "input=$(realpath {input}) " +
        " && cd " + ECP_RAW + "/.." +
        " && tar -xzf $input"

rule import_ecp:
    input:
        **ECP_CSVS
    output:
        ECP_DB
    shell:
        "python -m vocabaqdata.importers.ecp {input.profiles} {input.decisions} {input.sessions} {output}"


rule ecp_inventory:
    input:
        ECP_DB
    output:
        df = ECP_DF,
        df_enriched = ECP_ENRICHED_DF
    params:
        fmt = "ecp",
        lang = "en"
    script:
        "../scripts/enrich.py"
