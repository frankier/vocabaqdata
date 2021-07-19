DLP_URLS = [
    "http://crr.ugent.be/dlp/txt/dlp-items.txt.zip",
    "http://crr.ugent.be/dlp/txt/dlp-stimuli.txt.zip",
    "http://crr.ugent.be/dlp/txt/dlp-trials.txt.zip",
]

cnf("DLP_ZIPS_DIR", pjoin(WORK, "dlp_zips"))
cnf("DLP_TSVS_DIR", pjoin(WORK, "dlp_tsvs"))

## Output
cnf("DLP_DB", pjoin(WORK, "dlp.duckdb"))
cnf("DLP_DF", pjoin(WORK, "dlp.inventory.parquet"))
cnf("DLP_ENRICHED_DF", pjoin(WORK, "dlp.inventory.enriched.parquet"))


rule download_dlp:
    params:
        urls = DLP_URLS
    output:
        directory(DLP_ZIPS_DIR)
    script:
        "../scripts/download_zips.py"


rule extract_dlp:
    input:
        DLP_ZIPS_DIR
    output:
        directory(DLP_TSVS_DIR)
    script:
        "../scripts/extract_zips.py"


rule import_dlp:
    input:
        DLP_TSVS_DIR
    params:
        vocab_items = pjoin(DLP_TSVS_DIR, "dlp-items.txt"),
        stimuli = pjoin(DLP_TSVS_DIR, "dlp-stimuli.txt"),
        trials = pjoin(DLP_TSVS_DIR, "dlp-trials.txt")
    output:
        DLP_DB
    shell:
        "python -m vocabaqdata.importers.dlp {params.vocab_items} {params.stimuli} {params.trials} {output}"


rule dlp_inventory:
    input:
        DLP_DB
    output:
        df = DLP_DF,
        df_enriched = DLP_ENRICHED_DF
    params:
        fmt = "dlp"
    script:
        "../scripts/enrich.py"
