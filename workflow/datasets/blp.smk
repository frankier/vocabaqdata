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
    output:
        directory(BLP_ZIPS_DIR)
    run:
        shell("mkdir -p " + BLP_ZIPS_DIR)
        for url in BLP_URLS:
            shell("cd " + BLP_ZIPS_DIR + " && wget -nv " + url)


rule extract_blp:
    input:
        BLP_ZIPS_DIR
    output:
        directory(BLP_TSVS_DIR)
    shell:
        "input=$(realpath " + BLP_ZIPS_DIR + ")" +
        " && mkdir -p " + BLP_TSVS_DIR +
        " && cd " + BLP_TSVS_DIR +
        " && unzip -o $input/\\*.zip"


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


rule blp_to_inventory:
    input:
        BLP_DB
    output:
        BLP_DF
    shell:
        "python -m vocabaqdata.proc.lexdecis_to_inventory" +
        " --fmt blp {input} {output}"


rule enrich_blp_inventory:
    input:
        BLP_DF
    output:
        BLP_ENRICHED_DF
    shell:
        "python -m vocabaqdata.proc.add_zipfs {input} {output}"


rule import_blp_all:
    input:
        rules.import_blp.output,
        rules.blp_to_inventory.output,
        rules.enrich_blp_inventory.output
    output:
        touch(pjoin(WORK, ".blp_all"))
