SPALEX_URLS = [
    ("word_info.csv", "https://ndownloader.figshare.com/files/11826623"),
    ("lexical.csv", "https://ndownloader.figshare.com/files/11209613"),
    ("users.csv", "https://ndownloader.figshare.com/files/11209610"),
    ("sessions.csv", "https://ndownloader.figshare.com/files/11209607"),
]

cnf("SPALEX_CSVS_DIR", pjoin(WORK, "spalex_csvs"))

## Output
cnf("SPALEX_DB", pjoin(WORK, "spalex.duckdb"))
cnf("SPALEX_DF", pjoin(WORK, "spalex.inventory.parquet"))
cnf("SPALEX_ENRICHED_DF", pjoin(WORK, "spalex.inventory.enriched.parquet"))


rule download_spalex:
    output:
        directory(SPALEX_CSVS_DIR)
    run:
        shell("mkdir -p " + SPALEX_CSVS_DIR)
        for name, url in SPALEX_URLS:
            shell(
            "cd " + SPALEX_CSVS_DIR +
            " && wget -O " + name + " -nv " + url
            )


rule import_spalex:
    input:
        SPALEX_CSVS_DIR
    params:
        word_info = pjoin(SPALEX_CSVS_DIR, "word_info.csv"),
        lexical = pjoin(SPALEX_CSVS_DIR, "lexical.csv"),
        users = pjoin(SPALEX_CSVS_DIR, "users.csv"),
        sessions = pjoin(SPALEX_CSVS_DIR, "sessions.csv")
    output:
        SPALEX_DB
    shell:
        "python -m vocabaqdata.importers.spalex {params.word_info} {params.lexical} {params.users} {params.sessions} {output}"


rule spalex_inventory:
    input:
        SPALEX_DB
    output:
        df = SPALEX_DF,
        df_enriched = SPALEX_ENRICHED_DF
    params:
        fmt = "spalex",
        lang = "es"
    script:
        "../scripts/enrich.py"
