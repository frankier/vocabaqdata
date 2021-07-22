DLP2_URLS = [
    "http://crr.ugent.be/papers/dlp2_trials0.tsv.zip",
    "http://crr.ugent.be/papers/dlp2_trials1.tsv.zip",
]

cnf("DLP2_ZIPS_DIR", pjoin(WORK, "dlp2_zips"))
cnf("DLP2_TSVS_DIR", pjoin(WORK, "dlp2_tsvs"))

## Output
cnf("DLP2_DB", pjoin(WORK, "dlp2.duckdb"))
cnf("DLP2_DF", pjoin(WORK, "dlp2.inventory.parquet"))
cnf("DLP2_ENRICHED_DF", pjoin(WORK, "dlp2.inventory.enriched.parquet"))


rule download_dlp2:
    params:
        urls = DLP2_URLS
    output:
        directory(DLP2_ZIPS_DIR)
    script:
        "../scripts/download_zips.py"


rule extract_dlp2:
    input:
        DLP2_ZIPS_DIR
    output:
        directory(DLP2_TSVS_DIR)
    script:
        "../scripts/extract_zips.py"


rule import_dlp2:
    input:
        DLP2_TSVS_DIR
    params:
        dlp2_trials0 = pjoin(DLP2_TSVS_DIR, "dlp2_trials0.tsv"),
        dlp2_trials1 = pjoin(DLP2_TSVS_DIR, "dlp2_trials1.tsv"),
    output:
        DLP2_DB
    shell:
        "python -m vocabaqdata.importers.dlp2 {params.dlp2_trials0} {params.dlp2_trials1} {output}"


rule dlp2_inventory:
    input:
        DLP2_DB
    output:
        df = DLP2_DF,
        df_enriched = DLP2_ENRICHED_DF
    params:
        fmt = "dlp2",
        lang = "nl"
    script:
        "../scripts/enrich.py"
