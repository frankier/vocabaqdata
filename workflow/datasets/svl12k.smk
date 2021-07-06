cnf("SVL12K_RAW", "/does/not/exist")
cnf("SVL12K_DF", pjoin(WORK, "svl12k.parquet"))
cnf("SVL12K_ENRICHED_DF", pjoin(WORK, "svl12k.enriched.parquet"))
cnf("SVL12K_LIST", pjoin(WORK, "svl12k_wordlist.txt"))


rule all_svl12k:
    input:
        SVL12K_DF, SVL12K_LIST, SVL12K_ENRICHED_DF
    output:
        touch(pjoin(WORK, ".svl12k_all"))


rule import_svl12k:
    input:
        SVL12K_RAW
    output:
        SVL12K_DF
    shell:
        "python -m vocabaqdata.importers.svl12k {input} {output}"


rule mk_svl12k_wordlist:
    input:
        SVL12K_DF
    output:
        SVL12K_LIST
    shell:
        "python -m vocabaqdata.proc.extract_wordlist_from_resps {input} {output}"


rule enrich_svl12k:
    input:
        SVL12K_DF
    output:
        SVL12K_ENRICHED_DF
    shell:
        "python -m vocabaqdata.proc.enrich_svl12k {input} {output}"
