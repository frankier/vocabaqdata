BLP_URLS = [
    "http://crr.ugent.be/blp/txt/blp-items.txt.zip",
    "http://crr.ugent.be/blp/txt/blp-pseudoword-syllables.txt.zip",
    "http://crr.ugent.be/blp/txt/blp-stimuli.txt.zip",
    "http://crr.ugent.be/blp/txt/blp-trials.txt.zip",
]

cnf("BLP_ZIPS_DIR", pjoin(WORK, "blp_zips"))
cnf("BLP_TSVS_DIR", pjoin(WORK, "blp_tsvs"))

## Output
cnf("BLP_DB", pjoin(WORK, "blp.duckdb"))
cnf("BLP_DF", pjoin(WORK, "blp.inventory.parquet"))
cnf("BLP_ENRICHED_DF", pjoin(WORK, "blp.inventory.enriched.parquet"))


rule download_blp:
    params:
        urls = BLP_URLS
    output:
        directory(BLP_ZIPS_DIR)
    script:
        "../scripts/download_zips.py"


rule extract_blp:
    input:
        BLP_ZIPS_DIR
    output:
        directory(BLP_TSVS_DIR)
    script:
        "../scripts/extract_zips.py"


rule import_blp:
    input:
        BLP_TSVS_DIR
    params:
        vocab_items = pjoin(BLP_TSVS_DIR, "blp-items.txt"),
        pseudoword_syllables = pjoin(BLP_TSVS_DIR, "pseudoword_syllables.txt"),
        stimuli = pjoin(BLP_TSVS_DIR, "blp-stimuli.txt"),
        trials = pjoin(BLP_TSVS_DIR, "blp-trials.txt")
    output:
        BLP_DB
    shell:
        "python -m vocabaqdata.importers.blp {params.vocab_items} {params.pseudoword_syllables} {params.stimuli} {params.trials} {output}"


rule blp_inventory:
    input:
        BLP_DB
    output:
        df = BLP_DF,
        df_enriched = BLP_ENRICHED_DF
    params:
        fmt = "blp",
        lang = "en"
    script:
        "../scripts/enrich.py"
