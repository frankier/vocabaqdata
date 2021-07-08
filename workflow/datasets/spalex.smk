SPALEX_URLS = [
    "https://ndownloader.figshare.com/files/11826623",
    "https://ndownloader.figshare.com/files/11209613",
    "https://ndownloader.figshare.com/files/11209610",
    "https://ndownloader.figshare.com/files/11209607",
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
        for url in SPALEX_URLS:
            shell("cd " + SPALEX_CSVS_DIR + " && wget -nv " + url)


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


rule spalex_to_inventory:
    input:
        SPALEX_DB
    output:
        SPALEX_DF
    shell:
        "python -m vocabaqdata.proc.lexdecis_to_inventory {input} {output}"


rule enrich_spalex_inventory:
    input:
        SPALEX_DF
    output:
        SPALEX_ENRICHED_DF
    shell:
        "python -m vocabaqdata.proc.add_zipfs {input} {output}"


rule import_spalex_all:
    input:
        rules.import_spalex.output,
        rules.spalex_to_inventory.output,
        rules.enrich_spalex_inventory.output
    output:
        touch(pjoin(WORK, ".spalex_all"))
