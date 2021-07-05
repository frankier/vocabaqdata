# Outputs
cnf("WORDBANK_DDB", pjoin(WORK, "wordbank.duckdb"))


rule download_and_export_wordbank:
    output:
        WORDBANK_DDB
    run:
        "python -m vocabaqdata.importers.wordbank {output}"
